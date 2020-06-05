
check: check-infra check-eks-cluster check-app

check-infra:
	cd infra && \
	terraform init && \
	terraform plan
check-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform plan
check-app:
	cd app && \
	terraform init && \
	terraform plan

all: create-infra create-eks-cluster create-app

create-infra:
	cd infra && \
	terraform init && \
	terraform apply
create-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform apply
create-app:
	cd app && \
	terraform init && \
	terraform apply
