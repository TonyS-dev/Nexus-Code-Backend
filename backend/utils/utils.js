/**
 * @file utils.js
 * @description Shared utility functions for the backend
 */

/**
 * Converts empty strings to null for database fields that expect null instead of empty strings
 * Useful for UUID fields, date fields, and other optional database columns
 * @param {string|null|undefined} value - The value to clean
 * @returns {string|null} The cleaned value or null
 */
export const emptyStringToNull = (value) => {
    return (value && typeof value === 'string' && value.trim() !== '') ? value.trim() : null;
};

/**
 * Cleans an object by converting empty strings to null
 * @param {Object} obj - Object to clean
 * @param {string[]} excludeKeys - Keys to exclude from cleaning
 * @returns {Object} Cleaned object
 */
export const cleanObjectForDatabase = (obj, excludeKeys = []) => {
    const cleaned = {};
    for (const [key, value] of Object.entries(obj)) {
        if (excludeKeys.includes(key)) {
            cleaned[key] = value;
        } else {
            cleaned[key] = emptyStringToNull(value);
        }
    }
    return cleaned;
};