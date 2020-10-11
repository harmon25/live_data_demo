import { uuid } from "@live-data/hooks";

export function getSessionId() {
  let sessionId = localStorage.getItem("sessionId");
  if (!sessionId) {
    sessionId = uuid();
    localStorage.setItem("sessionId", sessionId);
  }

  return sessionId;
}
