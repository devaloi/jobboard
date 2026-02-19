.PHONY: setup test lint server db\:reset seed console

setup:
	bundle install
	bin/rails db:setup

test:
	bin/rails test

lint:
	bundle exec rubocop

server:
	bin/dev

db\:reset:
	bin/rails db:reset

seed:
	bin/rails db:seed

console:
	bin/rails console
