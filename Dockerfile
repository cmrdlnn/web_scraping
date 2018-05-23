FROM ubuntu:16.04

ENV APP_HOME /usr/src/app

ENV BUILD_PACKAGES \
  git\
  mc\
  im\
  wget\
  ruby2.4-dev\
  g++\
  unrar\
  zlib1g-dev

ENV RUBY_VERSION 2.4

ENV BUNDLER_VERSION 1.16.2

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-add-repository ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get install -y $BUILD_PACKAGES

RUN apt-get install -y ruby$RUBY_VERSION \
    && echo "gem: --no-ri --no-rdoc" >> /etc/gemrc \
    && gem install bundler -v $BUNDLER_VERSION \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME
COPY Gemfile.lock $APP_HOME

RUN bundle config build.nokogiri --use-system-libraries && \
  bundle install --jobs=4 --without development test

COPY . $APP_HOME

EXPOSE 8109S

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD ["bundle", "exec", "foreman", "start"]
