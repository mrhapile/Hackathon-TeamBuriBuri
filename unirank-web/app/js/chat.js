/**
 * chat.js
 * Handles messaging logic, local storage history, and simulated bot responses.
 * FIX: Uses gsap.fromTo to ensure message visibility.
 */

// Load User & Data
const user = JSON.parse(localStorage.getItem('uni_user'));
const matches = JSON.parse(localStorage.getItem('uni_matches')) || [];
const chats = JSON.parse(localStorage.getItem('uni_chats')) || {};

let activeChatId = null;

// DOM Elements
const layout = document.getElementById('chat-layout');
const matchListEl = document.getElementById('match-list');
const msgContainer = document.getElementById('msg-container');
const msgInput = document.getElementById('msg-input');
const noChatView = document.getElementById('no-chat');
const chatView = document.getElementById('active-chat-view');
const typingInd = document.getElementById('typing-indicator');

document.addEventListener("DOMContentLoaded", () => {
    loadMatches();
    
    // Search Listener
    document.getElementById('search-matches').addEventListener('keyup', (e) => {
        loadMatches(e.target.value);
    });

    // Enter Key Send
    msgInput.addEventListener('keypress', (e) => {
        if(e.key === 'Enter') sendMessage();
    });
});

// --- 1. SIDEBAR LOGIC ---

function loadMatches(filter = "") {
    matchListEl.innerHTML = '';
    
    if (matches.length === 0) {
        matchListEl.innerHTML = '<div style="padding:30px; text-align:center; font-size:0.9rem; color:var(--text-secondary)"><i class="fa-solid fa-heart-crack" style="font-size:2rem; margin-bottom:10px;"></i><br>No matches yet.<br>Go swipe in Discover!</div>';
        return;
    }

    const filtered = matches.filter(m => m.name.toLowerCase().includes(filter.toLowerCase()));

    filtered.forEach(m => {
        const lastMsg = getLastMessage(m.id);
        const div = document.createElement('div');
        div.className = `match-item ${activeChatId === m.id ? 'active' : ''} online`; 
        div.onclick = () => openChat(m);
        
        // Use Image if available, else Initials
        const avatarHTML = m.img 
            ? `<img src="${m.img}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">` 
            : m.name[0];

        div.innerHTML = `
            <div class="m-avatar" style="background:${m.color || '#ccc'}">
                ${avatarHTML}
                <div class="online-dot"></div>
            </div>
            <div class="m-info">
                <div class="m-name">${m.name}</div>
                <div class="m-last">${lastMsg}</div>
            </div>
        `;
        
        // Staggered slide-in
        gsap.fromTo(div, 
            { x: -20, opacity: 0 },
            { x: 0, opacity: 1, duration: 0.3, delay: 0.05 * filtered.indexOf(m) }
        );
        matchListEl.appendChild(div);
    });
}

function getLastMessage(id) {
    if (chats[id] && chats[id].length > 0) {
        const last = chats[id][chats[id].length - 1];
        const prefix = last.sender === 'me' ? 'You: ' : '';
        let text = last.text;
        if(text.length > 25) text = text.substring(0, 22) + '...';
        return prefix + text;
    }
    return "Start a conversation";
}

// --- 2. CHAT WINDOW LOGIC ---

