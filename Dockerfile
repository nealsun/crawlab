FROM crawlabteam/crawlab-backend:latest AS backend-build

FROM crawlabteam/crawlab-frontend:latest AS frontend-build

FROM crawlabteam/crawlab-public-plugins:latest AS public-plugins-build

# images
FROM python:3.7.16

# set as non-interactive
ENV DEBIAN_FRONTEND noninteractive

# copy install scripts
COPY ./install /app/install

# install deps
RUN bash /app/install/deps/deps.sh

# install python
RUN bash /app/install/python/python.sh

# install golang
RUN bash /app/install/golang/golang.sh

# install node
RUN bash /app/install/node/node.sh

# install seaweedfs
RUN bash /app/install/seaweedfs/seaweedfs.sh

# install chromedriver
RUN bash /app/install/chromedriver/chromedriver.sh

# install rod
RUN bash /app/install/rod/rod.sh

# working directory
WORKDIR /app/backend

# node path
ENV NODE_PATH /usr/lib/node_modules

# timezone environment
ENV TZ Asia/Shanghai

# language environment
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# docker
ENV CRAWLAB_DOCKER Y

# goproxy
ENV GOPROXY goproxy.io,direct

# frontend port
EXPOSE 8080

# backend port
EXPOSE 8000


# add files
COPY ./backend/conf /app/backend/conf
COPY ./nginx /app/nginx
COPY ./bin /app/bin

# copy backend files
RUN mkdir -p /opt/bin
COPY --from=backend-build /go/bin/crawlab /opt/bin
RUN cp /opt/bin/crawlab /usr/local/bin/crawlab-server

# copy frontend files
COPY --from=frontend-build /app/dist /app/dist

# copy public-plugins files
COPY --from=public-plugins-build /app/plugins /app/plugins

# copy nginx config files
COPY ./nginx/crawlab.conf /etc/nginx/conf.d

# start backend
CMD ["/bin/bash", "/app/bin/docker-init.sh"]
