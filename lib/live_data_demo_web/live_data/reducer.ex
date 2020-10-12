defmodule LiveData.Reducer do
  @moduledoc """
  Reducer module

  A reducer is a module that implements action/2 and default_state/1 callbacks.

  action/2 takes an action_arg and state - and returns a new state.

  Can be used on its own, or combined into a RootReducer.

  This module also implements persistence for the state in the form of an agent which is the context in which the action and default_state callbacks are executed.
  """

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
        @parent Module.split(__MODULE__) |> Enum.drop(-1) |> Module.concat()

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
