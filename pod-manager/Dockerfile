FROM alpine:3.18

# Installation des dépendances nécessaires
RUN apk add --no-cache \
    bash \
    socat \
    kubectl \
    curl

# Copier le script
COPY scripts/pod-manager.sh /scripts/
RUN chmod +x /scripts/pod-manager.sh

# Point d'entrée
ENTRYPOINT ["/scripts/pod-manager.sh"]