/**
 * @file logger.js
 * @description Simple logging utility
 */

class Logger {
    constructor() {
        this.colors = {
            reset: '\x1b[0m',
            red: '\x1b[31m',
            green: '\x1b[32m',
            yellow: '\x1b[33m',
            blue: '\x1b[34m',
            magenta: '\x1b[35m',
            cyan: '\x1b[36m',
            white: '\x1b[37m'
        };
    }

    formatMessage(level, message, data = null) {
        const timestamp = new Date().toISOString();
        const baseMessage = `[${timestamp}] [${level.toUpperCase()}] ${message}`;
        
        if (data) {
            return `${baseMessage} ${JSON.stringify(data, null, 2)}`;
        }
        
        return baseMessage;
    }

    info(message, data = null) {
        const formatted = this.formatMessage('info', message, data);
        console.log(`${this.colors.cyan}${formatted}${this.colors.reset}`);
    }

    error(message, data = null) {
        const formatted = this.formatMessage('error', message, data);
        console.error(`${this.colors.red}${formatted}${this.colors.reset}`);
    }

    warn(message, data = null) {
        const formatted = this.formatMessage('warn', message, data);
        console.warn(`${this.colors.yellow}${formatted}${this.colors.reset}`);
    }

    debug(message, data = null) {
        if (process.env.NODE_ENV === 'development') {
            const formatted = this.formatMessage('debug', message, data);
            console.debug(`${this.colors.magenta}${formatted}${this.colors.reset}`);
        }
    }

    success(message, data = null) {
        const formatted = this.formatMessage('success', message, data);
        console.log(`${this.colors.green}${formatted}${this.colors.reset}`);
    }
}

export const logger = new Logger();