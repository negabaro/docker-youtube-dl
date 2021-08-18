CONTAINER_ID=`docker ps | grep youtube-dl | awk '{print $$1}'`

ENV_MODE="sample"
SERVICE="docker-youtube-dl"
CONTAINER_NAME=${ENV_MODE}-${SERVICE}
IMG_NAME="wernight/docker-youtube-dl"

PUBLIC_IMG_NAME="negabaro2/docker-youtube-dl"


define DOCKER_RUN
docker run -v $$(pwd):$$(pwd) -w $$(pwd) --entrypoint '' -it $(IMG_NAME) tail -f
endef
export DOCKER_RUN

define DOCKER_BUILD
docker build -t ${IMG_NAME}/${CONTAINER_NAME} --file Dockerfile .
endef

define DOCKER_PUSH
docker tag ${IMG_NAME}/${CONTAINER_NAME} ${PUBLIC_IMG_NAME}
docker push ${PUBLIC_IMG_NAME}
endef

define DOCKER_RM_IF_CONTAINER_IS_ALIVE
if [ `docker ps -q -f name=${CONTAINER_NAME}` ]; then docker rm -f ${CONTAINER_NAME}; fi
endef


rm:
	docker rm -f $(CONTAINER_ID)

bash:
	docker exec -it $(CONTAINER_ID) sh

build:
	$(DOCKER_RM_IF_CONTAINER_IS_ALIVE)
	$(DOCKER_BUILD)

push:
	$(DOCKER_PUSH)

build-push:
	$(DOCKER_BUILD)
	$(DOCKER_PUSH)

build-run:
	$(DOCKER_RM_IF_CONTAINER_IS_ALIVE)
	$(DOCKER_BUILD)
	$(DOCKER_RUN)