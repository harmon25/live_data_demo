import React, { useEffect, useState, Fragment } from "react";
import { useLiveData, uuid } from "@live-data/hooks";

const opts = {
  persist: true,
  selector: (state) => state.messages,
};

const Messages = ({ roomName, username }) => {
  const [messages, dispatch, connected] = useLiveData("Room", roomName, opts);
  console.log("MESSAGES!");
  console.log(messages);

  return (
    <ul>
      {messages.map((message) => {
        return (
          <li key={message.id}>
            <strong>{message.from}</strong>: {message.message}{" "}
          </li>
        );
      })}
    </ul>
  );
};

const MsgInput = ({ sendMsg, username }) => {
  const [message, setMsg] = useState("");

  const handleMsgChange = (e) => {
    setMsg(e.target.value);
  };

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        if (message) {
          let msg = { message, from: username, id: uuid() };
          sendMsg("send_msg", msg);
          setMsg("");
        }
      }}
    >
      <input
        type="text"
        name="message"
        value={message}
        onChange={handleMsgChange}
      />
      <button type="submit">Send</button>
    </form>
  );
};

export const Room = ({ name = "lobby", username }) => {
  // this onConnect is helpful when needing to send a message immediatly when joining, this could also be done via more parameters retured from the hook..
  // like a connected boolean, that could trigger the running of an effect.
  const [active_users, dispatch] = useLiveData("Room", name, {
    persist: true,
    afterConnect: (push) => {
      console.log("joining room!");
      push("join", { username });
    },
    beforeDisconnect: (push) => {
      console.log("beforeDisconnect");
      push("leave", { username });
    },
    selector: (state) => state.active_users,
  });

  return (
    <div>
      <h2>
        {name} (
        {active_users.map((u, i) =>
          u === username ? (
            <Fragment key={u}>
              <strong>{u}</strong>
              {i !== active_users.length - 1 ? "," : ""}
            </Fragment>
          ) : (
            <span key={u}>
              {u}
              {i !== active_users.length - 1 ? "," : ""}
            </span>
          )
        )}
        )
      </h2>
      <Messages roomName={name} username={username} />
      <hr />
      <MsgInput sendMsg={dispatch} username={username} />
    </div>
  );
};
