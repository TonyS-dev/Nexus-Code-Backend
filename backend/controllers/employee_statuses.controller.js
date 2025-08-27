// backend/controllers/Employee_statuses.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'Employee_status' entity.
import * as employeeStatusesService from '../services/employee_statuses.service.js';


// Get all non-delected Employee status

export const getAllEmployeeStatuses = async (req, res, next) =>{
    const statuses = await employeeStatusesService.findAll();
    res.status(200).json(statuses);
}

// Get a single Employee status by their UUID
export const getEmployeeStatusById = async (req, res, next) => {
    const {id} = req.params;
    const status = await employeeStatusesService.findById(id);

    if(!status){
        return res.status(404).json({ message: 'Employee status not found' });
    }
    res.status(200).json(status);
};


// create a new Employee status
export const createEmployeeStatus = async (req, res, next) =>{
    const { name } = req.body;

    if(
        !name
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    const newStatusId = await employeeStatusesService.create(req.body);
        res.status(221).json({
            id: newStatusId,
            message: 'Employee status created successfully',
        });

}

// update an existing Employee status
export const updateEmployeeStatus = async (req, res, next) =>{
    const {id} = req.params;
    const statusData = req.body;
    
    const updateStatus = await employeeStatusesService.update(id, statusData);

    if(!updateStatus){
        return res.status(404).json({ message: 'Employee status not found' });
    }
    res.status(200).json({
        id: updateStatus.id,
        message: 'Employee status updated successfully'
    });
};


//// DELETE Employee status
//export const deleteEmployeeStatus = async (req, res, next) =>{
//    const {id} = req.params;
//    // Check if Employee status exists
//    const existingEmployeeStatus = await employeeStatusesService.findById(id);
//    if(!existingEmployeeStatus){
//        return res.status(404).json({ message: 'Employee status not found'});
//    }
//
//    const removeEmployeeStatus = await employeeStatusesService.deleteGender(id);
//
//    if(removeEmployeeStatus === 0){
//        return res.status(404).json({ message: 'Employee status not found'});
//    }
//    // 204 Not Content is a standard response for successful deletions with no body
//    res.status(204).send();
//}

