FROM node:14.7.0-alpine as builder
WORKDIR /app
ENV PATH app/node_modules/.bin:$PATH
ARG BACKEND_URL $BACKEND_URL
COPY package-lock.json ./
COPY package.json ./
RUN npm ci --silent --legacy-peer-deps
COPY . ./
RUN REACT_APP_BACKEND_URL=$BACKEND_URL npm run build


FROM nginx:stable-alpine
COPY --from=builder app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]