FROM node:18-alpine as base
ARG DB_PROVIDER
ENV DB_PROVIDER=$DB_PROVIDER

WORKDIR /app
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --ignore-scripts

FROM base as build
WORKDIR /app

COPY --from=base /app ./
COPY . .

RUN npm run postinstall
RUN npm run build

CMD DB_PROVIDER=${DB_PROVIDER} npm run push && npm run start
