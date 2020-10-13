defmodule LiveDataDemo.AppReducer do
  use LiveData.Reducer
  @valid_tabs ~w(counter chat modals)

  # used to set key in map, also if :root, has special behaviours?
  def key, do: :app

  # children is called to merge reducers that exist at this level of state - but are their own reducer/process.
  # def children, do: []

  def action({:set_tab, tab}, state, _context) when tab in @valid_tabs do
    %{state | active_tab: tab}
  end

  def default_state() do
    %{active_tab: "counter"}
  end

  def default_state(existing_state) do
    existing_state
  end
end
