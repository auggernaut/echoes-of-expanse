const functions = require("firebase-functions");
const express = require("express");
const WebSocket = require("ws");
const cors = require("cors")({origin: true});

const app = express();
app.use(cors);

const server = app.listen(0);
const wss = new WebSocket.Server({server});

const clients = new Set();
console.log("Server started");

wss.on("connection", (ws) => {
  console.log("New client connected");
  clients.add(ws);

  ws.on("message", (message) => {
    console.log("Received:", message);

    // Broadcast the message to all connected clients
    clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  });

  ws.on("close", () => {
    console.log("Client disconnected");
    clients.delete(ws);
  });
});

exports.websocket = functions.https.onRequest(app);
