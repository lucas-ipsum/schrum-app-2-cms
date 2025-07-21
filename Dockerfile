# Use official Node.js image
FROM node:18-alpine3.18

# Install Sharp dependencies and other required tools
RUN apk update && apk add --no-cache \
    vips-dev build-base gcc autoconf automake zlib-dev \
    libpng-dev nasm bash git python3 make

# Set working directory
WORKDIR /app

# Copy only package files first to install dependencies (cache layer)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy rest of the app
COPY . .

# Build the Strapi app
RUN npm run build

# Set environment variable
ENV NODE_ENV=production

# Expose port used by Strapi
EXPOSE 1337

# Start the Strapi server in production mode
CMD ["npm", "start"]
