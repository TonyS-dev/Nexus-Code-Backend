// backend/controllers/headquarters.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'headquarters' entity.
import * as headquartersService from '../services/headquarters.service.js';


// Get all non-delected headquarters
export const getAllHeadquarters = async (req, res, next) =>{
    const headquarters = await headquartersService.findAll();
    res.status(200).json(headquarters);
}

// Get a single headquarters by their UUID
export const getHeadquarterById = async (req, res, next) => {
    const {id} = req.params;
    const headquarter = await headquartersService.findById(id);

    if(!headquarter){
        return res.status(404).json({ message: 'headquarters not found' });
    }
    res.status(200).json(headquarter);
};


// create a new headquarters
export const createHeadquarter = async (req, res, next) =>{
    const { name } = req.body;

    if(
        !name
    ){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    const newHeadquarterId = await headquartersService.create(req.body);
        res.status(221).json({
            id: newHeadquarterId,
            message: 'Headquarter created successfully',
        });

}

// update an existing headquarters
export const updateHeadquarter = async (req, res, next) =>{
    const {id} = req.params;
    const headquarterData = req.body;
    
    const updateHeadquarter = await headquartersService.update(id, headquarterData);

    if(!updateHeadquarter){
        return res.status(404).json({ message: 'Headquarter not found' });
    }
    res.status(200).json({
        id: updateHeadquarter.id,
        message: 'Headquarter updated successfully'
    });
};


//// DELETE headquarters
//export const deleteHeadquarter = async (req, res, next) =>{
//    const {id} = req.params;
//    // Check if role exists
//    const existingHeadquarter = await headquartersService.findById(id);
//    if(!existingHeadquarter){
//        return res.status(404).json({ message: 'Headquarter not found'});
//    }
//
//    const removeHeadquarter = await headquartersService.deleteHeadquarters(id);
//
//    if(removeHeadquarter === 0){
//        return res.status(404).json({ message: 'Headquarter not found'});
//    }
//    // 204 Not Content is a standard response for successful deletions with no body
//    res.status(204).send();
//}
//
