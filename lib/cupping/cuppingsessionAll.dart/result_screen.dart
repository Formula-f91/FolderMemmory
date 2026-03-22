// result_screen.dart  (lib/cupping/cuppingsessionAll.dart/result_screen.dart)
import 'package:flutter/material.dart';
import 'package:wememmory/cupping/Service.dart/cupping_service.dart';
import 'package:wememmory/cupping/Service.dart/evaluation_service.dart';
import 'package:wememmory/cupping/cuppingsessionAll.dart/cupping_session_model.dart';
import 'package:wememmory/cupping/creatcupping/sample_coffee_model.dart';


const Color secondaryColor2 = Color(0xFF6B4226);

class ResultScreen extends StatefulWidget {
  final CuppingSession session;

  const ResultScreen({super.key, required this.session});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLoading = true;
  String? _errorMsg;

  List<Evaluation> _evaluations = [];
  List<SessionSample> _sessionSamples = [];

  // ✅ คะแนนเฉลี่ย: Map<sessionSampleId, Map<field, avgScore>>
  Map<String, Map<String, double>> _aggregated = {};

  // จำนวน participant ที่ทำเสร็จ
  int _doneCount = 0;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() { _isLoading = true; _errorMsg = null; });
    try {
      final sessionId = widget.session.sessionId!;

      // โหลดพร้อมกัน
      final results = await Future.wait([
        EvaluationService.getSessionEvaluations(sessionId),
        CuppingService.getSessionSamples(sessionId),
        EvaluationService.countDoneParticipants(sessionId),
      ]);

      final evals = results[0] as List<Evaluation>;
      final samples = results[1] as List<SessionSample>;
      final done = results[2] as int;

      setState(() {
        _evaluations = evals;
        _sessionSamples = samples;
        _doneCount = done;
        _aggregated = EvaluationService.aggregateScores(evals);
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _errorMsg = e.toString(); _isLoading = false; });
    }
  }

  // ── label ชื่อ field สวยงาม ───────────────────────────────────────────────
  String _fieldLabel(String key) {
    const map = {
      'fragrance': 'Fragrance',
      'aroma': 'Aroma',
      'flavor': 'Flavor',
      'aftertaste': 'Aftertaste',
      'acidity': 'Acidity',
      'body': 'Body',
      'balance': 'Balance',
      'overall': 'Overall',
      'overallLiking': 'Overall Liking',
      'appearanceLiking': 'Appearance',
      'aromaLiking': 'Aroma Liking',
      'flavorLiking': 'Flavor Liking',
      'score': 'Score',
    };
    return map[key] ?? key;
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text("Results",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadResults,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: secondaryColor2))
          : _errorMsg != null
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildError() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_errorMsg!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadResults,
              style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor2,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text("Retry",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Session info header ──
          _buildSessionHeader(),
          const SizedBox(height: 24),

          // ── Summary stats ──
          _buildSummaryRow(),
          const SizedBox(height: 24),

          const Divider(),
          const SizedBox(height: 16),

          // ── Per sample results ──
          if (_sessionSamples.isEmpty)
            Center(
              child: Text("No samples found",
                  style: TextStyle(color: Colors.grey.shade400)),
            )
          else
            ..._sessionSamples.map((s) => _buildSampleResult(s)),
        ],
      ),
    );
  }

  // ── Session header ────────────────────────────────────────────────────────

  Widget _buildSessionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.session.cuppingName ?? "Cupping Session",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          widget.session.cuppingModeName,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        if (widget.session.location != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 14, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(widget.session.location!,
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 13)),
            ],
          ),
        ],
      ],
    );
  }

  // ── Summary row ───────────────────────────────────────────────────────────

  Widget _buildSummaryRow() {
    // นับ unique participant
    final participantCount =
        _evaluations.map((e) => e.participantUid).toSet().length;

    return Row(
      children: [
        _buildStatCard(
            label: "Samples",
            value: _sessionSamples.length.toString(),
            icon: Icons.coffee),
        const SizedBox(width: 12),
        _buildStatCard(
            label: "Participants",
            value: participantCount.toString(),
            icon: Icons.people_outline),
        const SizedBox(width: 12),
        _buildStatCard(
            label: "Completed",
            value: _doneCount.toString(),
            icon: Icons.check_circle_outline),
      ],
    );
  }

  Widget _buildStatCard(
      {required String label,
      required String value,
      required IconData icon}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: secondaryColor2.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: secondaryColor2.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: secondaryColor2, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor2)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // ── Per sample result card ────────────────────────────────────────────────

  Widget _buildSampleResult(SessionSample sample) {
    final sampleId = sample.id ?? '';
    final scores = _aggregated[sampleId];

    // นับ evaluations ของ sample นี้
    final evalCount = _evaluations
        .where((e) => e.sessionSampleId == sampleId)
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sample header ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: secondaryColor2.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sample ${sample.sessionSampleCode ?? '-'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: secondaryColor2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: secondaryColor2.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("$evalCount evaluations",
                      style: const TextStyle(
                          fontSize: 11,
                          color: secondaryColor2,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),

          // ── Scores ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: scores == null || scores.isEmpty
                ? Center(
                    child: Text("No evaluations yet",
                        style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13)),
                  )
                : Column(
                    children: scores.entries.map((entry) {
                      return _buildScoreRow(
                          _fieldLabel(entry.key), entry.value);
                    }).toList(),
                  ),
          ),

          // ── Average total (ถ้ามี score หลายตัว) ──
          if (scores != null && scores.length > 1) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Average Total",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    _calcTotal(scores).toStringAsFixed(2),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: secondaryColor2),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Score row with bar ────────────────────────────────────────────────────

  Widget _buildScoreRow(String label, double score) {
    // สมมุติ max score = 10
    const double maxScore = 10.0;
    final double ratio = (score / maxScore).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87)),
              Text(score.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor2)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(secondaryColor2),
            ),
          ),
        ],
      ),
    );
  }

  double _calcTotal(Map<String, double> scores) {
    if (scores.isEmpty) return 0;
    return scores.values.reduce((a, b) => a + b) / scores.length;
  }
}