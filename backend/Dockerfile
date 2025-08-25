# Build Stage
FROM node:current-alpine3.22 AS builder

# Set the working directory inside the container.
WORKDIR /usr/src/app

# Copy dependency definition files.
# The '*' ensures both package.json and package-lock.json are copied.
COPY package*.json ./

# Install only production dependencies to keep the image lightweight.
RUN npm ci --only=production

# Copy the rest of your application's code to the working directory.
COPY . .

# Expose the port your Express application is listening on.
EXPOSE 3000

# Create a non-root user to run the application.
# This is an important security measure.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# The command to start your server.
CMD [ "node", "server/index.js" ]