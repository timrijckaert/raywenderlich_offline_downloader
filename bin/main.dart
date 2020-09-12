import 'package:args/args.dart';
import 'package:raywenderlich_offline_downloader/raywenderlich_offline_downloader.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(
      'username',
      abbr: 'u',
      help: 'Provide your Raywenderlich email address.',
    )
    ..addOption(
      'password',
      abbr: 'p',
      help: 'Provide your Raywenderlich password address',
    )
    ..addFlag(
      'materials',
      abbr: 'm',
      defaultsTo: true,
      help: 'Whether you want to fetch the links to the materials.',
    );

  final commandLineArgsResult = parser.parse(arguments);
  String username = commandLineArgsResult['username'];
  String password = commandLineArgsResult['password'];
  final urls = commandLineArgsResult.rest;
  final extractMaterials = commandLineArgsResult['materials'];

  void printExampleUsage(final String extra) {
    final baseUsage =
        "-u 'firstname.lastname@emailprovider.com' -p 'password' 'https://www.raywenderlich.com/4001741-swiftui'";
    final helpUsage = parser.usage;
    print('$extra\n\nExample usage:\n$baseUsage\n\n$helpUsage');
  }

  if (username?.isEmpty ?? true) {
    printExampleUsage('No username found!');
    return;
  }

  if (password?.isEmpty ?? true) {
    printExampleUsage('No password found!');
    return;
  }

  if (urls.isEmpty) {
    printExampleUsage('No urls found to download');
    return;
  }

  await RaywenderlichMetaDownloader.extractMetadata(
    username,
    password,
    urls,
    extractMaterials,
  );
}
