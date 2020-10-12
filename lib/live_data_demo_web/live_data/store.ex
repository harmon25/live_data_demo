defmodule LiveData.Store do
  require Logger

  def start_link(id) do
    name = "ld_store_#{id}"

    GenServer.start_link(__MODULE__, [id], name: {:global, name})
    |> case do
      {:ok, pid} ->
        Logger.debug("Launched new #{__MODULE__}: #{name}")
        {:ok, :new, pid}

      {:error, {:already_started, pid}} ->
        Logger.debug("Associated Existing #{__MODULE__}: #{name}")
        {:ok, :existing, pid}
    end
  end

  #
  def init([id]) do
    # channel pids is a list - as this user could be connected via different sockets
    {:ok, %{super_pid: nil, id: id, channel_pids: []}, {:continue, "ld_store_super_#{id}"}}
  end

  def handle_continue(super_name, state) do
    super_pid =
      DynamicSupervisor.start_link(
        name: {:global, super_name},
        strategy: :one_for_one
      )
      |> case do
        {:ok, pid} ->
          Logger.debug("Launched new #{super_name}")
          pid

        {:error, {:already_started, pid}} ->
          Logger.debug("Associated Existing #{super_name}")
          pid
      end

    {:noreply, %{state | super_pid: super_pid}}
  end

  def handle_info({:__live_data_init__, nil}, %{super_pid: super_pid} = state) do
    Logger.debug("Init store for #{state.id}!")

    # this is where, similar to redux - the reducers will be launched - and start in their default state.

    # the actual children of the dynamic supervisor - could just be agents?
    # the

    {:noreply, state}
  end

  # monitor the channel process - so we know when the connection is lost...
  def handle_info({:__live_data_monitor__, channel_pid}, state) do
    IO.inspect("Monitoring #{inspect(channel_pid)}")
    Process.monitor(channel_pid)
    {:noreply, %{state | channel_pids: [channel_pid | state.channel_pids]}}
  end

  def handle_info({:DOWN, _ref, :process, object, _reason}, state) do
    IO.inspect(object, label: "Channel process down!")
    Process.send_after(self(), :__live_data_shutdown__, 10000)
    {:noreply, %{state | channel_pids: Enum.reject(state.channel_pids, &(&1 == object))}}
  end

  def handle_info(:__live_data_shutdown__, %{channel_pids: []} = state) do
    # have no associated channel pid after 10 seconds. leave it.
    {:stop, :normal, state}
  end

  def handle_info(:__live_data_shutdown__, state) do
    IO.inspect(state, label: "state")
    Logger.debug("Skipping shutdown, new channel associated")
    {:noreply, state}
  end

  def terminate(reason, %{super_pid: spid, id: id}) do
    Logger.debug("Shutting down #{id} with reason #{reason}")
    DynamicSupervisor.stop(spid)
    :ok
  end
end
