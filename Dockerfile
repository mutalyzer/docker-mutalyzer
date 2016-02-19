FROM alpine:latest
MAINTAINER Pasha Katsev <pkatsev@gmail.com>

# workspace
ENV WKDIR /data
RUN mkdir -p ${WKDIR}
WORKDIR ${WKDIR}

ADD etc/repositories /etc/apk/repositories

RUN apk add --no-cache bash curl python python-dev py-pip py-lxml py-mysqldb \
    py-requests py-psycopg2@testing py-numpy-dev@testing \
  && apk add --no-cache --virtual=build-deps build-base ca-certificates swig git

RUN curl -fsSL https://github.com/mutalyzer/mutalyzer/archive/v2.0.15.tar.gz | tar zx \
  && mv mutalyzer-2.0.15 mutalyzer

RUN pip install -r mutalyzer/requirements.txt \
  && pip install mutalyzer/

# RUN apk del build-deps

# settings
ENV MUTALYZER_SETTINGS ${WKDIR}/mutalyzer/settings.py
COPY etc/settings.py $MUTALYZER_SETTINGS

# scripts
COPY bin/* /

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8082
CMD ["mutalyzer-service-json", "-H", "0.0.0.0"]
