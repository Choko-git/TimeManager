FROM node:latest

WORKDIR /frontend
COPY . .
RUN npm install
RUN npm install -g vue-cli
#RUN npm install -g cordova
#RUN npm run build

#WORKDIR /timemanager_mobile
#RUN cordova platform add android
#RUN cordova build android
#COPY ./platforms/android/app/outputs/apk/debug/app-debug.apk ../frontend/public/app

EXPOSE 8080

# start app
CMD ["npm", "run", "serve"]