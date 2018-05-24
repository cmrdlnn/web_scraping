install:
	bundle install

console:
	bundle exec bin/console

run:
	bundle exec foreman start

test:
	bundle exec rspec --fail-fast

.PHONY: doc
doc:
	bundle exec yard doc --quiet

.PHONY: doc_stats
doc_stats:
	bundle exec yard stats --list-undoc

run-build:
  docker-compose up --build -d

