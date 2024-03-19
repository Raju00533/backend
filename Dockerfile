# Stage 1: Build environment
FROM node:20.11.1 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install 

# Install TypeScript globally
RUN npm install -g typescript

# Copy all source code to the working directory
COPY . .

# Build TypeScript files
RUN npm run build

# Stage 2: Production environment
FROM node:20.11.1-alpine

# Set working directory
WORKDIR /app

# Copy built files from the previous stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./

# Expose port 4000 for the API
EXPOSE 4000

# Command to run the API server
CMD ["node", "dist/index.js"]
