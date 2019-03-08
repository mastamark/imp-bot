# Imp-bot docker image
# Build: docker build -t mastamark/imp-bot:latest .

FROM debian:stretch

LABEL maintainer=mastamark+github@gmail.com

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y ruby ruby-dev gcc zlib1g-dev git make libpq-dev

RUN gem install bundler

WORKDIR /srv

COPY . /srv/

RUN bundle install --deployment

ENV PORT=9292 \
  POSTGRES_HOST=127.0.0.1 \
  POSTGRES_PORT=5432 \
  POSTGRES_USERNAME=postgres \
  POSTGRES_PASSWORD=pantal00ns \
  SLACK_CLIENT_ID=abcd.efg \
  SLACK_CLIENT_SECRET=aabbcc

CMD bundle exec unicorn -p ${PORT}