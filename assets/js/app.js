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

import React, { useState } from "react";
import { render } from "react-dom";
import { LiveDataProvider, useLiveData } from "@live-data/hooks";
// import { LiveDataSocket, LiveData } from "@live-data/core";
// let ldSocket = new LiveDataSocket();

// let ld = new LiveData({ name: "App", socket: ldSocket });

// ld.connect();

const Providers = (props) => {
  return <LiveDataProvider>{props.children}</LiveDataProvider>;
};

const Counter = () => {
  const [state, dispatch] = useLiveData("App", { counter: 0 });
  console.log(state);

  return (
    <div>
      <h1>{state.counter}</h1>
      <button
        onClick={() => {
          dispatch("inc", {});
        }}
      >
        Inc
      </button>
      <button
        onClick={() => {
          dispatch("dec", {});
        }}
      >
        Dec
      </button>
    </div>
  );
};

const App = () => {
  const [hidden, setHidden] = useState(false);

  return (
    <div>
      <button
        onClick={() => {
          setHidden(!hidden);
        }}
      >
        {hidden ? "show" : "hide"}
      </button>
      {hidden ? null : <Counter />}
    </div>
  );
};

let root = document.getElementById("root");
render(
  <Providers>
    <App />
  </Providers>,
  root
);
