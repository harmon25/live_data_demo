defmodule LiveDataDemo.RootReducer do
  def type() do
    :root
  end

  def children() do
    [{:counter, LiveDataDemo.CounterReducer}]
  end

  # def combine_reducers() do
  #   children()
  #   |> Enum.into(%{}, fn {k, v} ->
  #     {k, v.action({:init, Map.get(existing_state, k, nil)}, nil)}
  #   end)
  # end

  def default_state(existing_state \\ nil) do
    %{}
  end

  def action(:init, nil) do
    default_state()
  end

  def action(:init, existing_state) do
    existing_state
  end

  # def action(action, state) do
  # end
end
