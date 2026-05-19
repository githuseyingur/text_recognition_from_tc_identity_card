import 'dart:io';

import 'package:detect_text_from_image/controller/extract_data_controller.dart';
import 'package:detect_text_from_image/core/app_snackbar.dart';
import 'package:detect_text_from_image/models/id_card_model.dart';
import 'package:detect_text_from_image/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExtractDataController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('detail_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _share(controller.idCard.value),
          ),
        ],
      ),
      body: Obx(() {
        final card = controller.idCard.value;
        final path = controller.imagePath.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (path.isNotEmpty) _ImageCard(imagePath: path),
              const SizedBox(height: 20),
              _DataCard(card: card),
            ],
          ),
        );
      }),
    );
  }

  void _share(IdCardModel card) {
    final buffer = StringBuffer()
      ..writeln('TC No: ${card.tckn.isEmpty ? "-" : card.tckn}')
      ..writeln('${'full_name'.tr}: ${card.fullName.isEmpty ? "-" : card.fullName}')
      ..writeln('${'birthdate'.tr}: ${card.birthdate.isEmpty ? "-" : card.birthdate}')
      ..writeln('${'serial_no'.tr}: ${card.serialNumber.isEmpty ? "-" : card.serialNumber}')
      ..writeln('${'valid_until'.tr}: ${card.validUntil.isEmpty ? "-" : card.validUntil}');

    Share.share(buffer.toString().trim());
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.card});

  final IdCardModel card;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            _DataRow(
              icon: Icons.badge_outlined,
              label: 'tc_no'.tr,
              value: card.tckn,
              onCopy: card.tckn.isNotEmpty ? () => _copy(card.tckn) : null,
            ),
            const _RowDivider(),
            _DataRow(
              icon: Icons.person_outline,
              label: 'full_name'.tr,
              value: card.fullName,
              onCopy: card.fullName.isNotEmpty ? () => _copy(card.fullName) : null,
            ),
            const _RowDivider(),
            _DataRow(
              icon: Icons.cake_outlined,
              label: 'birthdate'.tr,
              value: card.birthdate,
            ),
            const _RowDivider(),
            _DataRow(
              icon: Icons.article_outlined,
              label: 'serial_no'.tr,
              value: card.serialNumber,
            ),
            const _RowDivider(),
            _DataRow(
              icon: Icons.date_range_outlined,
              label: 'valid_until'.tr,
              value: card.validUntil,
            ),
          ],
        ),
      ),
    );
  }

  void _copy(String value) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.info('copied'.tr);
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppTheme.labelColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          if (onCopy != null)
            GestureDetector(
              onTap: onCopy,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.copy_outlined, size: 16, color: AppTheme.labelColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Color(0xFFEDECEC), height: 1);
  }
}
