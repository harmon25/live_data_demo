defmodule LiveData.Channel do
  use Phoenix.Channel
  require Logger

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


  def handle_in("dispatch", %{"type" => action_type, "payload" => payload}, socket) do
   store = get_store_name(socket)
   # grab state before dispatching...
   old_state = LiveData.Store.get_state(store)
   # dispatch action against store
   LiveData.Store.dispatch(store, {String.to_existing_atom(action_type), payload})
   # grab state again.
   new_state = LiveData.Store.get_state(store)
   broadcast!(socket, "diff", %{diff: JSONDiff.diff(old_state, new_state) })
   {:noreply, socket}
  end

  def handle_in("current_state", _, socket) do
     store = get_store_name(socket)
     {:reply, {:ok, LiveData.Store.get_state(store)}, socket}
  end

  def handle_info({:after_join, user_id}, socket) do
    # am launching this store without any supervison? - kinda just floating in the beam
    # because of the stateful nature - live_data should probably be its own :application that can have its own supervison tree, so the store can be launched supervised.
    pid =
      LiveData.Store.start(user_id)
      |> case do
        {:ok, :new, pid} ->
          # the second param - could be some persisted client side state?
          send(pid, {:__live_data_init__, nil})
          pid

        {:ok, :existing, pid} ->
          # store already existed - does not neeed initalization...
          pid
      end

      Logger.debug("Store at pid: #{inspect(pid)}")

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

  defp get_store_name(socket) do
    {:global, "ld_store_#{socket.assigns.user_id}"}
  end

  defp get_name(id) do
    {:global, "ld_store_#{id}"}
  end
end
