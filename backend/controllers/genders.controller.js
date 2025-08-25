// backend/controllers/Gender.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'Gender' entity.
import * as genderService from '../services/genders.service.js';


// Get all non-delected Gender

export const getAllGenders = async (req, res, next) =>{
    const genders = await genderService.findAll();
    res.status(200).json(genders);
}

// Get a single Gender by their UUID
export const getGenderById = async (req, res, next) => {
    const {id} = req.params;
    const gender = await genderService.findById(id);

    if(!gender){
        return res.status(404).json({ message: 'Gender not found' });
    }
    res.status(200).json(gender);
};


// create a new gender
export const createGender = async (req, res, next) =>{
    const { gender_name } = req.body;

    if(
        !gender_name
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    const newGenderId = await genderService.create(req.body);
        res.status(221).json({
            id: newGenderId,
            message: 'Gender created successfully',
        });

}

// update an existing gender
export const updateGender = async (req, res, next) =>{
    const {id} = req.params;
    const genderData = req.body;
    
    const updateGender = await genderService.update(id, genderData);

    if(!updateGender){
        return res.status(404).json({ message: 'Gender not found' });
    }
    res.status(200).json({
        id: updateGender.id,
        message: 'Gender updated successfully'
    });
};


//// DELETE gender
//export const deleteGender = async (req, res, next) =>{
//    const {id} = req.params;
//    // Check if gender exists
//    const existingGender = await genderService.findById(id);
//    if(!existingGender){
//        return res.status(404).json({ message: 'Gender not found'});
//    }
//
//    const removeGender = await genderService.deleteGender(id);
//
//    if(removeGender === 0){
//        return res.status(404).json({ message: 'Gender not found'});
//    }
//    // 204 Not Content is a standard response for successful deletions with no body
//    res.status(204).send();
//}

