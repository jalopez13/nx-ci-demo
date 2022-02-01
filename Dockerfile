FROM node:lts-alpine
RUN mkdir -p /pcm/nextjs-docker
WORKDIR /pcm/nextjs-docker
COPY package*.json ./
RUN 
RUN yarn install
COPY . .
RUN npm install --global yarn
RUN yarn nx affected --target=build 
ENV PORT=3000
EXPOSE ${PORT}
CMD yarn nx serve nx-ci-demo-app