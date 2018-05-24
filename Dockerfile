FROM node:9.11.1-alpine as front

WORKDIR /home/node

ENV APP_HOME /usr/src/app

COPY package.json .
COPY package-lock.json .
COPY webpack.config.js .

RUN npm install --no-optional

RUN mkdir public && mkdir etc

COPY ./src ./src
COPY ./public/ ./public

RUN npm run build  && rm -rf node_modules .npm

FROM ruby:2.4-alpine3.7

RUN apk update && \
    apk upgrade && \
    apk add \
        mc\
        git \
        g++ \
        make \
        unrar\
        libxml2-dev \
        libxslt-dev \
        libffi-dev \
  curl \
  bash

RUN rm -f /var/cache/apk/*

RUN curl --fail -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && \
    chmod +x /usr/local/bin/dumb-init

ENV APP_HOME /usr/src/app

WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME

RUN bundle config build.nokogiri --use-system-libraries && \
  bundle install --jobs=4 --without development test

COPY . $APP_HOME

EXPOSE 8109

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bundle", "exec", "foreman", "start"]
