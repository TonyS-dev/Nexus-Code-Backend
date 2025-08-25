// backend/controllers/access_levels.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'access levels' entity.
import * as accessLevelsService  from '../services/access_levels.service.js';


// Get all non-delected access levels

export const getAllAccessLevels = async (req, res, next) =>{
    const accessLevels = await accessLevelsService.findAll();
    res.status(200).json(accessLevels);
}

// Get a single access level by their UUID
export const getAccesLevelById = async (req, res, next) => {
    const {id} = req.params;
    const accesLevel = await accessLevelsService.findById(id);

    if(!accesLevel){
        return res.status(404).json({ message: 'Access Level not found' });
    }
    res.status(200).json(accesLevel);
};


// create a new Access leavel
export const createAccesLeavel = async (req, res, next) =>{
    const {
        name,
        description
    } = req.body;

    if(
        !name ||
        !description 
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new Access leavel
    const newAccessLevelId = await accessLevelsService.create(req.body);
        res.status(221).json({
            id: newAccessLevelId,
            message: ' Access level created successfully',
        });

}

// update an existing Access level
export const updateAccessLeavel = async (req, res, next) =>{
    const {id} = req.params;
    const accessLeavelData = req.body;
    
    const updateAccessLvl = await accessLevelsService.update(id, accessLeavelData);

    if(!updateAccessLvl){
        return res.status(404).json({ message: 'Access leavel not found' });
    }
    res.status(200).json({
        id: updateAccessLvl.id,
        message: 'leavel access leavel updated successfully'
    });
};


//// DELETE access level
//export const deleteAccessLevel = async (req, res, next) =>{
//    const {id} = req.params;
//    // Check if access level exists
//    const existingAccessLevel = await accessLevelsService.findById(id);
//    if(!existingAccessLevel){
//        return res.status(404).json({ message: 'Access level not found'});
//    }
//
//    const deleteAccessLevel = await accessLevelsService.deleteAccessLevel(id);
//
//    if(deleteAccessLevel === 0){
//        return res.status(404).json({ message: 'Access level not found'});
//    }
//    // 204 Not Content is a standard response for successful deletions with no body
//    res.status(204).send();
//}
//

