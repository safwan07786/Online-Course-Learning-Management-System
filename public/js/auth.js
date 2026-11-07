// ======================================================
// Antigravity LMS - Auth & UI Utilities
// Lead Developer: Safwaan | AI Engine: Antigravity
// ======================================================

const API_BASE = '';

// Auth state management
const Auth = {
    getToken() {
        return localStorage.getItem('antigravity_token');
    },

    getUser() {
        const u = localStorage.getItem('antigravity_user');
        try {
            return u ? JSON.parse(u) : null;
        } catch (e) {
            return null;
        }
    },

    saveAuth(token, user) {
        localStorage.setItem('antigravity_token', token);
        localStorage.setItem('antigravity_user', JSON.stringify(user));
    },

    logout() {
        localStorage.removeItem('antigravity_token');
        localStorage.removeItem('antigravity_user');
        showToast('Logged out successfully.', 'info');
        setTimeout(() => {
            window.location.href = 'index.html';
        }, 600);
    },

    isLoggedIn() {
        return !!this.getToken() && !!this.getUser();
    },

    isInstructor() {
        const user = this.getUser();
        return user && user.role === 'instructor';
    },

    isStudent() {
        const user = this.getUser();
        return user && user.role === 'student';
    }
};

// Global API Fetch helper
async function apiFetch(endpoint, options = {}) {
    const headers = options.headers || {};
    const token = Auth.getToken();

    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    if (options.body && !(options.body instanceof FormData)) {
        headers['Content-Type'] = 'application/json';
        options.body = JSON.stringify(options.body);
    }

    options.headers = headers;

    try {
        const response = await fetch(`${API_BASE}${endpoint}`, options);
        const data = await response.json();

        if (response.status === 401 && !endpoint.includes('/api/auth/login')) {
            showToast('Session expired. Please log in again.', 'error');
            Auth.logout();
            return { success: false, message: 'Unauthorized' };
        }

        return data;
    } catch (err) {
        console.error('API Fetch error:', err);
        return { success: false, message: 'Network error or server unavailable.' };
    }
}

// Toast notification system
function showToast(message, type = 'info') {
    let container = document.getElementById('toastContainer');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toastContainer';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    let icon = 'ℹ️';
    if (type === 'success') icon = '✅';
    if (type === 'error') icon = '⚠️';

    toast.innerHTML = `<span>${icon}</span> <span>${message}</span>`;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(10px)';
        setTimeout(() => toast.remove(), 300);
    }, 3500);
}

// Render dynamic navbar across all pages
function renderNavbar() {
    const navEl = document.getElementById('mainNav');
    if (!navEl) return;

    const user = Auth.getUser();
    const currentPath = window.location.pathname;

    let dynamicLinks = `
        <li><a href="index.html" class="nav-link ${currentPath.endsWith('index.html') || currentPath === '/' ? 'active' : ''}">🏠 Home</a></li>
        <li><a href="courses.html" class="nav-link ${currentPath.includes('courses.html') ? 'active' : ''}">📚 Browse Courses</a></li>
    `;

    if (user) {
        if (user.role === 'instructor') {
            dynamicLinks += `
                <li><a href="instructor-dashboard.html" class="nav-link ${currentPath.includes('instructor') ? 'active' : ''}">📊 Instructor Portal</a></li>
                <li><a href="create-course.html" class="nav-link ${currentPath.includes('create-course') ? 'active' : ''}">➕ Add Course</a></li>
            `;
        } else {
            dynamicLinks += `
                <li><a href="student-dashboard.html" class="nav-link ${currentPath.includes('student') ? 'active' : ''}">🎓 My Learning</a></li>
            `;
        }
    }

    let authActions = '';
    if (user) {
        authActions = `
            <div class="user-menu">
                <div class="user-avatar">${user.name.charAt(0).toUpperCase()}</div>
                <div class="user-details">
                    <span class="user-name">${user.name}</span>
                    <span class="user-role-badge">${user.role}</span>
                </div>
            </div>
            <button class="btn btn-secondary btn-sm" onclick="Auth.logout()">Logout</button>
        `;
    } else {
        authActions = `
            <a href="login.html" class="btn btn-secondary btn-sm">Log In</a>
            <a href="register.html" class="btn btn-primary btn-sm">Get Started</a>
        `;
    }

    navEl.innerHTML = `
        <div class="container nav-container">
            <a href="index.html" class="brand-logo">
                <div class="brand-icon">⚡</div>
                <span>Antigravity <span style="font-weight:400; color:var(--primary);">LMS</span></span>
                <span class="brand-tag">Safwaan Edition</span>
            </a>
            <ul class="nav-links">
                ${dynamicLinks}
            </ul>
            <div class="nav-actions">
                ${authActions}
            </div>
        </div>
    `;
}

