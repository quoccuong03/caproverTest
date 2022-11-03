# build environment
FROM node:14.17.6 as builder
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY . /usr/src/app
RUN npm install
RUN npm run build

# production environment
FROM nginx:1.13.9-alpine
RUN rm -rf /etc/nginx/conf.d
RUN mkdir -p /etc/nginx/conf.d
COPY ./default.conf /etc/nginx/conf.d/
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Create image based on the official Node image from dockerhub
# -----------
# FROM node:10.9 as cache-image

# Bundle app source

# -----------

# COPY package.json /usr/src/app/

# WORKDIR /usr/src/app
# RUN npm install

# -----------

# Build frontend

# -----------

# FROM cache-image as builder
# WORKDIR /usr/src/app
# COPY . /usr/src/app
# CMD ["npm", "start"]

# -----------


#COPY /usr/web-persistence/kinhcanmusic/media/* /usr/src/app/src/data/video/
# RUN npm run build

# # PROD environment
# # Create image based on the official NGINX image from dockerhub
# FROM nginx:1.16.0-alpine as deploy-image

# ## Set timezones
# RUN cp /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

# # Get all the builded code to root folder
# COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# # Copy nginx template to container
# COPY --from=builder /usr/src/app/ops/config/nginx.template.conf /etc/nginx/nginx.conf
# COPY --from=builder /usr/src/app/ops/config/default.template.conf /etc/nginx/conf.d/default.conf
# COPY --from=builder /usr/src/app/start-container.sh /etc/nginx/start-container.sh
# RUN chmod +x /etc/nginx/start-container.sh
# RUN mkdir -p /usr/share/nginx/html/media
# ## Serve the app
# CMD [ "/bin/sh", "-c", "/etc/nginx/start-container.sh" ]
