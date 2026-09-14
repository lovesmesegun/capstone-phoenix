The Cost Analysis Used
This deployment made use of K3s on AWS EC2 with Argo CD, PostgreSQL, and nip.io for DNS.

Monthly Itemized Cost
Item Spec Qty $/mo

No cost spent building this capstone-phoenix project. Still on free aws tier.

Production-Grade Infrastructure
Kubernetes delivers robust operational reliability for production workloads through five core automation capabilities:
High Availability: Distributed worker nodes eliminate single points of failure.
Zero-Downtime Deployments: Progressive rolling updates push new code without interrupting users.
Self-Healing Infrastructure: Automated health checks instantly restart failed components.
GitOps Automation: Continuous deployment loops sync state automatically via Argo CD.
Horizontal Scalability: Dedicated controllers scale replica counts dynamically using HPAs.

How I'd Halve This Cost
If I wanted to slash these infrastructure costs, my first move would be switching the worker nodes to cheaper Spot Instances while keeping the control plane on a reliable On-Demand instance. For dev environments, we could shrink the control plane's size or just spin up a quick two-node K3s cluster. Since the project relies on nip.io, we already skip out on regular DNS costs. To save even more, we can share one load balancer and keep storage tight—giving us nearly full Kubernetes power for way less money.
