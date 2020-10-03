defmodule LiveDataDemoWeb.LiveData.Socket do
  use Phoenix.Socket

  channel("App:*", LiveDataDemoWeb.LiveData.AppState.Channel)

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
