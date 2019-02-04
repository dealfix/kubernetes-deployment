#!/usr/bin/env bash

docker build -t hatrena/multi-client:latest -t hatrena/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t hatrena/multi-server:latest -t hatrena/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t hatrena/multi-worker:latest -t hatrena/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push hatrena/multi-client:latest
docker push hatrena/multi-server:latest
docker push hatrena/multi-worker:latest

docker push hatrena/multi-client:$SHA
docker push hatrena/multi-server:$SHA
docker push hatrena/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=hatrena/multi-server:$SHA
kubectl set image deployments/client-deployment client=hatrena/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=hatrena/multi-worker:$SHA