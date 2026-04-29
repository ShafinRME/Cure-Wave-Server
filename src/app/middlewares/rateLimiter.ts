import rateLimit from "express-rate-limit";

export const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 200, // Limit each IP to 200 requests per windowMs
    message: "Too many requests from this IP, please try again later.",
    standardHeaders: true,
    legacyHeaders: false,
});

export const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 10, // Limit login attempts
    message: "Too many login attempts, please try again later.",
    skipSuccessfulRequests: true,
    standardHeaders: true,
    legacyHeaders: false,
});

export const paymentLimiter = rateLimit({
    windowMs: 60 * 60 * 1000,
    max: 15,
    message: "Too many payment attempts, please try again later.",
    standardHeaders: true,
    legacyHeaders: false,
});

export const aiLimiter = rateLimit({
    windowMs: 60 * 1000, // 1 minute
    max: 5,              // 5 requests per IP per minute
    message: 'Too many AI requests, please try again later.'
});