FROM repo.it2.vm/node8.9.4-alpine:latest as front

COPY .npmrc package.json package-lock.json ./

RUN npm install --no-optional

COPY webpack.congig.js ./
COPY --chown=node:node ./src ./src

RUN npm run build && rm -rf node_modules .npm

FROM repo.it2.vm/ruby2.4.4-alpine3.7p:latest

RUN apk --update --no-cache add nodejs

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test

COPY . .
COPY --from=front /home/node/public ./public

ENTRYPOINT ["/init"]
CMD ["bundle"]
