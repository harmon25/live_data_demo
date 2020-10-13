defmodule ObservableGenServer do
  defmacro __using__(opts) do
    quote do
      defmodule Server do
        use GenServer

        def start_link(n) do
          GenServer.start_link(__MODULE__, n)
        end

        def init(arg) do
          parent_module =
            __MODULE__
            |> to_string
            |> String.split(".")
            |> Enum.drop(-1)
            |> Enum.join(".")
            |> String.to_atom()

          {:ok, initial_state} = parent_module.init(arg)
          {:ok, %{state: initial_state, parent: parent_module}}
        end

        def handle_call(:read_state, from, state) do
          {:reply, state.state, state}
        end

        def handle_call(msg, from, state) do
          case state.parent.handle_call(msg, from, state.state) do
            {:reply, reply, new_state} ->
              case state.parent.handle_changed(new_state, state.state) do
                {:noreply, nstate} -> {:reply, nstate, %{state | state: nstate}}
                {:stop, reason, new_state} -> {:stop, reason, reply, %{state | state: new_state}}
              end

            other ->
              raise "Bad return from handle_call"
          end
        end

        def handle_cast(msg, state) do
          state.parent.handle_cast(msg, state.state)
          |> handle_result({:handle_cast, 2, nil}, state)
        end

        def handle_info(msg, state) do
          state.parent.handle_info(msg, state.state)
          |> handle_result({:handle_info, 2, nil}, state)
        end

        defp handle_result({:noreply, new_state}, {_from, _arity, ref}, state) do
          {:noreply, new_state} = state.parent.handle_changed(new_state, state.state)
          {:noreply, %{state | state: new_state}}
        end
      end

      def start_link(args) do
        __MODULE__.Server.start_link(args)
      end
    end
  end
end
