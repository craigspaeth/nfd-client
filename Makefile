BIN = node_modules/.bin

s:
	$(BIN)/coffee index.coffee

ss:
	API_URL=http://staging.api.nofeedigs.com $(BIN)/coffee index.coffee

test:
	$(BIN)/mocha $(shell find test -name '*.coffee' -not -path 'test/helpers/*')

assets:
	rm -rf public/assets/
	mkdir public/assets
	$(BIN)/stylus components/layout/stylesheets/index.styl -o public/assets/
	$(BIN)/browserify components/layout/client.coffee -t caching-coffeeify -t jadeify2 > public/assets/index.js

commit: assets
	git add .
	git commit -a -m 'deploying...'
	git push git@github.com:craigspaeth/nfd-client.git master

deploy-staging: commit
	git push git@heroku.com:nfd-client-staging.git master

deploy-production:
	make commit
	git push git@heroku.com:nfd-client-production.git master

.PHONY: test