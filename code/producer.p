
using OpenEdge.Messaging.*.
using OpenEdge.Messaging.Kafka.*.
using Progress.Json.ObjectModel.*.

block-level on error undo, throw.

    var RecordBuilder recordBuilder.
    var ProducerBuilder pb.
    var IProducer producer.
    var IProducerRecord record.
    var ISendResponse response.
    var JsonObject msgbody.
    
    define variable iCount as integer no-undo.
    define variable kMsg        as character format "x(40)" label "Message" no-undo.

    pb = ProducerBuilder:Create("progress-kafka").

    pb:SetProducerOption("bootstrap.servers", "localkafka:9092"). // Kafka reqires at least one bootstrap server host and port.
    // pb:SetProducerOption("value.serializer", "OpenEdge.Messaging.StringSerializer").
    pb:SetBodySerializer(new JsonSerializer()).

    producer = pb:Build().
    recordBuilder = producer:RecordBuilder.

    recordBuilder:SetTopicName("mystream").  
    iCount = 0.
    repeat:
        assign
            kMsg = ""
            iCount += 1.
        update kMsg with frame MsgFrame.
        hide frame MsgFrame.
    
        msgBody = new JsonObject().
        msgBody:Add("message", kMsg).
        msgBody:Add("message_number", iCount).

        recordBuilder:SetBody(msgBody). // The body of the record is always required
        record = recordBuilder:Build().
        response = producer:Send(record).  // send the record (message)
        
        // request the producer empty its send queue to ensure the message is sent in a timely manner
        producer:Flush(5000) no-error.
        
        if not response:Completed then do:
            undo, throw new Progress.Lang.AppError("Failed to complete", 0). 
        end.

        if not response:Success then do:
            undo, throw new Progress.Lang.AppError("Failed to send the record: " + response:ErrorMessage, 0).
        end.

        delete object msgBody no-error.
    end.

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
