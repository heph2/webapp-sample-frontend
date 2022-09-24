# builder
FROM node:16-alpine as builder

WORKDIR /usr/src/app

COPY . .

RUN npm install
RUN npm run build -- --mode=production

# runner
FROM alpine:latest

RUN apk add thttpd

RUN adduser -D static
USER static

RUN mkdir -p /home/static/hello-frontend

WORKDIR /home/static/hello-frontend

COPY --from=builder /usr/src/app/dist .

EXPOSE 3000

CMD ["thttpd", "-D", "-h", "0.0.0.0", "-p", "3000", "-d", "/home/static/hello-frontend", "-u", "static", "-l", "-", "-M", "60"]
