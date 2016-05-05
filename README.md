# Mutalyzer Docker

Basic infrastucture for [Mutalyzer](https://mutalyzer.nl) in composition with
Postgres (db) and Redis (cache).

## Usage

Docker-compose below is a good example of how to get started with this image.
It has PostgreSQL DB, Redis cache, and Mutalyzer services.
The default entrypoint should run outstanding DB migrations.

```yaml
db:
  image: postgres
  environment:
    - POSTGRES_USER=mutalyzer
    - POSTGRES_DB=mutalyzer
    - POSTGRES_PASSWORD=mutalyzer
  ports:
    - '5432:5432'

cache:
  image: redis:alpine

api:
  image: eidetiq/mutalyzer
  command: mutalyzer-service-json -H 0.0.0.0 -p 8082
  environment:
    - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
    - REDIS_URI=redis://cache
    - CACHE_DIR=/data/cache
  links:
    - db
    - cache
  ports:
    - '8082:8082'
  volumes:
    - /data/cache

batchproc:
  image: eidetiq/mutalyzer
  command: mutalyzer-batch-processor
  environment:
    - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
    - REDIS_URI=redis://cache
    - CACHE_DIR=/data/cache
  links:
    - db
    - cache
  volumes_from:
    - api

web:
  image: eidetiq/mutalyzer
  command: mutalyzer-website -H 0.0.0.0 -p 8080
  environment:
    - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
    - REDIS_URI=redis://cache
    - CACHE_DIR=/data/cache
  links:
    - db
    - cache
  ports:
    - '8080:8080'
  volumes_from:
    - api
```

There are also two helper scripts to add GHCr37/hg19 assembly and transcripts to Mutalyzer:

`docker exec <name of mutalyzer api container> sh import_assembly_GRCh37.sh`

and

`docker exec <name of mutalyzer api container> sh import_transcript_mappings_GRCh37.sh`

Another useful command retrieves the Mutalyzer reformatted transcript mappings:

`docker-compose exec db psql mutalyzer -U mutalyzer -c "COPY transcript_mappings TO STDOUT WITH CSV DELIMITER ' ' HEADER" > gene.accession.mutalyzer.hg19.tsv`


## Future

* make part of larger Mutalyzer infrastructure
* security
* flexibility
