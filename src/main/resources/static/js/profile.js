document.addEventListener('DOMContentLoaded', async () => {
    if (!requireAuth()) return;

    try {
        const res = await authFetch('/api/user/me');
        if (!res || !res.ok) { logout(); return; }
        const data = await res.json();

        document.getElementById('loading-section')?.classList.add('d-none');
        document.getElementById('profile-content')?.classList.remove('d-none');

        // Avatar initials
        const initials = data.username.slice(0, 2).toUpperCase();
        document.getElementById('user-avatar').textContent = initials;
        document.getElementById('user-name').textContent   = data.username;

        // Stats
        const wrong    = Math.max(0, data.totalAnswered - data.totalCorrect);
        const accuracy = data.totalAnswered > 0 ? Math.round(data.totalCorrect / data.totalAnswered * 100) : 0;

        document.getElementById('total-answered').textContent = data.totalAnswered;
        document.getElementById('total-correct').textContent  = data.totalCorrect;
        document.getElementById('total-wrong').textContent    = wrong;
        document.getElementById('accuracy').textContent       = accuracy + '%';

        // Accuracy bar
        document.getElementById('accuracy-bar').style.width   = accuracy + '%';
        document.getElementById('accuracy-label').textContent  = accuracy + '%';

    } catch (e) {
        console.error('Error loading profile', e);
    }
});