# OEKafkaContainer
You must have a Docker Container that has OpenEdge 12.5+ installed on in. The Dockerfile builds FROM openedge:12.5.2. You can see [OE Batch Coantiner project](http://github.com/kiltedkanuck/OE-Batch-Conatiner) for details

### Build OpenEdge Kafka container
```
docker build -t openedge:kafka .
```
### Build Java Kafka container
```
docker build -f Dockerjava - java:kafka .
```

### Start the Kafka cluster
```
docker-compose up -d
```
Once Kafka and Zookeeper are up they have created a private network "oekafkacontainer_default". When you run java:kafka and opendge:kafka you must attach them to that network.

