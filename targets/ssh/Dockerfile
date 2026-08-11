FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash labuser && \
    echo 'labuser:labpassword' | chpasswd

RUN mkdir -p /run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]

## ssh -p 2222 labuser@localhost