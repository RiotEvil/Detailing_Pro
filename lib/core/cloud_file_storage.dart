import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'constants.dart';

class CloudFileStorage {
  CloudFileStorage._();

  static String? get _orgId =>
      Hive.box(HiveBoxes.settings).get('orgId')?.toString();

  static Future<String> uploadOrderPhoto({
    required String orderId,
    required bool isBefore,
    required XFile file,
  }) async {
    final orgId = _orgId;
    if (orgId == null || orgId.isEmpty) {
      throw Exception('Organization is not configured');
    }

    var ext = _extFromName(file.name, fallback: 'jpg');
    final originalBytes = await file.readAsBytes();
    final uploadBytes = await _compressImageIfNeeded(
      originalBytes,
      ext: ext,
      maxLongSide: 1600,
      quality: 78,
    );
    if (_isImageExt(ext)) ext = 'jpg';

    final slot = isBefore ? 'before' : 'after';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'organizations/$orgId/orders/$orderId/$slot/$fileName';
    final ref = FirebaseStorage.instance.ref(path);

    await ref.putData(
      uploadBytes,
      SettableMetadata(contentType: _contentTypeFromExt(ext)),
    );
    return ref.getDownloadURL();
  }

  static Future<void> deleteOrderPhoto(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (_) {}
  }

  static Future<String> uploadClientCarPhoto({
    required String clientId,
    required String car,
    required XFile file,
  }) async {
    final orgId = _orgId;
    if (orgId == null || orgId.isEmpty) {
      throw Exception('Organization is not configured');
    }

    var ext = _extFromName(file.name, fallback: 'jpg');
    final originalBytes = await file.readAsBytes();
    final uploadBytes = await _compressImageIfNeeded(
      originalBytes,
      ext: ext,
      maxLongSide: 1600,
      quality: 78,
    );
    if (_isImageExt(ext)) {
      ext = 'jpg';
    }

    final safeCar = _safeSegment(car);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'organizations/$orgId/clients/$clientId/$safeCar/$fileName';
    final ref = FirebaseStorage.instance.ref(path);

    await ref.putData(
      uploadBytes,
      SettableMetadata(contentType: _contentTypeFromExt(ext)),
    );
    return ref.getDownloadURL();
  }

  static Future<String> uploadChatAttachment({
    required String roomId,
    required String senderId,
    required String fileName,
    required bool isImage,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final orgId = _orgId;
    final ext = _extFromName(fileName, fallback: isImage ? 'jpg' : 'bin');
    final safeName = _safeSegment(fileName);
    final basePath = (orgId != null && orgId.isNotEmpty)
        ? 'organizations/$orgId/chat/$roomId'
        : 'chat/global/$roomId';

    final storagePath =
        '$basePath/${DateTime.now().millisecondsSinceEpoch}_${_safeSegment(senderId)}_$safeName';

    final ref = FirebaseStorage.instance.ref(storagePath);

    if (isImage) {
      Uint8List sourceBytes;
      if (bytes != null) {
        sourceBytes = bytes;
      } else if (filePath != null && filePath.isNotEmpty) {
        if (kIsWeb) {
          throw Exception('Image bytes are required on web upload');
        }
        sourceBytes = await File(filePath).readAsBytes();
      } else {
        throw Exception('No image bytes or path provided');
      }

      final optimizedBytes = await _compressImageIfNeeded(
        sourceBytes,
        ext: ext,
        maxLongSide: 1600,
        quality: 78,
      );

      await ref.putData(
        optimizedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } else if (bytes != null) {
      await ref.putData(
        bytes,
        SettableMetadata(contentType: _contentTypeFromExt(ext)),
      );
    } else if (filePath != null && filePath.isNotEmpty) {
      await ref.putFile(
        File(filePath),
        SettableMetadata(contentType: _contentTypeFromExt(ext)),
      );
    } else {
      throw Exception('No file bytes or path provided');
    }

    return ref.getDownloadURL();
  }

  static String _safeSegment(String input) {
    final normalized = input.trim();
    if (normalized.isEmpty) return 'file';
    return normalized.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
  }

  static String _extFromName(String name, {required String fallback}) {
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot >= name.length - 1) return fallback;
    return name.substring(dot + 1).toLowerCase();
  }

  static String _contentTypeFromExt(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  static bool _isImageExt(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
      case 'heic':
      case 'heif':
        return true;
      default:
        return false;
    }
  }

  static Future<Uint8List> _compressImageIfNeeded(
    Uint8List bytes, {
    required String ext,
    required int maxLongSide,
    required int quality,
  }) async {
    if (!_isImageExt(ext)) {
      return bytes;
    }

    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return bytes;
    }

    final longestSide = math.max(decoded.width, decoded.height);
    img.Image resized = decoded;
    if (longestSide > maxLongSide) {
      final scale = maxLongSide / longestSide;
      final targetWidth = (decoded.width * scale).round();
      final targetHeight = (decoded.height * scale).round();
      resized = img.copyResize(
        decoded,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.average,
      );
    }

    final encoded = Uint8List.fromList(
      img.encodeJpg(resized, quality: quality),
    );

    if (encoded.length >= bytes.length) {
      return bytes;
    }
    return encoded;
  }
}
