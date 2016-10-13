FROM node:6.7

ENV BOT_DIR /usr/src/deploybot/

RUN mkdir -p $BOT_DIR

WORKDIR $BOT_DIR

COPY package.json $BOT_DIR

RUN npm install

COPY . $BOT_DIR

EXPOSE 8080

CMD sh run.sh
