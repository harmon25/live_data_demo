import "../css/app.scss";
// import React from "react";
// import { render } from "react-dom";
import { LiveDataSocket } from "./live_data";
import { Socket } from "phoenix";
// import { Providers } from "./components/Providers";
// import { App } from "./components/App";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let authtoken = document
  .querySelector("meta[name='token']")
  .getAttribute("content");

let ldSocket = new LiveDataSocket("/live_data", Socket, {
  params: { _csrf_token: csrfToken, auth_token: authtoken },
});

// attach socket to window for debugging
window.LD_SOCKET = ldSocket;

let chan = ldSocket.socket.channel("ld:" + authtoken, { token: authtoken });
// attach channel to window for easy debugging.
window.LD_CHANNEL = chan;

// join the channel
chan.join();
// check current state.
chan.push("current_state", {}).receive("ok", (result) => console.log(result));
// dispach an action.
chan
  .push("dispatch", { type: "add", payload: 10 })
  .receive("ok", (result) => console.log(result));

chan.on("diff", (data) => {
  console.log(data);
});
// {params: {_csrf_token: csrfToken}}

// render(
//   <ErrorBoundary>
//     <Providers>
//       <App />
//     </Providers>
//   </ErrorBoundary>,
//   document.getElementById("root")
// );
