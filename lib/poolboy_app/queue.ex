defmodule PoolboyApp.Queue do
	use GenServer

	@moduledoc false
	

	##
	## API
	#

	@spec start_link(any) :: {:ok,pid} | {:error,term}
	def start_link(_) do
		GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
	end

	@spec enqueue_a(GenServer.from, any) :: :ok 
	def enqueue_a({pid,_tag} = from, value) when is_pid(pid) do
		GenServer.cast(__MODULE__, {{:encueue, from}, value})
	end

	@spec dequeue_a(GenServer.from) :: any
	def dequeue_a({pid,_tag} = from) when is_pid(pid) do
		GenServer.cast(__MODULE__, {:dequeue, from})
	end

	def dequeue do
		GenServer.call(__MODULE__, :dequeue)
	end

	##
	## callbacks
	#


	@impl true
	@spec init(any) :: {:ok, any}
	def init(_) do
		{:ok, :queue.new}
	end

	def handle_call(:dequeue, _from, state) do
		case :queue.out(state) do
			{{:value, value},new_state} -> {:reply, value, new_state}
			{:empty,state} -> {:reply, :empty, state}
			_ -> {:reply, :error, state}
		end
	end

	@impl true
	def handle_call(request, _from, state) do
		IO.puts "unhandled CALL request #{ inspect request }"
		{:noreply, state}
	end


	@impl true
	def handle_cast({:enqueue, value}, state) do
		new_state = :queue.in(value, state)
		{:noreply, new_state}
	end

	@impl true
	def handle_cast({:dequeue, from}, state) do
		case :queue.out(state) do
			{{:value, value},new_state} ->
				GenServer.reply(from, value)
				{:noreply, new_state}
			{:empty,state} ->
				GenServer.reply(from, :empty)
				{:noreply, state}
			_ ->
				GenServer.reply(from, :error)
				{:noreply, state}
		end
	end

	@impl true
	def handle_cast(request, state) do
		IO.puts "unhandled CAST request #{ inspect request }"
		{:noreply, state}
	end

end # eof module

