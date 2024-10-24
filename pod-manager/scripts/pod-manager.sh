# generic-chart/scripts/pod-manager.sh
#!/bin/bash

# Configuration des variables
# attention elles sont utilisées dans les yaml (donc pas changer les noms, mais valeurs peuvents)
NAMESPACE=${NAMESPACE:-default}
MODULE_NAME=${MODULE_NAME:-default}
CONTAINER_IMAGE=${CONTAINER_IMAGE:-""}
CONTAINER_TAG=${CONTAINER_TAG:-"latest"}
CONTAINER_PORT=${CONTAINER_PORT:-80}
POD_TTL=${POD_TTL:-3600}

# Fonction de création et gestion des pod
create_temp_pod() {
    # Créer un nom unique pour le pod
    POD_NAME="$MODULE_NAME-$(date +%s)"
    
    # Créer le pod temporaire
    kubectl run $POD_NAME \
        --image=$CONTAINER_IMAGE:$CONTAINER_TAG \
        --labels="temp=true,app=$MODULE_NAME-$COMPONENT-pod"
        --port=$CONTAINER_PORT \
        -n $NAMESPACE
    
    # Attendre que le pod soit prêt
    kubectl wait --for=condition=ready pod/$POD_NAME --timeout=60s -n $NAMESPACE
    
    # Créer un service temporaire pour ce pod
    kubectl expose pod $POD_NAME \
        --name=$POD_NAME-svc \
        --port=$CONTAINER_PORT \
        -n $NAMESPACE
    
    # Programmer la suppression du pod et du service
    (
        sleep $POD_TTL
        kubectl delete pod $POD_NAME -n $NAMESPACE
        kubectl delete svc $POD_NAME-svc -n $NAMESPACE
    ) &
    
    # Retourner le nom du service
    echo $POD_NAME-svc
}

# Boucle principale
# Remplacer la boucle nc par socat
while true; do
    socat TCP-LISTEN:8080,fork - | while read request; do
        if echo "$request" | grep -q "GET / HTTP/1.1"; then
            SERVICE_NAME=$(create_temp_pod)
            echo -e "HTTP/1.1 307 Temporary Redirect\r\nLocation: http://$SERVICE_NAME\r\n\r\n"
        fi
    done
done
