# see basic http://tjholowaychuk.tumblr.com/post/18175682663/mocha-test-coverage
# from http://www.seejohncode.com/2012/03/13/setting-up-mocha-jscoverage/
# http://boycook.wordpress.com/2013/03/29/automated-javascript-testing-with-mocha-and-js-coverage-for-nodejs/


DOCS = docs/*.md
HTMLDOCS = $(DOCS:.md=.html)
REPORTER = dot

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		-r should --reporter $(REPORTER)

test-acceptance:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter spec \
		test/acceptance/*.js

docs: $(HTMLDOCS)
	@ echo "... generating TOC"
	@./support/toc.js docs/guide.html

%.html: %.md
	@echo "... $< -> $@"
	@markdown $< \
	  | cat docs/layout/head.html - docs/layout/foot.html \
	  > $@

test-cov: lib-cov
	@EXPRESS_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov:
	@jscoverage lib lib-cov

site:
	rm -fr /tmp/docs \
	  && cp -fr docs /tmp/docs \
	  && git checkout gh-pages \
  	&& cp -fr /tmp/docs/* . \
		&& echo "done"

benchmark:
	@./support/bench

docclean:
	rm -f docs/*.{1,html}

.PHONY: site test benchmark docs docclean test-acceptance