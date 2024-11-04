FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app
COPY manage_pod.py .

# Install the kubernetes python package
RUN pip install kubernetes
RUN pip install flask

# Run the manage_pod.py script when the container starts up
CMD ["python", "manage_pod.py"]
