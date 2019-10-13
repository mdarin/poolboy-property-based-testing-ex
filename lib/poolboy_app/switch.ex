defmodule PoolboyApp.Switch do
  use GenStateMachine, callback_mode: :handle_event_function

	@moduledoc """
		repo: https://github.com/ericentin/gen_state_machine
		documentation: https://hexdocs.pm/gen_state_machine/GenStateMachine.html
	"""

  # Callbacks

  def handle_event(:cast, :flip, :off, data) do
    {:next_state, :on, data + 1}
  end

  def handle_event(:cast, :flip, :on, data) do
    {:next_state, :off, data}
  end

  def handle_event({:call, from}, :get_count, state, data) do
    {:next_state, state, data, [{:reply, from, data}]}
  end
end

## Usage example

# Start the server
#{:ok, pid} = GenStateMachine.start_link(PoolboyApp.Switch, {:off, 0})

# This is the client
#GenStateMachine.cast(pid, :flip)
#=> :ok

#GenStateMachine.call(pid, :get_count)
#=> 1
