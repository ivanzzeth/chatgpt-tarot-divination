#!/bin/bash

docker build -t tarot-ai .
docker rm -f tarot-ai
docker run -d --name tarot-ai -v ./data:/usr/src/app/data \
    -v ./.env:/app/.env \
    --restart always -p 9004:8000 tarot-ai
