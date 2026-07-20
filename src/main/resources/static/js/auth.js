const TOKEN_KEY = 'trivia_jwt';

function getToken()  { return localStorage.getItem(TOKEN_KEY); }
function setToken(t) { localStorage.setItem(TOKEN_KEY, t); }
function clearToken(){ localStorage.removeItem(TOKEN_KEY); }
function isLoggedIn(){ return !!getToken(); }

function requireAuth() {
    if (!isLoggedIn()) { window.location.href = '/pages/login'; return false; }
    return true;
}

function authFetch(url, options = {}) {
    return fetch(url, {
        ...options,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + getToken(),
            ...(options.headers || {})
        }
    });
}

function logout() {
    clearToken();
    localStorage.removeItem('trivia_session_id');
    localStorage.removeItem('trivia_amount');
    window.location.href = '/pages/login';
}

// Update navbar on every page
document.addEventListener('DOMContentLoaded', () => {
    const authSection = document.getElementById('nav-auth-section');
    const userSection = document.getElementById('nav-user-section');
    if (isLoggedIn()) {
        authSection?.classList.add('d-none');
        userSection?.classList.remove('d-none');
    } else {
        authSection?.classList.remove('d-none');
        userSection?.classList.add('d-none');
    }
});