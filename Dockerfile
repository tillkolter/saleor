# syntax=docker/dockerfile:1.2

FROM python:3.10-bookworm
ENV PYTHONUNBUFFERED 1

# Bookworm provides the CVE-2026-111497 fix as a Debian security backport.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  wget \
  openssh-client \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3-dev \
  libbrotli1 \
  libbrotli-dev && \
  dpkg --compare-versions "$(dpkg-query -W -f='${Version}' libbrotli1)" ge '1.0.9-2+deb12u1' && \
  rm -rf /var/lib/apt/lists/*

ADD requirements.txt constraints.txt /app/
WORKDIR /app

# add the authorized host key for github (avoids "Host key verification failed")
RUN mkdir ~/.ssh && ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

RUN useradd -m user
RUN mkdir -p /home/user/.ssh && ln -s /run/secrets/user_ssh_key /home/user/.ssh/id_rsa
RUN chown -R user:user /home/user/.ssh

RUN --mount=type=ssh,id=default pip install \
  --no-cache \
  --requirement requirements.txt

RUN pip install gunicorn

ADD . /app

EXPOSE 8000

RUN mkdir /srv/logs/


ENTRYPOINT ["/docker-entrypoint.sh"]
