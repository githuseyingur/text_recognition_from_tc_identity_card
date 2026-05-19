import 'package:detect_text_from_image/models/scan_record.dart';
import 'package:detect_text_from_image/services/history_service.dart';
import 'package:detect_text_from_image/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<ScanRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final records = await HistoryService.getAll();
    if (mounted) {
      setState(() {
        _records = records;
        _loading = false;
      });
    }
  }

  void _confirmClear() {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_clear'.tr),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              await HistoryService.clear();
              Get.back();
              setState(() => _records = []);
            },
            child: Text('yes'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('history_title'.tr),
        actions: [
          if (_records.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? Center(
                  child: Text(
                    'history_empty'.tr,
                    style: const TextStyle(color: AppTheme.labelColor),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _HistoryCard(record: _records[index]),
                ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});

  final ScanRecord record;

  @override
  Widget build(BuildContext context) {
    final card = record.card;
    final name = card.fullName.isEmpty ? '-' : card.fullName;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.badge_outlined, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  if (card.tckn.isNotEmpty)
                    Text(
                      card.tckn,
                      style: const TextStyle(color: AppTheme.labelColor, fontSize: 13),
                    ),
                ],
              ),
            ),
            Text(
              _formatDate(record.scannedAt),
              style: const TextStyle(color: AppTheme.labelColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
}
