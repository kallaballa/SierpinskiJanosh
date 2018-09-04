import '../node_modules/babelify/node_modules/babel-core/browser-polyfill.js';

import api from './api';
// we seem to need DOMContentLoaded here, because script tags,
// including our mustache templates aren't necessarily loaded
// on document.load().
document.addEventListener('DOMContentLoaded', ev => {
  var c = document.getElementById("sierpinksi");
  var ctx = c.getContext("2d");
  ctx.fillStyle = "rgba(0,0,0,255)";

  api.subscribe("update", (value) => {
		var arr = JSON.parse(value)
                var line = atob(arr[1]);
                var y = arr[0];
                for(var x = 0; x < line.length; ++x) {
                        var c = line.charCodeAt(x);
                        for(var k = 0; k < 8; ++k) {
                                var m = 0x00000001 << (7 - k);
                                if((c & m) > 0) {
                                        ctx.fillRect(x*8+k,y, 1, 1);
                                }
                        }
                }
  });

  api.subscribe("clear", (value) => {
	ctx.clearRect(0, 0, c.width, c.height);
 });

  api.onError((error) => {
  });

  api.onReceive((state) => {
  });
});
