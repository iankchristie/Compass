const express = require("express");
const bodyParser = require("body-parser");
const app = express();
const server = require("http").createServer(app);
const websocket = require("ws");

const wss = new websocket.Server({ server: server });

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.set("location", { latitude: 1, longitude: 1 });
app.set("allow_automatic_updates", true);
app.set("connections", []);

wss.on("connection", function connection(ws) {
  var id = Math.random();
  console.log("connection is established : " + id);
  app.get("connections")[id] = ws;

  ws.on("error", console.error);

  ws.on("message", function message(data) {
    console.log("received: %s", data);
    ws.send("pong");
  });

  ws.send(JSON.stringify(app.get("location")));

  ws.on("close", function () {
    console.log("Closing " + id);
    delete app.get("connections")[id];
  });
});

app.get("/", (request, response) => {
  response.send("Use location api");
});

app.get("/location", (request, response) => {
  response.send(JSON.stringify(app.get("location")));
});

const validLocationKeys = ["latitude", "longitude", "update_type"];

app.post("/location", (req, res) => {
  let data = req.body;
  Object.keys(data).forEach(
    (key) => validLocationKeys.includes(key) || delete data[key]
  );
  if (!("latitude" in data) || !("longitude" in data)) {
    res.status(400).send("Bad Request");
    return;
  }
  if ("update_type" in data) {
    if (
      data["update_type"] === "automatic" &&
      !app.get("allow_automatic_updates")
    ) {
      res.status(403).send("Not Accepting Automatic Updates");
      return;
    }
  }

  app.set("location", data);

  console.log(app.get("connections"));
  for (const [key, value] of Object.entries(app.get("connections"))) {
    value.send(JSON.stringify(app.get("location")));
  }

  res.status(204).send({});
});

app.get("/allow_automatic_updates", (request, response) => {
  response.send(
    JSON.stringify({
      allow_automatic_updates: app.get("allow_automatic_updates"),
    })
  );
});

const validAllowAutomaticUpdatesKeys = ["allow_automatic_updates"];

app.post("/allow_automatic_updates", (req, res) => {
  let data = req.body;
  Object.keys(data).forEach(
    (key) => validAllowAutomaticUpdatesKeys.includes(key) || delete data[key]
  );
  if (!("allow_automatic_updates" in data)) {
    res.status(400).send("Bad Request");
    return;
  }
  app.set("allow_automatic_updates", data["allow_automatic_updates"]);
  res.status(204).send({});
});

server.listen(8080, () => {
  console.log("Listen on the port 8080...");
});

/*
curl http://localhost:3000/location
curl -X POST -d '{"latitude": 37.297922, "longitude": -120.182438}' -H 'Content-Type: application/json' http://localhost:3000/location
curl http://localhost:3000/allow_automatic_updates
curl -X POST -d '{"allow_automatic_updates": true}' -H 'Content-Type: application/json' http://localhost:3000/allow_automatic_updates
curl -X POST -d '{"allow_automatic_updates": false}' -H 'Content-Type: application/json' http://localhost:3000/allow_automatic_updates
curl -X POST -d '{"latitude": 38.297922, "longitude": -121.182438}' -H 'Content-Type: application/json' http://localhost:3000/location
curl -X POST -d '{"latitude": 1, "longitude": 2, "update_type": "manual"}' -H 'Content-Type: application/json' http://localhost:3000/location
curl -X POST -d '{"latitude": 2, "longitude": 3, "update_type": "automatic"}' -H 'Content-Type: application/json' http://localhost:3000/location
*/

/*
curl -X POST -d '{"latitude": 37.297922, "longitude": -120.182438, "update_type": "manual"}' -H 'Content-Type: application/json' https://location.iankchristie.com/location
curl -X POST -d '{"allow_automatic_updates": false}' -H 'Content-Type: application/json'  https://location.iankchristie.com/allow_automatic_updates
curl https://location.iankchristie.com/allow_automatic_updates
*/
