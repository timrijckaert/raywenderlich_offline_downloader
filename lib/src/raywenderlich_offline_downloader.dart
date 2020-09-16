import 'package:puppeteer/puppeteer.dart';
import 'package:pedantic/pedantic.dart';

import 'printer.dart';
import 'token_provider.dart';
import 'metadata_extractors.dart';
import 'args_parser.dart';

const bool kReleaseMode = bool.fromEnvironment('dart.vm.product');

class RaywenderlichMetaDownloader {
  RaywenderlichMetaDownloader._();

  static final List<MetadataExtractor> _extractors = [
    CourseMetadataExtractor(),
    LearningPathMetadatExtractor(),
    LessonExtractor(),
  ];

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

  static void outputMetadataFromArguments(final List<String> arguments) {
    final inputArguments = ArgsParser.argsToInputArguments(arguments);
    unawaited(
      _extractMetadata(
        inputArguments.username,
        inputArguments.password,
        inputArguments.inputUrls,
        inputArguments.outputConfig,
      ),
    );
  }

  static Future<void> _extractMetadata(
    final String username,
    final String password,
    final List<String> urls,
    final OutputConfig outputConfig,
  ) async {
    final browser = await puppeteer.launch(headless: kReleaseMode);
    try {
      final userToken = await TokenProvider.getUserToken(
        browser,
        username,
        password,
      );

      await Future.forEach(urls, (url) {
        final extractor = _extractors.firstWhere(
          (extractor) => extractor.canExtractMetadataFromUrl(url),
          orElse: () => null,
        );

        if (extractor == null) {
          throw 'No extractor found which can extract metadata information for: $url';
        }

        return extractor.metadataOutputForUrl(browser, userToken, url).then(
              (metadata) => Future.wait(
                outputConfig.ouputTypes.map(
                  (outputType) => printerForOutputType(outputType).print(
                    metadata,
                    outputConfig.canExtractMaterials,
                  ),
                ),
              ),
            );
      });
    } finally {
      await browser.close();
    }
  }
}
