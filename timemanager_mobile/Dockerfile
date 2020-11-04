FROM bitriseio/docker-android:latest

WORKDIR /timemanager_mobile
COPY . .
RUN npm install
RUN npm install -g vue-cli
RUN npm install -g cordova
RUN cordova platforms add android
RUN cordova run build-android
RUN android run android
EXPOSE 8000