# Introduction

### Release a new Docker build

The pipeline uses docker images on Github Docker Registry. If you make any changes to the underlying files including in the dockerfile, please push them to Dockerhub:

1. Login using a token with access to Github Packages. See [here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) for more info.

```bash
export CR_PAT=YOUR_TOKEN

echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

2. Build docker image and upload to Github Packages

```bash

git clone https://github.com/Sentieon/sentieon-cli
REPOSITORY_NAME=sentieon-cli
IMAGE_ID=ghcr.io/ucl-medical-genomics/sentieon-cli
docker build --build-arg SENTIEON_VERSION=202308.03 -t ${REPOSITORY_NAME} .

docker tag ${REPOSITORY_NAME} ${IMAGE_ID}:latest

docker push ${IMAGE_ID}:latest
docker push ${IMAGE_ID}:v0.0.1
```
