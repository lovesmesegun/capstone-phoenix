Here are the architecture — TaskApp on Kubernetes
The Node Topology
3-node k3s cluster on AWS us-east-1a:

Control Plane (t3.micro) 3.237.103.110 - k3s server, Traefik, CoreDNS, cert-manager, Argo CD
Worker 1 (t3.micro) 100.53.110.36 - k3s agent, app pods
Worker 2 (t3.micro) 3.236.137.190 - k3s agent, app pods
Pod CIDR: 10.42.0.0/16 (Flannel VXLAN) Service CIDR: 10.43.0.0/16  Domain: https://taskapp.3.237.103.110.nip.io

System Architecture & Request Flow
User Request: A browser initiates a connection to https://taskapp.3.237.103.110.nip.io
TLS Termination & Routing: The Traefik Ingress Controller intercepts the traffic, managing TLS termination using a Let's Encrypt certificate via cert-manager. It then routes the traffic based on the URL path: 1. Frontend Path (/*): Directed to frontend-service:80, where an Nginx server serves a React SPA. 2. API Path (/api/*): Directed to backend-service:5000, a Flask application that dynamically scales between 2 to 6 replicas via a Horizontal Pod Autoscaler (HPA).
Database Layer: The Flask backend communicates with postgres-service:5432, which runs as a StatefulSet backed by a 5Gi Persistent Volume Claim (PVC).

Core Requirements - Single-Server Assumptions Fixed
Namespace + ConfigMap/Secret: ConfigMap holds non-secret config, Secret holds credentials. Replaces flat .env file.
Postgres StatefulSet + PVC: Data persists across pod restarts. Replaces Docker volume that dies with host.
2+ replicas across nodes: topologySpreadConstraints forces pods onto different nodes. Eliminates single point of failure.
Migration as Job: db-migration Job runs once before app starts. Eliminates alembic race condition at 2+ replicas.
Probes: startupProbe + readinessProbe + livenessProbe on all pods. Dead containers are detected and replaced.
Resource limits: requests + limits on every container. Prevents containers starving each other.
RollingUpdate maxUnavailable 0: New pod passes readiness before old is terminated. Zero downtime deploys.
Ingress + TLS: Traefik + cert-manager + Let's Encrypt. Replaces manual certbot on host.
Pinned image tags: All images pinned to commit SHA c2b906d. No more non-deterministic :latest deploys.
Advanced Infrastructure Features
Horizontal Pod Autoscaling (HPA): Dynamically scales the backend between 2 to 6 replicas when CPU exceeds 50% or memory exceeds 90%.
Pod Disruption Budgets (PDB): Enforces minAvailable: 1 on frontend and backend workloads to prevent outages during voluntary node drains.
Continuous Delivery: Leverages Argo CD to continuously reconcile git state with the cluster and automatically revert manual overrides.
Cluster-Wide Observability: Deploys metrics-server to collect and expose real-time CPU and memory metrics for scaling and monitoring.
GitOps Deployment Flow
Commit & Push: A developer pushes code or manifest changes to the GitHub repository.
Polling & Detection: Argo CD polls the repository every 3 minutes to detect configuration drift between Git and the live cluster.
Automated Reconciliation: Manifests are applied automatically to the cluster.
Self-Healing (selfHeal: true): Instantly rolls back and overwrites any manual configuration changes made via kubectl.
Pruning (prune: true): Automatically purges and deletes cluster resources that have been removed from the Git repository.

Domain Configuration & Cost Optimization
To optimize costs for this academic project, nip.io was selected as the wildcard DNS provider.
Dynamic Resolution: It provides a legitimate public DNS record that automatically maps directly to the cluster’s public IP address.
Automated TLS Issuance: This public visibility allows cert-manager to successfully pass Let's Encrypt HTTP-01 challenges, granting valid SSL/TLS certificates without purchasing a dedicated domain name.
Zero Financial Overhead: Eliminates the ongoing registration and maintenance costs of a traditional domain.
Production-Grade Security: The overall security posture and traffic encryption remain identical to using a premium registered domain.
