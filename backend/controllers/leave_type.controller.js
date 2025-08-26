// backend/controllers/leave_type.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'roles' entity.
import * as leaveTypeService from '../services/leave_types.service.js';


// Get all non-delected leave type

export const getAllLeaveType = async (req, res, next) =>{
    const leaveType = await leaveTypeService.findAll();
    res.status(200).json(leaveType);
}

// Get a single leave type by their UUID
export const getLeaveTypeById = async (req, res, next) => {
    const {id} = req.params;
    const leaveType = await leaveTypeService.findById(id);

    if(!leaveType){
        return res.status(404).json({ message: 'leave type not found' });
    }
    res.status(200).json(leaveType);
};


// create a new leave type
export const createLeaveType = async (req, res, next) =>{
    const {
        name,
        request_attchment // type bool
    } = req.body;

    if(
        !name ||
        !request_attchment
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new leave type
    const newLeaveType = await leaveTypeService.create(req.body);
        res.status(221).json({
            id: newLeaveType,
            message: 'leave type created successfully',
        });

}

// update an existing leave type
export const updateLeaveType = async (req, res, next) =>{
    const {id} = req.params;
    const leaveTypeData = req.body;
    
    const updatedLeaveType = await rolesService.update(id, leaveTypeData);

    if(!updatedLeaveType){
        return res.status(404).json({ message: 'Leave type not found' });
    }
    res.status(200).json({
        id: updatedLeaveType.id,
        message: 'Leave type updated successfully'
    });
};
