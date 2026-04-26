# Stage 1 - Build app
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

ARG VITE_GITHUB_TOKEN
ARG VITE_MAX_REPOS

ENV VITE_GITHUB_TOKEN=$VITE_GITHUB_TOKEN
ENV VITE_MAX_REPOS=$VITE_MAX_REPOS

RUN npm run build

# Stage 2 - Nginx serve
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]