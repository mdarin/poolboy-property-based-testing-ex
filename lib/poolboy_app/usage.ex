defmodule PoolboyApp.Usage do
	use Task
	use Agent

	@moduledoc false
	
	
	#	If no worker is available in the pool, Poolboy will timeout after the default timeout period
	# (five seconds) and won’t accept any new requests. In our example, we’ve increased the default
	# 	timeout to one minute in order to demonstrate how we can change the default timeout value.
	# 	In case of this app, you can observe the error if you change the value of @timeout to less than 1000.
	@timeout 60000


	##
	## API
	#

	@doc """
		load by default up to 20 requests
	"""
	@spec start :: :ok
	def start do
		0..20
		|> Enum.map(fn i -> async_call_square_root(i) end)
		|> Enum.reduce([], fn task,acc -> [await_and_inspect(task)|acc] end)
	end


	@doc """
		load is a list of integer values that will be passed to worker for further handling 
	"""
	@spec start(arg) :: arg when arg: list
	def start(load) when is_list(load) do
		IO.puts "----------------------------------" 
		IO.puts "::load -> #{ inspect load }" 
		IO.puts "::len -> #{ inspect length(load) }"
		IO.puts "----------------------------------" 
		#queue = :queue.from_list(load)	
		#IO.puts "::queue -> #{ inspect queue }"
		#IO.puts "::queue.out -> #{ inspect :queue.out(queue) }"
		timeout = length(load) * 1000
		
		load	
		|> Enum.map(fn i -> async_call_square_root(i, timeout) end)
		|> Enum.reduce( [], fn task,acc -> [await_and_inspect(task)|acc] end)

	end


	##
	## internals
	#


	defp async_call_square_root(i, timeout \\ @timeout) do
		Task.async(fn ->
			:poolboy.transaction(
				:worker,
				fn pid -> GenServer.call(pid, {:square_root2, i}) end,
				timeout
			)
		end)
	end

	defp await_and_inspect(task) do
		 task 
			|> Task.await(@timeout) 
			|> (fn 
					res -> 
						IO.puts "::await.result #{ inspect res }"
						res 
				end).()
	end

end # eof module
