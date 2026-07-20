let sessionId      = null;
let totalQuestions = 10;
let questionsAnswered = 0;
let score          = 0;
let locked         = false; // prevent double-answers

document.addEventListener('DOMContentLoaded', async () => {
    if (!requireAuth()) return;

    sessionId      = localStorage.getItem('trivia_session_id');
    totalQuestions = parseInt(localStorage.getItem('trivia_amount') || '10');
    if (!sessionId) { window.location.href = '/pages/session/setup'; return; }

    document.getElementById('end-session-btn').addEventListener('click', endEarly);

    window.addEventListener('beforeunload', () => {
        const id = sessionId;
        const token = getToken();
        if (!id || !token) return;

        fetch('/api/session/end_session', {
            method: 'GET',
            headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + token },
            keepalive: true
        });
    });

    await loadFirstQuestion();
});

async function loadFirstQuestion() {
    showScreen('loading');
    try {
        const res = await authFetch('/api/session/get_questions', {
            method: 'POST',
            body: JSON.stringify({ sessionId })
        });
        if (!res || !res.ok) { showError('Could not load questions. Start a new session.'); return; }
        const data = await res.json();
        showScreen('game');
        displayQuestion(data.firstQuestion, data.options);
    } catch {
        showError('Network error loading questions.');
    }
}

function displayQuestion(question, options) {
    locked = false;
    document.getElementById('feedback-banner').style.display = 'none';
    document.getElementById('question-text').innerHTML = decode(question);

    const container = document.getElementById('answers-container');
    container.innerHTML = '';

    options.forEach(opt => {
        const btn = document.createElement('button');
        btn.className      = 'answer-btn';
        btn.innerHTML      = decode(opt);
        btn.dataset.raw    = opt; // raw value for submission
        btn.addEventListener('click', () => submitAnswer(opt, btn));
        container.appendChild(btn);
    });

    updateHUD();
}

async function submitAnswer(answer, clicked) {
    if (locked) return;
    locked = true;
    document.querySelectorAll('.answer-btn').forEach(b => b.disabled = true);

    try {
        const res = await authFetch('/api/session/check_answer', {
            method: 'POST',
            body: JSON.stringify({ sessionId, answer })
        });
        const data = await res.json();

        if ('wasCorrect' in data) {
            // Game continues — CheckAnswerResponse
            questionsAnswered++;
            if (data.wasCorrect) score++;

            // Highlight buttons
            document.querySelectorAll('.answer-btn').forEach(b => {
                if (b.dataset.raw === data.correctAnswer) b.classList.add('correct');
            });
            if (!data.wasCorrect) clicked.classList.add('wrong');

            showFeedback(data.wasCorrect, data.correctAnswer);
            updateHUD();

            setTimeout(() => {
                displayQuestion(data.nextQuestion, data.options);
            }, 1500);

        } else {
            // Game over — EndingResponse
            questionsAnswered++;
            sessionId = null; // prevent beforeunload from hitting end_session again
            localStorage.removeItem('trivia_session_id');
            localStorage.removeItem('trivia_amount');
            showResults(data);
        }
    } catch {
        showError('Network error. Please try again.');
        locked = false;
        document.querySelectorAll('.answer-btn').forEach(b => b.disabled = false);
    }
}

function showResults(data) {
    document.getElementById('progress-bar').style.width = '100%';
    showScreen('results');
    const correct  = data.correctAnswers ?? score;
    const total    = data.totalQuestions ?? questionsAnswered;
    const accuracy = total > 0 ? Math.round(correct / total * 100) : 0;

    document.getElementById('results-correct').textContent  = correct;
    document.getElementById('results-total').textContent    = total;
    document.getElementById('results-accuracy').textContent = accuracy + '%';
    document.getElementById('results-message').textContent  = data.message ?? '';
}

async function endEarly() {
    if (!confirm('End this session? Progress will not be saved.')) return;
    try {
        alert(getToken())
        await authFetch('/api/session/end_session', {
            method: 'GET',
            header:{
                'Authorization': 'Bearer ' + getToken()
            }
        })

    }catch {}
    sessionId = null; // prevent beforeunload from double-firing
    localStorage.removeItem('trivia_session_id');
    localStorage.removeItem('trivia_amount');
    window.location.href = '/';
}

function showFeedback(correct, correctAnswer) {
    const el = document.getElementById('feedback-banner');
    el.className = 'feedback-banner ' + (correct ? 'correct' : 'wrong');
    el.innerHTML = correct
        ? '<i class="bi bi-check-circle-fill me-2"></i>Correct!'
        : `<i class="bi bi-x-circle-fill me-2"></i>Wrong! Answer: <strong>${decode(correctAnswer)}</strong>`;
    el.style.display = 'block';
}

function updateHUD() {
    const pct = totalQuestions > 0 ? Math.round(questionsAnswered / totalQuestions * 100) : 0;
    document.getElementById('progress-bar').style.width = pct + '%';
    document.getElementById('progress-text').textContent = (questionsAnswered + 1) + ' / ' + totalQuestions;
    document.getElementById('current-score').textContent = score;
}

function showScreen(name) {
    ['loading', 'error', 'game', 'results'].forEach(s => {
        document.getElementById(s + '-screen').classList.toggle('d-none', s !== name);
    });
}

function showError(msg) {
    showScreen('error');
    document.getElementById('error-msg').textContent = msg;
}

function decode(str) {
    const t = document.createElement('textarea');
    t.innerHTML = str;
    return t.value;
}