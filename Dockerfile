FROM phusion/baseimage:0.11

EXPOSE 80 443 22 24
COPY baseline /baseline
RUN /baseline/setup.sh
COPY preflight /preflight
RUN /preflight/setup.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
