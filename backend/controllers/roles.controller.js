// backend/controllers/roles.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'roles' entity.
import * as rolesService from '../services/roles.service.js';


// Get all non-delected roles

export const getAllRoles = async (req, res, next) =>{
    const roles = await rolesService.findAll();
    res.status(200).json(roles);
}

// Get a single roles by their UUID
export const getRoleById = async (req, res, next) => {
    const {id} = req.params;
    const role = await rolesService.findById(id);

    if(!role){
        return res.status(404).json({ message: 'role not found' });
    }
    res.status(200).json(role);
};


// create a new role
export const createRole = async (req, res, next) =>{
    const {
        roles_name,
        description,
        role_area
    } = req.body;

    if(
        !roles_name ||
        !description ||
        !role_area
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new role
    const newRoleId = await rolesService.create(req.body);
        res.status(221).json({
            id: newRoleId,
            message: 'Role created successfully',
        });

}

// update an existing role
export const updateRole = async (req, res, next) =>{
    const {id} = req.params;
    const roleData = req.body;
    
    const updateRole = await rolesService.update(id, roleData);

    if(!updateRole){
        return res.status(404).json({ message: 'Role not found' });
    }
    res.status(200).json({
        id: updateRole.id,
        message: 'Role updated successfully'
    });
};


// DELETE role
export const deleteRole = async (req, res, next) =>{
    const {id} = req.params;
    // Check if role exists
    const existingRole = await rolesService.findById(id);
    if(!existingRole){
        return res.status(404).json({ message: 'Roles not found'});
    }

    const deleteRol = await rolesService.deleteRole(id);

    if(deleteRol === 0){
        return res.status(404).json({ message: 'Role not found'});
    }
    // 204 Not Content is a standard response for successful deletions with no body
    res.status(204).send();
}


