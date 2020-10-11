defmodule LiveDataDemoWeb.LiveData.Modals do
  use LiveData,
    endpoint: LiveDataDemoWeb.Endpoint,
    default_state: %{main: false},
    state_output_path: "../../../assets/js/state"

  @default_state %{main: false}

  def init(args) do
    {:ok, args["prevState"] || @default_state}
  end

  def handle_call({:open, %{"name" => name}}, _from, state) do
    atom_name = String.to_existing_atom(name)
    {:reply, :ok, %{state | atom_name => true}}
  end

  def handle_call({:close, %{"name" => name}}, _from, state) do
    atom_name = String.to_existing_atom(name)
    {:reply, :ok, %{state | atom_name => false}}
  end

  def serialize(state) do
    state
  end
end
