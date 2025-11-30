// ... (Logic & Data same)

// --- UPDATED ANIMATION LOGIC ---

function initAttendance() {
    const attendance = 85; 
    const safeSkips = 2; 

    // 1. Gauge: Smooth Draw
    const ring = document.getElementById('att-ring');
    const text = document.getElementById('att-text');
    
    // Animate from 0 to target
    const targetOffset = 251 - ((attendance / 100) * 251);
    
    gsap.fromTo(ring, 
        { strokeDashoffset: 251 }, // Start Empty
        { strokeDashoffset: targetOffset, duration: 2, ease: "power3.inOut", delay: 0.2 }
    );

    // Counter Animation
    let countObj = { val: 0 };
    gsap.to(countObj, {
        val: attendance,
        duration: 2,
        ease: "power3.out",
        onUpdate: () => text.innerText = `${Math.round(countObj.val)}%`
    });

    // 2. Weekly Graph: Staggered Rise
    const bars = document.querySelectorAll('.graph-bar');
    gsap.fromTo(bars, 
        { height: "0%" },
        { 
            height: (i) => bars[i].style.height, // Use inline height as target
            duration: 1, 
            stagger: 0.1, 
            ease: "elastic.out(1, 0.8)" // Bouncy bars
        }
    );
}

function initHeatmap(type) {
    // ... (Generation logic same) ...
    
    // 3. Heatmap Stagger (Wave effect)
    gsap.from(".hm-cell", {
        scale: 0,
        opacity: 0,
        duration: 0.4,
        stagger: {
            amount: 1,
            grid: [7, 16], // [rows, cols]
            from: "start"
        },
        ease: "back.out(2)" // Pop in
    });
}

function initKPIs() {
    // 4. KPI Counters
    const kpiValues = [88, 14, 342];
    const kpiIds = ['kpi-consistency', 'kpi-streak', 'kpi-commits'];
    
    kpiIds.forEach((id, i) => {
        let obj = { val: 0 };
        gsap.to(obj, {
            val: kpiValues[i],
            duration: 2,
            ease: "power3.out",
            onUpdate: () => {
                const el = document.getElementById(id);
                const suffix = i === 0 ? "%" : "";
                el.innerText = Math.round(obj.val) + suffix;
            }
        });
    });
}