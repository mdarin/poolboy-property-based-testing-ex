defmodule PoolboyApp.Worker do
	use GenServer

	@moduledoc false
	
	@spec start_link(any) :: {:ok,pid} | {:error,term}
	def start_link(_) do
		GenServer.start_link(__MODULE__, nil, [])
	end

	@spec init(any) :: {:ok, any}
	def init(_) do
		{:ok, nil}
	end

	def handle_call({:square_root, x}, _from, state) do
		IO.puts "progress #{ inspect(self()) } calculating square root of #{x}"
		# make immitation of a hung up or a long time processing
		processing_time = 1000 #Enum.random 1000..5000 #10000
		IO.puts "::processing time -> #{ processing_time }"
		:timer.sleep(processing_time)
		{:reply, :math.sqrt(x), state}
	end

	def handle_call(request, _from, state) do
		IO.puts "unhandled request #{ inspect request }"
		{:noreply, state}
	end

end # eof module
