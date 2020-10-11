defmodule LiveDataDemoWeb.LiveData.Chat do
  use LiveData,
    endpoint: LiveDataDemoWeb.Endpoint,
    default_state: %{
      username: "",
      current_room: nil,
      rooms: ["lobby"]
    },
    state_output_path: "../../../assets/js/state"

  @default_state %{
    username: "",
    current_room: nil,
    rooms: ["lobby"]
  }

  def init(args) do
    {:ok, args["prevState"] || @default_state}
  end

  def handle_call({:join_room, %{"room" => room}}, _from, state) do
    IO.inspect(state)
    new_state = %{state | current_room: room}
    IO.inspect(new_state)
    {:reply, :ok, new_state}
  end

  def handle_call({:sign_out, _}, _from, state) do
    {:reply, :ok, %{state | username: nil}}
  end

  def handle_call({:sign_in, %{"username" => username}}, _from, state) do
    {:reply, :ok, %{state | username: username}}
  end

  def handle_call({:create_room, %{"room" => room}}, _from, state) do
    {:reply, :ok, %{state | room: Enum.reverse([room | state.rooms])}}
  end

  def serialize(state) do
    state
  end
end
