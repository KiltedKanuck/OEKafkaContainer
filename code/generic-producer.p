/**
    This example shows how to construct a generic message producer and send a message.

    The message producer is configured using the generic SetProducerOption() function
    without referencing any Kafka specific classes.
*/


using OpenEdge.Messaging.IProducer from propath.
using OpenEdge.Messaging.ProducerBuilder from propath.
using OpenEdge.Messaging.IProducerRecord from propath.
using OpenEdge.Messaging.RecordBuilder from propath.
using OpenEdge.Messaging.ISendResponse from propath.

block-level on error undo, throw.


    var RecordBuilder recordBuilder.
    var ProducerBuilder pb.
    var IProducer producer.
    var IProducerRecord record.
    var ISendResponse response.

    pb = ProducerBuilder:Create("progress-kafka").

    //pb:SetProducerOption("bootstrap.servers", "vm-lxoedevkafkabroker1-3:5001"). // Kafka reqires at least one bootstrap server host and port.
    pb:SetProducerOption("bootstrap.servers", "localkafka:9092"). // Kafka reqires at least one bootstrap server host and port.
    pb:SetProducerOption("value.serializer", "OpenEdge.Messaging.StringSerializer").

    producer = pb:Build().
    recordBuilder = producer:RecordBuilder.

    recordBuilder:SetTopicName("mystream").  // The topic name is always required
    recordBuilder:SetBody("~{ state : 'running' ~}"). // The body of the record is always required
    record = recordBuilder:Build().
    response = producer:Send(record).  // send the record (message)
    
    // request the producer empty its send queue to ensure the message is sent in a timely manner
    producer:Flush(5000).
    
    // Wait until the delivery response is received and the response object properties have been populated
    
    /*
    repeat while not response:Completed:
        pause .1 no-message.
    end.
    */
    if not response:Success then do:
        undo, throw new Progress.Lang.AppError("Failed to send the record: " + response:ErrorMessage, 0).
    end.
    else
        message "sent".
    

catch e as Progress.Lang.Error :
    message 
        e:GetMessage(1) skip(2) 
        e:CallStack 
            view-as alert-box.
end catch.
finally:
    // Explicitly cleanup our producer
    delete object producer no-error.
end.    
