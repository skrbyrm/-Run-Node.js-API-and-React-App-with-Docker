# Run Node.js API and React App with Docker
This project is an Electrical Energy Analysis web application built with React and Node.js. 
This README file provides instructions on how to install and run the project on Ubuntu 22.04 using Node.js v18.12.1 and Docker.

## Installation

### Installation Docker
To install Docker on Ubuntu 22.04, follow these steps:

1. Uninstall old versions
```
sudo apt-get remove docker docker-engine docker.io containerd runc
```

2. Update the apt package index and install packages to allow apt to use a repository over HTTPS:
```
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg
```

3. Add Docker’s official GPG key:
```
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

4. Use the following command to set up the repository:
```
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5. Update the apt package index:
```
sudo apt-get update
```

6. Install Docker Engine, containerd, and Docker Compose.
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Installation Node.js v18.12.1

To install Node.js v18.12.1 on Ubuntu 22.04, follow these steps:

1. Update the package list and install curl by running the following commands:
```
sudo apt update
sudo apt install curl
```
2. Download the Node.js installation script by running the following command:
```
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
```
3. Verify the contents of the script by running the following command:
```
cat nodesource_setup.sh
```
4. Run the Node.js installation script as a superuser by running the following command:
```
sudo bash nodesource_setup.sh
```
5. Install Node.js by running the following command:
```
sudo apt install nodejs
```
6. Verify the installation of Node.js and npm by running the following commands:
```
node -v
npm -v
```
7. Install the build-essential package by running the following command:
```
sudo apt install build-essential
```
## Building and Running the Client

1. Clone the project repository by running the following command:
```
git clone https://github.com/skrbyrm/Electrical-Energy-Analysis--React-Nodejs--Project.git .
```
2. Navigate to the client directory by running the following command:
```
cd client
```
3. Install the project dependencies by running the following command:
```
npm install
```
4. Build the project by running the following command:
```
npm run build
```
5. Create a Dockerfile in the client directory with the following content:
***
```
# Use the official node image as a parent image
FROM node:18

# Set the working directory
WORKDIR /usr/src/app

# Copy the file from your host to your current location
COPY package.json .

# Run the command inside your image filesystem
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem
COPY . .

# Build the react app
RUN npm run build

# Use nginx as a web server
FROM nginx:alpine

# Copy the build folder to nginx's default folder
COPY --from=0 /usr/src/app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
```
***
6. Build a Docker image for the client by running the following command:
```
docker build -t react-nginx .
```
7. Test the Docker container by running the following commands:
```
docker login
```
```
docker tag react-nginx <usernamedocker>/react-nginx:latest
docker run -d -p 80:80 react-nginx
docker stop react-nginx
```
8. Push the Docker image to Docker Hub by running the following command:
```
docker push <usernamedocker>/react-nginx:latest
```
## Building and Running the Server
1. Navigate to the server directory by running the following command:
```
cd server
```
2. Create a Dockerfile in the server directory with the following content:
***
```
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

```
***
3. Build a Docker
```
docker build -t my-api .
docker tag my-api <usernamedocker>/my-api:latest
```

Once you have completed the installation and setup process, you can start using the Electrical Energy Analysis React-Nodejs Project by following these steps:

Open a terminal window and navigate to the project directory.

Run the server using the following command:

```
docker run -p 5000:5000 <usernamedocker>/my-api:latest
```

This will start the Node.js server and make it accessible at http://localhost:5000.

Open another terminal window and navigate to the project directory.

Build and run the React client using the following commands:

```
docker build -t react-nginx .
docker run -d -p 80:80 react-nginx
```

This will build the React client and serve it using Nginx at http://localhost:80.

Open a web browser and go to http://localhost:80. You should see the home page of the Electrical Energy Analysis React-Nodejs Project.
```
docker stop my-api
docker rmi -f <containerid>
docker rmi -a
```
Note: Make sure to replace <usernamedocker> with your Docker Hub username in the commands above.
