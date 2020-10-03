defmodule LiveDataDemoWeb.LiveData.AppState do
  use LiveData, endpoint: LiveDataDemoWeb.Endpoint

  def init(_) do
    {:ok,
     %{
       test: "HI"
     }}
  end

  def handle_call({"click", %{"key" => val}}, _from, state) do
    IO.inspect(val)

    {:reply, :ok, state}
  end

  def serialize(state) do
    state
  end

  # def handle_call({:toggle_all, _}, _from, state) do
  #   all_done = state.todos |> Enum.all?(fn todo -> todo.done end)

  #   new_todos =
  #     state.todos
  #     |> Enum.map(fn
  #       todo -> Map.put(todo, :done, !all_done)
  #     end)

  #   {:reply, :ok, state |> update_todos(new_todos)}
  # end

  # def handle_call({:add_todo, %{"title" => title}}, _from, state) do
  #   new_todos = [%{id: state.todos |> length, title: title, done: false} | state.todos]

  #   {:reply, :ok, state |> update_todos(new_todos)}
  # end

  # def handle_call({:clear_completed, _}, _from, state) do
  #   new_todos =
  #     state.todos
  #     |> Enum.filter(fn
  #       %{done: true} -> false
  #       _ -> true
  #     end)

  #   {:reply, :ok, state |> update_todos(new_todos)}
  # end

  # def handle_call({:toggle_done, id}, _from, state) do
  #   new_todos =
  #     state.todos
  #     |> Enum.map(fn
  #       %{id: ^id} = todo -> Map.put(todo, :done, !todo.done)
  #       todo -> todo
  #     end)

  #   {:reply, :ok, state |> update_todos(new_todos)}
  # end

  # defp update_todos(state, todos) do
  #   new_todos =
  #     state
  #     |> Map.put(
  #       :todos,
  #       todos
  #     )

  #   new_todos
  # end
end
