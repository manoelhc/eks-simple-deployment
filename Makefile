all:
	cd deployment/drupal && make create
check:
	cd deployment/drupal && make check
destroy:
	cd deployment/drupal && make destroy