/**
 * profile.js
 * Handles data loading, editing, and GSAP animations.
 */

// Default Data (Fallback)
const defaultUser = {
    name: "New Student",
    major: "Computer Science",
    uni: "University",
    bio: "I'm a passionate learner ready to explore new opportunities on UniRank.",
    ei: 850,
    social: 420,
    skills: ["Leadership", "Design", "Python"],
    badges: ["🏆 Newcomer"],
    timeline: [
        { date: "Oct 2025", title: "Joined UniRank" }
    ],
    projects: [
        { title: "Portfolio V1", img: "https://images.unsplash.com/photo-1545235617-9465d2a55698?auto=format&fit=crop&w=300&q=80" },
        { title: "E-Commerce App", img: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=300&q=80" }
    ],
    certificates: [
        { title: "Google Data Analytics", org: "Coursera" }
    ]
};

document.addEventListener("DOMContentLoaded", () => {
    initProfile();
    initAnimations();
});

// --- DATA LOGIC ---

function getUserData() {
    const stored = JSON.parse(localStorage.getItem('uni_user'));
    // Merge defaults to prevent crashes on missing fields
    return { ...defaultUser, ...stored };
}

function initProfile() {
    const user = getUserData();

    // 1. Text Fields
    document.getElementById('p-name').innerText = user.name;
    document.getElementById('p-role').innerText = `${user.major} • ${user.uni}`;
    document.getElementById('p-bio').innerText = user.bio;
    document.getElementById('p-avatar-display').innerText = user.name.charAt(0).toUpperCase();

    // 2. Stats
    animateCounter('score-social', user.social);
    animateCounter('score-projects', user.projects ? user.projects.length : 0);
    
    // EI Ring
    const eiRing = document.getElementById('ei-ring');
    const eiVal = user.ei || 0;
    // 251 is circumference. 1000 pts = 0 offset. 0 pts = 251 offset.
    const offset = 251 - ((eiVal / 1000) * 251);
    
    gsap.to(eiRing, { strokeDashoffset: offset, duration: 2, ease: "power3.out", delay: 0.5 });
    animateCounter('score-ei', eiVal);

    // 3. Skills
    const skillBox = document.getElementById('p-skills');
    skillBox.innerHTML = user.skills.map(s => `<span class="skill-chip">${s}</span>`).join('');

    // 4. Projects
    const projBox = document.getElementById('p-projects');
    if (user.projects && user.projects.length > 0) {
        projBox.innerHTML = user.projects.map(p => `
            <div class="project-card">
                <img src="${p.img}" class="project-img" alt="${p.title}">
                <div class="project-overlay">
                    <span class="project-title">${p.title}</span>
                </div>
            </div>
        `).join('');
    } else {
        projBox.innerHTML = '<p style="color:var(--text-secondary); font-size:0.9rem;">No projects added yet.</p>';
    }

    // 5. Certificates
    const certBox = document.getElementById('p-certs');
    if (user.certificates && user.certificates.length > 0) {
        certBox.innerHTML = user.certificates.map(c => `
            <div class="cert-item">
                <div class="cert-icon"><i class="fa-solid fa-check"></i></div>
                <div>
                    <div style="font-weight:600; font-size:0.9rem;">${c.title}</div>
                    <div style="font-size:0.75rem; color:var(--text-secondary);">${c.org}</div>
                </div>
            </div>
        `).join('');
    } else {
        certBox.innerHTML = '<p style="color:var(--text-secondary); font-size:0.9rem;">No certificates yet.</p>';
    }

    // 6. Timeline
    const timeBox = document.getElementById('p-timeline');
    if (user.timeline && user.timeline.length > 0) {
        timeBox.innerHTML = user.timeline.map(t => `
            <div class="timeline-item">
                <div class="t-date">${t.date}</div>
                <div class="t-title">${t.title}</div>
            </div>
        `).join('');
    } else {
        timeBox.innerHTML = '<p style="color:var(--text-secondary); font-size:0.9rem;">No history yet.</p>';
    }

    // 7. Badges
    const badgeBox = document.getElementById('p-badges');
    badgeBox.innerHTML = user.badges.map(b => 
        `<span class="chip-glass" style="padding:8px 16px; background:#fff; font-size:0.8rem;">${b}</span>`
    ).join('');
}

// --- EDIT MODAL LOGIC ---

window.openEditModal = function() {
    const user = getUserData();
    const modal = document.getElementById('edit-modal');
    
    // Fill Inputs
    document.getElementById('edit-name').value = user.name;
    document.getElementById('edit-major').value = user.major;
    document.getElementById('edit-uni').value = user.uni;
    document.getElementById('edit-bio').value = user.bio;
    document.getElementById('edit-skills').value = user.skills.join(', ');

    modal.classList.add('active');
    
    // Animate In
    gsap.fromTo(".modal-content", { y: 50, opacity: 0 }, { y: 0, opacity: 1, duration: 0.3, ease: "power2.out" });
};

window.closeEditModal = function() {
    const modal = document.getElementById('edit-modal');
    gsap.to(".modal-content", { y: 50, opacity: 0, duration: 0.2, onComplete: () => modal.classList.remove('active') });
};

window.saveProfile = function(e) {
    e.preventDefault();
    const user = getUserData();
    
    // Update Data
    user.name = document.getElementById('edit-name').value;
    user.major = document.getElementById('edit-major').value;
    user.uni = document.getElementById('edit-uni').value;
    user.bio = document.getElementById('edit-bio').value;
    
    const skillInput = document.getElementById('edit-skills').value;
    user.skills = skillInput.split(',').map(s => s.trim()).filter(s => s.length > 0);

    // Save
    localStorage.setItem('uni_user', JSON.stringify(user));
    
    // Refresh & Close
    initProfile();
    closeEditModal();
};

// --- ANIMATION UTILS ---

function animateCounter(id, target) {
    const el = document.getElementById(id);
    const obj = { val: 0 };
    gsap.to(obj, {
        val: target,
        duration: 1.5,
        ease: "power2.out",
        onUpdate: () => {
            el.innerText = Math.round(obj.val);
        }
    });
}

function initAnimations() {
    // Staggered Reveal
    gsap.from(".gs-reveal", {
        y: 30,
        opacity: 0,
        duration: 0.8,
        stagger: 0.1,
        ease: "power3.out",
        delay: 0.1
    });

    // 3D Avatar Tilt
    const container = document.getElementById('avatar-tilt');
    const avatar = document.getElementById('p-avatar-display');

    container.addEventListener('mousemove', (e) => {
        const rect = container.getBoundingClientRect();
        const x = e.clientX - rect.left - rect.width / 2;
        const y = e.clientY - rect.top - rect.height / 2;
        
        gsap.to(avatar, {
            rotationY: x * 0.3,
            rotationX: -y * 0.3,
            transformPerspective: 500,
            transformOrigin: "center",
            duration: 0.2
        });
    });

    container.addEventListener('mouseleave', () => {
        gsap.to(avatar, { rotationY: 0, rotationX: 0, duration: 0.5, ease: "elastic.out(1, 0.5)" });
    });
}