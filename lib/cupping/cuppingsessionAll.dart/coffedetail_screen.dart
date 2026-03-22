// coffedetail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';

const Color secondaryColor2 = Color(0xFF6B4226);

class CoffeeDetailScreen extends StatefulWidget {
  final bool isAvailable;
  final CuppingSession eventData;
  final String pageType; // "All", "Create", "Join"
  final JoinCupping? joinCupping;
  final VoidCallback? onJoin;

  const CoffeeDetailScreen({
    super.key,
    required this.isAvailable,
    required this.eventData,
    required this.pageType,
    this.joinCupping,
    this.onJoin,
  });

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  bool _hasJoined = false;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _getCuppingModeName(int? modeId) {
    switch (modeId) {
      case 1:
        return 'Descriptive';
      case 2:
        return 'Affective';
      case 3:
        return 'Combined';
      case 4:
        return 'Quick Mode';
      case 5:
        return 'Quick Mode 2';
      default:
        return 'N/A';
    }
  }

  // ✅ รับ DateTime? โดยตรง — ไม่ต้อง DateTime.parse(String) อีกต่อไป
  String _formatDateTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return "No date specified";
    final format = DateFormat('dd MMM yyyy (HH:mm)');
    final startStr = format.format(start);
    final endStr = end != null ? format.format(end) : '-';
    return '$startStr\n— $endStr';
  }

  // ── Join ──────────────────────────────────────────────────────────────────

  void _handleJoin() {
    widget.onJoin?.call();
    setState(() => _hasJoined = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE5F9EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF4CAF50),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Joined Successfully!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have joined\n"${widget.eventData.cuppingName}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check your session in the "Join" tab',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Back to Events",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // ── Start Cupping ─────────────────────────────────────────────────────────

  void _handleStartCupping() {
    final modeId = widget.eventData.cuppingModeId;
    final modeName = _getCuppingModeName(modeId);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Start Cupping"),
            content: Text(
              'Starting "$modeName" mode\nfor "${widget.eventData.cuppingName}"',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: navigate to cupping form ตาม modeId
                  // if (modeId == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => DescriptiveStep1(...)));
                  // if (modeId == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => AffectiveStep1(...)));
                  // if (modeId == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => CombinedAssessmentScreen(...)));
                  // if (modeId == 4 || modeId == 5) Navigator.push(context, MaterialPageRoute(builder: (_) => CombinedResult(...)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening $modeName form...'),
                      backgroundColor: secondaryColor2,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Start",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final data = widget.eventData;
    final bool isJoinTab = widget.pageType == "Join";
    final bool isCreateTab = widget.pageType == "Create";
    final bool isAllTab = widget.pageType == "All";
    final bool cuppingDone = widget.joinCupping?.cupping_status == true;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Main Image ──
                  _buildCoverImage(data.imageUrl),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Title + Share ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.cuppingName ?? "Cupping Session",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share, size: 18),
                              label: const Text("Share"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // ── Status badge ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                data.isActive == 'Y'
                                    ? const Color(0xFFE5F9EA)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.isActive == 'Y'
                                ? '✓ Open for Evaluation'
                                : '✗ Closed',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color:
                                  data.isActive == 'Y'
                                      ? const Color(0xFF4CAF50)
                                      : Colors.grey[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Info rows ──
                        _buildInfoRow(
                          Icons.location_on_outlined,
                          data.location ?? "Unknown location",
                        ),
                        const SizedBox(height: 10),

                        // ✅ ส่ง DateTime? โดยตรง
                        _buildInfoRow(
                          Icons.access_time,
                          _formatDateTimeRange(data.startAt, data.endAt),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          Icons.coffee_maker_outlined,
                          'Mode: ${_getCuppingModeName(data.cuppingModeId)}',
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),

                        // ── Description ──
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.description ?? "No description available.",
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Coffee Samples ──
                        Text(
                          "Coffee Samples (${data.numberOfSamples ?? 0} Samples)",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if ((data.numberOfSamples ?? 0) == 0)
                          _buildBulletPoint("No samples added yet")
                        else
                          ...List.generate(
                            data.numberOfSamples ?? 0,
                            (i) => _buildBulletPoint("Sample #${i + 1}"),
                          ),
                        const SizedBox(height: 24),

                        // ── Organizer ──
                        const Text(
                          "Organizer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildBulletPoint(
                          data.isCreatedByMe
                              ? "You (Host)"
                              : "Coffee Session Organizer",
                        ),

                        // ── Join status (Join tab) ──
                        if (isJoinTab) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  cuppingDone
                                      ? const Color(0xFFE5F9EA)
                                      : const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    cuppingDone
                                        ? const Color(0xFF4CAF50)
                                        : Colors.orange.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  cuppingDone
                                      ? Icons.check_circle
                                      : Icons.pending,
                                  color:
                                      cuppingDone
                                          ? const Color(0xFF4CAF50)
                                          : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  cuppingDone
                                      ? "Cupping completed"
                                      : "You've joined — ready to start cupping",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        cuppingDone
                                            ? const Color(0xFF4CAF50)
                                            : Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Action ──
          _buildBottomAction(
            isAllTab: isAllTab,
            isJoinTab: isJoinTab,
            isCreateTab: isCreateTab,
            cuppingDone: cuppingDone,
          ),
        ],
      ),
    );
  }

  // ── Cover Image ───────────────────────────────────────────────────────────
  // ✅ รองรับ imageUrl จาก Firebase Storage

  Widget _buildCoverImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 280,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: Image.asset(
        'assets/images/coffee5.png',
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.brown.shade100,
              child: const Icon(Icons.coffee, size: 80, color: Colors.brown),
            ),
      ),
    );
  }

  // ── Reusable ──────────────────────────────────────────────────────────────

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: secondaryColor2,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction({
    required bool isAllTab,
    required bool isJoinTab,
    required bool isCreateTab,
    required bool cuppingDone,
  }) {
    Widget button;

    if (isAllTab && !_hasJoined) {
      final bool canJoin = widget.eventData.isActive == 'Y';
      button = ElevatedButton(
        onPressed: canJoin ? _handleJoin : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canJoin ? secondaryColor2 : Colors.grey[400],
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          canJoin ? "Join Session" : "Session Closed",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isAllTab && _hasJoined) {
      button = ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          "✓ Joined — Go Back",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isJoinTab && !cuppingDone) {
      button = ElevatedButton(
        onPressed: _handleStartCupping,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor2,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Start Cupping",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    } else if (isJoinTab && cuppingDone) {
      button = ElevatedButton(
        onPressed: () {
          // TODO: navigate to result screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          "View Result",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      // Create tab
      button = ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor2,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: const Text(
          "Manage Session",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(top: false, child: button),
    );
  }
}
