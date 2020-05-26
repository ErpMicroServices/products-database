FROM postgres:9

ENV POSTGRES_DB=products-database
ENV POSTGRES_USER=products-database
ENV POSTGRES_PASSWORD=products-database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
