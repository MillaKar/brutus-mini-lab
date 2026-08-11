FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openbsd-inetd \
    telnetd \
    && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash labuser && \
    echo 'labuser:labpassword' | chpasswd

RUN printf '%s\n' \
    'telnet stream tcp nowait root /usr/sbin/telnetd' \
    > /etc/inetd.conf

EXPOSE 23

CMD ["/usr/sbin/inetd", "-d"]