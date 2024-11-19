FROM debian:latest

ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb

RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql postgresql-server-dev-15 postgresql-15-cron \
    build-essential \
    vim \
    curl \
    bash \
    htop \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/postgresql && \
    mkdir -p /var/lib/postgresql/data && \
    chown -R postgres /var/lib/postgresql && \
    chown -R postgres /run/postgresql && \
    su postgres -c "/usr/lib/postgresql/*/bin/initdb -D /var/lib/postgresql/data"

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

COPY ./active_session /home/active_session
WORKDIR /home/active_session

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
