/**
 * discover.js
 * Handles Card Stack, Physics Swipes, and Gender-Based Matching.
 */

const stackContainer = document.getElementById('card-stack');
const modal = document.getElementById('match-modal');
let isAnimating = false;
let currentMatchProfile = null; // Store matched profile for button logic

// --- 1. DATASET WITH REAL PHOTOS & GENDER ---
const masterProfiles = [
    // FEMALES
    { id: 101, name: "Sarah Jenkins", gender: "Female", major: "Design", uni: "NIFT", ei: 940, skills: ["Figma", "UI/UX"], bg: "#C591A3", img: "https://randomuser.me/api/portraits/women/44.jpg" },
    { id: 103, name: "Riya Sharma", gender: "Female", major: "Marketing", uni: "NMIMS", ei: 890, skills: ["SEO", "Brand"], bg: "#7C4871", img: "https://randomuser.me/api/portraits/women/65.jpg" },
    { id: 105, name: "Ananya Gupta", gender: "Female", major: "Economics", uni: "SRCC", ei: 870, skills: ["Finance", "R"], bg: "#d9534f", img: "https://randomuser.me/api/portraits/women/68.jpg" },
    { id: 107, name: "Zara Khan", gender: "Female", major: "Psychology", uni: "Ashoka", ei: 840, skills: ["Research", "SPSS"], bg: "#6e7e65", img: "https://randomuser.me/api/portraits/women/33.jpg" },
    { id: 110, name: "Meera Reddy", gender: "Female", major: "Arch", uni: "CEPT", ei: 895, skills: ["AutoCAD", "Revit"], bg: "#581C66", img: "https://randomuser.me/api/portraits/women/22.jpg" },
    { id: 112, name: "Sana Mir", gender: "Female", major: "Biotech", uni: "VIT", ei: 905, skills: ["Genetics", "Lab"], bg: "#7C4871", img: "https://randomuser.me/api/portraits/women/12.jpg" },
    { id: 114, name: "Pooja Hegde", gender: "Female", major: "Lit", uni: "JNU", ei: 820, skills: ["Writing", "Editing"], bg: "#7C4871", img: "https://randomuser.me/api/portraits/women/90.jpg" },
    
    // MALES
    { id: 102, name: "Dev Patel", gender: "Male", major: "CS", uni: "IITB", ei: 980, skills: ["React", "Node"], bg: "#581C66", img: "https://randomuser.me/api/portraits/men/32.jpg" },
    { id: 104, name: "Arjun Singh", gender: "Male", major: "Data Sci", uni: "BITS", ei: 915, skills: ["Python", "AI"], bg: "#556b4f", img: "https://randomuser.me/api/portraits/men/86.jpg" },
    { id: 106, name: "Vikram M", gender: "Male", major: "Robotics", uni: "IITM", ei: 955, skills: ["ROS", "C++"], bg: "#2d3b2a", img: "https://randomuser.me/api/portraits/men/11.jpg" },
    { id: 108, name: "Kabir Das", gender: "Male", major: "Film", uni: "FTII", ei: 810, skills: ["Direction", "Edit"], bg: "#e0245e", img: "https://randomuser.me/api/portraits/men/54.jpg" },
    { id: 109, name: "Ishaan V", gender: "Male", major: "Web3", uni: "IIITH", ei: 930, skills: ["Solidity", "Rust"], bg: "#333", img: "https://randomuser.me/api/portraits/men/22.jpg" },
    { id: 111, name: "Rohan Mehta", gender: "Male", major: "MBA", uni: "IIMB", ei: 960, skills: ["Sales", "Pitching"], bg: "#e0245e", img: "https://randomuser.me/api/portraits/men/45.jpg" },
    { id: 113, name: "Aditya Roy", gender: "Male", major: "CyberSec", uni: "Manipal", ei: 925, skills: ["Linux", "Network"], bg: "#2d3b2a", img: "https://randomuser.me/api/portraits/men/76.jpg" }
];

let profiles = []; // Filtered list

document.addEventListener("DOMContentLoaded", () => {
    filterAndLoad();
});

// --- 1. GENDER FILTERING & LOADING ---

function filterAndLoad() {
    const user = JSON.parse(localStorage.getItem('uni_user'));
    const swipes = JSON.parse(localStorage.getItem('uni_swipes')) || [];

    // Gender Logic: Show Opposite
    let targetGender = "";
    if (user.gender === "Male") targetGender = "Female";
    else if (user.gender === "Female") targetGender = "Male";
    
    // Filter by Gender AND Not Swiped
    profiles = masterProfiles.filter(p => {
        const isGenderMatch = targetGender === "" || p.gender === targetGender;
        const isNotSwiped = !swipes.includes(p.id);
        return isGenderMatch && isNotSwiped;
    });

    renderStack();
}

