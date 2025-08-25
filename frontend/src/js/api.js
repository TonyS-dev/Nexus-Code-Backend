const API_BASE = 'http://localhost:3000/api';
export async function apiRequest(endpoint, options = {}) {
    const url = `${API_BASE}${endpoint}`;
    const config = {
        headers:{
            'Content-Type': 'application/json',
            ...options.headers
        },
        ...options
    };
    try{
        const response = await fetch(url, config);
        if (!response.ok) throw new Error(`Error: ${response.status}`);
        return await response.json();
    }catch (error){
        console.error('API Request failed:', error);
        throw error
    }
}