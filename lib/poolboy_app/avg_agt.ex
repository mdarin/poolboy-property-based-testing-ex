defmodule PoolboyApp.AvgAgt do
	use Agent

	@doc false
	@spec start_link(integer) :: {:ok, pid} | {:error, term}
	def start_link(initial_value) when is_integer(initial_value) do
		Agent.start_link(fn () -> initial_value end,  name: __MODULE__) end


	@doc false
	@spec value :: integer 
	def value do
		# Agent.update pid, fn state -> state + 1 end
		Agent.get(__MODULE__, & &1)
	end

	@doc false
	@spec increment :: :ok
	def increment do
		# Agent.update pid, fn state -> state + 1 end
		Agent.update(__MODULE__, &(&1 + 1))
	end


	#@spec update(agent(), module(), atom(), [term()], timeout()) :: :ok
	def upd(value) do
		Agent.update(__MODULE__, __MODULE__, :new_state, [value])
		#Agent.update(__MODULE__, fn _state -> value end)
	end


	def new_state(_state, value) do
		value		
	end


end # eof module

