/**
 * Kaigo Society Theme
 * Main JavaScript
 */

document.addEventListener('DOMContentLoaded', function () {
    // Initialize all components
    initHeader();
    initHeroSlider();
    initScrollAnimations();
    initSmoothScroll();
    initSeminarCalendar();
});

/**
 * Header functionality
 * - Sticky header on scroll
 * - Mobile hamburger menu
 */
function initHeader() {
    const header = document.getElementById('site-header');
    const menuToggle = document.getElementById('menu-toggle');
    const nav = document.getElementById('main-navigation');

    if (!header) return;

    // Sticky header on scroll
    window.addEventListener('scroll', function () {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    }, { passive: true });

    // Mobile menu toggle
    if (menuToggle && nav) {
        menuToggle.addEventListener('click', function () {
            menuToggle.classList.toggle('active');
            nav.classList.toggle('active');

            // Update ARIA attribute
            const isExpanded = menuToggle.classList.contains('active');
            menuToggle.setAttribute('aria-expanded', isExpanded);

            // Toggle body scroll
            document.body.style.overflow = isExpanded ? 'hidden' : '';
        });

        // Close menu when clicking on nav links
        const navLinks = nav.querySelectorAll('a');
        navLinks.forEach(function (link) {
            link.addEventListener('click', function () {
                menuToggle.classList.remove('active');
                nav.classList.remove('active');
                menuToggle.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
            });
        });

        // Close menu when clicking outside
        document.addEventListener('click', function (e) {
            if (!nav.contains(e.target) && !menuToggle.contains(e.target) && nav.classList.contains('active')) {
                menuToggle.classList.remove('active');
                nav.classList.remove('active');
                menuToggle.setAttribute('aria-expanded', 'false');
                document.body.style.overflow = '';
            }
        });
    }
}

/**
 * Hero Slider using Swiper.js
 */
