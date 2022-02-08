console.log("start");

const fs = require('fs');
const express = require('express');
var mc = require('minecraft-protocol');
console.log(mc.supportedVersions)
var ip;
var ver;

const app = express();
const port = 3000;
app.get('/', (req, res) => res.send(ip));
app.listen(port, () => console.log(`listen ${port}`));

ip = fs.readFileSync('./../ip.txt', 'utf8').toString();
console.log("node ip:  " + ip);

ver = fs.readFileSync('./../ver.txt', 'utf8').toString();
console.log("node ver:  " + ver);



/*
var server = mc.createServer({
  'online-mode': true,   // optional
  host: ip.split(':')[0],       // optional
  port: ip.split(':')[1],           // optional
});
//https://github.com/PrismarineJS/flying-squid
const mcData = require('minecraft-data')(server.version)

server.on('login', function(client) {
  console.log('login')
  let loginPacket = mcData.loginPacket
  client.write('login', {
    entityId: client.id,
    isHardcore: false,
    gameMode: 0,
    previousGameMode: 255,
    worldNames: loginPacket.worldNames,
    dimensionCodec: loginPacket.dimensionCodec,
    dimension: loginPacket.dimension,
    worldName: 'minecraft:overworld',
    hashedSeed: [0, 0],
    maxPlayers: server.maxPlayers,
    viewDistance: 10,
    reducedDebugInfo: false,
    enableRespawnScreen: true,
    isDebug: false,
    isFlat: false
  });
  client.write('position', {
    x: 0,
    y: 1.62,
    z: 0,
    yaw: 0,
    pitch: 0,
    flags: 0x00
  });
  var msg = {
    translate: 'chat.type.announcement',
    "with": [
      'Server',
      'Hello, world!'
    ]
  };
  client.write("chat", { message: JSON.stringify(msg), position: 0, sender: '0' });
});
*/
