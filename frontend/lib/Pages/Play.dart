import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/API/fetch.dart';
import 'package:frontend/API/fetch_responses.dart';
import 'package:frontend/auth/authfunctions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// ─── Constants ──────────────────────────────────────────────────────────────

const List<Color> _kAnswerColors = [
  Color(0xFFE21B3C),
  Color(0xFF1368CE),
  Color(0xFFD89E00),
  Color(0xFF26890C),
];

const List<IconData> _kAnswerIcons = [
  Icons.change_history,
  Icons.diamond,
  Icons.circle,
  Icons.square,
];

const int _kAnswerSeconds = 20;
const String _kApiBase = 'https://stardance-hosting.tail5b0cb9.ts.net';

// Decodes HTML entities returned by the Open Trivia DB.
// Options are kept raw for server submission; this is only called for display.
String _decodeHtml(String text) {
  // Numeric decimal entities: &#NNN;
  text = text.replaceAllMapped(
    RegExp(r'&#(\d+);'),
    (m) => String.fromCharCode(int.parse(m.group(1)!)),
  );
  // Numeric hex entities: &#xHHH;
  text = text.replaceAllMapped(
    RegExp(r'&#x([0-9a-fA-F]+);', caseSensitive: false),
    (m) => String.fromCharCode(int.parse(m.group(1)!, radix: 16)),
  );
  // Common named entities (&amp; must be last)
  return text
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&ldquo;', '\u201C')
      .replaceAll('&rdquo;', '\u201D')
      .replaceAll('&lsquo;', '\u2018')
      .replaceAll('&rsquo;', '\u2019')
      .replaceAll('&ndash;', '\u2013')
      .replaceAll('&mdash;', '\u2014')
      .replaceAll('&hellip;', '\u2026')
      .replaceAll('&amp;', '&');
}

const _kGradient = LinearGradient(
  begin: Alignment(-0.35, -1),
  end: Alignment(0.35, 1),
  colors: [Color(0xFF2D1265), Color(0xFF46178F), Color(0xFF2D1265)],
  stops: [0.0, 0.55, 1.0],
);

// ─── PlayPageSetup ──────────────────────────────────────────────────────────

class PlayPageSetup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayPageSetupState();
}

class _PlayPageSetupState extends State<PlayPageSetup> {
  static const Map<String, String> _categories = {
    'Any Category': 'any',
    'General Knowledge': 'general knowledge',
    'Books': 'books',
    'Film': 'film',
    'Music': 'Music',
    'Musicals & Theater': 'musicals and theaters',
    'Television': 'tv',
    'Video Games': 'video games',
    'Board Games': 'board games',
    'Science & Nature': 'science and nature',
    'Science: Computers': 'science:computers',
    'Science: Math': 'science:math',
    'Mythology': 'mythology',
    'Sports': 'sports',
    'History': 'history',
    'Geography': 'geography',
    'Politics': 'politics',
    'Art': 'art',
    'Celebrities': 'celebrities',
    'Animals': 'animals',
    'Vehicles': 'vehicles',
    'Comics': 'comics',
    'Gadgets': 'gadgets',
    'Anime and Manga': 'anime and manga',
    'Cartoons and Animation': 'cartoons and animation',
  };

  static const Map<String, String> _questionTypes = {
    'Both': 'any',
    'Multiple Choice': 'multiple',
    'True/False': 'boolean',
  };

  static const Map<String, String> _difficulties = {
    'Any': 'any',
    'Easy': 'easy',
    'Medium': 'medium',
    'Hard': 'hard',
  };

  int _amount = 10;
  final Map<String, dynamic> _req = {
    'category': 'any',
    'difficulty': 'any',
    'type': 'any',
    'amount': 10,
  };

