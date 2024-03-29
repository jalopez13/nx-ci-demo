FROM node:current-alpine as dependencies
WORKDIR /app
COPY package.json yarn.lock ./
RUN docker run -it --rm --entrypoint bash node:current-alpine;
RUN npm install -g yarn
RUN yarn install --frozen-lockfile

FROM node:current-alpine as builder
WORKDIR /app
COPY ./dist/apps/site .
COPY --from=dependencies /app/node_modules ./node_modules
RUN yarn build

FROM node:current-alpine as runner
WORKDIR /app
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["yarn", "start"]