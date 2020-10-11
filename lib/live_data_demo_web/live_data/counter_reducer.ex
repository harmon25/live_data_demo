defmodule LiveDataDemo.CounterReducer do
  use LiveData.Reducer

  def default_state() do
    0
  end

  def default_state(existing_state) do
    existing_state
  end

  # init action callbacks can probably be injected...
  def action({:init, nil}, state) when is_nil(state) do
    default_state()
  end

  def action({:init, existing_state}, _) do
    existing_state
  end

  def action({:add, number}, state) do
    state + number
  end
end
