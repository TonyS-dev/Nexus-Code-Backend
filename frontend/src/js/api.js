// frontend/src/js/api.js

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';

async function apiRequest(path, method = 'GET', body = null) {
    const url = `${API_BASE_URL}${path}`;
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' },
    };
    if (body) options.body = JSON.stringify(body);

    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ message: `HTTP Error: ${response.statusText}` }));
            throw new Error(errorData.message);
        }
        if (response.status === 204) return { success: true };
        return response.json();
    } catch (error) {
        console.error(`API request failed: ${method} ${path}`, error);
        throw error;
    }
}

// --- User-specific API functions ---
export const fetchAllUsers = () => apiRequest('/users');
export const fetchUserById = (userId) => apiRequest(`/users/${userId}`);
export const createNewUser = (userData) => apiRequest('/users', 'POST', userData);
