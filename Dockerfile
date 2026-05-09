FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY . .

RUN rm -f /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]