import 'package:puppeteer/puppeteer.dart';
import 'youtubedl_printer.dart';
import 'token_provider.dart';
import 'metadata_extractors.dart';

class RaywenderlichMetaDownloader {
  RaywenderlichMetaDownloader._();

  static final List<MetadataExtractor> _extractors = [
    CourseMetadataExtractor(),
    LearningPathMetadatExtractor(),
    LessonExtractor(),
  ];

  static Future<void> extractMetadata(
    final String username,
    final String password,
    final List<String> urls,
    final bool canExtractMaterials,
  ) async {
    final browser = await puppeteer.launch(headless: true);
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
              (metadata) => YoutubeDlPrinter.printBashFile(
                canExtractMaterials,
                metadata,
              ),
            );
      });
    } finally {
      await browser.close();
    }
  }
}
