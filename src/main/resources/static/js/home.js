document.addEventListener('DOMContentLoaded', async () => {
    if (!isLoggedIn()) return; // stay on guest view

    document.getElementById('guest-actions')?.classList.add('d-none');
    document.getElementById('user-actions')?.classList.remove('d-none');
    document.getElementById('user-stats')?.classList.remove('d-none');

    try {
        const res = await authFetch('/api/user/me');
        if (!res || !res.ok) return;
        const data = await res.json();

        document.getElementById('home-total').textContent   = data.totalAnswered;
        document.getElementById('home-correct').textContent = data.totalCorrect;
        document.getElementById('home-accuracy').textContent = data.totalAnswered > 0
            ? Math.round(data.totalCorrect / data.totalAnswered * 100) + '%'
            : '0%';
    } catch (e) {
        console.error('Failed to load stats', e);
    }
});