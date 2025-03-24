// ignore_for_file: public_member_api_docs, sort_constructors_first
class ImageExtra {
  final String? image;
  final List<String>? images;
  final int? currentIndex;
  final String? tag;
  ImageExtra({
    this.image,
    this.images,
    this.currentIndex,
    this.tag,
  });

  @override
  String toString() {
    return 'ImageExtra(image: $image, images: $images, currentIndex: $currentIndex, tag: $tag)';
  }
}
