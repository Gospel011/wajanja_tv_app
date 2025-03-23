import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wajanja/data_layer/models/audiobook/audiobook_chapter.dart';

class Audiobook {
  final String coverphoto;
  final String postedBy;
  final String title;
  final double averageRating;
  final Timestamp createdAt;
  final List<AudiobookChapter> chapters;
}
