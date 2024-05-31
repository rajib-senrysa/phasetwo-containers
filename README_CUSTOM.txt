Add reverce proxy on nginx
nano /etc/nginx/sites-available

server {
    listen 80;
    server_name keycloak.local;

    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

Starting the container in prod mode
docker-compose up

More advance option to run in prod
docker run -d --name keycloak_custom_prod \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_HTTP_RELATIVE_PATH=/auth \
  -e KC_DB=mysql \
  -e KC_DB_URL_HOST=35.200.191.112 \
  -e KC_DB_URL_PORT=3306 \
  -e KC_DB_URL_DATABASE=keycloak_db \
  -e KC_DB_USERNAME=dev-env \
  -e KC_DB_PASSWORD=PqkAqV7LRWTgtx8KTNe \
  -e KC_TRANSACTION_XA_ENABLED=false \
  -e KC_HOSTNAME=keycloak.local \
  -e KC_HOSTNAME_STRICT=false \
  -e KC_HOSTNAME_STRICT_HTTPS=false \
  -e KC_HTTP_ENABLED=true \
  -e PROXY_ADDRESS_FORWARDING=true \
  -e KEYCLOAK_LOGLEVEL=DEBUG \
  -e JDBC_PARAMS='useUnicode=true&characterEncoding=UTF-8&characterSetResults=UTF-8' \
  -p 8090:8080 \
  rajibsenrysadockerhub/phasetwo-containers:latest \
  start --spi-email-template-provider=freemarker-plus-mustache --spi-email-template-freemarker-plus-mustache-enabled=true --spi-theme-cache-themes=false

Starting container in dev mode
docker run \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_HTTP_RELATIVE_PATH=/auth \
  -e KC_DB=mysql \
  -e KC_DB_URL_HOST=35.200.191.112 \
  -e KC_DB_URL_PORT=3306 \
  -e KC_DB_URL_DATABASE=keycloak_db \
  -e KC_DB_USERNAME=dev-env \
  -e KC_DB_PASSWORD=PqkAqV7LRWTgtx8KTNe \
  -e JDBC_PARAMS='useUnicode=true&characterEncoding=UTF-8&characterSetResults=UTF-8' \
  -p 8090:8080 \
  rajibsenrysadockerhub/phasetwo-containers:latest \
  start-dev 
  --spi-email-template-provider=freemarker-plus-mustache \
  --spi-email-template-freemarker-plus-mustache-enabled=true \ 
  --spi-theme-cache-themes=false \
  --spi-connections-jpa-default-migration-strategy=manual \
  --spi-phone-default-service=twilio \
  --spi-message-sender-service-twilio-account=ACd096f24eddfc10e0679188443fb77e8c \
  --spi-message-sender-service-twilio-token=70d5ad7a907443c192771719719f478c \
  --spi-message-sender-service-twilio-number=+18283445365


Access the web interface
Prod
http://keycloak.local

Dev
http://localhost:8090

For mysql
---------
DROP DATABASE `keycloak_db`;
CREATE DATABASE `keycloak_db` CHARACTER SET utf8 COLLATE utf8_unicode_ci;