  Widget _buildDropdown(String label, Map<String, String> options, String key) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.novaSquare(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 12),
        DropdownMenu<String>(
          initialSelection: options.entries.first.value,
          width: 400,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.blueGrey[50]),
          ),
          onSelected: (String? value) => _req[key] = value,
          dropdownMenuEntries: options.entries
              .map((e) => DropdownMenuEntry(value: e.value, label: e.key))
              .toList(),
        ),
        const SizedBox(height: 35),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 700,
            constraints: const BoxConstraints(maxWidth: 700, maxHeight: 2000),
            decoration: BoxDecoration(
              color: Colors.blue.shade400,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Setup Session',
                    style:
                        GoogleFonts.novaSquare(fontSize: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 35),
                  _buildDropdown('Select Category', _categories, 'category'),
                  _buildDropdown('Select Question Type', _questionTypes, 'type'),
                  _buildDropdown('Select Difficulty', _difficulties, 'difficulty'),
                  Text(
                    'Number of Questions: $_amount',
                    style:
                        GoogleFonts.novaSquare(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: _amount.roundToDouble(),
                    min: 1,
                    max: 50,
                    onChanged: (double value) {
                      setState(() {
                        _amount = value.round();
                        _req['amount'] = _amount;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .findAncestorStateOfType<PlayPageState>()!
                          .startGame(Map.from(_req));
                    },
                    child: const Text('Start Session'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PlayPageGame ───────────────────────────────────────────────────────────

class PlayPageGame extends StatefulWidget {
  final Map<String, dynamic> sessionReq;
  const PlayPageGame({super.key, required this.sessionReq});

  @override
  State<StatefulWidget> createState() => _PlayPageGameState();
}

class _PlayPageGameState extends State<PlayPageGame>
    with SingleTickerProviderStateMixin {
  // ── Game state ─────────────────────────────────────────────────────────────
  bool _loading = true;
  String? _errorMessage;
  bool _answered = false;

  String _question = '';
  List<String> _options = [];
  int _questionNumber = 1;
  int _totalQuestions = 10;
  int _score = 0;
  int _correctCount = 0;
  int _answeredCount = 0;
  int _lastPoints = 0;
  String? _selectedAnswer;
  String? _correctAnswer;

  // ── Timer ──────────────────────────────────────────────────────────────────
  late AnimationController _timerController;
  int _timeLeft = _kAnswerSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _totalQuestions = widget.sessionReq['amount'] as int;
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _kAnswerSeconds),
    );
    _loadInitialQuestion();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _timerController.dispose();
    super.dispose();
  }

  // ── API ─────────────────────────────────────────────────────────────────────

  Future<void> _loadInitialQuestion() async {
    try {
      final req = widget.sessionReq;
      final gq = await fetch().getInitialQuestion(
        req['category'] as String,
        req['difficulty'] as String,
        req['type'] as String,
        req['amount'] as int,
      );
      if (!mounted) return;
      setState(() {
        _question = _decodeHtml(gq.firstQuestion);
        _options = (gq.options as List).cast<String>();
        _loading = false;
      });
      _startTimer();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Failed to load questions. Please try again.';
      });
    }
  }

  Future<void> _submitAnswer(String answer) async {
    if (_answered) return;
    _countdownTimer?.cancel();
    _timerController.stop();

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      _answeredCount++;
    });

    try {
      final token = getToken();
      final sessionId = getSessionId();
      final resp = await http.post(
        Uri.parse('$_kApiBase/api/session/check_answer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'sessionId': sessionId, 'answer': answer}),
      );

      if (!mounted) return;

      if (resp.statusCode == 200) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;

        // Backend returns EndingResponse when the last question is answered:
        // { "message": String, "correctAnswers": int, "totalQuestions": int }
        if (json.containsKey('message')) {
          final wasCorrect = (json['correctAnswers'] as int) > _correctCount;
          int points = 0;
          if (wasCorrect) {
            points =
                (_timeLeft / _kAnswerSeconds * 1000).round().clamp(100, 1000);
            setState(() {
              _correctAnswer = answer;
            });
          }
          setState(() {
            _score += points;
            _lastPoints = points;
            if (wasCorrect) _correctCount++;
          });
          await Future.delayed(const Duration(milliseconds: 2500));
          if (!mounted) return;
          _finishGame();
          return;
        }

        final cq = CheckQuestion.fromJson(json);

        int points = 0;
        if (cq.wasCorrect) {
          points =
              (_timeLeft / _kAnswerSeconds * 1000).round().clamp(100, 1000);
        }

        setState(() {
          _correctAnswer = cq.correctAnswer;
          _score += points;
          _lastPoints = points;
          if (cq.wasCorrect) _correctCount++;
        });

        await Future.delayed(const Duration(milliseconds: 2500));
        if (!mounted) return;

        final hasNext =
            cq.nextQuestion.isNotEmpty && cq.option.isNotEmpty;
        if (hasNext) {
          setState(() {
            _questionNumber++;
            _question = _decodeHtml(cq.nextQuestion);
            _options = (cq.option as List).cast<String>();
            _answered = false;
            _selectedAnswer = null;
            _correctAnswer = null;
            _lastPoints = 0;
          });
          _startTimer();
        } else {
          _finishGame();
        }
      }
    } catch (_) {
      if (mounted) _finishGame();
    }
  }

  void _finishGame() {
    context
        .findAncestorStateOfType<PlayPageState>()!
        .endGame(_score, _correctCount, _answeredCount, _totalQuestions);
  }

  // ── Timer ───────────────────────────────────────────────────────────────────

  void _startTimer() {
    _timeLeft = _kAnswerSeconds;
    _timerController
      ..reset()
      ..forward();
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _submitAnswer(''); // timeout → counts as wrong
      }
    });
  }

  // ── Button styling ──────────────────────────────────────────────────────────

  Color _buttonColor(int index) {
    final base = _kAnswerColors[index % _kAnswerColors.length];
    if (!_answered) return base;
    final opt = _options[index];
    if (opt == _correctAnswer) return const Color(0xFF27AE60);
    if (opt == _selectedAnswer) return Colors.red.shade700;
    return base.withValues(alpha: 0.3);
  }

  IconData _buttonIcon(int index) {
    if (!_answered) return _kAnswerIcons[index % _kAnswerIcons.length];
    final opt = _options[index];
    if (opt == _correctAnswer) return Icons.check_circle;
    if (opt == _selectedAnswer) return Icons.cancel;
    return _kAnswerIcons[index % _kAnswerIcons.length];
  }

  // ── Widget builders ─────────────────────────────────────────────────────────

  Widget _topChip(IconData icon, String label, {VoidCallback? onTap}) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x26FFFFFF),
        border: Border.all(color: const Color(0x4DFFFFFF), width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
    return onTap != null ? GestureDetector(onTap: onTap, child: chip) : chip;
  }

  Widget _buildAnswerButton(int index) {
    if (index >= _options.length) return const SizedBox.shrink();
    final text = _options[index];
    return GestureDetector(
      onTap: _answered ? null : () => _submitAnswer(text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            const EdgeInsets.symmetric(horizontal: 19, vertical: 18),
        decoration: BoxDecoration(
          color: _buttonColor(index),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              blurRadius: 0,
              offset: Offset(0, _answered ? 0 : 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(_buttonIcon(index), size: 26, color: Colors.white),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _decodeHtml(text),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerGrid() {
    // True/False: 2 tall stacked buttons
    if (_options.length <= 2) {
      return Column(
        children: [
          Expanded(child: _buildAnswerButton(0)),
          const SizedBox(height: 12),
          Expanded(child: _buildAnswerButton(1)),
        ],
      );
    }
    // Multiple choice: 2×2 grid
    return Column(
      children: [
        Expanded(
          child: Row(children: [
            Expanded(child: _buildAnswerButton(0)),
            const SizedBox(width: 12),
            Expanded(child: _buildAnswerButton(1)),
          ]),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Row(children: [
            Expanded(child: _buildAnswerButton(2)),
            const SizedBox(width: 12),
            Expanded(child: _buildAnswerButton(3)),
          ]),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: const BoxDecoration(gradient: _kGradient),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            const SizedBox(height: 24),
            Text(
              'Loading questions…',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      decoration: const BoxDecoration(gradient: _kGradient),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 60),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context
                    .findAncestorStateOfType<PlayPageState>()!
                    .setScreen(1),
                child: const Text('Back to Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildLoading();
    if (_errorMessage != null) return _buildError();

    final timerColor = _timeLeft > 10
        ? Colors.white
        : (_timeLeft > 5 ? Colors.orange : Colors.red.shade400);

    return Container(
      decoration: const BoxDecoration(gradient: _kGradient),
      child: SafeArea(
        child: Column(
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Container(
              color: const Color(0x4D000000),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topChip(
                    Icons.format_list_numbered,
                    'Q $_questionNumber / $_totalQuestions',
                  ),
                  // Score chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x59000000),
                          blurRadius: 14,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt,
                            size: 19, color: Color(0xFFFFA602)),
                        const SizedBox(width: 6),
                        Text(
                          '$_score',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Color(0xFF2D1265),
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _topChip(
                    Icons.stop_circle_outlined,
                    'End',
                    onTap: _finishGame,
                  ),
                ],
              ),
            ),

            // ── Timer bar ──────────────────────────────────────────────────
            AnimatedBuilder(
              animation: _timerController,
              builder: (_, child) {
                final frac = _answered
                    ? 0.0
                    : (1 - _timerController.value).clamp(0.0, 1.0);
                return Container(
                  height: 9,
                  color: const Color(0x4D000000),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: frac,
                      child: Container(
                        decoration: BoxDecoration(
                          color: timerColor,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Timer / Points feedback ────────────────────────────────────
            SizedBox(
              height: 28,
              child: Center(
                child: _answered
                    ? (_lastPoints > 0
                        ? Text(
                            '+$_lastPoints pts',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              color: Color(0xFF7BE8A1),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          )
                        : const Text(
                            'No points',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Color(0xFFFF8A8A),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ))
                    : Text(
                        '$_timeLeft',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: timerColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),

            // ── Question card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 130),
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x59000000),
                    blurRadius: 30,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 22,
                    height: 1.4,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A0540),
                  ),
                ),
              ),
            ),

            // ── Answer grid ────────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: _buildAnswerGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PlayPageResults ─────────────────────────────────────────────────────────

class PlayPageResults extends StatelessWidget {
  final int score;
  final int correctCount;
  final int answeredCount;
  final int totalQuestions;

  const PlayPageResults({
    super.key,
    required this.score,
    required this.correctCount,
    required this.answeredCount,
    required this.totalQuestions,
  });

  Widget _statBadge(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pct = answeredCount > 0
        ? (correctCount / answeredCount * 100).round()
        : 0;

    return Container(
      decoration: const BoxDecoration(gradient: _kGradient),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 480,
            padding:
                const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
            decoration: BoxDecoration(
              color: const Color(0xCC1A0540),
              border:
                  Border.all(color: const Color(0x4DFFFFFF), width: 2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events,
                    size: 72, color: Color(0xFFFFA602)),
                const SizedBox(height: 12),
                const Text(
                  'Game Over!',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Score card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 24, horizontal: 32),
                  decoration: BoxDecoration(
                    color: const Color(0x26FFFFFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'FINAL SCORE',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: Color(0xCCFFFFFF),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt,
                              size: 32, color: Color(0xFFFFA602)),
                          const SizedBox(width: 8),
                          Text(
                            '$score',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1, color: const Color(0x33FFFFFF)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statBadge(
                            Icons.check_circle,
                            '$correctCount correct',
                            const Color(0xFF7BE8A1),
                          ),
                          _statBadge(
                            Icons.percent,
                            '$pct% accuracy',
                            Colors.white70,
                          ),
                          _statBadge(
                            Icons.format_list_numbered,
                            '$answeredCount answered',
                            Colors.white70,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF46178F),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => context
                          .findAncestorStateOfType<PlayPageState>()!
                          .setScreen(1),
                      icon: const Icon(Icons.replay),
                      label: const Text(
                        'Play Again',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                            color: Color(0x66FFFFFF), width: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/leaderboard'),
                      icon: const Icon(Icons.leaderboard),
                      label: const Text(
                        'Leaderboard',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── PlayPage ────────────────────────────────────────────────────────────────

class PlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PlayPageState();
}

class PlayPageState extends State<PlayPage> {
  int _screen = 1; // 1 = setup, 2 = game, 3 = results
  Map<String, dynamic> _sessionReq = {
    'category': 'any',
    'difficulty': 'any',
    'type': 'any',
    'amount': 10,
  };
  int _finalScore = 0;
  int _finalCorrect = 0;
  int _finalAnswered = 0;

  void setScreen(int num) => setState(() => _screen = num);

  // Kept for any existing call sites
  void setBody(int num) => setScreen(num);

  void startGame(Map<String, dynamic> req) {
    setState(() {
      _sessionReq = req;
      _screen = 2;
    });
  }

  void endGame(int score, int correct, int answered, int total) {
    setState(() {
      _finalScore = score;
      _finalCorrect = correct;
      _finalAnswered = answered;
      _sessionReq['amount'] = total;
      _screen = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_screen) {
      case 2:
        return PlayPageGame(sessionReq: _sessionReq);
      case 3:
        return PlayPageResults(
          score: _finalScore,
          correctCount: _finalCorrect,
          answeredCount: _finalAnswered,
          totalQuestions: _sessionReq['amount'] as int,
        );
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: PlayPageSetup(),
        );
    }
  }
}