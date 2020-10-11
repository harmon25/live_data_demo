defmodule LiveDataDemoWeb.LiveData.App do
  use LiveData,
    endpoint: LiveDataDemoWeb.Endpoint,
    default_state: %{active_tab: "counter"},
    state_output_path: "../../../assets/js/state"

  @default_state %{active_tab: "counter"}

  @valid_tabs ~w(counter chat modals)

  def init(args) do
    {:ok, args["prevState"] || @default_state}
  end

  def handle_call({:change_tab, %{"newTab" => new_tab}}, _from, state)
      when new_tab in @valid_tabs do
    {:reply, :ok, %{state | active_tab: new_tab}}
  end

  def serialize(state) do
    state
  end
end
