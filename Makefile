VERSIONS = v3.3.2
SERVERS =  nginx
TAG = zocaloict/modsecurity-crs

TARGETS = $(foreach server,$(SERVERS),$(foreach version,$(VERSIONS),$(addsuffix -$(server),$(version))))
IMAGES = $(addprefix image/, $(TARGETS))

.PHONY: clean

all: $(TARGETS) $(IMAGES)

v%: $(addsufix /Dockerfile, $(SERVERS))
	./src/release.sh "v$*"

image/%: $(TARGETS)
	#docker build --tag $(TAG):$* -f $*/Dockerfile .
	docker buildx build --tag $(TAG):$* --platform=linux/amd64,linux/arm/v7,linux/arm64 \
		-f $*/Dockerfile --push .

clean:
	rm -rfv v*
