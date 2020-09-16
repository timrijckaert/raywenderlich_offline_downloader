import 'dart:io';

import 'package:args/args.dart';

const _usernameKey = 'username';
const _passwordKey = 'password';
const _outputKey = 'output';
const _materialsKey = 'materials';

enum OutputType {
  json,
  youtubedl,
}

extension _OutputTypeFromString on String {
  OutputType get toOutputType {
    switch (this) {
      case 'json':
        return OutputType.json;
      case 'youtubedl':
        return OutputType.youtubedl;
      default:
        throw 'Invalid input type $this';
    }
  }
}

class OutputConfig {
  final bool canExtractMaterials;
  final List<OutputType> ouputTypes;

  OutputConfig(
    this.canExtractMaterials,
    this.ouputTypes,
  );
}

class _InputArguments {
  final String username;
  final String password;
  final List<String> inputUrls;
  final OutputConfig outputConfig;

  _InputArguments(
    this.username,
    this.password,
    this.inputUrls,
    this.outputConfig,
  );
}

class ArgsParser {
  ArgsParser._();

  static final _parser = ArgParser()
    ..addOption(
      _usernameKey,
      abbr: 'u',
      help: 'Provide your Raywenderlich email address.',
    )
    ..addOption(
      _passwordKey,
      abbr: 'p',
      help: 'Provide your Raywenderlich password address',
    )
    ..addMultiOption(
      _outputKey,
      abbr: 'o',
      allowed: ['json', 'youtubedl'],
      defaultsTo: ['youtubedl'],
      allowedHelp: {
        'json': 'Export to JSON',
        'youtubedl': 'Makes a bash script with the help of Youtubedl and curl',
      },
    )
    ..addFlag(
      _materialsKey,
      abbr: 'm',
      defaultsTo: true,
      help: 'Whether you want to fetch the links to the materials.',
    );

  static void printExampleUsage(final String title) {
    final baseUsage =
        "-u 'firstname.lastname@emailprovider.com' -p 'password' 'https://www.raywenderlich.com/4001741-swiftui'";
    final helpUsage = _parser.usage;
    print('''
$title

Example usage:
$baseUsage

$helpUsage
    ''');
  }

  static _InputArguments argsToInputArguments(final List<String> arguments) {
    _InputArguments inputArguments;
    try {
      final commandLineArgsResult = _parser.parse(arguments);
      String username = commandLineArgsResult[_usernameKey];
      String password = commandLineArgsResult[_passwordKey];
      final outputTypes = (commandLineArgsResult[_outputKey] as List<String>)
          .map((outputType) => outputType.toOutputType)
          .toList();
      final canExtractMaterials = commandLineArgsResult[_materialsKey];
      final urls = commandLineArgsResult.rest;

      if (username?.isEmpty ?? true) {
        printExampleUsage('No username found!');
        exit(1);
      }

      if (password?.isEmpty ?? true) {
        printExampleUsage('No password found!');
        exit(1);
      }

      if (urls.isEmpty) {
        printExampleUsage('No urls found to download');
        exit(1);
      }
      inputArguments = _InputArguments(
        username,
        password,
        urls,
        OutputConfig(
          canExtractMaterials,
          outputTypes,
        ),
      );
    } on Exception {
      print('Could not parse the input arguments: $arguments');
      exit(1);
    }
    return inputArguments;
  }
}
