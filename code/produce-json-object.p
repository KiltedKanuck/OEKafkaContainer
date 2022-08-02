/**

Tthis example shows how to use Jsonobject as a message body. The JsonSerializer class
is used by the serializer is used to convert the JsonObject  

*/


using OpenEdge.Messaging.*.
using OpenEdge.Messaging.Kafka.*.
using Progress.Json.ObjectModel.*.

block-level on error undo, throw.

    var RecordBuilder recordBuilder.
    var KafkaProducerBuilder pb.
    var IProducer producer.
    var JsonObject msgbody.
    var IProducerRecord record.
    
    pb = cast(ProducerBuilder:Create("progress-kafka"), KafkaProducerBuilder).
    pb:SetBootstrapServers("vm-lxoedevkafkabroker1-1:5001").
    pb:SetBodySerializer(new JsonSerializer()).

    producer = pb:Build().

    recordBuilder = producer:RecordBuilder.

    recordBuilder:SetTopicName("mbaker-testing").

    
    msgBody = new JsonObject().
    msgBody:Add("name", "Lift Line Skiing").
    msgBody:Add("address", "1 main street").
    
    recordBuilder:SetBody(msgBody). 
    record = recordBuilder:Build().

    producer:Send(record).
    
    producer:Flush(5000).
    
        
catch e as Progress.Lang.Error :
    message e:GetMessage(1) view-as alert-box.
end catch.
