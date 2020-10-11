import React from "react";
import { useLiveData } from "@live-data/hooks";
import { getSessionId } from "../sessionId";

export const Counter = () => {
  const [state, dispatch] = useLiveData("Counter", getSessionId(), {
    selector: (state) => state.counter,
    persist: true,
  });

  const decrement = () => {
    dispatch("dec");
  };

  const increment = () => {
    dispatch("inc");
  };

  return (
    <div>
      <h1>{state}</h1>
      <button onClick={decrement}>Dec</button>
      <button onClick={increment}>Inc</button>
    </div>
  );
};
