COMMIT:=$(shell git rev-parse --verify --short HEAD)
PROJECT:=questions-for-1on1s
IMAGE_NAME:=qf1on1


build:
	docker build -t $(IMAGE_NAME) -t gcr.io/$(PROJECT)/$(IMAGE_NAME) -t gcr.io/$(PROJECT)/$(IMAGE_NAME):$(COMMIT) .

run: build
	docker run -p 8080:8080 -v `pwd`/questions:/app/questions $(IMAGE_NAME)

push:
	docker push gcr.io/$(PROJECT)/$(IMAGE_NAME)

deploy:
	gcloud run deploy $(PROJECT) --image gcr.io/$(PROJECT)/$(IMAGE_NAME):$(COMMIT) --allow-unauthenticated

run-service:
	gcloud scheduler jobs run $(PROJECT)

logs:
	gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=$(PROJECT)" \
    --project $(PROJECT) --limit 30 --order desc --format "value(textPayload)" | tac

update: build push deploy
