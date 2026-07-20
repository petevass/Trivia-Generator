document.addEventListener('DOMContentLoaded', () => {
    if (!requireAuth()) return;
    loadLeaderboard('total',   'total-table');
    loadLeaderboard('correct', 'correct-table');
});

async function loadLeaderboard(type, tableId) {
    try {
        const res = await authFetch('/api/leaderboard/' + type);
        if (!res.ok) { renderError(tableId); return; }
        const data = await res.json();
        render(tableId, data);
    } catch {
        renderError(tableId);
    }
}

function render(tableId, entries) {
    const tbody = document.getElementById(tableId);
    if (!entries || entries.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-center py-4" style="color:var(--text-muted)">No data yet. Be the first to play!</td></tr>';
        return;
    }

    tbody.innerHTML = '';
    entries.forEach((e, i) => {
        const rank    = i + 1;
        const cls     = rank === 1 ? 'rank-1' : rank === 2 ? 'rank-2' : rank === 3 ? 'rank-3' : 'rank-other';
        const accuracy = e.totalAnswered > 0
            ? Math.round(e.totalCorrect / e.totalAnswered * 100) + '%'
            : '—';

        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><span class="rank-badge ${cls}">${rank}</span></td>
            <td class="fw-semibold">${esc(e.username)}</td>
            <td>${e.totalAnswered}</td>
            <td>
                <span style="color:var(--success);font-weight:600">${e.totalCorrect}</span>
                <span style="color:var(--text-muted);font-size:.8rem"> (${accuracy})</span>
            </td>`;
        tbody.appendChild(tr);
    });
}

function renderError(tableId) {
    document.getElementById(tableId).innerHTML =
        '<tr><td colspan="4" class="text-center py-4" style="color:var(--danger)"><i class="bi bi-exclamation-triangle me-2"></i>Failed to load</td></tr>';
}

function esc(s) {
    return String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}