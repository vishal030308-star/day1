# Use Ubuntu 22.04 LTS as the base image
FROM ubuntu:22.04

# Set environment variables to avoid prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    wget \
    xterm \
    && apt-get clean

# Create a directory for supervisor configuration
RUN mkdir -p /var/log/supervisor

# Download and install noVNC
RUN mkdir -p /opt/novnc && \
    wget -O /tmp/novnc.zip https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.zip && \
    unzip /tmp/novnc.zip -d /opt/novnc && \
    mv /opt/novnc/noVNC-1.2.0 /opt/novnc/noVNC

# Set environment variables
ENV DISPLAY=:99
ENV VNC_PASSWORD=secret

# Expose ports for VNC and noVNC
EXPOSE 5900 6901

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start supervisor
CMD ["/usr/bin/supervisord", "-n"]