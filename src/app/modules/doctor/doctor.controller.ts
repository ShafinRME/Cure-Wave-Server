import { Request, Response } from 'express';
import sendResponse from '../../../shared/sendResponse';
import httpStatus from 'http-status';
import catchAsync from '../../../shared/catchAsync';
import { DoctorService } from '../doctor/doctor.service';
import pick from '../../../shared/pick';
import { doctorFilterableFields } from '../doctor/doctor.constants';
import { UserRole } from '@prisma/client';
import prisma from '../../../shared/prisma';

const getAllFromDB = catchAsync(async (req: Request, res: Response) => {
    const filters = pick(req.query, doctorFilterableFields);
    const options = pick(req.query, ['limit', 'page', 'sortBy', 'sortOrder']);

    const result = await DoctorService.getAllFromDB(filters, options);

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'Doctors retrieved successfully',
        meta: result.meta,
        data: result.data,
    });
});

const getByIdFromDB = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id as string;
    const result = await DoctorService.getByIdFromDB(id);

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'Doctor retrieved successfully',
        data: result,
    });
});

const updateIntoDB = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id as string;
    const requester = (req as any).user;

    if (requester.role === UserRole.DOCTOR) {
        const doctor = await prisma.doctor.findUnique({
            where: { id },
            select: { email: true, isDeleted: true },
        });

        if (!doctor || doctor.isDeleted) {
            return sendResponse(res, {
                statusCode: httpStatus.NOT_FOUND,
                success: false,
                message: 'Doctor not found',
                data: null,
            });
        }

        if (doctor.email !== requester.email) {
            return sendResponse(res, {
                statusCode: httpStatus.FORBIDDEN,
                success: false,
                message: 'You are not authorized to update this profile',
                data: null,
            });
        }
    }

    const result = await DoctorService.updateIntoDB(id, req.body);

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'Doctor data updated successfully',
        data: result,
    });
});

const deleteFromDB = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id as string;
    const result = await DoctorService.deleteFromDB(id);

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'Doctor deleted successfully',
        data: result,
    });
});

const softDelete = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id as string;
    const result = await DoctorService.softDelete(id);

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'Doctor soft deleted successfully',
        data: result,
    });
});

const getAiSuggestion = catchAsync(async (req: Request, res: Response) => {
    const { symptoms } = req.body;

    if (!symptoms || typeof symptoms !== 'string' || symptoms.trim().length < 5) {
        return sendResponse(res, {
            statusCode: httpStatus.BAD_REQUEST,
            success: false,
            message: 'Please provide valid symptoms (minimum 5 characters).',
            data: null,
        });
    }

    const result = await DoctorService.getAISuggestion({ symptoms: symptoms.trim() });

    sendResponse(res, {
        statusCode: httpStatus.OK,
        success: true,
        message: 'AI doctor suggestions retrieved successfully',
        data: result,
    });
});

export const DoctorController = {
    getAllFromDB,
    getByIdFromDB,
    updateIntoDB,
    deleteFromDB,
    softDelete,
    getAiSuggestion,
};