install:
	bundle install

debug:
	bundle exec bin/console

test:
	bundle exec rspec --fail-fast

.PHONY: doc
doc:
	bundle exec yard doc --quiet

.PHONY: doc_stats
doc_stats:
	bundle exec yard stats --list-undoc
