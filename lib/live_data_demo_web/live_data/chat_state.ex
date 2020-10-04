defmodule LiveDataDemoWeb.LiveData.ChatState do
  use LiveData, endpoint: LiveDataDemoWeb.Endpoint

  def init(args) do
    IO.inspect(args)

    {:ok,
     %{
       username: "",
       messages: []
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

  def handle_call({"sign_in", %{"username" => username}}, _from, state) do
    {:reply, :ok, %{state | username: username}}
  end

  def handle_call({"send_message", message}, _from, state) do
    {:reply, :ok, %{state | messages: Enum.reverse([message | state.messages])}}
  end

  def serialize(state) do
    state
  end
end
