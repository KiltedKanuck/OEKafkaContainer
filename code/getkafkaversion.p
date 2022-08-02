using OpenEdge.Messaging.*.
block-level on error undo, throw.

var ProducerBuilder pb.
var IProducer producer.
var char msg.
// use producer builder to request an instance of the progress kafka
// messaging implementation...or you could create the producer builder directly
// but we like late binding, so it this way.

pb = ProducerBuilder:Create("progress-kafka").
pb:SetProducerOption("bootstrap.servers", "fakehost:2181").
pb:SetBodySerializer(new StringSerializer()).
producer = pb:Build().

msg = substitute("Producer:[&1], Version:[&2]", producer:ImplementationName, producer:ImplementationVersion).
message msg.