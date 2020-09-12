import 'package:puppeteer/puppeteer.dart';
import 'youtubedl_printer.dart';
import 'token_provider.dart';
import 'metadata_extractor.dart';

class RaywenderlichMetaDownloader {
  RaywenderlichMetaDownloader._();

  static final List<MetadataExtractor> _extractors = [
    CourseMetadataExtractor(),
    PathMetadatExtractor(),
    SingleLessonExtractor(),
  ];

  static Future<void> extractMetadata(
    final String username,
    final String password,
    final List<String> courseUrls,
    final bool canExtractMaterials,
  ) async {
    final browser = await puppeteer.launch(headless: true);
    try {
      final userToken = await TokenProvider.getUserToken(
        browser,
        username,
        password,
      );

      await Future.forEach(courseUrls, (courseUrl) {
        final extractor = _extractors.firstWhere(
          (extractor) => extractor.canExtractMetadataFromUrl(courseUrl),
          orElse: () => null,
        );

        if (extractor == null) {
          throw 'No extractor found which can extract metadata information for: $courseUrl';
        }

        return extractor.getCourse(browser, userToken, courseUrl).then(
              (course) => YoutubeDlPrinter.printBashFile(
                canExtractMaterials,
                course,
              ),
            );
      });
    } finally {
      await browser.close();
    }
  }
}
