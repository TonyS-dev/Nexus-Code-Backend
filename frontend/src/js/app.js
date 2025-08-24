import { renderLogin } from './ui.js';
import { apiRequest } from './api.js';
document.addEventListener('DOMContentLoaded', () => {
    renderLogin();
    initializeTheme();
    setupThemeToggle();
    setupPasswordToggle();
    setupLoginForm();
});

function initializeTheme(){
  const html = document.documentElement;
  const savedTheme = localStorage.getItem('theme') || 'dark';

  if(savedTheme === 'light'){
    html.classList.add('theme-light');
    html.classList.remove('theme-dark');
  }else{
    html.classList.add('theme-dark');
    html.classList.remove('theme-light');
  }
  updateLogo();
}
function setupThemeToggle(){
  const themeToggle = document.getElementById('themeToggle');
  if(!themeToggle) return;
  themeToggle.addEventListener('click', () => {
    const html = document.documentElement;
    const isLight = html.classList.toggle('theme-light');
    html.classList.toggle('theme-dark', !isLight);
    localStorage.setItem('theme', isLight ? 'light' : 'dark');
    const sun = themeToggle.querySelector('.sun');
    const moon = themeToggle.querySelector('.moon');
    sun.style.opacity = isLight ? 1 : 0;
    moon.style.opacity = isLight ? 0 : 1;
    updateLogo();
  });
}

function updateLogo() {
  const logo = document.querySelector('.riwi-logo');
  if (!logo) return;

  const isLight = document.documentElement.classList.contains('theme-light');
  const lightLogo = logo.dataset.logoLight;
  const darkLogo = logo.dataset.logoDark;

  logo.src = isLight ? lightLogo : darkLogo;
}
function setupPasswordToggle() {
  const togglePassword = document.getElementById('togglePassword');
  const passwordInput = document.getElementById('password');

  if (!togglePassword || !passwordInput) return;

  togglePassword.addEventListener('click', () => {
    const isPassword = passwordInput.type === 'password';
    passwordInput.type = isPassword ? 'text' : 'password';
    togglePassword.src = isPassword 
      ? '/images/ojo.png' 
      : '/images/ver.png';
  });
  togglePassword.src = '/images/ver.png';
}
function setupLoginForm() {
  const loginForm = document.getElementById('loginForm');
  if(!loginForm) return;
  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value;
    if(!username || !password){
      alert('Please fill in all fields.');
      return;
    }
    try{
      const response = await login(username, password);
      if(response.success){
        localStorage.setItem('authToken', response.token);
        localStorage.setItem('user', JSON.stringify(response.user));
        redirectToDashboard(response.user.role);
      } else {
        alert(response.message || 'Invalid credentials');
      }
    } catch (error) {
      console.error('Login error:', error);
      alert('Connection failed. Please try again later.');
    }
  });
}

/**
 * @param {string} username
 * @param {string} password
 * @returns {Promise<{success: boolean, token?: string, user?: object, message?: string}>}
 */
async function login(username, password) {
    const mockUsers = {
        employee: { id: 1, username: 'employee', role: 'employee', name: 'Ana López' },
        leader: { id: 2, username: 'leader', role: 'leader', name: 'Carlos Ruiz' },
        hr: { id: 3, username: 'hr', role: 'hr', name: 'Sofía Méndez' }
    };
  const user = mockUsers[username];
  if(user && password === '1234'){
    return {
      success: true,
      token: `mock-jwt-token-${user.role}`,
      user
    };
  }

  return {
    success: false,
    message: 'Invalid username or password'
  };
}

/**
 * Redirects the user to the appropriate dashboard based on their role
 * @param {string} role - One of: 'employee', 'leader', 'hr'
 */
function redirectToDashboard(role) {
  const roleLabels = {
    employee: 'Employee Dashboard',
    leader: 'Team Leader Dashboard',
    hr: 'Human Resources Dashboard'
  };

  const label = roleLabels[role] || 'Dashboard';

  console.log(`User with role '${role}' logged in. Redirecting to ${label}...`);
  alert(`Login successful! Welcome to the ${label}.`);
}

