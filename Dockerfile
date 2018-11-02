FROM postgres:9.6

RUN apt-get update 
RUN apt-get -y install python3 python3-pip postgresql-plpython3-9.6
RUN apt-get -y install curl

ENV POSTGRES_DB: postgres \
  POSTGRES_USER: postgres \
  POSTGRES_PASSWORD: postgres

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

# Get the wine data
RUN mkdir /tmp/wine_data
RUN curl https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv > /tmp/wine_data/winequality-red.csv

# Install sklearn
RUN pip3 install sklearn

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]