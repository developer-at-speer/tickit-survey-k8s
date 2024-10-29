# How to run locally?
## Run the server
- `rails s`
# How to run using Docker Container?
## Build and run docker image
- docker-compose build
- docker-compose run web
### Or specify other environment variables and ports
- docker-compose run -e DB_PORT=3306 -e DB_USERNAME=username -p 3000:3000 web 

# How to run using Kubernetes?
- Build docker image
- Push docker image to dockerhub
- Update `rails-survey-deployment.yaml` to fetch correct image name
- Run minikube locally using `minikube start`
- Run `minikube addons enable ingress` to create nginx ingress controller
- Apply deployments, ingresses, services, PVs, PVCs and configmaps using `kubectl apply -f <file_name>`
- Get minikube ip using `minikube ip`
- Update `/etc/hosts` with the following record: `<minikube ip>   app.local`
