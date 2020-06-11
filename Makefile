all:
	cd deployment/drupal && make create
	kubectl cluster-info
	kubectl get all
check:
	cd deployment/drupal && make check
destroy:
	cd deployment/drupal && make destroy