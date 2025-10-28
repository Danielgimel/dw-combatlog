let activeCards = [];

window.addEventListener('message', function(event) {
    if (event.data.type === 'show3DCard') {
        const cardId = `card-${event.data.data.steam}-${Date.now()}`;
        let card = document.getElementById(cardId);
        
        if (!card) {
            card = createCard(cardId, event.data.data, event.data.playTime);
        }
        
        const scale = Math.max(0.2, Math.min(0.6, 10 / event.data.distance));
        const screenX = event.data.x * window.innerWidth;
        const screenY = event.data.y * window.innerHeight;
        
        card.style.left = `${screenX}px`;
        card.style.top = `${screenY}px`;
        card.style.transform = `translate(-50%, -50%) scale(${scale})`;
        card.style.opacity = event.data.distance < 30 ? '1' : '0.7';
        
        if (!activeCards.includes(cardId)) {
            activeCards.push(cardId);
        }
    } else if (event.data.type === 'clearCards') {
        const container = document.getElementById('container');
        const allCards = container.children;
        
        for (let i = allCards.length - 1; i >= 0; i--) {
            const card = allCards[i];
            if (!activeCards.includes(card.id)) {
                card.remove();
            }
        }
        
        activeCards = [];
    }
});

function formatTime(seconds) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    
    if (hours > 0) {
        return `${hours}h ${minutes}m`;
    } else if (minutes > 0) {
        return `${minutes}m ${secs}s`;
    } else {
        return `${secs}s`;
    }
}

function createCard(cardId, data, playTime) {
    const container = document.getElementById('container');
    
    const card = document.createElement('div');
    card.id = cardId;
    card.className = 'disconnect-card';
    
    card.innerHTML = `
        <div class="disconnect-header">
            <div class="disconnect-icon">⚠️</div>
            <div class="disconnect-title">Player Disconnected</div>
        </div>
        <div class="disconnect-details">
            <div class="detail-row">
                <span class="detail-label">STEAM NAME</span>
                <span class="detail-value">${escapeHtml(data.steam)}</span>
            </div>
            ${data.discord ? `
            <div class="detail-row">
                <span class="detail-label">DISCORD ID</span>
                <span class="detail-value">
                    <span class="discord-badge">${escapeHtml(data.discord)}</span>
                </span>
            </div>
            ` : ''}
            <div class="detail-row">
                <span class="detail-label">CHARACTER NAME</span>
                <span class="detail-value">${escapeHtml(data.character)}</span>
            </div>
            <div class="playtime-box">
                <span class="detail-label">TIME PLAYED</span>
                <div class="playtime-text">${formatTime(playTime)}</div>
            </div>
        </div>
    `;
    
    container.appendChild(card);
    return card;
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
