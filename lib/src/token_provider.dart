import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:puppeteer/puppeteer.dart';

const _usernameKey = 'username';
const _validityKey = 'validUntil';
const _tokenKey = 'token';

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
    if (await userTokenCache.exists()) {
      final json = jsonDecode(userTokenCache.readAsStringSync());
      if (json[_usernameKey] == username) {
        final validUntil = json[_validityKey];
        if (validUntil > _millisecondsSinceEpoch) {
          return json[_tokenKey];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
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
      });
    }
  }

  static Future<String> getUserToken(
    final Browser browser,
    final String username,
    final String password,
  ) async {
    final completer = Completer<String>();

    final cachedToken = await _getCachedToken(username);
    if (cachedToken?.isNotEmpty ?? false) {
      print('Found cached token for $username: $cachedToken');
      return cachedToken;
    }

    final raywenderlichPage = await browser.newPage();
    await raywenderlichPage.goto(
      'https://www.raywenderlich.com/sessions/new',
      wait: Until.networkIdle,
    );

    browser.onTargetChanged
        .listen((target) => _onUrlChange(browser, username, target, completer));

    final usernameField =
        await raywenderlichPage.$('input.o-input[name=username]');
    await usernameField.type(username);

    final passwordField =
        await raywenderlichPage.$('input.o-input[name=password]');
    await passwordField.type(password);

    await (await raywenderlichPage.$('form button[type=submit]')).tap();

    return completer.future;
  }
}