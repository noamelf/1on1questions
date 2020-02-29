COMMIT:=$(shell git rev-parse --verify --short HEAD)
PROJECT:=1on1questions


build:
	docker build -t $(PROJECT) -t gcr.io/$(PROJECT)/$(PROJECT) -t gcr.io/$(PROJECT)/$(PROJECT):$(COMMIT) .

push:
	docker push gcr.io/$(PROJECT)/$(PROJECT)

deploy:
	gcloud run deploy $(PROJECT) --image gcr.io/$(PROJECT)/$(PROJECT):$(COMMIT)

run-service:
	gcloud scheduler jobs run $(PROJECT)

logs:
	gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=$(PROJECT)" \
    --project $(PROJECT) --limit 30 --order desc --format "value(textPayload)" | tac

update: build push deploy run-service
