import 'dart:io';

import 'package:detect_text_from_image/controller/extract_data_controller.dart';
import 'package:detect_text_from_image/core/app_snackbar.dart';
import 'package:detect_text_from_image/theme/app_theme.dart';
import 'package:detect_text_from_image/view/history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void _toggleLocale() {
  if (Get.locale?.languageCode == 'tr') {
    Get.updateLocale(const Locale('en', 'US'));
  } else {
    Get.updateLocale(const Locale('tr', 'TR'));
  }
  AppSnackbar.info('language_changed'.tr);
}

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExtractDataController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('scan_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            onPressed: () => Get.to(() => const HistoryView()),
          ),
          IconButton(
            icon: const Icon(Icons.language_outlined),
            onPressed: _toggleLocale,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: Obx(
                  () => controller.imagePath.value.isEmpty
                      ? const _EmptyState()
                      : _ImagePreview(
                          imagePath: controller.imagePath.value,
                          onDelete: controller.clearData,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              _ScanButton(onTap: controller.getImage),
              const SizedBox(height: 10),
              _GalleryButton(onTap: controller.getImageFromGallery),
              const SizedBox(height: 10),
              Obx(
                () => controller.imagePath.value.isNotEmpty
                    ? _ExtractButton(controller: controller)
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: _ScanGuide(),
        ),
        const SizedBox(height: 16),
        Text(
          'position_guide'.tr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.labelColor,
              ),
        ),
      ],
    );
  }
}

class _ScanGuide extends StatelessWidget {
  const _ScanGuide();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 85.6 / 54.0,
      child: CustomPaint(
        painter: _ScanGuidePainter(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.primary.withAlpha(200)
              : AppTheme.primary,
        ),
        child: Center(
          child: Icon(
            Icons.credit_card_outlined,
            size: 52,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white24
                : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

class _ScanGuidePainter extends CustomPainter {
  const _ScanGuidePainter({required this.color});

  final Color color;

  static const _strokeWidth = 3.0;
  static const _cornerLength = 26.0;
  static const _d = _strokeWidth / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    const l = _cornerLength;
    const d = _d;

    // subtle full-border
    canvas.drawRRect(
      RRect.fromLTRBR(d, d, w - d, h - d, const Radius.circular(8)),
      Paint()
        ..color = color.withAlpha(40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // top-left
    canvas.drawLine(const Offset(d, d), Offset(l, d), paint);
    canvas.drawLine(const Offset(d, d), Offset(d, l), paint);
    // top-right
    canvas.drawLine(Offset(w - l, d), Offset(w - d, d), paint);
    canvas.drawLine(Offset(w - d, d), Offset(w - d, l), paint);
    // bottom-left
    canvas.drawLine(Offset(d, h - l), Offset(d, h - d), paint);
    canvas.drawLine(Offset(d, h - d), Offset(l, h - d), paint);
    // bottom-right
    canvas.drawLine(Offset(w - d, h - l), Offset(w - d, h - d), paint);
    canvas.drawLine(Offset(w - l, h - d), Offset(w - d, h - d), paint);
  }

  @override
  bool shouldRepaint(covariant _ScanGuidePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imagePath, required this.onDelete});

  final String imagePath;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        label: Text(
          'scan_button'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.photo_library_outlined,
            color: const Color(0xFFA280FF), size: 18),
        label: Text(
          'gallery_button'.tr,
          style: TextStyle(
            color: const Color(0xFFA280FF),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: const Color(0xFF9974FD).withAlpha(120)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _ExtractButton extends StatelessWidget {
  const _ExtractButton({required this.controller});

  final ExtractDataController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isProcessing = controller.isProcessing.value;
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: isProcessing ? null : controller.processImage,
          icon: isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Icon(Icons.document_scanner_outlined,
                  color: Colors.white),
          label: Text(
            isProcessing ? 'processing'.tr : 'extract_button'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accent,
            disabledBackgroundColor: AppTheme.accent.withAlpha(150),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    });
  }
}
