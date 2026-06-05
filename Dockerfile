# Keycloak image with the ERP login theme baked in.
# Runtime settings such as DB connection, hostname, and admin credentials
# should be supplied by Jenkins/EC2 environment variables, not this image.
FROM quay.io/keycloak/keycloak:26.6.2

COPY keycloak-themes/erp /opt/keycloak/themes/erp
COPY import /opt/keycloak/data/import

EXPOSE 8080
