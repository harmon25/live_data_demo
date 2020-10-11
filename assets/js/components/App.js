import React from "react";
import { Counter } from "./Counter";
import { Chat } from "./Chat";
import { useLiveData } from "@live-data/hooks";
import { getSessionId } from "../sessionId";
import { Modals } from "./Modals";
const tabs = {
  counter: { name: "Counter", comp: <Counter /> },
  chat: { name: "Chat", comp: <Chat /> },
  modals: { name: "Modals", comp: <Modals /> },
};

export const App = () => {
  const [active_tab, dispatch] = useLiveData("App", getSessionId(), {
    selector: (state) => state.active_tab,
    persist: true,
  });
  const handleTabClick = (e) => {
    active_tab !== e.target.dataset["key"] &&
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
