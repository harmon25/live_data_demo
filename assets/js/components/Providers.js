import React from "react";
import { LiveDataProvider } from "@live-data/hooks";
import chatState from "../state/chat.json";
import appState from "../state/app.json";
import counterState from "../state/counter.json";
import roomState from "../state/room.json";
import modalState from "../state/modals.json";

const defaultStates = {
  ...chatState,
  ...counterState,
  ...appState,
  ...roomState,
  ...modalState,
};

export const Providers = (props) => {
  return (
    <LiveDataProvider defaultStates={defaultStates}>
      {props.children}
    </LiveDataProvider>
  );
};
