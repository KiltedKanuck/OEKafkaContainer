/**
    This example shows how to consume a stream of messages. The messages
    themselves are JSON objects, and the example uses the JSONDeserializer
    class to convert the network messages to JSON objects that can be used
    by the application. 
*/
  
block-level on error undo, throw.
 
using OpenEdge.Messaging.ConsumerBuilder.
using OpenEdge.Messaging.IConsumer.
using OpenEdge.Messaging.IConsumerRecord.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
 
var ConsumerBuilder cb.
var IConsumer consumer.
var IConsumerRecord record.
var JsonObject messageBody.
var char kServer = "localkafka:9092".
var char kTopic = "mystream".
 
cb = ConsumerBuilder:Create("progress-kafka").
 
// Kafka requires at least one bootstrap server host and port.
cb:SetConsumerOption("bootstrap.servers", kServer).

// Explicitly disable auto commit so it can be controlled within the application.
cb:SetConsumerOption("enable.auto.commit", "false").

// Identify the consumer group. The consumer group allows multiple clients to
//  coordinate the consumption of multiple topics and partitions
cb:SetConsumerOption("group.id", "my.consumer.group").

// Specify whether the consumer group should automatically be deleted when
//  the consumer is garbage collected.
cb:SetConsumerOption("auto.delete.group", "true").

// Configure the consumer's deserializer in order to convert MEMPTR values from
//  the network messages to JSON objects.
cb:SetConsumerOption("value.deserializer", "OpenEdge.Messaging.JsonDeserializer").

// Set the consumer starting position to the most recent message
cb:SetConsumerOption("auto.offset.reset", "latest").
     
// identify one or more topics to consume
cb:AddSubscription(kTopic).
     
// build the consumer
consumer = cb:Build().
          
// loop forever receiving and processing records.
message substitute ("Kafka consumer for &1 on &2", kTopic, kServer).
repeat while true:
    // request a record, waiting up to 1 second for some records to be available
    record = consumer:Poll(1000).
         
    if valid-object(record) then do:
           
        // acknowledge the message so the client can resume where it leaves off
        // the next time it is started
        consumer:CommitOffset(record).
             
        messageBody = cast(record:Body, JsonObject).
             
        message substitute("Message:[&2] - Number: &1", 
                        messageBody:GetInteger("message_number"),
                        messageBody:GetCharacter("message"))
        .
    end.
         
end.
     
 
catch err as Progress.Lang.Error :
    message err:GetMessage(1) view-as alert-box.
end catch.

finally:
    delete object consumer no-error.
end.