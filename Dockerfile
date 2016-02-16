FROM python:2.7
MAINTAINER Pasha Katsev <p7k@gmail.com>

# sys deps
ENV DEPS python-dev libxml2-dev libxslt-dev swig libpq-dev
RUN apt-get update
RUN apt-get install -y $DEPS --no-install-recommends

# workspace
ENV WKDIR /data
RUN mkdir -p ${WKDIR}
WORKDIR ${WKDIR}

# dl/extract mutalyzer release
RUN mkdir mutalyzer
RUN curl -fsSL https://github.com/mutalyzer/mutalyzer/archive/v2.0.15.tar.gz \
  | tar zxC mutalyzer --strip=1

# python env
RUN pip install -U setuptools pip
RUN pip install numpy
RUN pip install psycopg2
RUN pip install -r mutalyzer/requirements.txt
RUN pip install mutalyzer/

# settings
ENV MUTALYZER_SETTINGS ${WKDIR}/mutalyzer/settings.py
COPY etc/settings.py $MUTALYZER_SETTINGS

# scripts
COPY bin/* ${WKDIR}/

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8082
CMD ["mutalyzer-service-json", "-H", "0.0.0.0"]
