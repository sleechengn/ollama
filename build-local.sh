#!/usr/bin/bash
./build.sh 192.168.13.73:5000/sleechengn/ollama:latest
docker push 192.168.13.73:5000/sleechengn/ollama:latest
