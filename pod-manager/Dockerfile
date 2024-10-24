FROM alpine:3.18

# Installation des dépendances nécessaires
RUN apk add --no-cache \
    bash \
    socat \
    kubectl \
    curl

# Installation de kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copier le script
COPY scripts/pod-manager.sh /scripts/
RUN chmod +x /scripts/pod-manager.sh

# Point d'entrée
ENTRYPOINT ["/scripts/pod-manager.sh"]