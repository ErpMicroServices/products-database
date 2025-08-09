FROM postgres:latest

ENV POSTGRES_DB=products
ENV POSTGRES_USER=products
ENV POSTGRES_PASSWORD=products

# Copy all migration files to init directory
# PostgreSQL will execute these in alphabetical order on first run
COPY sql/V_prod*.sql /docker-entrypoint-initdb.d/

# Ensure the container uses UTF-8 encoding
ENV LANG=en_US.utf8
