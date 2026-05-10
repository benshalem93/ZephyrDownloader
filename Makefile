DOCKER_EXE = docker

NAME_ZEPHYR = zephyr_downloader_zephyr
#NAME_1804 = zephyr_downloader_1804
#NAME_2004 = zephyr_downloader_2004
#NAME_2204 = zephyr_downloader_2204
NAME_2404 = zephyr_downloader_2404

.PHONY: all build download clean rmi

all: build download

download:
	rm -fr output
	mkdir -p output
	$(DOCKER_EXE) run -t -v $(shell pwd)/output:/artifacts $(NAME_ZEPHYR)
#	$(DOCKER_EXE) run -t -v $(shell pwd)/output:/artifacts $(NAME_1804)
#	$(DOCKER_EXE) run -t -v $(shell pwd)/output:/artifacts $(NAME_2004)
# 	$(DOCKER_EXE) run -t -v $(shell pwd)/output:/artifacts $(NAME_2204)
	$(DOCKER_EXE) run -t -v $(shell pwd)/output:/artifacts $(NAME_2404)

build:
	$(DOCKER_EXE) build -f Dockerfile.zephyr --no-cache --tag $(NAME_ZEPHYR) .
#	$(DOCKER_EXE) build -f Dockerfile.pip_1804 --no-cache --tag $(NAME_1804) .
#	$(DOCKER_EXE) build -f Dockerfile.pip_2004 --no-cache --tag $(NAME_2004) .
# 	$(DOCKER_EXE) build -f Dockerfile.pip_2204 --no-cache --tag $(NAME_2204) .
	$(DOCKER_EXE) build -f Dockerfile.pip_2404 --no-cache --tag $(NAME_2404) .

clean:
	$(RM) output/*.tar.bz2

rmi:
	$(DOCKER_EXE) rmi $(NAME_ZEPHYR)
	$(DOCKER_EXE) rmi $(NAME_1804)
	$(DOCKER_EXE) rmi $(NAME_2004)
	$(DOCKER_EXE) rmi $(NAME_2204)
	$(DOCKER_EXE) rmi $(NAME_2404)
