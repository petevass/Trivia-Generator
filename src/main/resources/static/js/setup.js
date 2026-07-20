let selectedDifficulty = 'any';
let selectedType = 'any';

document.addEventListener('DOMContentLoaded', () => {
    if (!requireAuth()) return;

    // Amount slider
    const slider  = document.getElementById('amount-slider');
    const display = document.getElementById('amount-display');
    slider.addEventListener('input', () => { display.textContent = slider.value; });

    // Difficulty picker
    document.querySelectorAll('[data-difficulty]').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('[data-difficulty]').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            selectedDifficulty = btn.dataset.difficulty;
        });
    });

    // Type picker
    document.querySelectorAll('[data-type]').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('[data-type]').forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            selectedType = btn.dataset.type;
        });
    });

    // Submit
    document.getElementById('setup-form').addEventListener('submit', async e => {
        e.preventDefault();
        const category = document.getElementById('category-select').value;
        const amount   = parseInt(slider.value);
        const errorEl  = document.getElementById('setup-error');
        const btn      = document.getElementById('start-btn');

        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Starting...';
        errorEl.style.display = 'none';

        try {
            const res = await authFetch('/api/session/start', {
                method: 'POST',
                body: JSON.stringify({ category, difficulty: selectedDifficulty, type: selectedType, amount })
            });
            const data = await res.json();

            if (res.ok && data.sessionId) {
                localStorage.setItem('trivia_session_id', data.sessionId);
                localStorage.setItem('trivia_amount', amount);
                window.location.href = '/pages/session/play';
            } else {
                errorEl.textContent  = typeof data === 'string' ? data : 'Failed to start session. Try again.';
                errorEl.style.display = 'block';
            }
        } catch {
            errorEl.textContent  = 'Network error. Please try again.';
            errorEl.style.display = 'block';
        } finally {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-play-fill me-2"></i>Start Session';
        }
    });
});