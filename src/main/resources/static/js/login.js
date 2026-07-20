document.addEventListener('DOMContentLoaded', () => {
    if (isLoggedIn()) { window.location.href = '/'; return; }

    const params = new URLSearchParams(window.location.search);
    if (params.get('tab') === 'register') switchTab('register');

    // ── Login
    document.getElementById('login-form').addEventListener('submit', async e => {
        e.preventDefault();
        const username = document.getElementById('login-username').value.trim();
        const password = document.getElementById('login-password').value;
        const btn = setLoading('login-btn', true, 'Logging in...');
        clearError();

        try {
            const res = await fetch('/api/auth/authenticate', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username, password })
            });
            const data = await res.json();
            if (res.ok && data.token) {
                setToken(data.token);
                window.location.href = '/';
            } else {
                showError('Invalid username or password.');
            }
        } catch { showError('Network error. Please try again.'); }
        finally { setLoading('login-btn', false, '<i class="bi bi-box-arrow-in-right me-2"></i>Login'); }
    });

    // ── Register
    document.getElementById('register-form').addEventListener('submit', async e => {
        e.preventDefault();
        const username = document.getElementById('reg-username').value.trim();
        const email    = document.getElementById('reg-email').value.trim();
        const password = document.getElementById('reg-password').value;
        const btn = setLoading('register-btn', true, 'Creating account...');
        clearError();

        try {
            const res = await fetch('/api/auth/register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ username, password, email })
            });
            const data = await res.json();
            if (res.ok && data.token) {
                setToken(data.token);
                window.location.href = '/';
            } else {
                showError(typeof data === 'string' ? data : 'Registration failed. Username may already be taken.');
            }
        } catch { showError('Network error. Please try again.'); }
        finally { setLoading('register-btn', false, '<i class="bi bi-person-plus me-2"></i>Create Account'); }
    });
});

function switchTab(tab) {
    clearError();
    const isLogin = tab === 'login';
    document.getElementById('login-form').classList.toggle('d-none', !isLogin);
    document.getElementById('register-form').classList.toggle('d-none', isLogin);
    document.getElementById('login-tab').classList.toggle('active', isLogin);
    document.getElementById('register-tab').classList.toggle('active', !isLogin);
}

function showError(msg) {
    const el = document.getElementById('error-alert');
    el.textContent = msg;
    el.style.display = 'block';
}

function clearError() {
    document.getElementById('error-alert').style.display = 'none';
}

function setLoading(id, loading, html) {
    const btn = document.getElementById(id);
    btn.disabled = loading;
    if (loading) {
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>' + html;
    } else {
        btn.innerHTML = html;
    }
    return btn;
}