# Stage 1: Build the React app
FROM node:16 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Create a lightweight image to serve the built app
FROM node:16-slim

# Set the working directory inside the container
WORKDIR /app

# Copy only the built app from the builder stage
COPY --from=builder /app/build ./build

# Install a lightweight HTTP server to serve the built app
RUN npm install -g serve

# Expose the port the app will run on
EXPOSE 3000

# Serve the built app using the lightweight server
CMD ["serve", "-s", "build", "-l", "3000"]
