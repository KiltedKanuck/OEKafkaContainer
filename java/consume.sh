#!/bin/bash
java -jar qa-kafka-client.jar -consume -b localkafka:9092 -t mystream