// add_cupping_session_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wememmory/cupping/Service.dart/cupping_service.dart';
import 'package:wememmory/cupping/Service.dart/storage_service.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';
import 'package:wememmory/cupping/creatcupping/sampleinfo.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';

const Color secondaryColor2 = Color(0xFF6B4226);

class AddCoffeeInfoPage extends StatefulWidget {
  final bool isEdit;
  final CuppingSession? existingSession;

  const AddCoffeeInfoPage({
    super.key,
    this.isEdit = false,
    this.existingSession,
  });

  @override
  State<AddCoffeeInfoPage> createState() => _AddCoffeeInfoPageState();
}

class _AddCoffeeInfoPageState extends State<AddCoffeeInfoPage> {
  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController _cuppingNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _numberOfSampleController = TextEditingController(
    text: "0",
  );
  final TextEditingController _participantLimitController =
      TextEditingController();
  final TextEditingController _participationFeeController =
      TextEditingController();

  // ── State ─────────────────────────────────────────────────────────────────
  bool _hasParticipationFee = false;
  int _selectedSampleIdStructure = 0;
  int? _selectedCuppingModeId;
  int _currentStep = 1;
  bool _isSubmitting = false;
  double _uploadProgress = 0;

  DateTime? _startDate;
  TimeOfDay? _startTime;

  File? _pickedImageFile; // รูปที่ user เลือกใหม่
  String? _existingImageUrl; // URL เดิม (กรณี edit)

  List<SampleCoffee> _selectedSamplesList = [];

  final List<Map<String, dynamic>> _mockModes = [
    {'id': 1, 'name': 'Descriptive'},
    {'id': 2, 'name': 'Affective'},
    {'id': 3, 'name': 'Combined'},
    {'id': 4, 'name': 'Quick Mode'},
    {'id': 5, 'name': 'Quick Mode 2'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingSession != null) {
      final s = widget.existingSession!;
      _cuppingNameController.text = s.cuppingName ?? '';
      _locationController.text = s.location ?? '';
      _descController.text = s.description ?? '';
      _selectedCuppingModeId = s.cuppingModeId;
      _existingImageUrl = s.imageUrl;
      if (s.participantLimit != null) {
        _participantLimitController.text = s.participantLimit.toString();
      }
      if (s.participationFee != null && s.participationFee! > 0) {
        _hasParticipationFee = true;
        _participationFeeController.text = s.participationFee.toString();
      }
      if (s.startAt != null) {
        _startDate = DateTime(
          s.startAt!.year,
          s.startAt!.month,
          s.startAt!.day,
        );
        _startTime = TimeOfDay(
          hour: s.startAt!.hour,
          minute: s.startAt!.minute,
        );
      }
      // map sampleIdStructure string → index
      switch (s.sampleIdStructure) {
        case 'three_digit':
          _selectedSampleIdStructure = 1;
          break;
        case 'letter':
          _selectedSampleIdStructure = 2;
          break;
        default:
          _selectedSampleIdStructure = 0;
      }
    }
  }

  @override
  void dispose() {
    _cuppingNameController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _numberOfSampleController.dispose();
    _participantLimitController.dispose();
    _participationFeeController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _formatDate(DateTime? date) {
    if (date == null) return "DD/MM/YYYY";
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return "HH:MM";
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}";
  }

  String _getSampleIdStructureString() {
    switch (_selectedSampleIdStructure) {
      case 1:
        return 'three_digit';
      case 2:
        return 'letter';
      default:
        return 'number';
    }
  }

