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

import React, { useEffect, useState } from "react";
import { render } from "react-dom";
import { LiveDataProvider, useLiveData, uuid } from "@live-data/hooks";
// import { LiveDataSocket, LiveData } from "@live-data/core";
// let ldSocket = new LiveDataSocket();

// let ld = new LiveData({ name: "App", socket: ldSocket });

// ld.connect();
const sessionId = uuid();
// const counterId = uuid();
// const chatId = uuid();
const SignOut = ({ setUser }) => {
  return (
    <button
      onClick={() => {
        localStorage.removeItem("username");

        setUser(null);
      }}
    >
      Signout
    </button>
  );
};

const SignIn = ({ setUser }) => {
  const [username, setUsername] = useState("");

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        console.log(username);
        localStorage.setItem("username", username);
        setUser(username);
        setUsername("");
      }}
    >
      <h4> Login </h4>
      <input
        type="text"
        name="username"
        placeholder="a name"
        value={username}
        onChange={(e) => {
          setUsername(e.target.value);
        }}
      />
      <button type="submit"> Submit</button>
    </form>
  );
};

const Chat = () => {
  const [username, setUser] = useState(localStorage.getItem("username"));
  const [state, dispatch] = useLiveData("Chat", sessionId, {
    username,
    messages: [],
  });

  useEffect(() => {
    dispatch("sign_in", { username });
  }, [username, dispatch]);

  console.log(username);

  if (state.username) {
    return (
      <div>
        Some chat?
        <br />
        <SignOut setUser={setUser} />
      </div>
    );
  } else {
    return <SignIn setUser={setUser} />;
  }
};

const Providers = (props) => {
  return <LiveDataProvider>{props.children}</LiveDataProvider>;
};

const Counter = () => {
  const [state, dispatch] = useLiveData(
    "Counter",
    sessionId,
    { counter: 0 },
    (state) => state.counter
  );
  console.log(state);

  return (
    <div>
      <h1>{state}</h1>
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

const tabs = {
  counter: { name: "Counter", comp: <Counter /> },
  chat: { name: "Chat", comp: <Chat /> },
};

const App = () => {
  const [{ active_tab }, dispatch] = useLiveData("App", sessionId, {
    active_tab: "counter",
  });
  const handleTabClick = (e) => {
    dispatch("change_tab", { newTab: e.target.dataset["key"] });
  };

  let active = tabs[active_tab];

  return (
    <div>
      {Object.keys(tabs).map((t, i) => {
        return (
          <button
            key={t}
            data-key={t}
            onClick={handleTabClick}
            className={active_tab === t ? "active" : ""}
          >
            {tabs[t].name}
          </button>
        );
      })}

      {active.comp}
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
