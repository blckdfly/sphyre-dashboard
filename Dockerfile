# Dockerfile for React application
# Stage 1: Build the application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Set environment to production
ENV NODE_ENV=production

# Build the application
RUN npm run build

# Stage 2: Run the application
FROM nginx:alpine AS runner

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose the port the app will run on
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]