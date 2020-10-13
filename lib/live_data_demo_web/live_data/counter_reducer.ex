defmodule LiveDataDemo.CounterReducer do
  use LiveData.Reducer

  def key, do: :counter

  def action({:add, number}, state, _context) do
    state + number
  end

  def action({:sub, number}, state, _context) do
    state - number
  end

  def action({:reset, _}, _state, _context) do
    default_state()
  end

  def default_state() do
    0
  end

  def default_state(existing_state) do
    existing_state
  end
end
