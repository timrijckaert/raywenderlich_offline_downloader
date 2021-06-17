import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:puppeteer/puppeteer.dart';
import 'package:pedantic/pedantic.dart';

const _usernameKey = 'username';
const _validityKey = 'validUntil';
const _tokenKey = 'token';

const _userInputSelector = 'input.o-input[id=user_login]';
const _passwordInputSelector = 'input.o-input#user_password';
const _submitButtonSelector = 'form button[type=submit]';

const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

class TokenProvider {
  TokenProvider._();

  static int get _millisecondsSinceEpoch =>
      DateTime.now().millisecondsSinceEpoch;

  static int _calculateMaxValidityUserToken() {
    final validity = 55 * 60 * 1000; //55 minutes (just to be sure)
    return _millisecondsSinceEpoch + validity;
  }

  static String _userTokenFile(final String username) =>
      '${username}_usertoken.json';

  static Future<String> _getCachedToken(final String username) async {
    final userTokenCache = File(_userTokenFile(username));
    String cachedToken;
    if (await userTokenCache.exists()) {
      final json = jsonDecode(userTokenCache.readAsStringSync());
      if (json[_usernameKey] == username) {
        final validUntil = json[_validityKey];
        if (validUntil > _millisecondsSinceEpoch) {
          cachedToken = json[_tokenKey];
        }
      }
    }
    return cachedToken;
  }

  static void _cacheToken(
    final String username,
    final int maxValidity,
    final String token,
  ) async {
    final userTokenCache = File(_userTokenFile(username));
    try {
      userTokenCache.deleteSync();
    } catch (_) {}
    final sink = userTokenCache.openWrite();

    sink.writeln('''
{
  "$_usernameKey": "$username",
  "$_tokenKey": "$token",
  "$_validityKey" : $maxValidity 
}
    ''');
    await sink.flush();
    await sink.close();
  }

  static void _onUrlChange(
    final Browser browser,
    final String username,
    final Target target,
    final Completer<String> completer,
  ) async {
    if (target.url == 'https://www.raywenderlich.com/') {
      final loggedInPage = await target.page;
      loggedInPage.onLoad.listen((_) async {
        final userTokenJsHandle = await loggedInPage
            .evaluateHandle('() => window.CAROLUS_ENV.USER_TOKEN');
        final userToken = await userTokenJsHandle.jsonValue as String;
        _cacheToken(
          username,
          _calculateMaxValidityUserToken(),
          userToken,
        );
        print('Found token: $userToken');
        await loggedInPage.close();

        completer.complete(userToken);
        unawaited(browser.close());
      });
    }
  }

  static void _onConsoleLogMessagePrinted(
      final ConsoleMessage consoleMessage) async {
    if (consoleMessage.args.isNotEmpty) {
      try {
        final jsonifiedConsoleMessage = consoleMessage
            .args.first.remoteObject.preview.properties
            .map((e) => e.toJson())
            .toList()[1];

        if (jsonifiedConsoleMessage['name'] == 'errorDescription') {
          print(jsonifiedConsoleMessage['value']);
          throw 'Wrong email or password.';
        }
      } catch (_) {}
    }
  }

  static Future<String> getUserToken(
    final String username,
    final String password,
  ) async {
    final cachedToken = await _getCachedToken(username);
    if (cachedToken?.isNotEmpty ?? false) {
      print('Found cached token for $username: $cachedToken');
      return cachedToken;
    }

    final browser = await puppeteer.launch(headless: kReleaseMode);

    final loginPage = await browser.newPage();
    loginPage.onConsole.listen(_onConsoleLogMessagePrinted);
    await loginPage.goto(
      'https://www.raywenderlich.com/sessions/new',
      wait: Until.networkIdle,
    );

    final completer = Completer<String>();
    browser.onTargetChanged
        .listen((target) => _onUrlChange(browser, username, target, completer));

    await (await loginPage.$(_userInputSelector)).type(username);
    await (await loginPage.$(_submitButtonSelector)).tap();

    sleep(Duration(seconds: 1));

    await (await loginPage.$(_passwordInputSelector)).type(password);
    await (await loginPage.$(_submitButtonSelector)).tap();

    return completer.future;
  }
}
