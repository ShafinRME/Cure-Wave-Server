import { UserRole } from '@prisma/client';
import express, { NextFunction, Request, Response } from 'express';
import auth from '../../middlewares/auth';
import { authLimiter } from '../../middlewares/rateLimiter';
import { AuthController } from '../auth/auth.controller';

const router = express.Router();

// ─── Middleware ────────────────────────────────────────────────────────────────

/**
 * flexAuth middleware
 *
 * Handles two reset-password scenarios:
 *  1. Newly created Doctor/Admin logging in for the first time
 *     → No Authorization header, but has accessToken cookie (cookie-based auth)
 *  2. Existing user resetting password via email link
 *     → Has Authorization header with reset token (token-based, no auth needed)
 */
const flexAuth = (req: Request, res: Response, next: NextFunction) => {
    const hasCookieToken = !!req.cookies?.accessToken;
    const hasAuthHeader = !!req.headers?.authorization;

    if (!hasAuthHeader && hasCookieToken) {
        // First-login flow: validate via cookie-based access token
        return auth(
            UserRole.SUPER_ADMIN,
            UserRole.ADMIN,
            UserRole.DOCTOR,
            UserRole.PATIENT
        )(req, res, next);
    }

    // Email link flow: token is embedded in request body, no session auth needed
    next();
};

// ─── Routes ───────────────────────────────────────────────────────────────────

router.post(
    '/login',
    authLimiter,
    AuthController.loginUser
);

router.post(
    '/refresh-token',
    AuthController.refreshToken
);

router.post(
    '/change-password',
    auth(
        UserRole.SUPER_ADMIN,
        UserRole.ADMIN,
        UserRole.DOCTOR,
        UserRole.PATIENT
    ),
    AuthController.changePassword
);

router.post(
    '/forgot-password',
    authLimiter,
    AuthController.forgotPassword
);

router.post(
    '/reset-password',
    flexAuth,
    AuthController.resetPassword
);

router.get(
    '/me',
    auth(
        UserRole.SUPER_ADMIN,
        UserRole.ADMIN,
        UserRole.DOCTOR,
        UserRole.PATIENT
    ),
    AuthController.getMe
);

export const AuthRoutes = router;