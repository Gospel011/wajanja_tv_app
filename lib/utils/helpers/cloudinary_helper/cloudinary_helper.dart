import 'dart:io';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
// ignore: implementation_imports
import 'package:cloudinary_api/src/request/model/uploader_params.dart';
import 'package:uuid/uuid.dart';
import 'package:wajanja/utils/constants/enums.dart';
import 'package:wajanja/utils/helpers/logger.dart';

class CloudinaryHelper {
  static CloudinaryHelper? _instance;
  late Cloudinary _cloudinary;

  CloudinaryHelper._();

  static CloudinaryHelper get instance {
    _instance ??= CloudinaryHelper._();

    return _instance!;
  }

  /// Initializes cloudinary and configures it to use secure urls.
  void initCloudinary() {
    _cloudinary = Cloudinary.fromStringUrl(
        'cloudinary://682398265466428:FfSsiMOgFYk2c_8ELoDwhm4YL6o@extelvogroup')
      ..config.urlConfig.secure = true;
  }

  /// Upload a file to cloudinary
  /// [file] The dart file you want to upload. Must be from 'dart:io'.
  /// [path] The path to the file including folder names e.g photos/example.png
  /// [filename] The name of the file, this would be used in generating the url.
  /// If not provided, a random url is auto-generated.
  /// [progressCallback] useful for updating the ui on the percentage of the file that has been uploaded.
  Future<String?> upload(
    File file, {
    required CloudinaryUploadPath path,
    String? filename,
    void Function(int bytesUploaded, int totalBytes)? progressCallback,
  }) async {
    var response = await _cloudinary.uploader().upload(file,
        progressCallback: progressCallback,
        params: UploadParams(
            publicId:
                "${path.describe}/${filename ?? ''}${filename != null ? "-${const Uuid().v4()}" : const Uuid().v4()}",
            uniqueFilename: false,
            overwrite: true));
    log.i(response?.data?.publicId);
    log.i(response?.data?.secureUrl);

    return response?.data?.secureUrl;
  }

  Future<void> delete(String url) async {
    final publicId = _extractPublicId(url);
    if (publicId == null) return;

    await _cloudinary.uploader().destroy(DestroyParams(publicId: publicId));
  }

  String? _extractPublicId(String url) {
    final splitUrl = url.split('/');

    if (splitUrl.isEmpty) return null;

    final last = splitUrl.last.split('.');

    if (last.isEmpty) return null;

    final extractedId = last.first;

    log.i("EXTRACTED ID: $extractedId");

    return extractedId;
  }
}
