# SaintBlitz

### Sneaker E-Commerce Landing Site

SaintBlitz is a static marketing and shop website for a sneaker brand, built with plain HTML, CSS, and JavaScript. Orders are placed by phone rather than through an online checkout. The project also includes configuration for containerizing the site and deploying it through several different paths (Docker/Kubernetes, AWS S3, and Azure Static Web Apps).

---

## Project Overview

The site includes:

- A home page (`index.html`) with a hero section, feature highlights, and a collection preview
- A shop page (`shop.html`) listing products, with ordering handled via phone call
- Light/dark theme toggle
- Responsive layout and mobile navigation

There is no backend, database, or payment processing. All "Shop Now" and "Order" actions link to a phone number (`tel:` link).

---

## Project Structure

```text
SaintBlitz/
├── .github/workflows/
│   ├── deploy.yml                                  # Deploy static site to AWS S3
│   └── azure-static-web-apps-happy-pond-...yml     # Deploy static site to Azure Static Web Apps
├── k8s/
│   ├── deployment.yaml     # Kubernetes Deployment (5 replicas)
│   ├── service.yaml        # LoadBalancer Service
│   ├── ingress.yaml        # Ingress routing (host: saintblitz.local)
│   ├── hpa.yaml            # Horizontal Pod Autoscaler (2-5 replicas, 50% CPU target)
│   └── configmap.yaml      # Environment configuration
├── Dockerfile              # Container build definition (Nginx)
├── index.html              # Home page
├── shop.html                # Shop page
├── styles.css                # Site styling
├── logo.svg                   # Brand logo
└── README.md
```

---

## Tech Stack

**Frontend**
- HTML5
- CSS3
- JavaScript

**Web server / container**
- Nginx (Alpine base image)
- Docker

**Orchestration**
- Kubernetes (Deployment, Service, Ingress, HPA, ConfigMap)

**CI/CD and Hosting**
- GitHub Actions
- AWS S3 (static hosting via one workflow)
- Azure Static Web Apps (static hosting via another workflow)

---

## Prerequisites

Depending on which part of this project you want to run:

**To view the site locally (static files only)**
- A modern web browser
- Optionally, any static file server (e.g. `python3 -m http.server`)

**To build and run the container**
- Docker (20.x or later)

**To deploy to Kubernetes**
- A running Kubernetes cluster
- `kubectl` configured to point at that cluster
- A LoadBalancer-capable environment (cloud provider, or MetalLB/similar for local clusters) for the Service to receive an external IP
- An ingress controller installed on the cluster if you intend to use `k8s/ingress.yaml`

**To use the AWS S3 deploy workflow**
- An AWS account and an S3 bucket configured for static website hosting
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` set as GitHub repository secrets
- The bucket name in `.github/workflows/deploy.yml` updated to match your own bucket (it currently points at `s3://saintblittz`)

**To use the Azure Static Web Apps workflow**
- An Azure Static Web Apps resource
- `AZURE_STATIC_WEB_APPS_API_TOKEN_HAPPY_POND_024439410` set as a GitHub repository secret (or renamed to match your own resource's token)

---

## Running Locally

Open `index.html` directly in a browser, or serve the folder:

```bash
python3 -m http.server 8080
```

Then visit `http://localhost:8080`.

---

## Docker

### Build the image

```bash
docker build -t saintblitz .
```

### Run the container

```bash
docker run -p 8080:80 saintblitz
```

Then visit `http://localhost:8080`.

Note: the Dockerfile removes `index.html` after copying the site files into the image. If you build and run the image as-is, the home page will not be served at `/` unless this line is removed or an alternate default page is configured. Review the `Dockerfile` before deploying.

---

## Kubernetes

Manifests are in the `k8s/` directory and can be applied directly:

```bash
kubectl apply -f k8s/
```

This creates:

- A **Deployment** (`saintblitz-deployment`) running the `francisegenti/saintblitz:latest` image with 5 replicas
- A **Service** (`saintblitz-service`) of type `LoadBalancer` exposing port 80
- An **Ingress** (`saintblitz-ingress`) routing the host `saintblitz.local` to the service
- A **HorizontalPodAutoscaler** scaling the deployment between 2 and 5 replicas, targeting 50% average CPU utilization
- A **ConfigMap** (`saintblitz-config`) setting `ENV=production`

Update the image reference in `k8s/deployment.yaml` if you are publishing to your own registry, and update the host in `k8s/ingress.yaml` to match your own domain.

---

## CI/CD Pipelines

Two independent deployment workflows are included; use whichever hosting target applies to you (they are not designed to run together).

### AWS S3 (`deploy.yml`)

On every push to `main`, this workflow:

1. Checks out the code
2. Configures AWS credentials from repository secrets
3. Verifies AWS access
4. Syncs the repository contents to an S3 bucket, excluding `.git` and `.github`

### Azure Static Web Apps (`azure-static-web-apps-happy-pond-024439410.yml`)

On every push to `main`, and on pull request open/sync/reopen, this workflow builds and deploys the site to Azure Static Web Apps. It also closes the corresponding preview environment when a pull request is closed.

---

## Author

**Francis Egenti**

- GitHub: https://github.com/francisegenti
- LinkedIn: https://www.linkedin.com/in/francis-egenti-1537442a7

---

## Support

If you found this project useful, consider starring or forking the repository, or sharing feedback.
