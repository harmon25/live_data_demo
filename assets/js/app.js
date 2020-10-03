// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html";

import React from "react";
import { render } from "react-dom";
import { LiveDataProvider, useLiveData } from "@live-data/hooks";
// import { LiveDataSocket, LiveData } from "@live-data/core";
// let ldSocket = new LiveDataSocket();

// let ld = new LiveData({ name: "App", socket: ldSocket });

// ld.connect();

const Providers = (props) => {
  return <LiveDataProvider>{props.children}</LiveDataProvider>;
};

const App = () => {
  const [state, dispatch] = useLiveData("App");
  console.log(state);

  if (state == null) {
    return <div>Loading...</div>;
  }

  return (
    <h1
      onClick={() => {
        dispatch("click", { key: "WHOAAA" });
      }}
    >
      {" "}
      {JSON.stringify(state)}
    </h1>
  );
};

let root = document.getElementById("root");
render(
  <Providers>
    <App />
  </Providers>,
  root
);
