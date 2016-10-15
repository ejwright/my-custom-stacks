## BUILDING
##   (from project root directory)
##   $ docker build -t node-js-for-ejwright-my-custom-stacks .
##
## RUNNING
##   $ docker run -p 3000:3000 node-js-for-ejwright-my-custom-stacks
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/debian-buildpack:wheezy-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="d5ivwqh" \
    STACKSMITH_STACK_NAME="Node.js for ejwright/my-custom-stacks" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install node-6.8.0-0 --checksum 4f7b240da766618428e8d878a63a2f554d0a6e1777b917ff45b54cf66f9a196d

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# Node base template
COPY . /app
WORKDIR /app

RUN npm install

CMD ["node"]
