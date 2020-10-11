import React, { useState } from "react";
import { useLiveData } from "@live-data/hooks";
import { getSessionId } from "../sessionId";
import { Room } from "./Room";
const SignOut = ({ signOut }) => {
  return (
    <button
      onClick={() => {
        signOut();
      }}
    >
      Signout
    </button>
  );
};

const SignIn = ({ signIn }) => {
  const [username, setUsername] = useState("");

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        console.log("Signing in?");
        signIn(username);
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

export const Chat = () => {
  const [state, dispatch] = useLiveData("Chat", getSessionId(), {
    persist: true,
  });

  const signOut = () => {
    dispatch("sign_out");
  };

  const signIn = (username) => {
    dispatch("sign_in", { username });
  };

  const joinRoom = (room) => {
    dispatch("join_room", { room });
  };

  if (state.username) {
    return (
      <div>
        {state.rooms.map((r) => (
          <div key={r}>
            <button
              onClick={() => {
                joinRoom(r);
              }}
            >
              {r}
            </button>
          </div>
        ))}

        {state.current_room && (
          <Room name={state.current_room} username={state.username} />
        )}

        <br />
        <SignOut signOut={signOut} />
      </div>
    );
  } else {
    return <SignIn signIn={signIn} />;
  }
};
