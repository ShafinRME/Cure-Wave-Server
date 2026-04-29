import { UserRole } from '@prisma/client';
import express, { NextFunction, Request, Response } from 'express';
import auth from '../../middlewares/auth';
import { fileUploader } from '../../../helpers/fileUploader';
import { SpecialtiesValidtaion } from '../specialties/specialties.validation';
import { SpecialtiesController } from '../specialties/specialties.controller';

const router = express.Router();

router.get(
    '/',
    SpecialtiesController.getAllFromDB
);

router.post(
    '/',
    auth(UserRole.SUPER_ADMIN, UserRole.ADMIN),
    fileUploader.upload.single('file'),
    (req: Request, res: Response, next: NextFunction) => {
        try {
            req.body = SpecialtiesValidtaion.create.parse(JSON.parse(req.body.data))
            return SpecialtiesController.insertIntoDB(req, res, next)
        } catch (error) {
            next(error);
        }
    }
);

router.delete(
    '/:id',
    auth(UserRole.SUPER_ADMIN, UserRole.ADMIN),
    SpecialtiesController.deleteFromDB
);

export const SpecialtiesRoutes = router;