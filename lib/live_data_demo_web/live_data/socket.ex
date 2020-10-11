defmodule LiveDataDemoWeb.LiveData.Socket do
  use Phoenix.Socket

  channel("ld:*", LiveData.Channel)
  # channel("Counter:*", LiveDataDemoWeb.LiveData.Counter.Channel)
  # channel("Chat:*", LiveDataDemoWeb.LiveData.Chat.Channel)
  # channel("Room:*", LiveDataDemoWeb.LiveData.Room.Channel)
  # channel("Modals:*", LiveDataDemoWeb.LiveData.Modals.Channel)

  @doc """
  Connects the Phoenix.Socket for a LiveData client.
  """
  @impl Phoenix.Socket
  def connect(_params, socket, connect_info) do
    IO.inspect(connect_info)
    IO.inspect(socket.endpoint)
    {:ok, put_in(socket.private[:connect_info], connect_info)}
  end

  @doc """
  Identifies the Phoenix.Socket for a LiveData client.
  """
  @impl Phoenix.Socket
  def id(socket), do: socket.private.connect_info[:session]["live_data_socket_id"]
end
