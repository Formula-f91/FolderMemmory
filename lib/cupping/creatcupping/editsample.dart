// edit_sample_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';

const Color secondaryColor2 = Color(0xFF6B4226);

class EditSamplePage extends StatefulWidget {
  final SampleCoffee sampleData;
  final String sampleNumber;
  final bool isAddMode;

  const EditSamplePage({
    super.key,
    required this.sampleData,
    required this.sampleNumber,
    this.isAddMode = false,
  });

  @override
  State<EditSamplePage> createState() => _EditSamplePageState();
}

class _EditSamplePageState extends State<EditSamplePage> {
  // ── Controllers ───────────────────────────────────────────────────────────
  late TextEditingController _nameController;
  late TextEditingController _harvestController;
  late TextEditingController _moistureController;
  late TextEditingController _waterActivityController;
  late TextEditingController _densityController;
  late TextEditingController _coffeeProcessingController;
  late TextEditingController _agtronNumberController;

  // ── State ─────────────────────────────────────────────────────────────────
  String _selectedRoastLevel = 'Light';
  String? _selectedSampleType;
  String? _selectedCropYear;
  String? _selectedSpecies;
  String? _selectedCountry;
  bool _isLoading = false;

  // ── Mock dropdown data (แทน API) ──────────────────────────────────────────
  final List<String> _sampleTypeItems = [
    'Green Bean',
    'Roasted Bean',
    'Ground Coffee',
    'Instant Coffee',
  ];
  final List<String> _speciesItems = [
    'Arabica',
    'Robusta',
    'Liberica',
    'Excelsa',
  ];
  final List<String> _cropYearItems = ['2022', '2023', '2024', '2025', '2026'];
  final List<String> _countryItems = [
    'Thailand',
    'Brazil',
    'Ethiopia',
    'Colombia',
    'Vietnam',
    'Indonesia',
  ];

  // ── ID counter ────────────────────────────────────────────────────────────
  static int _sampleIdCounter = 1000;

