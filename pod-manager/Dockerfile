FROM alpine:3.18

# Installation des dépendances de base sans kubectl
RUN apk add --no-cache \
    bash \
    socat \
    curl

# Installation spécifique de kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -L -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    kubectl version --client
    
# Copier le script
COPY scripts/pod-manager.sh /scripts/
RUN chmod +x /scripts/pod-manager.sh

# Point d'entrée
ENTRYPOINT ["/scripts/pod-manager.sh"]