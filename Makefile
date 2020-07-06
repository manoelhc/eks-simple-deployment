all:
	cd deployment/drupal && terraform_0.13.0_beta init && terraform_0.13.0_beta plan
	kubectl cluster-info
	kubectl get all
check:
	cd deployment/drupal && make check
destroy:
	cd deployment/drupal && make destroy