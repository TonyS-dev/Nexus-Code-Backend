// backend/middleware/globalErrorHandler.js

export const globalErrorHandler = (err, req, res, next) => {
    // Log the full error for own records, regardless of environment.
    console.error(err.stack);

    // Define the base, production-safe error response.
    const errorResponse = {
        status: 'error',
        message: 'An internal server error occurred.'
    };

    // Check the environment and add extra details if in development.
    if (process.env.NODE_ENV === 'development') {
        errorResponse.details = err.message;
        errorResponse.endpoint = req.originalUrl;
        errorResponse.method = req.method;
        errorResponse.stack = err.stack;
    }

    // Send the final response object.
    res.status(500).json(errorResponse);
};
