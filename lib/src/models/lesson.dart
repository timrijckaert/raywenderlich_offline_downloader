class Lesson {
  final int episode;
  final String title;
  final String lessonUrl;
  final String videoId;
  final String streamUrl;
  final String materialDownloadLink;

  bool get hasMaterials => materialDownloadLink.isNotEmpty;

  Lesson({
    this.episode,
    this.title,
    this.lessonUrl,
    this.videoId,
    this.streamUrl,
    this.materialDownloadLink,
  });

  @override
  String toString() => '${episode}. ${title}';
}
