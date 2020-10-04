import 'package:raywenderlich_offline_downloader/raywenderlich_offline_downloader.dart';

void main(List<String> arguments) {
  final inputArgs = ArgsParser.argsToInputArguments(arguments);
  RaywenderlichMetaDownloader.metadataFromArguments(
    inputArgs.username,
    inputArgs.password,
    inputArgs.inputUrls,
  ).listen(
    (metadata) {
      RaywenderlichMetaDownloader.outputMetadataFromArguments(
        metadata,
        inputArgs.outputConfig.ouputTypes,
        inputArgs.outputConfig.canExtractMaterials,
      );
    },
  );
}
