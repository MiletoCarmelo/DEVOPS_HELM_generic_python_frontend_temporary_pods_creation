from flask import Flask, request, jsonify
import kubernetes
import os

app = Flask(__name__)

# Configure the Kubernetes client
kubernetes.config.load_incluster_config()
v1 = kubernetes.client.CoreV1Api()

NAMESPACE = os.getenv("POD_NAMESPACE", "default")  # Default namespace

@app.route('/create_pod', methods=['POST'])
def create_pod():
    # Get parameters from request JSON
    data = request.get_json()
    image = data.get('image', "your-docker-repo/your-image:latest")  # Default image
    container_port = data.get('container_port', 80)  # Default port

    pod_name = "dynamic-pod-{}".format(request.remote_addr.replace('.', '-'))
    container = kubernetes.client.V1Container(
        name="dynamic-container",
        image=image,
        ports=[kubernetes.client.V1ContainerPort(container_port=container_port)]
    )
    
    pod_spec = kubernetes.client.V1PodSpec(containers=[container])
    pod_template = kubernetes.client.V1PodTemplateSpec(metadata=kubernetes.client.V1ObjectMeta(name=pod_name), spec=pod_spec)
    
    deployment_spec = kubernetes.client.V1DeploymentSpec(
        replicas=1,
        template=pod_template
    )
    
    deployment = kubernetes.client.V1Deployment(
        api_version="apps/v1",
        kind="Deployment",
        metadata=kubernetes.client.V1ObjectMeta(name=pod_name),
        spec=deployment_spec
    )
    
    # Create the pod in the namespace
    v1.create_namespaced_deployment(namespace=NAMESPACE, body=deployment)
    
    return jsonify({"message": f"Pod {pod_name} created"}), 201

@app.route('/delete_pod', methods=['DELETE'])
def delete_pod():
    pod_name = "dynamic-pod-{}".format(request.remote_addr.replace('.', '-'))
    
    # Delete the pod
    v1.delete_namespaced_pod(name=pod_name, namespace=NAMESPACE)
    
    return jsonify({"message": f"Pod {pod_name} deleted"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)



# test it : curl -X POST http://<your-service-ip>/create_pod -H "Content-Type: application/json" -d '{"image": "your-docker-repo/your-image:latest", "container_port": 8080}'