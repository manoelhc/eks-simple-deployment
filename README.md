# My IaC for K8s

![Randy C. Bunney, Great Circle Photography](https://upload.wikimedia.org/wikipedia/commons/e/e5/Scross_helmsman.jpg "Kubernetes stands for 'helmsman' or 'pilot' or 'governor' in Greek")
_Kubernetes stands for "helmsman" or "pilot" or "governor" in Greek" - Randy C. Bunney, Great Circle Photography, from wikipedia.org - CC BY-SA 2.5_

## Objective 

Deploy a webapp (currently WordPress) easily and safely to a high-available K8s cluster.

## Motivation

This is a simple IaC prototype to deploy Wordpress to AWS EKS using Terraform. I started this project from scratch using the technologies I've been using ultimately. Why from scratch? It's simple: technology changes all the time, even tiny changes matter. This is the opportunity I have to explore new features and share my thoughts with you. So far, I'm focused on delivering the basic working IaC. It might change drastically during the course of the roadmap. Feel free to contribute, tell me your thoughts and open an issue.

## Roadmap

This is the current roadmap. It might change during the development.

 1. ~~Create a basic AWS Network Setup script~~
 1. ~~Create a basic AWS EKS Cluster with worker nodes script~~
 1. ~~Create a basic Wordpress deployment script~~
 1. Support HELM Charts deployment
 1. Add metrics and monitoring services
 1. Add log management and analysis services
 1. Add end-to-end distributed tracing services  
 1. Add Basic WAF rules
 1. Code/Modules review to support multi-app, multi-region, multi-cloud providers
 1. Implement multi-app support
 1. Add support to GKE, AKS and OpenStack
 1. Add support to local development (Docker Desktop, Minikube, Raspberry PI, etc)
 1. Create a CLI to create project's templates (?)
 1. Find more stuff to do. Overall, this is a never-ending project :)

## 10,000-foot view 

_Note: This will be updated according the the project's progress!_

#### High-availability
The main goal of this project it to deliver a basic high-available Wordpress webapp. It starts with 3 application pods distributed in 3 different availability zones. There are 2 auto-scaling mechanisms:
 * EC2 Instance (increase resources capacity), provided by [EKS Managed Node Groups](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html). It creates/registers/unregisters/terminates EC2 instances automatically, based on pods allocation. Capacity: _min=3 instances (1 per region), max=30 instances (10 per region)_
 * [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/): Auto scales the pod (application) according to the defined resources limits. If Pod's CPU usage is over 80%, HPA will allocate more pods in the cluster to attend the demand. When the web traffic cools down, HPA will rebalance the pods. Capacity: _min=2 replicas, max=20 replicas, pod_cpu_limit: 1 core, pod_mem_limit: 512mb_


## Current Project's Architecture


Today, the project does:
 * Module `app-infra`: Network basics. Creates a VPC with 1 public subnet for ALB, 3 private subnets (for databases, eks worker nodes, systems __*__ and cache __*__ ) and 1 VPN gateway.
 * Module `app-cluster`: Basic EKS Cluster. Creates a EKS Cluster and a RDS instance with all credentials setup. It also setups your local kube config (I might rethink about this later).
 * Module `k8s-app`: Basic K8S deployment. Creates k8s objects (deployment, services, etc) for Wordpress.

__*__ _: Not in use yet_

## Dependencies

 * `Terraform ^0.12.26` - https://www.terraform.io/downloads.html
 * `AWS CLI ^1.17.9` - https://aws.amazon.com/cli/
 * `kubectl ^1.18.0` - https://kubernetes.io/docs/tasks/tools/install-kubectl/
 * `Helm ^3.2.2` - https://helm.sh/docs/intro/install/

## How to deploy

Once all the dependencies are satisfied, clone the project:
```
$ git clone https://github.com/manoelhc/k8s-simple-deployment.git
```

Run `make check` to run all the plans. Run `make all` to apply all the plans. Note: on `make all`, you need to approve the changes manually, by typing `yes`.

* Known issue:
 `make check` throws errors if you don't create the subnets first (app-infra module). Terraform tries to query the subnets with tag values. If they aren't created, it will return:

```
Error: no matching subnet found
```