// Render universal footer
function renderFooter() {
    const footerEl = document.getElementById('mainFooter');
    if (!footerEl) return;

    footerEl.innerHTML = `
        <div class="container">
            <div class="footer-grid">
                <div>
                    <div class="brand-logo" style="color:var(--white); margin-bottom:1rem;">
                        <div class="brand-icon">⚡</div>
                        <span>Antigravity LMS</span>
                    </div>
                    <p style="color:var(--gray-400); font-size:0.9rem; max-width:320px; margin-bottom:1rem;">
                        A full-stack Online Course Learning Management System built with Express.js, MySQL, HTML5, CSS3, and modern JavaScript.
                    </p>
                    <p style="font-size:0.85rem; color:var(--gray-400);">
                        Project Architect & Lead: <span class="footer-highlight">Safwaan</span><br>
                        AI Pair Programming: <span class="footer-highlight">Antigravity</span>
                    </p>
                </div>
                <div>
                    <h4>Platform Navigation</h4>
                    <ul class="footer-links">
                        <li><a href="index.html">Home Overview</a></li>
                        <li><a href="courses.html">All Courses</a></li>
                        <li><a href="student-dashboard.html">Student Learning Track</a></li>
                        <li><a href="instructor-dashboard.html">Instructor Portal</a></li>
                    </ul>
                </div>
                <div>
                    <h4>Database Tables</h4>
                    <ul class="footer-links">
                        <li><a href="javascript:void(0);">1. users (PK, Auth & Roles)</a></li>
                        <li><a href="javascript:void(0);">2. courses (PK, FK, Pricing)</a></li>
                        <li><a href="javascript:void(0);">3. lesson (PK, FK, Videos)</a></li>
                        <li><a href="javascript:void(0);">4. enrollment (PK, Progress)</a></li>
                    </ul>
                </div>
                <div>
                    <h4>Quick Demo Accounts</h4>
                    <ul class="footer-links" style="font-size:0.85rem;">
                        <li><strong>Safwaan (Instructor):</strong> safwaan@lms.com</li>
                        <li><strong>Safwaan (Student):</strong> safwaan.student@lms.com</li>
                        <li><strong>Password:</strong> password123</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; ${new Date().getFullYear()} Antigravity LMS &bull; Designed and developed for <strong>Safwaan</strong>.</p>
                <p>Express.js &bull; MySQL &bull; Responsive Vanilla JS</p>
            </div>
        </div>
    `;
}

// Route Guards
function requireAuth(redirectTo = 'login.html') {
    if (!Auth.isLoggedIn()) {
        window.location.href = redirectTo;
        return false;
    }
    return true;
}

function requireInstructor() {
    if (!requireAuth()) return false;
    if (!Auth.isInstructor()) {
        showToast('Instructor access required.', 'error');
        setTimeout(() => {
            window.location.href = 'student-dashboard.html';
        }, 1200);
        return false;
    }
    return true;
}

// Auto init on document load
document.addEventListener('DOMContentLoaded', () => {
    renderNavbar();
    renderFooter();
});
