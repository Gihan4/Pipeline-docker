#!/bin/bash

imageTag="gihan4/myimage:1.0"

# Stop and remove all running containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Get a list of image IDs with the specified tag
imageIDs=$(docker images --format "{{.ID}}" --filter "reference=${imageTag}")

# Sort the image IDs by creation date in descending order
sortedImageIDs=$(echo "${imageIDs}" | xargs docker inspect --format='{{.ID}} {{.Created}}' | sort -k2 -r | awk '{print $1}')

# Remove all images except the latest one
counter=0
for imageID in ${sortedImageIDs}; do
  if [[ ${counter} -gt 0 ]]; then
    docker rmi ${imageID}
  fi
  counter=$((counter+1))
done
