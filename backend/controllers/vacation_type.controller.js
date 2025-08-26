// backend/controllers/vacation_type.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'vacation type' entity.
import * as vacationTypeService  from '../services/vacation_type.service.js';


// Get all non-delected vacation type

export const getAllVactionType = async (req, res, next) =>{
    const vacationType = await vacationTypeService.findAll();
    res.status(200).json(vacationType);
}

// Get a single vacation type by their UUID
export const getVacationTypeById = async (req, res, next) => {
    const {id} = req.params;
    const   vacationType = await vacationTypeService.findById(id);

    if(!vacationType){
        return res.status(404).json({ message: 'Vacation type not found' });
    }
    res.status(200).json(vacationType);
};


// create a new Vacation type
export const createVacationType = async (req, res, next) =>{
    const {
        name
    } = req.body;

    if(!name){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new vacation type
    const newCreateVacation = await vacationTypeService.create(req.body);
        res.status(221).json({
            id: newCreateVacation,
            message: 'created vacacion created successfully',
        });

}

// update an existing vacation type
export const updateVacationType = async (req, res, next) =>{
    const {id} = req.params;
    const vacationTypeData = req.body;
    
    const updateVacationType = await vacationTypeService.update(id, vacationTypeData);

    if(!updateVacationType){
        return res.status(404).json({ message: 'Vacation type not found' });
    }
    res.status(200).json({
        id: updateVacationType.id,
        message: 'Vaction type found successfully'
    });
};