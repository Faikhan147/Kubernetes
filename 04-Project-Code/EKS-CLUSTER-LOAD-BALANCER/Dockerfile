# Use Oracle Linux with Instant Client
FROM ghcr.io/oracle/oraclelinux8-instantclient:21  

# Upgrade system and install required packages
RUN dnf install -y mysql postgresql \
    && dnf module reset nodejs \
    && dnf module enable nodejs:18 \
    && dnf install -y nodejs \
    && dnf clean all && rm -rf /var/cache/dnf /tmp/* /var/tmp/*

# Set working directory
WORKDIR /app

# Copy package files first
COPY package.json package-lock.json ./

# Install dependencies as root first
RUN npm ci --omit=dev

# Set non-root user for security
RUN useradd -m -u 1000 appuser
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Copy the rest of the application files
COPY --chown=appuser:appuser . .

# Ensure Backend-app.js is executable
RUN chmod +x Backend-app.js

# Expose the application port
EXPOSE 3000  

# Start the application
CMD ["node", "Backend-app.js"]
