import React from "react";
import { Popup } from "reactjs-popup";
import { useLiveData } from "@live-data/hooks";
import { getSessionId } from "../sessionId";

export const Modals = () => {
  const [state, dispatch] = useLiveData("Modals", getSessionId(), {
    persist: true,
  });

  const handleOpen = () => {
    dispatch("open", { name: "main" });
  };

  const handleClose = () => {
    dispatch("close", { name: "main" });
  };

  return (
    <div>
      <button className="button" onClick={handleOpen}>
        Open Modal
      </button>
      <Popup open={state.main} modal>
        <div className="modal">
          <a className="close" onClick={handleClose}>
            &times;
          </a>
          Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae magni
          omnis delectus nemo, maxime molestiae dolorem numquam mollitia,
          voluptate ea, accusamus excepturi deleniti ratione sapiente!
          Laudantium, aperiam doloribus. Odit, aut.
        </div>
      </Popup>
    </div>
  );
};
