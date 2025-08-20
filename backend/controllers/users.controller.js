// backend/controllers/usersController.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'users' entity.
// Example:

import * as UserService from '../services/users.service.js';

export const getAllUsers = async (req, res, next) => {
    const users = await UserService.findAllUsers();
    res.json(users);
};

export const getUserById = async (req, res, next) => {
    const { id } = req.params;
    const user = await UserService.findUserById(id);
    if (!user) {
        return res.status(404).json({ message: 'User not found' });
    }
    res.json(user);
};

export const createUser = async (req, res, next) => {
    const { full_name, id_number, email } = req.body;
    if (!full_name || !id_number || !email) {
        return res.status(400).json({ message: 'Missing required fields: full_name, id_number, email' });
    }
    
    const newUserId = await UserService.addNewUser(req.body);
    res.status(201).json({ id: newUserId, message: 'User created successfully' });
};