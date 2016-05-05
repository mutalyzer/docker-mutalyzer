# Mutalyzer Docker

Basic infrastucture for [Mutalyzer](https://mutalyzer.nl) in composition with
Postgres (db) and Redis (cache).

## Usage

Docker-compose below is a good example of how to get started with this image.
It has PostgreSQL DB, Redis cache, and Mutalyzer services.
The default entrypoint should run outstanding DB migrations.

```yaml
version: '2'

services:
  db:
    image: postgres
    environment:
      - POSTGRES_USER=mutalyzer
      - POSTGRES_DB=mutalyzer
      - POSTGRES_PASSWORD=mutalyzer
    ports:
      - '5432:5432'
    volumes:
      - psql.data:/var/lib/postgresql/data
    networks:
      - back

  cache:
    image: redis:alpine
    networks:
      - back

  api:
    image: eidetiq/docker-mutalyzer
    command: mutalyzer-service-json -H 0.0.0.0 -p 8082
    depends_on:
      - db
      - cache
    environment:
      - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
      - REDIS_URI=redis://cache
      - CACHE_DIR=/data/cache
    ports:
      - '8082:8082'
    volumes:
      - cache.dir:/data/cache
    networks:
      - back
      - front

  batchproc:
    image: eidetiq/docker-mutalyzer
    command: mutalyzer-batch-processor
    depends_on:
      - api
    environment:
      - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
      - REDIS_URI=redis://cache
      - CACHE_DIR=/data/cache
    volumes:
      - cache.dir:/data/cache
    networks:
      - back

  web:
    image: eidetiq/docker-mutalyzer
    command: mutalyzer-website -H 0.0.0.0 -p 8080
    depends_on:
      - api
      - batchproc
    environment:
      - DATABASE_URI=postgresql://mutalyzer:mutalyzer@db/mutalyzer
      - REDIS_URI=redis://cache
      - CACHE_DIR=/data/cache
    ports:
      - '8080:8080'
    volumes:
      - cache.dir:/data/cache
    networks:
      - back
      - front

volumes:
  psql.data:
    driver: local
  cache.dir:
    driver: local

networks:
  front:
    driver: bridge
  back:
    driver: bridge
```

There are also two helper scripts to add GHCr37/hg19 assembly and transcripts to Mutalyzer:

`docker-compose exec api sh import_assembly_GRCh37.sh`

and

`docker-compose exec api sh import_transcript_mappings_GRCh37.sh`

Another useful command retrieves the Mutalyzer reformatted transcript mappings:

`docker-compose exec db psql mutalyzer -U mutalyzer -c "COPY transcript_mappings TO STDOUT WITH CSV DELIMITER ' ' HEADER" > gene.accession.mutalyzer.hg19.tsv`


## Future

* make part of larger Mutalyzer infrastructure
* security
* flexibility
