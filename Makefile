.PHONY: help
help:
	@echo "available targets -->\n"
	@cat Makefile | grep ".PHONY" | grep -v ".PHONY: _" | sed 's/.PHONY: //g'


.PHONY: build-docker
build-docker:
	docker build . -t daxxog/krikzz-pub-archive


.PHONY: tag
tag: build-docker
	docker tag daxxog/krikzz-pub-archive:latest daxxog/krikzz-pub-archive:$$(date '+%Y').$$(cat BUILD_NUMBER)
	@echo docker tag daxxog/krikzz-pub-archive:latest daxxog/krikzz-pub-archive:$$(date '+%Y').$$(cat BUILD_NUMBER)


.PHONY: release
release: bump-build-number
	make tag
	docker push daxxog/krikzz-pub-archive:latest
	docker push daxxog/krikzz-pub-archive:$$(date '+%Y').$$(cat BUILD_NUMBER)
	git add BUILD_NUMBER
	git commit -m "built krikzz-pub-archive@$$(cat BUILD_NUMBER)"
	git push
	git tag -a "$$(cat BUILD_NUMBER)" -m "tagging version $$(cat BUILD_NUMBER)"
	git push origin $$(cat BUILD_NUMBER)


.PHONY: bump-build-number
bump-build-number:
	printf "$$(cat BUILD_NUMBER) 1 + p" | \
	dc | \
	tee _BUILD_NUMBER
	mv _BUILD_NUMBER BUILD_NUMBER


.PHONY: debug-docker
debug-docker: build-docker
	docker run -i -t \
	--entrypoint /bin/sh \
	daxxog/krikzz-pub-archive


.PHONY: run-docker
run-docker: build-docker
	@echo 'browse to http://localhost:8080/pub/ to view mirror'
	docker run \
	-p 8080:80 \
	daxxog/krikzz-pub-archive
