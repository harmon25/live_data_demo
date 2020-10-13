defmodule LiveDataDemo.RootReducer do
  use LiveData.Reducer
  def key, do: :root
  def children, do: [LiveDataDemo.CounterReducer]

  def default_state() do
    %{
      counter: LiveDataDemo.CounterReducer
    }
  end

  def default_state(existing) do
    existing
  end
end
