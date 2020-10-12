defmodule LiveData.Channel do
  use Phoenix.Channel

  def join("ld:" <> token, params, socket) do
    # IO.inspect(key, label: "Joined!")
    # IO.inspect(params, label: "join params")

    # module_map = Application.get_env(:live_data, :module_mapper)
    # socket_session = socket.private.connect_info[:session] || %{}

    # load_csrf_token(socket.endpoint, socket_session)

    with {:ok, user_id} <-
           Phoenix.Token.verify(LiveDataDemoWeb.Endpoint, "user auth", params["token"],
             max_age: 86400
           ),
         # i donno.. just make sure the token matches channel name?
         # socket is associated wit hthe user_id
         true <- params["token"] == token do
      send(self(), {:after_join, user_id})
      {:ok, assign(socket, :user_id, user_id)}
    else
      _ -> {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, user_id}, socket) do
    pid =
      LiveData.Store.start_link(user_id)
      |> case do
        {:ok, :new, pid} ->
          # the second param - could be some persisted client side state?
          send(pid, {:__live_data_init__, nil})
          pid

        {:ok, :existing, pid} ->
          # store already existed - does not neeed initalization...
          pid
      end

    # send channel pid over to newly started LD Server...
    send(pid, {:__live_data_monitor__, self()})

    {:noreply, socket}
  end

  # not using this - but idea is from liveview
  # defp load_csrf_token(endpoint, socket_session) do
  #   if token = socket_session["_csrf_token"] do
  #     state = Plug.CSRFProtection.dump_state_from_session(token)
  #     secret_key_base = endpoint.config(:secret_key_base)
  #     Plug.CSRFProtection.load_state(secret_key_base, state)
  #   end
  # end

  defp get_name(id) do
    {:global, "ld_store_#{id}"}
  end
end
