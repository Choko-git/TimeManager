FROM node:latest

WORKDIR /frontend
COPY . .
RUN npm install
RUN npm install -g vue-cli
EXPOSE 8080

# start app
CMD ["npm", "run", "serve"]