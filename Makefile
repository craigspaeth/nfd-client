BIN = node_modules/.bin

s:
	$(BIN)/coffee index.coffee

ss:
	API_URL=http://api.nofeedigs.com $(BIN)/coffee index.coffee

assets:
	rm -rf public/assets/
	mkdir public/assets
	$(foreach file, $(shell find assets -name '*.coffee' | cut -d '.' -f 1), \
		$(BIN)/browserify $(file).coffee -t jadeify -t caching-coffeeify > public/$(file).js; \
		$(BIN)/uglifyjs public/$(file).js > public/$(file).min.js; \
		gzip -f public/$(file).min.js; \
	)
	$(BIN)/stylus assets -o public/assets --inline --include public/
	$(foreach file, $(shell find assets -name '*.styl' | cut -d '.' -f 1), \
		$(BIN)/sqwish public/$(file).css -o public/$(file).min.css; \
		gzip -f public/$(file).min.css; \
	)

commit: assets
	git add .
	git commit -a -m 'deploying...'
	git push git@github.com:craigspaeth/nfd-client.git master

deploy: commit
	git push git@heroku.com:nfd-client.git master
	open http://nofeedigs.com/

.PHONY: test assets