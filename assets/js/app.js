import "../css/app.scss";
// import React from "react";
// import { render } from "react-dom";
import { LiveDataSocket } from "@live-data/core";
import { Socket } from "phoenix";

// import { Providers } from "./components/Providers";
// import { App } from "./components/App";
// this is likely not a good idea for navigation as backbutton integration is a pain, but for tabs works pretty well!

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let authtoken = document
  .querySelector("meta[name='token']")
  .getAttribute("content");

console.log(authtoken);

let ldSocket = new LiveDataSocket("/live_data", Socket, {
  params: { _csrf_token: csrfToken, auth_token: authtoken },
});

window.LD_SOCKET = ldSocket;

let chan = ldSocket.socket.channel("ld:" + authtoken, { token: authtoken });
window.LD_CHANNEL = chan;

chan.join();
// {params: {_csrf_token: csrfToken}}

// render(
//   <ErrorBoundary>
//     <Providers>
//       <App />
//     </Providers>
//   </ErrorBoundary>,
//   document.getElementById("root")
// );
