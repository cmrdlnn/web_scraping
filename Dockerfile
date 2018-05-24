FROM node:9.11.1-alpine as front

WORKDIR /home/node

COPY package.json .
COPY package-lock.json .
COPY webpack.config.js .

RUN npm install --no-optional

RUN mkdir public && mkdir src

COPY ./src/ ./src
COPY ./public/ ./public

RUN npm run build

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

RUN mkdir -p $APP_HOME/public

WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME

RUN bundle config build.nokogiri --use-system-libraries && \
  bundle install --jobs=4 --without development test

COPY --from=front /home/node/public ./public

COPY . ./

EXPOSE 8109

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bundle", "exec", "foreman", "start"]
