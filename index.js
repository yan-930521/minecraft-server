console.log("start");

const fs = require('fs');
//const express = require('express');
const mc = require('flying-squid');

var ip;
/*
const app = express();
const port = 3000;
app.get('/', (req, res) => res.send(ip));
app.listen(port, () => console.log(`listen ${port}`));
*/
ip = fs.readFileSync('./../ip.txt', 'utf8').toString();
console.log("node ip:  " + ip);

mc.createMCServer({
  'motd': 'A Minecraft Server \nRunning flying-squid',
  'host': ip.split(':')[0],
  'port': ip.split(':')[1],  
  'max-players': 10,
  'online-mode': true,
  'logging': false,
  'gameMode': 1,
  'difficulty': 1,
  'worldFolder':'world',
  'generation': {
    'name': 'diamond_square',
    'options':{
      'worldHeight': 80
    }
  },
  'kickTimeout': 10000000000,
  'plugins': {

  },
  'modpe': false,
  'view-distance': 10,
  'player-list-text': {
    'header':'Flying squid',
    'footer':'Test server'
  },
  'everybody-op': true,
  'max-entities': 100,
  'version': '1.16.1'
});