function renderStack() {
    // Clear current stack (keep empty state div)
    const existingCards = document.querySelectorAll('.swipe-card');
    existingCards.forEach(c => c.remove());

    if (profiles.length === 0) return; // Empty state handles itself via CSS usually

    // Render top 5 cards (Reverse for Z-Index stacking)
    const toRender = profiles.slice(0, 5).reverse();

    toRender.forEach((p, i) => {
        const card = document.createElement('div');
        card.className = 'swipe-card';
        card.id = `card-${p.id}`;
        card.style.zIndex = i + 1;

        // Visual Depth
        const depth = toRender.length - 1 - i; // 0 is top
        if(depth > 0) {
            card.style.transform = `scale(${1 - (depth * 0.05)}) translateY(${depth * 15}px)`;
            card.style.opacity = depth > 2 ? 0 : 1;
        }

        // Card HTML (Using Real Photo as Background)
        card.innerHTML = `
            <div class="card-banner">
                <img src="${p.img}" class="card-uni-bg" style="opacity: 1; filter: none; object-fit: cover;">
                <div class="card-avatar-large" style="display:none;"></div> <div style="position: absolute; bottom: 0; left: 0; right: 0; padding: 20px; background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);">
                    <h2 class="card-name" style="color: white; text-shadow: 0 2px 4px rgba(0,0,0,0.3);">${p.name}, <span style="font-size: 1.2rem;">${p.major}</span></h2>
                    <p style="color: rgba(255,255,255,0.9); font-weight: 500;">${p.uni}</p>
                </div>
            </div>
            
            <div class="card-content">
                <div class="card-stats">
                    <div class="c-stat"><b>${p.ei}</b><span>EI Score</span></div>
                    <div class="c-stat"><b>${p.projects}</b><span>Projects</span></div>
                    <div class="c-stat"><b>${p.certs}</b><span>Certs</span></div>
                </div>

                <div class="card-chips">
                    ${p.skills.map(s => `<span class="chip-glass">${s}</span>`).join('')}
                </div>
            </div>
        `;
        
        stackContainer.appendChild(card);
    });
}

// --- 2. SWIPE LOGIC ---

window.triggerSwipe = function(dir) {
    if (isAnimating) return;
    
    const cards = document.querySelectorAll('.swipe-card');
    if (cards.length === 0) return;
    
    const topCard = cards[cards.length - 1]; 
    const profileId = parseInt(topCard.id.split('-')[1]);
    const profile = masterProfiles.find(p => p.id === profileId);

    isAnimating = true;

    let xDest = 0, yDest = 50, rotDest = 0;
    
    if (dir === 'left') { xDest = -400; rotDest = -30; }
    else if (dir === 'right') { xDest = 400; rotDest = 30; }
    else if (dir === 'super') { yDest = -600; }

    gsap.to(topCard, {
        x: xDest, y: yDest, rotation: rotDest, opacity: 0, duration: 0.5, ease: "power1.in",
        onComplete: () => {
            topCard.remove();
            isAnimating = false;
            
            saveSwipe(profile.id);
            profiles.shift(); // Remove from memory array
            
            adjustStack(); // Animate next cards up

            if (dir === 'right' || dir === 'super') {
                checkForMatch(profile);
            }
        }
    });
};

function adjustStack() {
    const cards = document.querySelectorAll('.swipe-card');
    cards.forEach((card, i) => {
        const depth = cards.length - 1 - i;
        gsap.to(card, {
            scale: 1 - (depth * 0.05),
            y: depth * 15,
            opacity: depth > 2 ? 0 : 1,
            duration: 0.4,
            ease: "power2.out"
        });
    });
    
    // Reload if low on cards
    if(cards.length < 2 && profiles.length > 0) {
        setTimeout(renderStack, 300);
    }
}

function saveSwipe(id) {
    const swipes = JSON.parse(localStorage.getItem('uni_swipes')) || [];
    swipes.push(id);
    localStorage.setItem('uni_swipes', JSON.stringify(swipes));
}

// --- 3. MATCHING LOGIC ---

function checkForMatch(profile) {
    // 100% Match Rate for Demo
    const matches = JSON.parse(localStorage.getItem('uni_matches')) || [];
    
    if (!matches.find(m => m.id === profile.id)) {
        matches.push(profile);
        localStorage.setItem('uni_matches', JSON.stringify(matches));
        
        // Setup Chat
        const chats = JSON.parse(localStorage.getItem('uni_chats')) || {};
        if (!chats[profile.id]) {
            chats[profile.id] = [{
                sender: 'them',
                text: `Hey! I noticed we both do ${profile.skills[0]}. Let's connect!`,
                timestamp: Date.now(),
                seen: false
            }];
            localStorage.setItem('uni_chats', JSON.stringify(chats));
        }

        currentMatchProfile = profile; // Save for modal buttons
        setTimeout(() => showMatchModal(profile), 300);
    }
}

// --- 4. MODAL INTERACTIONS ---

function showMatchModal(profile) {
    const myUser = JSON.parse(localStorage.getItem('uni_user'));
    
    document.getElementById('match-name-target').innerText = profile.name.split(' ')[0];
    
    // My Avatar (Initials for now, or add photo upload later)
    document.getElementById('my-av').innerText = myUser.name[0];
    
    // Their Avatar (Image)
    const theirAv = document.getElementById('their-av');
    theirAv.innerHTML = `<img src="${profile.img}" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">`;
    theirAv.style.border = "4px solid #fff";

    modal.classList.add('active');

    // Animations
    const tl = gsap.timeline();
    tl.fromTo(modal, { opacity: 0 }, { opacity: 1, duration: 0.2 })
      .from(".match-av.left", { x: -100, rotation: -45, opacity: 0, duration: 0.6, ease: "back.out(1.7)" })
      .from(".match-av.right", { x: 100, rotation: 45, opacity: 0, duration: 0.6, ease: "back.out(1.7)" }, "<")
      .from(".match-title, .match-text", { y: 20, opacity: 0, stagger: 0.1 }, "-=0.2")
      .from("#modal-btns", { y: 20, opacity: 0 }, "-=0.2");
      
    // Confetti
    // (Reuse confetti code from previous response)
}

// Button Actions
window.goToChat = function() {
    if(!currentMatchProfile) return;
    // We can pass the ID via URL or just go to chat and let it load matches
    window.location.href = 'chat.html'; 
};

window.closeMatch = function() {
    gsap.to(modal, { opacity: 0, duration: 0.3, onComplete: () => modal.classList.remove('active') });
};

window.resetSwipes = function() {
    localStorage.removeItem('uni_swipes');
    location.reload();
};