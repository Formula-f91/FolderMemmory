// CoffeeEventScreen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/coffedetail_screen.dart';
import 'package:wememmory/cupping/creatcupping/add_cupping_session_screen.dart' hide CuppingSession;

// ── Constants ─────────────────────────────────────────────────────────────────
const Color secondaryColor2 = Color(0xFF6B4226);
const Color primaryColor = Color(0xFF3E2723);

// ─────────────────────────────────────────────────────────────────────────────
// Mock Data  (ใช้ DateTime แทน String ตาม model ใหม่)
// ─────────────────────────────────────────────────────────────────────────────

final List<CuppingSession> _initialAllSessions = [
  CuppingSession(
    id: 1,
    sessionId: 'mock-1',
    cuppingName: 'Single Origin Showcase',
    description:
        'A cupping session focused on Ethiopian and Colombian single origins.',
    startAt: DateTime(2025, 4, 1, 9, 0),
    endAt: DateTime(2025, 4, 1, 12, 0),
    isActive: 'Y',
    location: 'Bangkok, Thailand',
    cuppingModeId: 1,
    numberOfSamples: 5,
    isCreatedByMe: false,
  ),
  CuppingSession(
    id: 2,
    sessionId: 'mock-2',
    cuppingName: 'Washed vs Natural',
    description:
        'Explore the differences between washed and natural processed beans.',
    startAt: DateTime(2025, 4, 10, 13, 0),
    endAt: DateTime(2025, 4, 10, 16, 0),
    isActive: 'N',
    location: 'Chiang Mai, Thailand',
    cuppingModeId: 2,
    numberOfSamples: 4,
    isCreatedByMe: false,
  ),
];

