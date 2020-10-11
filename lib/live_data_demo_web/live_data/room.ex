defmodule LiveDataDemoWeb.LiveData.Room do
  use LiveData,
    endpoint: LiveDataDemoWeb.Endpoint,
    default_state: %{messages: [], active_users: []},
    state_output_path: "../../../assets/js/state"

  @default_state %{messages: [], active_users: []}

  def init(args) do
    {:ok, args["prevState"] || @default_state}
  end

  def handle_call({:join, %{"username" => username}}, _from, state) do
    {:reply, :ok, %{state | active_users: (state.active_users ++ [username]) |> Enum.uniq()}}
  end

  def handle_call({:leave, %{"username" => username}}, _from, state) do
    {:reply, :ok, %{state | active_users: Enum.filter(state.active_users, &(&1 != username))}}
  end

  def handle_call({:send_msg, %{"message" => _m, "from" => _f, "id" => _id} = msg}, _from, state) do
    timestamp = DateTime.utc_now() |> DateTime.to_iso8601()
    msg_with_timestamp = Map.put_new(msg, "timestamp", timestamp)
    # if i try to prepend and reverse the list of messages, the json diff seems off...
    # am concating lists here which seems to work better
    {:reply, :ok,
     %{
       state
       | messages: state.messages ++ [msg_with_timestamp]
     }}
  end

  def serialize(state) do
    state
  end
end
