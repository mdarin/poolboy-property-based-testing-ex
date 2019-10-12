defmodule PoolboyApp.Usage do
	use Task

	# response timeout
	@timeout 6000


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
		|> Enum.each(fn task -> await_and_inspect(task) end)
	end


	@doc """
		load is a list of integer values that will be passed to worker for further handling 
	"""
	@spec start(arg) :: :ok when arg: list
	def start(load) when is_list(load) do
		IO.puts "::load -> #{ inspect load }" 
		IO.puts "::len -> #{ inspect length(load) }"
		load	
		|> Enum.map(fn i -> async_call_square_root(i) end)
		|> Enum.each(fn task -> await_and_inspect(task) end)
	end


	##
	## internals
	#

	defp async_call_square_root(i) do
		Task.async(fn ->
			:poolboy.transaction(
				:worker,
				fn pid -> GenServer.call(pid, {:square_root, i}) end,
				@timeout
			)
		end)
	end

	defp await_and_inspect(task) do
		 task 
			|> Task.await(@timeout) 
			|> (fn (res) -> IO.puts "::result #{ inspect res }" end).()
	end

end # eof module
