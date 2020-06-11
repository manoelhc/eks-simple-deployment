
check: check-infra check-eks-cluster check-app check-services

check-infra:
	cd infra && \
	terraform init && \
	terraform plan
check-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform plan
check-services:
	cd services && \
	terraform init && \
	terraform plan
check-app:
	cd apps && \
	terraform init && \
	terraform plan

create: create-infra create-eks-cluster create-services create-app

create-infra:
	cd infra && \
	terraform init && \
	terraform apply --auto-approve
create-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform apply --auto-approve
create-services:
	cd services && \
	terraform init && \
	terraform apply --auto-approve
create-app:
	cd apps && \
	terraform init && \
	terraform apply --auto-approve


destroy: destroy-app destroy-services destroy-eks-cluster destroy-infra 

destroy-infra:
	cd infra && \
	terraform init && \
	terraform destroy --auto-approve && \
	rm -f terraform.tfstate*
destroy-eks-cluster:
	cd eks-cluster && \
	terraform init && \
	terraform destroy --auto-approve && \
	rm -f terraform.tfstate*
destroy-services:
	cd services && \
	terraform init && \
	terraform destroy --auto-approve && \
	rm -f terraform.tfstate*
destroy-app:
	cd apps && \
	terraform init && \
	terraform destroy --auto-approve && \
	rm -f terraform.tfstate*
