// sampleinfo.dart  (lib/cupping/creatcupping/sampleinfo.dart)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wememmory/cupping/Service.dart/sample_service.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';
import 'package:wememmory/cupping/creatcupping/editsample.dart';

const Color secondaryColor2 = Color(0xFF6B4226);

// ─────────────────────────────────────────────────────────────────────────────
// SampleInfoPage
// ─────────────────────────────────────────────────────────────────────────────

class SampleInfoPage extends StatefulWidget {
  final List<SampleCoffee>? initialSamples;
  const SampleInfoPage({super.key, this.initialSamples});

  @override
  State<SampleInfoPage> createState() => _SampleInfoPageState();
}

class _SampleInfoPageState extends State<SampleInfoPage> {
  late List<SampleCoffee> samples;

  @override
  void initState() {
    super.initState();
    samples =
        widget.initialSamples != null ? List.from(widget.initialSamples!) : [];
  }

  // ── Delete Dialog ──────────────────────────────────────────────────────────

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, thickness: 1, color: Colors.black12),
                  const SizedBox(height: 30),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Are you sure you want to delete?",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => samples.removeAt(index));
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
    );
  }

  // ── Add Options Bottom Sheet ───────────────────────────────────────────────

  void _showAddOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Option",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 24),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 24,
                    thickness: 1,
                    color: Colors.black12,
                  ),

                  // ── Add New Sample ──
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Add Sample",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    onTap: () async {
                      Navigator.pop(context);
                      final sampleNumber = "#${samples.length + 1}";
                      final result = await Navigator.push<SampleCoffee>(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditSamplePage(
                                sampleData: SampleCoffee.empty(),
                                sampleNumber: sampleNumber,
                                isAddMode: true,
                              ),
                        ),
                      );
                      if (result != null && mounted) {
                        setState(() => samples.add(result));
                      }
                    },
                  ),

                  // ── Add from Firestore Existing Sample ──
                  ListTile(
                    leading: const Icon(
                      Icons.list_alt,
                      size: 30,
                      color: Colors.black,
                    ),
                    title: const Text(
                      "Add Existing Sample",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    onTap: () async {
                      Navigator.pop(context);
                      final selected = await showModalBottomSheet<SampleCoffee>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder:
                            (context) => _ExistingSampleSheet(
                              alreadySelectedSamples: samples,
                            ),
                      );
                      if (selected != null && mounted) {
                        setState(() {
                          final isDuplicate = samples.any(
                            (s) => s.sample_id == selected.sample_id,
                          );
                          if (!isDuplicate) {
                            samples.add(selected);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('This sample is already added.'),
                              ),
                            );
                          }
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context, samples),
        ),
        centerTitle: true,
        title: const Text(
          "Sample Info",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              "Sample Information",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _showAddOptionsSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Add Sample",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child:
                samples.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.coffee_outlined,
                            size: 56,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No samples yet",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tap \"Add Sample\" to get started",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      itemCount: samples.length,
                      separatorBuilder:
                          (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(color: Colors.grey.shade200),
                          ),
                      itemBuilder:
                          (context, index) =>
                              _buildSampleItem(index, samples[index]),
                    ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // ── Sample Item ───────────────────────────────────────────────────────────

  Widget _buildSampleItem(int index, SampleCoffee data) {
    String formattedDate = "-";
    try {
      final dt =
          data.createdAt ??
          (data.created_at != null
              ? DateTime.tryParse(data.created_at!)
              : null);
      if (dt != null) {
        formattedDate = DateFormat('dd/MM/yyyy').format(dt);
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "#${index + 1}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Text(
          "Sample ID : ${data.sample_id ?? '-'}",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          "Sample Name : ${data.sample_name ?? '-'}",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          "Species : ${data.sample_species?.name ?? data.species ?? '-'}",
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.blue.shade800,
            ),
            const SizedBox(width: 8),
            Text(
              "Created On : $formattedDate",
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              width: 60,
              child: OutlinedButton(
                onPressed: () => _showDeleteDialog(index),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: secondaryColor2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(color: secondaryColor2, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 30,
              width: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<SampleCoffee>(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditSamplePage(
                            sampleData: data,
                            sampleNumber: "#${index + 1}",
                            isAddMode: false,
                          ),
                    ),
                  );
                  if (result != null && mounted) {
                    setState(() => samples[index] = result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: secondaryColor2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, samples),
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExistingSampleSheet — ขั้น 5: ดึงจาก Firestore จริง
// ─────────────────────────────────────────────────────────────────────────────

class _ExistingSampleSheet extends StatefulWidget {
  final List<SampleCoffee> alreadySelectedSamples;
  const _ExistingSampleSheet({required this.alreadySelectedSamples});

  @override
  State<_ExistingSampleSheet> createState() => _ExistingSampleSheetState();
}

class _ExistingSampleSheetState extends State<_ExistingSampleSheet> {
  final TextEditingController _searchController = TextEditingController();

  // ✅ ดึงจาก Firestore แทน mock list
  List<SampleCoffee> _allSamples = [];
  List<SampleCoffee> _displayedList = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadSamples();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSamples() async {
    try {
      final result = await SampleService.getMySamples();
      if (mounted) {
        setState(() {
          _allSamples = result;
          _displayedList = List.from(result);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedList = List.from(_allSamples);
      } else {
        _displayedList =
            _allSamples.where((item) {
              final idMatch = (item.sample_id ?? '').toLowerCase().contains(
                query.toLowerCase(),
              );
              final nameMatch = (item.sample_name ?? '').toLowerCase().contains(
                query.toLowerCase(),
              );
              return idMatch || nameMatch;
            }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.8;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: sheetHeight,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Existing Sample",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            const SizedBox(height: 16),

            // ── Search ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: "Search by ID or name",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(
                      color: secondaryColor2,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── List ──
            Expanded(
              child:
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: secondaryColor2,
                        ),
                      )
                      : _errorMsg != null
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMsg!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _errorMsg = null;
                                });
                                _loadSamples();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor2,
                              ),
                              child: const Text(
                                "Retry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                      : _displayedList.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchController.text.isNotEmpty
                                  ? "No results for \"${_searchController.text}\""
                                  : "No existing samples found",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        itemCount: _displayedList.length,
                        separatorBuilder:
                            (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Divider(color: Colors.grey.shade200),
                            ),
                        itemBuilder: (context, index) {
                          final item = _displayedList[index];
                          final bool isAlreadySelected = widget
                              .alreadySelectedSamples
                              .any((s) => s.sample_id == item.sample_id);

                          // ✅ ใช้ createdAt DateTime โดยตรง
                          String dateStr = "-";
                          final dt =
                              item.createdAt ??
                              (item.created_at != null
                                  ? DateTime.tryParse(item.created_at!)
                                  : null);
                          if (dt != null) {
                            dateStr = DateFormat('dd/MM/yyyy').format(dt);
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                "#${index + 1}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Sample ID : ${item.sample_id ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Sample Name : ${item.sample_name ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Species : ${item.sample_species?.name ?? item.species ?? '-'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 18,
                                        color: Colors.blue.shade800,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Created On : $dateStr",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(
                                      onPressed:
                                          isAlreadySelected
                                              ? null
                                              : () =>
                                                  Navigator.pop(context, item),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isAlreadySelected
                                                ? Colors.grey.shade400
                                                : secondaryColor2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ),
                                        ),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                      ),
                                      child: Text(
                                        isAlreadySelected
                                            ? "Selected"
                                            : "Select",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
