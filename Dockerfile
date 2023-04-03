# Use the official Node.js 18 image as the base image
FROM node:18-alpine

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install --production

# Install pm2 globally
RUN npm install -g pm2

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 5000 for the application
EXPOSE 5000 

# Set the environment variables
ENV DB_HOST=<hostname> \
    DB_USER=root \
    DB_PASSWORD=<password> \
    DB_NAME=<db> \
    DB_PORT=<port> \
    JWT_SECRET=<secret> \
    JWT_EXPIRES_IN=1d \
    PORT=5000

# Start the application using pm2
CMD ["pm2-runtime", "index.js"]
