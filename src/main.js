import '../node_modules/babelify/node_modules/babel-core/browser-polyfill.js';

import _ from 'underscore';
import api from './api';

// we seem to need DOMContentLoaded here, because script tags,
// including our mustache templates aren't necessarily loaded
// on document.load().
document.addEventListener('DOMContentLoaded', ev => {
  var c = document.getElementById("sierpinksi");
  var ctx = c.getContext("2d");
  ctx.fillStyle = "rgba(0,0,0,255)";

  api.subscribe("line", (value) => {
	var line = JSON.parse(value)
	var y = line[0];
	
	for(var x = 0; x < line[1].length; ++x) {
	  if(line[1].charAt(x) == '1')
	  	ctx.fillRect(x,y, 1, 1);
	}
  });

  api.subscribe("clear", (value) => {
	ctx.clearRect(0, 0, c.width, c.height);
 });

  api.onError((error) => {
  });

  api.onReceive(_.debounce((state) => {
  }, 200));
});
