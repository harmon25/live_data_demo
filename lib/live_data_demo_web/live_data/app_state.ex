defmodule LiveDataDemoWeb.LiveData.AppState do
  use LiveData, endpoint: LiveDataDemoWeb.Endpoint

  @valid_tabs ~w(counter chat)

  def init(_) do
    {:ok,
     %{
       active_tab: "counter"
     }}
  end

  def handle_call({"change_tab", %{"newTab" => new_tab}}, _from, state)
      when new_tab in @valid_tabs do
    {:reply, :ok, %{state | active_tab: new_tab}}
  end

  def serialize(state) do
    state
  end
end