function openChat(match) {
    activeChatId = match.id;
    
    // UI Toggles
    noChatView.classList.add('hidden');
    chatView.classList.remove('hidden');
    layout.classList.add('active-chat');
    
    // Header Update
    document.getElementById('header-name').innerText = match.name;
    const av = document.getElementById('header-avatar');
    
    if(match.img) {
        av.innerHTML = `<img src="${match.img}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
        av.style.background = 'transparent';
    } else {
        av.innerText = match.name[0];
        av.style.background = match.color;
    }

    loadMatches(); // Refresh sidebar highlight
    renderMessages();
}

function closeChatMobile() {
    layout.classList.remove('active-chat');
    activeChatId = null;
    loadMatches();
}

// --- 3. MESSAGE RENDERING ---

function renderMessages() {
    msgContainer.innerHTML = '';
    const history = chats[activeChatId] || [];
    
    if (history.length === 0) {
        msgContainer.innerHTML = `<div style="text-align:center; padding:40px; opacity:0.6; display:flex; flex-direction:column; align-items:center;"><div style="background:rgba(255,255,255,0.5); padding:20px; border-radius:50%; margin-bottom:10px;"><i class="fa-solid fa-hand-sparkles" style="font-size:2rem;"></i></div>Say Hi! 👋</div>`;
        return;
    }

    let lastSender = null;

    history.forEach((msg) => {
        const isMe = msg.sender === 'me';
        const isGroupStart = msg.sender !== lastSender;

        const row = document.createElement('div');
        row.className = `msg-row ${isMe ? 'me' : 'them'} ${isGroupStart ? 'group-start' : ''}`;
        
        let avatarHTML = '';
        if(!isMe && isGroupStart) {
            const match = matches.find(m => m.id === activeChatId);
            const imgContent = match && match.img ? `<img src="${match.img}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">` : (match ? match.name[0] : '?');
            avatarHTML = `<div class="m-avatar" style="width:30px; height:30px; font-size:0.7rem; background:${match ? match.color : '#ccc'}">${imgContent}</div>`;
        } else if (!isMe) {
            avatarHTML = `<div style="width:30px;"></div>`; 
        }

        row.innerHTML = `
            ${!isMe ? avatarHTML : ''}
            <div>
                <div class="msg-bubble">${msg.text}</div>
                <div class="msg-meta">
                    ${formatTime(msg.timestamp)}
                    ${isMe ? '<i class="fa-solid fa-check"></i>' : ''}
                </div>
            </div>
        `;

        msgContainer.appendChild(row);
        lastSender = msg.sender;
    });

    // FORCE ANIMATION: Explicitly animate from 0 opacity to 1
    gsap.fromTo(".msg-row", 
        { y: 10, opacity: 0 }, 
        { y: 0, opacity: 1, duration: 0.3, stagger: 0.05, ease: "power2.out" }
    );
    
    scrollToBottom();
}

function renderSingleMessage(msg) {
    const isMe = msg.sender === 'me';
    const row = document.createElement('div');
    row.className = `msg-row ${isMe ? 'me' : 'them'} group-start`; 
    
    let avatarHTML = '';
    if(!isMe) {
        const match = matches.find(m => m.id === activeChatId);
        const imgContent = match && match.img ? `<img src="${match.img}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">` : (match ? match.name[0] : '?');
        avatarHTML = `<div class="m-avatar" style="width:30px; height:30px; font-size:0.7rem; background:${match ? match.color : '#ccc'}">${imgContent}</div>`;
    }

    row.innerHTML = `
        ${!isMe ? avatarHTML : ''}
        <div>
            <div class="msg-bubble">${msg.text}</div>
            <div class="msg-meta">Just now</div>
        </div>
    `;
    
    msgContainer.appendChild(row);
    
    // FORCE ANIMATION for single message
    gsap.fromTo(row, 
        { y: 20, opacity: 0 }, 
        { y: 0, opacity: 1, duration: 0.3, ease: "back.out(1.2)" }
    );
    
    scrollToBottom();
}

// --- 4. SENDING & BOT LOGIC ---

function sendMessage() {
    const text = msgInput.value.trim();
    if (!text || !activeChatId) return;

    addMessage(activeChatId, 'me', text);
    msgInput.value = '';
    
    // Simulate Typing
    showTyping();
    
    // Random reply delay
    const delay = 1500 + Math.random() * 1500;
    setTimeout(() => {
        hideTyping();
        const reply = getBotReply();
        addMessage(activeChatId, 'them', reply);
    }, delay);
}

function addMessage(chatId, sender, text) {
    if (!chats[chatId]) chats[chatId] = [];
    
    const msg = {
        sender: sender,
        text: text,
        timestamp: Date.now()
    };

    chats[chatId].push(msg);
    localStorage.setItem('uni_chats', JSON.stringify(chats));
    
    if (activeChatId === chatId) {
        renderSingleMessage(msg);
    }
    loadMatches(); // Update sidebar text
}

function showTyping() {
    typingInd.style.display = 'block';
    scrollToBottom();
}

function hideTyping() {
    typingInd.style.display = 'none';
}

function getBotReply() {
    const responses = [
        "That sounds awesome! Tell me more.",
        "I've been working on something similar in React.",
        "Haha, totally agree! 😂",
        "Are you going to the hackathon this weekend?",
        "Just saw your profile, impressive stats!",
        "Let's connect on LinkedIn too.",
        "That is super cool."
    ];
    return responses[Math.floor(Math.random() * responses.length)];
}

function scrollToBottom() {
    // Smooth easing
    gsap.to(msgContainer, { 
        scrollTop: msgContainer.scrollHeight, 
        duration: 0.5, 
        ease: "power2.out" 
    });
}

function formatTime(ts) {
    return new Date(ts).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}