final List<JoinCupping> _initialJoinCupping = [
  JoinCupping(
    cupping_session: CuppingSession(
      id: 3,
      sessionId: 'mock-3',
      cuppingName: 'Espresso Deep Dive',
      description: 'Intensive espresso tasting session with baristas.',
      startAt: DateTime(2025, 4, 15, 10, 0),
      endAt: DateTime(2025, 4, 15, 13, 0),
      isActive: 'Y',
      location: 'Phuket, Thailand',
      isCreatedByMe: false,
    ),
    cupping_status: false,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// CoffeeEventScreen
// ─────────────────────────────────────────────────────────────────────────────

class CoffeeEventScreen extends StatefulWidget {
  const CoffeeEventScreen({super.key});

  @override
  State<CoffeeEventScreen> createState() => _CoffeeEventScreenState();
}

class _CoffeeEventScreenState extends State<CoffeeEventScreen> {
  String selectedCategory = "All";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<CuppingSession> _allSessions = List.from(_initialAllSessions);
  final List<CuppingSession> _mySessions = [];
  final List<JoinCupping> _joinCupping = List.from(_initialJoinCupping);

  // ── Filtered getters ──────────────────────────────────────────────────────

  List<CuppingSession> get _filteredAllSessions {
    // กรอง session ที่ join แล้วออก โดยเทียบจาก sessionId
    final joinedIds =
        _joinCupping.map((j) => j.cupping_session?.sessionId).toSet();
    final available =
        _allSessions.where((s) => !joinedIds.contains(s.sessionId)).toList();
    if (_searchQuery.isEmpty) return available;
    return available
        .where(
          (s) => (s.cuppingName ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  List<CuppingSession> get _filteredMySessions {
    if (_searchQuery.isEmpty) return _mySessions;
    return _mySessions
        .where(
          (s) => (s.cuppingName ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  List<JoinCupping> get _filteredJoinCupping {
    if (_searchQuery.isEmpty) return _joinCupping;
    return _joinCupping
        .where(
          (j) => (j.cupping_session?.cuppingName ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Join session ──────────────────────────────────────────────────────────

  void _joinSession(CuppingSession session) {
    final alreadyJoined = _joinCupping.any(
      (j) => j.cupping_session?.sessionId == session.sessionId,
    );
    if (alreadyJoined) return;
    setState(() {
      _joinCupping.add(
        JoinCupping(cupping_session: session, cupping_status: false),
      );
    });
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAddPage() async {
    final result = await Navigator.push<CuppingSession>(
      context,
      MaterialPageRoute(builder: (context) => const AddCoffeeInfoPage()),
    );
    if (result != null && mounted) {
      setState(() => _mySessions.add(result));
    }
  }

  Future<void> _openEditPage(CuppingSession session) async {
    final result = await Navigator.push<CuppingSession>(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddCoffeeInfoPage(isEdit: true, existingSession: session),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        // เทียบ sessionId แทน int id
        final index = _mySessions.indexWhere(
          (s) => s.sessionId == result.sessionId,
        );
        if (index != -1) _mySessions[index] = result;
      });
    }
  }

  void _openDetailScreen(
    CuppingSession event,
    String pageType,
    JoinCupping? join,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CoffeeDetailScreen(
              isAvailable: event.isActive == 'Y',
              eventData: event,
              pageType: pageType,
              joinCupping: join,
              onJoin: pageType == 'All' ? () => _joinSession(event) : null,
            ),
      ),
    ).then((_) => setState(() {}));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
          selectedCategory == "Join"
              ? null
              : Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: SizedBox(
                  width: 59,
                  height: 59,
                  child: FloatingActionButton(
                    onPressed: _openAddPage,
                    backgroundColor: secondaryColor2,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  // ── Content ───────────────────────────────────────────────────────────────

  Widget _buildContent() {
    if (selectedCategory == "All") {
      final sessions = _filteredAllSessions;
      if (sessions.isEmpty) return _buildEmpty();
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder:
            (context, index) => _buildEventCard(sessions[index], 'All', null),
      );
    }
    if (selectedCategory == "Create") {
      final sessions = _filteredMySessions;
      if (sessions.isEmpty) return _buildEmpty();
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sessions.length,
        itemBuilder:
            (context, index) =>
                _buildEventCard(sessions[index], 'Create', null),
      );
    }
    // Join tab
    final joins = _filteredJoinCupping;
    if (joins.isEmpty) return _buildEmpty();
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: joins.length,
      itemBuilder:
          (context, index) => _buildEventCard(
            joins[index].cupping_session!,
            'Join',
            joins[index],
          ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        _searchQuery.isNotEmpty
            ? 'ไม่พบ "$_searchQuery"'
            : 'ไม่มีข้อมูล Cupping Session',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 50,
            height: 50,
            color: Colors.white,
            child: const Center(
              child: Icon(Icons.qr_code_scanner, size: 28, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip("All"),
          _buildCategoryChip("Create"),
          _buildCategoryChip("Join"),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final bool isActive = selectedCategory == label;
    return GestureDetector(
      onTap:
          () => setState(() {
            selectedCategory = label;
            _searchQuery = '';
            _searchController.clear();
          }),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? secondaryColor2.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? secondaryColor2 : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? secondaryColor2 : Colors.black,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // ── Event Card ────────────────────────────────────────────────────────────

  Widget _buildEventCard(
    CuppingSession event,
    String pageType,
    JoinCupping? joinCupping,
  ) {
    // ✅ ใช้ DateTime โดยตรงจาก model ใหม่
    final String startDate =
        event.startAt != null
            ? DateFormat('dd/MM/yyyy (HH:mm)').format(event.startAt!)
            : 'N/A';
    final String endDate =
        event.endAt != null
            ? DateFormat('dd/MM/yyyy (HH:mm)').format(event.endAt!)
            : 'N/A';

    return GestureDetector(
      onTap: () => _openDetailScreen(event, pageType, joinCupping),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            _buildCoverImage(event.imageUrl),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title ──
                  Text(
                    event.cuppingName ?? 'Unnamed Session',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // ── Description ──
                  Text(
                    event.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // ── Date ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: secondaryColor2,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$startDate / $endDate',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  event.isActive == 'Y'
                                      ? const Color(0xFFE5F9EA)
                                      : Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              event.isActive == 'Y'
                                  ? 'Open for Evaluation'
                                  : 'Closed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color:
                                    event.isActive == 'Y'
                                        ? const Color(0xFF4CAF50)
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Location + Buttons ──
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 24, color: secondaryColor2),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location ?? 'Unknown location',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryColor2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Edit — Create tab only
                      if (pageType == "Create") ...[
                        ElevatedButton(
                          onPressed: () => _openEditPage(event),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: secondaryColor2,
                            side: BorderSide(color: secondaryColor2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            minimumSize: const Size(25, 32),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Action button
                      ElevatedButton(
                        onPressed:
                            () =>
                                _openDetailScreen(event, pageType, joinCupping),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(80, 32),
                        ),
                        child: Text(
                          pageType == "Join" &&
                                  joinCupping?.cupping_status == true
                              ? "Result"
                              : pageType == "Join" &&
                                  joinCupping?.cupping_status == false
                              ? "Start"
                              : "Read More",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Cover Image ───────────────────────────────────────────────────────────
  // ✅ รองรับทั้ง imageUrl จาก Firebase Storage และ fallback asset

  Widget _buildCoverImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
      );
    }
    return _fallbackImage();
  }

  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/coffee5.png',
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder:
          (context, error, stackTrace) => Container(
            height: 180,
            width: double.infinity,
            color: Colors.brown.shade100,
            child: const Icon(Icons.coffee, size: 60, color: Colors.brown),
          ),
    );
  }
}