  @override
  void initState() {
    super.initState();

    final s = widget.sampleData;
    _nameController = TextEditingController(
      text: widget.isAddMode ? '' : (s.sample_name ?? ''),
    );
    _harvestController = TextEditingController(
      text: widget.isAddMode ? '' : (s.harvest ?? ''),
    );

    final initialMoisture = s.moisture?.toString() ?? '';
    _moistureController = TextEditingController(
      text:
          (widget.isAddMode || initialMoisture == '0.0') ? '' : initialMoisture,
    );

    final initialWa = s.water_activity?.toString() ?? '';
    _waterActivityController = TextEditingController(
      text: (widget.isAddMode || initialWa == '0.0') ? '' : initialWa,
    );

    final initialDensity = s.density?.toString() ?? '';
    _densityController = TextEditingController(
      text: (widget.isAddMode || initialDensity == '0.0') ? '' : initialDensity,
    );

    _coffeeProcessingController = TextEditingController(
      text: widget.isAddMode ? '' : (s.coffee_processing ?? ''),
    );
    _agtronNumberController = TextEditingController(
      text: widget.isAddMode ? '' : (s.color_intensity ?? ''),
    );

    if (!widget.isAddMode) {
      _selectedSpecies = s.sample_species?.name;
      _selectedSampleType = s.sample_type?.name;
      _selectedCropYear = s.crop_year?.toString();
      _selectedCountry = s.country;
      if (s.roast_level != null && s.roast_level!.isNotEmpty) {
        _selectedRoastLevel = s.roast_level!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _harvestController.dispose();
    _moistureController.dispose();
    _waterActivityController.dispose();
    _densityController.dispose();
    _coffeeProcessingController.dispose();
    _agtronNumberController.dispose();
    super.dispose();
  }

  // ── Validate ──────────────────────────────────────────────────────────────

  String? _validate() {
    if (_nameController.text.trim().isEmpty) return 'Please enter Sample Name';
    if (_selectedSampleType == null) return 'Please select Sample Type';

    if (_moistureController.text.trim().isNotEmpty &&
        double.tryParse(_moistureController.text) == null) {
      return 'Moisture must be a number';
    }
    if (_waterActivityController.text.trim().isNotEmpty) {
      final waValue = double.tryParse(_waterActivityController.text.trim());
      if (waValue == null) return 'Water Activity must be a number';
      if (waValue > 1.0) return 'Water Activity must not exceed 1.0';
    }
    if (_densityController.text.trim().isNotEmpty &&
        double.tryParse(_densityController.text) == null) {
      return 'Density must be a number';
    }
    return null;
  }

  // ── Save: สร้าง SampleCoffee แล้ว pop กลับ ────────────────────────────────

  void _onSave() {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // หน่วงเล็กน้อยเพื่อ simulate saving
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      final newId =
          widget.isAddMode
              ? ++_sampleIdCounter
              : (widget.sampleData.id ?? ++_sampleIdCounter);
      final newSampleId =
          widget.isAddMode
              ? 'S${newId.toString().padLeft(4, '0')}'
              : (widget.sampleData.sample_id ??
                  'S${newId.toString().padLeft(4, '0')}');

      final result = SampleCoffee(
        id: newId,
        sample_id: newSampleId,
        sample_name: _nameController.text.trim(),
        species: _selectedSpecies,
        harvest: _harvestController.text.trim(),
        moisture: double.tryParse(_moistureController.text.trim()),
        water_activity: double.tryParse(_waterActivityController.text.trim()),
        density: double.tryParse(_densityController.text.trim()),
        coffee_processing: _coffeeProcessingController.text.trim(),
        crop_year: int.tryParse(_selectedCropYear ?? ''),
        country: _selectedCountry,
        created_at:
            widget.sampleData.created_at ?? DateTime.now().toIso8601String(),
        color_intensity: _agtronNumberController.text.trim(),
        roast_level: _selectedRoastLevel,
        sample_type:
            _selectedSampleType != null
                ? SampleType(
                  id: _sampleTypeItems.indexOf(_selectedSampleType!) + 1,
                  name: _selectedSampleType,
                )
                : null,
        sample_species:
            _selectedSpecies != null
                ? SampleSpecies(
                  id: _speciesItems.indexOf(_selectedSpecies!) + 1,
                  name: _selectedSpecies,
                )
                : null,
      );

      setState(() => _isLoading = false);
      Navigator.pop(context, result);
    });
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
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          widget.isAddMode ? "Add Sample" : "Edit Sample",
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.sampleNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if ((widget.sampleData.sample_id ?? '').isNotEmpty)
                        Text(
                          "Sample ID : ${widget.sampleData.sample_id}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Row 1: Sample Name + Sample Type ──
                  _buildRow(
                    left: _buildField(
                      "Sample Name *",
                      _buildTextField(_nameController),
                    ),
                    right: _buildField(
                      "Sample Type *",
                      _buildDropdown(
                        items: _sampleTypeItems,
                        value: _selectedSampleType,
                        onChanged:
                            (v) => setState(() => _selectedSampleType = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Row 2: Harvest + Moisture ──
                  _buildRow(
                    left: _buildField(
                      "Harvest",
                      _buildTextField(_harvestController),
                    ),
                    right: _buildField(
                      "Moisture",
                      _buildTextFieldSuffix(_moistureController, "%"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Row 3: Water Activity + Density ──
                  _buildRow(
                    left: _buildField(
                      "Water Activity",
                      _buildTextField(
                        _waterActivityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    right: _buildField(
                      "Density",
                      _buildTextFieldSuffix(_densityController, "g/L"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Row 4: Crop Year + Species ──
                  _buildRow(
                    left: _buildField(
                      "Crop Year",
                      _buildDropdown(
                        items: _cropYearItems,
                        value: _selectedCropYear,
                        onChanged: (v) => setState(() => _selectedCropYear = v),
                      ),
                    ),
                    right: _buildField(
                      "Species",
                      _buildDropdown(
                        items: _speciesItems,
                        value: _selectedSpecies,
                        onChanged: (v) => setState(() => _selectedSpecies = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Row 5: Coffee Processing + Country ──
                  _buildRow(
                    left: _buildField(
                      "Coffee Processing",
                      _buildTextField(_coffeeProcessingController),
                    ),
                    right: _buildField(
                      "Country",
                      _buildDropdown(
                        items: _countryItems,
                        value: _selectedCountry,
                        onChanged: (v) => setState(() => _selectedCountry = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Roasting color section ──
                  const Text(
                    "Roasting color",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildField(
                    "Agtron Number",
                    _buildTextField(
                      _agtronNumberController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Roasting Level",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(child: _buildRoastLevelButton("Light")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildRoastLevelButton("Medium")),
                      const SizedBox(width: 8),
                      Expanded(child: _buildRoastLevelButton("Dark")),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // ── Reusable Widgets ──────────────────────────────────────────────────────

  Widget _buildRow({required Widget left, required Widget right}) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildField(String label, Widget input) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
        input,
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        enabled: !_isLoading,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: _inputDecoration(),
      ),
    );
  }

  Widget _buildTextFieldSuffix(
    TextEditingController controller,
    String suffix,
  ) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        enabled: !_isLoading,
        decoration: _inputDecoration().copyWith(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  suffix,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: _isLoading ? Colors.grey.shade100 : Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
            size: 20,
          ),
          onChanged: _isLoading ? null : onChanged,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 13)),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildRoastLevelButton(String level) {
    final bool isSelected = _selectedRoastLevel == level;
    return GestureDetector(
      onTap:
          _isLoading ? null : () => setState(() => _selectedRoastLevel = level),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003399) : Colors.white,
          border: Border.all(color: const Color(0xFF003399)),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: Text(
            level,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF003399),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFFC67C4E), width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor2,
            disabledBackgroundColor: secondaryColor2.withOpacity(0.6),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 0,
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                  : const Text(
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
