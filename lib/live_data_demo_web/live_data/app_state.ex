defmodule LiveDataDemoWeb.LiveData.AppState do
  use LiveData, endpoint: LiveDataDemoWeb.Endpoint

  def init(_) do
    {:ok,
     %{
       counter: 0
     }}
  end

  #  api?
  #
  # def handle_mount(state) do
  # {:ok, state}
  # end
  # def handle_unmount(state) do
  #  :ok
  # end
  #
  # def handle_action({"inc", _}, state) do
  #   {:ok, %{state | counter: state.counter + 1}}
  # end

  def handle_call({"inc", _}, _from, state) do
    {:reply, :ok, %{state | counter: state.counter + 1}}
  end

  def handle_call({"dec", _}, _from, state) do
    {:reply, :ok, %{state | counter: state.counter - 1}}
  end

  def serialize(state) do
    state
  end
end
