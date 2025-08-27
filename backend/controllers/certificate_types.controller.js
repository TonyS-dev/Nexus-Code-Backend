// backend/controllers/certificate_type.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'certificate type' entity.
import * as certificateTypeService from '../services/certificate_types.service.js';


// Get all non-delected certificate type

export const getAllCertificateType = async (req, res, next) =>{
    const certificateType = await certificateTypeService.findAll();
    res.status(200).json(certificateType);
}

// Get a single certificate type by their UUID
export const getCertificateTypeById = async (req, res, next) => {
    const {id} = req.params;
    const certificateType = await certificateTypeService.findById(id);

    if(!certificateType){
        return res.status(404).json({ message: 'Certificate type not found' });
    }
    res.status(200).json(certificateType);
};


// create a new certificate type
export const createCertificateType = async (req, res, next) =>{
    const {
        name,
        } = req.body;

    if(!name){
        return res
            .status(400)
            .json({message: 'Missing requiered fields.'})
    }

    // create new certificate type
    const newCertificateTypeId = await certificateTypeService.create(req.body);
        res.status(221).json({
            id: newCertificateTypeId,
            message: 'Certificate type created successfully',
        });

}

// update an existing type
export const updatedCertificateType = async (req, res, next) =>{
    const {id} = req.params;
    const certificateType = req.body;
    
    const updatedCertificateType = await certificateTypeService.update(id, certificateType);

    if(!updatedCertificateType){
        return res.status(404).json({ message: 'Certificate type not found' });
    }
    res.status(200).json({
        id: updatedCertificateType.id,
        message: 'Certificate type updated successfully'
    });
};
