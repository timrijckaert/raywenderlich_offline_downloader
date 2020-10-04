import 'package:pedantic/pedantic.dart';

import 'api.dart';
import 'models.dart';
import 'printer.dart';
import 'token_provider.dart';
import 'args_parser.dart';

class RaywenderlichMetaDownloader {
  RaywenderlichMetaDownloader._();

  static Printer printerForOutputType(final OutputType outputType) {
    Printer printer;
    switch (outputType) {
      case OutputType.json:
        printer = JsonPrinter();
        break;
      case OutputType.youtubedl:
        printer = YoutubeDlPrinter();
        break;
    }
    return printer;
  }

  static void outputMetadataFromArguments(
    final Metadata metadata,
    final List<OutputType> outputTypes,
    final bool canExportMaterials,
  ) =>
      unawaited(
        Future.forEach(
          outputTypes,
          (outputType) => printerForOutputType(outputType)
              .print(metadata, canExportMaterials),
        ),
      );

  static Stream<Metadata> metadataFromArguments(
    final String username,
    final String password,
    final List<String> urls,
  ) async* {
    final userToken = await TokenProvider.getUserToken(
      username,
      password,
    );

    for (var url in urls) {
      yield await Api.metadataOutputForUrl(url, userToken);
    }
  }
}
