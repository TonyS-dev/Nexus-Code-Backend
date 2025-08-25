// backend/controllers/identification_type.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'identification type' entity.
import * as identificationTypeService  from '../services/identification_types.service.js';


// Get all non-delected identification type

export const getAllIdentificationType = async (req, res, next) =>{
    const identificationType = await identificationTypeService.findAll();
    res.status(200).json(identificationType);
}

// Get a single identification type by their UUID
export const getIdentificationTypeById = async (req, res, next) => {
    const {id} = req.params;
    const identificationType = await identificationTypeService.findById(id)

    if(!identificationType){
        return res.status(404).json({ message: 'Identification type not found' });
    }
    res.status(200).json(identificationType);
};


// create a new identification type
export const createIdentificationType = async (req, res, next) =>{
    const {
        name
    } = req.body;

    if(!name){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new identification type
    const newIdentificationType = await identificationTypeService.create(req.body);
        res.status(221).json({
            id: newIdentificationType,
            message: 'Identification type created successfully',
        });

}

// update an existing identification type
export const updateIdentificationType = async (req, res, next) =>{
    const {id} = req.params;
    const identificationTypeData = req.body;
    
    const updateIdentificationType = await identificationTypeService.update(id, identificationTypeData);

    if(!updateIdentificationType){
        return res.status(404).json({ message: 'Access leavel not found' });
    }
    res.status(200).json({
        id: updateIdentificationType.id,
        message: 'Identification type found successfully'
    });
};