  String _getCuppingModeName(int? modeId) {
    if (modeId == null) return "N/A";
    final found = _mockModes.firstWhere(
      (m) => m['id'] == modeId,
      orElse: () => {},
    );
    return found['name'] ?? "Unknown";
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: secondaryColor2,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: secondaryColor2),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  // ── Pick Image ────────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _pickedImageFile = File(pickedFile.path));
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _goBackStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep -= 1);
      return;
    }
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (_currentStep > 1) {
      setState(() => _currentStep -= 1);
      return false;
    }
    return true;
  }

  Future<void> _openSampleInfoPage() async {
    final result = await Navigator.push<List<SampleCoffee>>(
      context,
      MaterialPageRoute(
        builder:
            (context) => SampleInfoPage(initialSamples: _selectedSamplesList),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedSamplesList = result;
        _numberOfSampleController.text = _selectedSamplesList.length.toString();
      });
    }
  }

  // ── Validate ──────────────────────────────────────────────────────────────

  void _validateAndProceedToStep2() {
    if (_cuppingNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Session Name')),
      );
      return;
    }
    if (_selectedCuppingModeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Cupping Mode')),
      );
      return;
    }
    if (widget.isEdit) {
      _submitSession();
    } else {
      setState(() => _currentStep = 2);
    }
  }

  // ── Submit — เชื่อม Firebase จริง ─────────────────────────────────────────

  Future<void> _submitSession() async {
    setState(() {
      _isSubmitting = true;
      _uploadProgress = 0;
    });

    try {
      final DateTime startDateTime =
          (_startDate != null && _startTime != null)
              ? DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
                _startTime!.hour,
                _startTime!.minute,
              )
              : DateTime.now();
      final DateTime endDateTime = startDateTime.add(const Duration(hours: 2));

      // ── Build SessionSample list ──
      final samples =
          _selectedSamplesList.asMap().entries.map((e) {
            final code = _generateSampleCode(e.key);
            return SessionSample(
              sampleId: e.value.firestoreId ?? e.value.sample_id,
              sessionSampleCode: code,
              sortOrder: e.key + 1,
            );
          }).toList();

      // ── Build CuppingSession object ──
      final session = CuppingSession(
        sessionId: widget.existingSession?.sessionId,
        cuppingName: _cuppingNameController.text.trim(),
        description:
            _descController.text.trim().isEmpty
                ? 'No description'
                : _descController.text.trim(),
        startAt: startDateTime,
        endAt: endDateTime,
        isActive: 'Y',
        location:
            _locationController.text.trim().isEmpty
                ? 'Unknown location'
                : _locationController.text.trim(),
        cuppingModeId: _selectedCuppingModeId,
        sampleIdStructure: _getSampleIdStructureString(),
        participantLimit: int.tryParse(_participantLimitController.text) ?? 0,
        participationFee:
            _hasParticipationFee
                ? (int.tryParse(_participationFeeController.text) ?? 0)
                : 0,
        numberOfSamples: samples.length,
        imageUrl: _existingImageUrl, // จะอัปเดตทีหลังถ้ามีรูปใหม่
        isCreatedByMe: true,
      );

      if (widget.isEdit && widget.existingSession?.sessionId != null) {
        // ══ EDIT MODE ════════════════════════════════════════════════════════

        final sessionId = widget.existingSession!.sessionId!;

        // 1. อัปโหลดรูปใหม่ถ้ามี
        String? imageUrl = _existingImageUrl;
        if (_pickedImageFile != null) {
          imageUrl = await StorageService.uploadWithProgress(
            file: _pickedImageFile!,
            sessionId: sessionId,
            onProgress: (p) => setState(() => _uploadProgress = p),
          );
        }

        // 2. Update Firestore
        await CuppingService.updateSession(
          sessionId: sessionId,
          session: session.copyWith(imageUrl: imageUrl),
          samples: samples,
        );

        // 3. Return updated session
        final updated = session.copyWith(
          sessionId: sessionId,
          imageUrl: imageUrl,
        );
        if (mounted) Navigator.pop(context, updated);
      } else {
        // ══ CREATE MODE ══════════════════════════════════════════════════════

        // 1. อัปโหลดรูปชั่วคราวก่อน (ยังไม่รู้ sessionId)
        String? imageUrl;
        String? tempPath;
        if (_pickedImageFile != null) {
          final temp = await StorageService.uploadTempCoverImage(
            _pickedImageFile!,
          );
          imageUrl = temp.url;
          tempPath = temp.storagePath;
          setState(() => _uploadProgress = 0.5);
        }

        // 2. สร้าง session ใน Firestore
        final sessionId = await CuppingService.createSession(
          session: session.copyWith(imageUrl: imageUrl),
          samples: samples,
        );
        setState(() => _uploadProgress = 0.8);

        // 3. ย้ายรูปจาก temp → sessions/{sessionId}/cover.jpg
        if (tempPath != null) {
          imageUrl = await StorageService.moveTempToSession(
            tempPath: tempPath,
            sessionId: sessionId,
          );
          // อัปเดต imageUrl ใน Firestore
          await CuppingService.updateSession(
            sessionId: sessionId,
            session: session.copyWith(sessionId: sessionId, imageUrl: imageUrl),
          );
        }
        setState(() => _uploadProgress = 1.0);

        // 4. Return new session
        final newSession = session.copyWith(
          sessionId: sessionId,
          imageUrl: imageUrl,
          isCreatedByMe: true,
        );
        if (mounted) Navigator.pop(context, newSession);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ── Generate sample code ──────────────────────────────────────────────────

  String _generateSampleCode(int index) {
    switch (_selectedSampleIdStructure) {
      case 1: // 3 Digit
        return (100 + index).toString();
      case 2: // Letter
        return String.fromCharCode(65 + index); // A, B, C...
      default: // Number
        return (index + 1).toString();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
            onPressed: _goBackStep,
          ),
          centerTitle: true,
          title: Text(
            widget.isEdit ? "Edit Cupping Session" : "Add Cupping Session",
            style: const TextStyle(
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
          children: [
            // ── Upload progress bar ──
            if (_isSubmitting && _uploadProgress > 0 && _uploadProgress < 1)
              LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  secondaryColor2,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child:
                    _currentStep == 1 ? _buildFormStep() : _buildReviewStep(),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  // ── Step 1: Form ──────────────────────────────────────────────────────────

  Widget _buildFormStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Session Name"),
        _buildTextField(controller: _cuppingNameController),
        const SizedBox(height: 20),

        _buildLabel("Participant Limit"),
        _buildTextField(
          controller: _participantLimitController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Participation Fee",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Switch(
              value: _hasParticipationFee,
              activeColor: secondaryColor2,
              onChanged:
                  (value) => setState(() {
                    _hasParticipationFee = value;
                    if (!value) _participationFeeController.clear();
                  }),
            ),
          ],
        ),
        if (_hasParticipationFee) ...[
          _buildTextField(
            controller: _participationFeeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 12),

        _buildLabel("Upload Cupping Activity"),
        _buildUploadBox(),
        const SizedBox(height: 20),

        _buildLabel("Start Date & Time"),
        Row(
          children: [
            Expanded(
              child: _buildBoxWithIcon(
                _formatDate(_startDate),
                Icons.calendar_today,
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBoxWithIcon(
                _formatTime(_startTime),
                Icons.access_time_filled,
                onTap: () => _selectTime(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildLabel("Location"),
        _buildTextAreaField(controller: _locationController),
        const SizedBox(height: 20),

        _buildLabel("Cupping Activity Description"),
        _buildTextAreaField(controller: _descController),
        const SizedBox(height: 20),

        _buildLabel("Choose cupping mode (set by host)"),
        _buildDropdownField(
          "Select mode",
          _mockModes,
          _selectedCuppingModeId,
          (val) => setState(() => _selectedCuppingModeId = val),
        ),
        const SizedBox(height: 20),

        _buildLabel("Sample Id Structure"),
        Row(
          children: [
            _buildSampleIdOption(0, "Number (1,2,3..)"),
            _buildSampleIdOption(1, "3 Digit (i.e. 257)"),
            _buildSampleIdOption(2, "Letter (i.e. A,B)"),
          ],
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLabel("Number Of Sample"),
            Container(
              width: 60,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _numberOfSampleController,
                readOnly: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (_selectedSamplesList.isNotEmpty) _buildSelectedSamplesList(),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _openSampleInfoPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              elevation: 0,
            ),
            child: const Text(
              "Sample Info",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ── Step 2: Review ────────────────────────────────────────────────────────

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // รูปที่เลือก หรือรูปเดิม หรือ placeholder
        _buildReviewImage(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _cuppingNameController.text.isEmpty
                          ? "Cupping Session"
                          : _cuppingNameController.text,
                      style: const TextStyle(
                        fontSize: 20,
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
              const SizedBox(height: 8),
              Text(
                _locationController.text.isEmpty
                    ? "Location"
                    : _locationController.text,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                "${_formatDate(_startDate)} ${_formatTime(_startTime)}",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                _descController.text.isEmpty
                    ? "No description"
                    : _descController.text,
                style: TextStyle(color: Colors.grey[500], height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Cupping Protocol: ${_getCuppingModeName(_selectedCuppingModeId)}",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "All Coffee Samples (${_selectedSamplesList.length} Samples)",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedSamplesList.isNotEmpty)
                ..._selectedSamplesList.asMap().entries.map(
                  (e) => _buildBulletPoint(
                    "${_generateSampleCode(e.key)} — ${e.value.sample_name ?? '-'}",
                  ),
                )
              else
                _buildBulletPoint("No samples selected"),
              const SizedBox(height: 20),
              const Text(
                "Organizer",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint("My Coffee Farm"),
            ],
          ),
        ),
      ],
    );
  }

  // ── Reusable Widgets ──────────────────────────────────────────────────────

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child:
            _pickedImageFile != null
                ? Image.file(_pickedImageFile!, fit: BoxFit.cover)
                : _existingImageUrl != null
                ? Image.network(
                  _existingImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _uploadPlaceholder(),
                )
                : _uploadPlaceholder(),
      ),
    );
  }

  Widget _uploadPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 40,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            "Tap to select image",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewImage() {
    if (_pickedImageFile != null) {
      return Image.file(
        _pickedImageFile!,
        height: 280,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    if (_existingImageUrl != null) {
      return Image.network(
        _existingImageUrl!,
        height: 280,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.brown.shade100,
      child: const Icon(Icons.coffee, size: 80, color: Colors.brown),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: const BorderSide(color: Color(0xFFC67C4E), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTextAreaField({required TextEditingController controller}) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xFFC67C4E),
                width: 1.5,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 12,
          child: Text(
            "${controller.text.length}/200",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxWithIcon(
    String text,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            Icon(icon, size: 18, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String hint,
    List<Map<String, dynamic>> items,
    int? selectedValue,
    ValueChanged<int?> onChanged,
  ) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedValue,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items:
              items
                  .map(
                    (item) => DropdownMenuItem<int>(
                      value: (item['id'] as int?) ?? 0,
                      child: Text(
                        (item['name'] as String?) ?? 'Unknown',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSampleIdOption(int index, String text) {
    bool isSelected = _selectedSampleIdStructure == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSampleIdStructure = index),
        child: Container(
          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? secondaryColor2 : Colors.white,
            border: Border.all(
              color: isSelected ? secondaryColor2 : Colors.grey.shade400,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedSamplesList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Samples",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          ..._selectedSamplesList.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    "${entry.key + 1}.",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value.sample_name ?? "Unknown Sample",
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "ID: ${entry.value.sample_id ?? '-'}",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap:
                        () => setState(() {
                          _selectedSamplesList.removeAt(entry.key);
                          _numberOfSampleController.text =
                              _selectedSamplesList.length.toString();
                        }),
                    child: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6, left: 8),
    child: Row(
      children: [
        const Icon(Icons.circle, size: 6, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      ],
    ),
  );

  // ── Bottom Buttons ────────────────────────────────────────────────────────

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: _currentStep == 1 ? _buildStep1Buttons() : _buildStep2Buttons(),
    );
  }

  Widget _buildStep1Buttons() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _validateAndProceedToStep2,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          elevation: 0,
        ),
        child: Text(
          widget.isEdit ? "Save" : "Next",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStep2Buttons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : _goBackStep,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: secondaryColor2, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: const Text(
                "Back",
                style: TextStyle(
                  color: secondaryColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor2,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                elevation: 0,
              ),
              child:
                  _isSubmitting
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        widget.isEdit ? "Save Changes" : "Confirm",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }
}
