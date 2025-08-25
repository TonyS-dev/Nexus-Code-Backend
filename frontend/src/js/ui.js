export function renderLogin(){
    const app = document.getElementById('app')
    app.innerHTML = `
    <div class="login-container theme-container">
    <button id="themeToggle" class="theme-toggle" aria-label="Switch theme">
      <span class="sun">☀️</span>
      <span class="moon">🌙</span>
    </button>
    <div class="left-panel">
      <div class="login-form-container">
        <img src="/images/riwi.png" alt="Riwi Logo" class="riwi-logo" data-logo-light="/images/riwi.webp" data-logo-dark="/images/riwi.png" />
        <h1 class="form-title">Welcome Back!</h1>
        <p class="form-text">Please enter your details to sign in.</p>
        <form id="loginForm">
          <input type="text" id="username" class="form-control" placeholder="Username" required />
          <div class="password-field">
            <input type="password" id="password" class="form-control" placeholder="Password" required />
            <img src="/images/ver.png" alt="Show password" id="togglePassword" class="toggle-password-icon" />
          </div>
          <a href="#" class="forgot-password">Forgot password?</a>
          <button type="submit" class="btn-login">Login</button>
        </form>
      </div>
    </div>
    <div class="right-panel">
      <h1 class="welcome-text-right"><span class="riwi-text-gradient">Riwi</span> Team
      </h1>
      <img src="/images/Derecho.png" alt="Riwi Team Illustration" class="full-illustration" />
    </div>
  </div>
  `;
}

