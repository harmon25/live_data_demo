defmodule LiveDataDemoWeb.LiveData.Socket do
  use Phoenix.Socket

  channel("App:*", LiveDataDemoWeb.LiveData.AppState.Channel)
  channel("Counter:*", LiveDataDemoWeb.LiveData.CounterState.Channel)
  channel("Chat:*", LiveDataDemoWeb.LiveData.ChatState.Channel)

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
