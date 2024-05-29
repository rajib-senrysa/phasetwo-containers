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
  -p 8090:8080 \
  rajibsenrysadockerhub/phasetwo-containers:latest \
  start --spi-email-template-provider=freemarker-plus-mustache --spi-email-template-freemarker-plus-mustache-enabled=true --spi-theme-cache-themes=false

Starting container in dev mode
docker run --name keycloak_custom \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  -e KC_HTTP_RELATIVE_PATH=/auth \
  -e KC_DB=mysql \
  -e KC_DB_URL_HOST=35.200.191.112 \
  -e KC_DB_URL_PORT=3306 \
  -e KC_DB_URL_DATABASE=keycloak_db \
  -e KC_DB_USERNAME=dev-env \
  -e KC_DB_PASSWORD=PqkAqV7LRWTgtx8KTNe \
  -p 8090:8080 \
  rajibsenrysadockerhub/phasetwo-containers:latest \
  start-dev --spi-email-template-provider=freemarker-plus-mustache --spi-email-template-freemarker-plus-mustache-enabled=true --spi-theme-cache-themes=false


Access the web interface
Prod
http://keycloak.local

Dev
http://localhost:8090

