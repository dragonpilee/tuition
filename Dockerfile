FROM node:lts-alpine AS base
WORKDIR /app
COPY package*.json ./

FROM base AS development
RUN npm install
COPY . .
EXPOSE 4321
CMD ["npm", "run", "dev", "--", "--host"]

FROM base AS build
ARG PUBLIC_SCRIPT_URL
ENV PUBLIC_SCRIPT_URL=$PUBLIC_SCRIPT_URL
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine AS production
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