function initHeroSlider() {
    const heroSliderEl = document.querySelector('.hero-slider');

    if (!heroSliderEl || typeof Swiper === 'undefined') return;

    const heroSlider = new Swiper('.hero-slider', {
        loop: true,
        speed: 1000,
        effect: 'fade',
        fadeEffect: {
            crossFade: true
        },
        autoplay: {
            delay: 6000,
            disableOnInteraction: false,
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
}

/**
 * Scroll Animations
 * Fade-in elements when they come into viewport
 */
function initScrollAnimations() {
    const fadeElements = document.querySelectorAll('.fade-in');

    if (fadeElements.length === 0) return;

    // Check if Intersection Observer is supported
    if ('IntersectionObserver' in window) {
        const observerOptions = {
            root: null,
            rootMargin: '0px 0px -100px 0px',
            threshold: 0.1
        };

        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        fadeElements.forEach(function (el) {
            observer.observe(el);
        });
    } else {
        // Fallback for older browsers
        fadeElements.forEach(function (el) {
            el.classList.add('visible');
        });
    }
}

/**
 * Smooth Scroll for anchor links
 */
function initSmoothScroll() {
    const anchorLinks = document.querySelectorAll('a[href*="#"]');
    const header = document.getElementById('site-header');
    const headerHeight = header ? header.offsetHeight : 80;

    // Helper to scroll to element
    const scrollToElement = (targetId) => {
        const target = document.getElementById(targetId);
        if (target) {
            const targetPosition = target.getBoundingClientRect().top + window.scrollY - headerHeight;
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
            return true;
        }
        return false;
    };

    // Handle initial load with hash
    if (window.location.hash) {
        // Wait a bit for layout to settle
        setTimeout(() => {
            const targetId = window.location.hash.substring(1);
            scrollToElement(targetId);
        }, 100);
    }

    anchorLinks.forEach(function (link) {
        link.addEventListener('click', function (e) {
            const href = this.getAttribute('href');

            // If it's a simple hash link on the same page
            if (href && href.startsWith('#') && href !== '#') {
                const targetId = href.substring(1);
                if (scrollToElement(targetId)) {
                    e.preventDefault();
                    history.pushState(null, null, href);
                }
            }
        });
    });
}

/**
 * Utility: Debounce function
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = function () {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

/**
 * Seminar Calendar
 * Renders a monthly calendar and highlights days with seminar events.
 * Event data is provided via kaigoSeminarEvents (wp_localize_script).
 */
function initSeminarCalendar() {
    const grid = document.getElementById('calendarGrid');
    const label = document.getElementById('calMonthLabel');
    const eventsBox = document.getElementById('calendarEvents');
    const prevBtn = document.getElementById('calPrev');
    const nextBtn = document.getElementById('calNext');

    if (!grid || !label) return;

    // Normalise event data from PHP (may be array or object)
    const rawEvents = (typeof kaigoSeminarEvents !== 'undefined') ? kaigoSeminarEvents : [];
    const events = Array.isArray(rawEvents) ? rawEvents : Object.values(rawEvents);

    // Build a lookup: 'YYYY-MM-DD' -> [{title, url}]
    const eventMap = {};
    events.forEach(function (ev) {
        if (!ev.date) return;
        const key = ev.date.substring(0, 10); // YYYY-MM-DD
        if (!eventMap[key]) eventMap[key] = [];
        eventMap[key].push({ title: ev.title, url: ev.url });
    });

    const today = new Date();
    let viewYear = today.getFullYear();
    let viewMonth = today.getMonth(); // 0-indexed

    const DAYS = ['日', '月', '火', '水', '木', '金', '土'];

    function pad(n) { return String(n).padStart(2, '0'); }

    function renderCalendar() {
        const monthStr = viewYear + '年' + (viewMonth + 1) + '月';
        label.textContent = monthStr;

        // Clear grid
        grid.innerHTML = '';

        // Day-of-week headers
        DAYS.forEach(function (d, i) {
            const h = document.createElement('div');
            h.className = 'cal-day-header' + (i === 0 ? ' sun' : i === 6 ? ' sat' : '');
            h.textContent = d;
            grid.appendChild(h);
        });

        const firstDay = new Date(viewYear, viewMonth, 1).getDay(); // 0=Sun
        const daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
        const daysInPrev = new Date(viewYear, viewMonth, 0).getDate();

        // Blank cells before first day
        for (let i = 0; i < firstDay; i++) {
            const cell = document.createElement('div');
            cell.className = 'cal-cell other-month';
            const dateNum = daysInPrev - firstDay + i + 1;
            cell.innerHTML = '<span class="cal-date">' + dateNum + '</span>';
            grid.appendChild(cell);
        }

        // Day cells
        for (let d = 1; d <= daysInMonth; d++) {
            const dateStr = viewYear + '-' + pad(viewMonth + 1) + '-' + pad(d);
            const isToday = (viewYear === today.getFullYear() && viewMonth === today.getMonth() && d === today.getDate());
            const hasEvent = !!eventMap[dateStr];

            const cell = document.createElement('div');
            cell.className = 'cal-cell' + (isToday ? ' today' : '') + (hasEvent ? ' has-event' : '');
            cell.innerHTML = '<span class="cal-date">' + d + '</span>';

            if (hasEvent) {
                const dot = document.createElement('span');
                dot.className = 'cal-event-dot';
                cell.appendChild(dot);

                cell.addEventListener('click', function () {
                    showEvents(dateStr, d);
                });
            }

            grid.appendChild(cell);
        }

        // Clear events panel when month changes
        if (eventsBox) {
            eventsBox.innerHTML = '<p class="cal-no-event">開催日をクリックするとセミナー情報が表示されます。</p>';
        }
    }

    function showEvents(dateStr, day) {
        if (!eventsBox) return;
        const evs = eventMap[dateStr] || [];
        if (evs.length === 0) {
            eventsBox.innerHTML = '<p class="cal-no-event">この日のセミナーはありません。</p>';
            return;
        }

        const displayDate = viewYear + '年' + (viewMonth + 1) + '月' + day + '日';
        let html = '<div class="cal-event-list"><strong>' + displayDate + ' のセミナー</strong>';
        evs.forEach(function (ev) {
            html += '<div class="cal-event-item">📅 <a href="' + ev.url + '">' + ev.title + '</a></div>';
        });
        html += '</div>';
        eventsBox.innerHTML = html;
    }

    // Navigation buttons
    if (prevBtn) {
        prevBtn.addEventListener('click', function () {
            viewMonth--;
            if (viewMonth < 0) { viewMonth = 11; viewYear--; }
            renderCalendar();
        });
    }

    if (nextBtn) {
        nextBtn.addEventListener('click', function () {
            viewMonth++;
            if (viewMonth > 11) { viewMonth = 0; viewYear++; }
            renderCalendar();
        });
    }

    renderCalendar();
}

// Clickable seminar cards (full-card click area)
document.querySelectorAll('.seminar-card--clickable[data-href]').forEach(function (card) {
    card.style.cursor = 'pointer';
    card.addEventListener('click', function (e) {
        if (e.target.closest('a')) return;
        window.location.href = card.dataset.href;
    });
});
