defmodule LiveDataDemoWeb.LiveData.App2 do
  use ObservableGenServer

  @default_state %{active_tab: "counter"}

  @valid_tabs ~w(counter chat modals)

  def init(n) do
    {:ok, n}
  end

  def handle_call({:add, n}, _from, state) do
    {:reply, state, state + n}
  end

  def handle_call(_, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add, n}, state) do
    {:noreply, state + n}
  end

  def handle_cast(_, state) do
    {:noreply, state}
  end

  def handle_info({:add}, state) do
    {:noreply, state + 1}
  end

  def handle_changed(state, previous_state) do
    IO.inspect(state, label: "current")
    IO.inspect(previous_state, label: "prev")
    {:noreply, state}
  end
end
