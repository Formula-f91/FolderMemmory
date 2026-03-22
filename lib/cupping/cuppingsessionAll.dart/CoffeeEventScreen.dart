// CoffeeEventScreen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wememmory/cupping/Service.dart/cupping_service.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/coffedetail_screen.dart';
import 'package:wememmory/cupping/creatcupping/add_cupping_session_screen.dart'
    hide CuppingSession;

const Color secondaryColor2 = Color(0xFF6B4226);
const Color primaryColor = Color(0xFF3E2723);

class CoffeeEventScreen extends StatefulWidget {
  const CoffeeEventScreen({super.key});

  @override
  State<CoffeeEventScreen> createState() => _CoffeeEventScreenState();
}

class _CoffeeEventScreenState extends State<CoffeeEventScreen> {
  String selectedCategory = "All";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Streams จาก Firestore ─────────────────────────────────────────────────
  // ใช้ StreamBuilder แทน setState ทำให้ข้อมูล real-time อัตโนมัติ
  late Stream<List<CuppingSession>> _allStream;
  late Stream<List<CuppingSession>> _myStream;
  late Stream<List<JoinCupping>> _joinStream;

  @override
  void initState() {
    super.initState();
    _allStream = CuppingService.streamAllSessions();
    _myStream = CuppingService.streamMySessions();
    _joinStream = CuppingService.streamJoinedSessions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Filter helper ─────────────────────────────────────────────────────────

  List<CuppingSession> _filterSessions(List<CuppingSession> sessions) {
    if (_searchQuery.isEmpty) return sessions;
    return sessions
        .where(
          (s) => (s.cuppingName ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  List<JoinCupping> _filterJoins(List<JoinCupping> joins) {
    if (_searchQuery.isEmpty) return joins;
    return joins
        .where(
          (j) => (j.cupping_session?.cuppingName ?? '').toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAddPage() async {
    // ไม่ต้อง setState เพราะ stream จะอัปเดตอัตโนมัติ
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCoffeeInfoPage()),
    );
  }

  Future<void> _openEditPage(CuppingSession session) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddCoffeeInfoPage(isEdit: true, existingSession: session),
      ),
    );
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
            ),
      ),
    );
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

  // ── Content (StreamBuilder แต่ละ tab) ─────────────────────────────────────

  Widget _buildContent() {
    if (selectedCategory == "All") {
      return StreamBuilder<List<CuppingSession>>(
        stream: _allStream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snap.hasError) return _buildError(snap.error.toString());
          final sessions = _filterSessions(snap.data ?? []);
          if (sessions.isEmpty) return _buildEmpty();
          return _buildSessionList(sessions, 'All');
        },
      );
    }

    if (selectedCategory == "Create") {
      return StreamBuilder<List<CuppingSession>>(
        stream: _myStream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snap.hasError) return _buildError(snap.error.toString());
          final sessions = _filterSessions(snap.data ?? []);
          if (sessions.isEmpty) return _buildEmpty();
          return _buildSessionList(sessions, 'Create');
        },
      );
    }

    // Join tab
    return StreamBuilder<List<JoinCupping>>(
      stream: _joinStream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }
        if (snap.hasError) return _buildError(snap.error.toString());
        final joins = _filterJoins(snap.data ?? []);
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
      },
    );
  }

  Widget _buildSessionList(List<CuppingSession> sessions, String pageType) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder:
          (context, index) => _buildEventCard(sessions[index], pageType, null),
    );
  }

  Widget _buildLoading() =>
      const Center(child: CircularProgressIndicator(color: secondaryColor2));

  Widget _buildError(String msg) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 40),
        const SizedBox(height: 8),
        Text(
          msg,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildEmpty() => Center(
    child: Text(
      _searchQuery.isNotEmpty
          ? 'ไม่พบ "$_searchQuery"'
          : 'ไม่มีข้อมูล Cupping Session',
      style: const TextStyle(color: Colors.grey),
    ),
  );

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
            _buildCoverImage(event.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.cuppingName ?? 'Unnamed Session',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
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
                      Container(
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
                    ],
                  ),
                  const SizedBox(height: 12),
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
                              : pageType == "Join"
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

  Widget _buildCoverImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
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
          (_, __, ___) => Container(
            height: 180,
            color: Colors.brown.shade100,
            child: const Icon(Icons.coffee, size: 60, color: Colors.brown),
          ),
    );
  }
}
