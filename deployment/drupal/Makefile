
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
	cd apps && \
	terraform init && \
	terraform plan

create: create-infra create-eks-cluster create-app

create-infra:
	cd infra && \
	terraform init && \
	terraform apply
create-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform apply
create-app:
	cd apps && \
	terraform init && \
	terraform apply


destroy: destroy-app destroy-eks-cluster destroy-infra 

destroy-infra:
	cd infra && \
	terraform init && \
	terraform destroy && \
	rm -f terraform.tfstate
destroy-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform destroy && \
	rm -f terraform.tfstate
destroy-app:
	cd apps && \
	terraform init && \
	terraform destroy && \
	rm -f terraform.tfstate
