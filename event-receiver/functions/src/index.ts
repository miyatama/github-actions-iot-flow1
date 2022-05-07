import * as functions from "firebase-functions";
import * as Amqp from "amqp-ts";

export const githubActionsEvent =
  functions.https.onRequest((request, response) => {
    functions.logger.info("receive data: ", request.body);
    const user = "";
    const password = "";
    const rabbitMqHost = "";
    const rabbitMqEndpoint = 
      "amqp://" + user + ":" + password + "@" + rabbitMqHost;
    const connection = new Amqp.Connection(rabbitMqEndpoint);
    const msg = new Amqp.Message(JSON.stringify(request.body));
    const exchange = connection.declareExchange(
        "amq.topic",
        "topic",
        {durable: true});
    connection.completeConfiguration().then(() => {
      exchange.send(msg, "github-actions-event");
      functions.logger.info("AMQP publish: ", msg);

      setTimeout(function() {
        connection.close();
      }, 500);
      response
          .status(200)
          .send("AMQP publish succeed");
    }).catch((err) => {
      functions.logger.error("AMQP connection error: ", msg);
      response
          .status(500)
          .send("AMQP connection error");
    });
  });
