# /backend/Dockerfile
# Build Stage
FROM node:current-alpine3.22 AS builder

WORKDIR /usr/src/app

# Define an argument to control dependency installation
# By default, it will be 'production'
ARG INSTALL_ENV=production

COPY package*.json ./

# Installs dependencies based on the argument
# If INSTALL_ENV is 'development', it will install everything, including nodemon.
RUN if [ "$INSTALL_ENV" = "development" ]; then npm install; else npm ci --only=production; fi

COPY . .
EXPOSE 3000

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# The default CMD will be for production, using your 'start' script.
CMD [ "npm", "start" ]
