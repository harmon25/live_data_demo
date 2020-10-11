defmodule LiveData.Reducer do
  @type action :: atom()
  @type payload :: map()
  @type action_arg :: {action, payload}
  @type state :: any()

  @callback action(action :: action_arg(), state :: state()) :: state()
  @callback default_state() :: state()
  @callback default_state(existing_state :: state()) :: state()

  @optional_callbacks default_state: 1

  defmacro __using__(_opts) do
    quote do
      defmodule AgentStore do
        @parent __MODULE__
                |> to_string
                |> String.split(".")
                |> Enum.drop(-1)
                |> Enum.join(".")
                |> String.to_atom()

        use Agent

        def start_link() do
          Agent.start_link(fn -> @parent.default_state() end)
        end

        def start_link(nil) do
          Agent.start_link(fn -> @parent.default_state() end)
        end

        def start_link(initial_value) do
          Agent.start_link(fn -> @parent.default_state(initial_value) end)
        end

        def value(pid) do
          Agent.get(pid, & &1)
        end

        def reduce(pid, action) do
          Agent.update(pid, fn state ->
            @parent.action(action, state)
          end)
        end
      end
    end
  end
end
