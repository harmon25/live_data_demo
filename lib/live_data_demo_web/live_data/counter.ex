defmodule LiveDataDemoWeb.LiveData.Counter do
  use LiveData,
    endpoint: LiveDataDemoWeb.Endpoint,
    default_state: %{counter: 0},
    state_output_path: "../../../assets/js/state"

  @default_state %{counter: 0}

  # types_output_path: "../../../assets/js/types"

  def init(args) do
    {:ok, args["prevState"] || @default_state}
  end

  # @spec handle_call({atom(), map()}, any(), any()) :: {:reply, :ok, %{counter: integer()}}
  def handle_call({:inc, _}, _from, state) do
    {:reply, :ok, %{state | counter: state.counter + 1}}
  end

  # @spec handle_call({atom(), map()}, any(), any()) :: {:reply, :ok, %{counter: integer()}}
  def handle_call({:dec, _}, _from, state) do
    {:reply, :ok, %{state | counter: state.counter - 1}}
  end

  def serialize(state) do
    state
  end
end
