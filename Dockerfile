FROM quay.io/phasetwo/keycloak-crdb:24.0.4 as builder

ENV KC_METRICS_ENABLED=true
ENV KC_HEALTH_ENABLED=true
ENV KC_FEATURES=preview

# jdbc_ping infinispan configuration
COPY ./conf/cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml

# custom keycloak.conf
#COPY ./conf/keycloak.conf /opt/keycloak/conf/keycloak.conf
#COPY ./conf/quarkus.properties /opt/keycloak/conf/quarkus.properties

# 3rd party themes and extensions
COPY ./libs/ext/*.jar /opt/keycloak/providers/
COPY ./libs/target/container*/*.jar /opt/keycloak/providers/

# RUN /opt/keycloak/bin/kc.sh --verbose build --spi-email-template-provider=freemarker-plus-mustache --spi-email-template-freemarker-plus-mustache-enabled=true --spi-theme-cache-themes=false
RUN /opt/keycloak/bin/kc.sh build \
--spi-phone-default-service=twilio \
--spi-message-sender-service-twilio-account=ACd096f24eddfc10e0679188443fb77e8c \
--spi-message-sender-service-twilio-token=70d5ad7a907443c192771719719f478c \
--spi-message-sender-service-twilio-number=+18283445365
# --spi-phone-default-token-expires-in=60 \
# --spi-phone-default-source-hour-maximum=10 \
# --spi-phone-default-target-hour-maximum=3 \
# --spi-phone-default-[$realm-]duplicate-phone=false \
# --spi-phone-default-[$realm-]default-number-regex=^\+?\d+$ \ 
# --spi-phone-default-[$realm-]valid-phone=true \
# --spi-phone-default-[$realm-]canonicalize-phone-numbers=E164 \ 
# --spi-phone-default-[$realm-]phone-default-region=US \
# --spi-phone-default-[$realm-]compatible=false \
# --spi-phone-default-[$realm-]otp-expires=3600



FROM quay.io/phasetwo/keycloak-crdb:24.0.4

#USER root
# remediation for vulnerabilities
# no longer works after switch to ubi-micro 
#RUN microdnf update -y && microdnf clean all && rm -rf /var/cache/yum/* && rm -f /tmp/tls-ca-bundle.pem

USER 1000

COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/
COPY --from=builder /opt/keycloak/providers/ /opt/keycloak/providers/
COPY --from=builder /opt/keycloak/conf/cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml
# custom keycloak.conf
#COPY --from=builder /opt/keycloak/conf/quarkus.properties /opt/keycloak/conf/quarkus.properties
#COPY --from=builder /opt/keycloak/conf/keycloak.conf /opt/keycloak/conf/keycloak.conf

WORKDIR /opt/keycloak
# this cert shouldn't be used, as it's just to stop the startup from complaining
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore

