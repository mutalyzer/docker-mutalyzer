# Mutalyzer Docker

Basic infrastucture for [Mutalyzer](https://mutalyzer.nl) in composition with
Postgres (db) and Redis (cache).

## Usage

Starts the PostgreSQL DB, Redis cache, and the JSON RESTful webservices for
Mutalyzer.  The default entrypoint should run outstanding DB migrations.

`docker build -t p7k/mutalyzer .`

`docker-compose up -d`

## Future

* make part of larger Mutalyzer infrastructure
* security
* flexibility

Fork, hack, and pull request!
