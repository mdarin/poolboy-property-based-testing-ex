defmodule PoolboyApp.UsageProper do
  use ExUnit.Case
  use PropCheck
	use Task
	
	# units


	@doc """
		Simple use case example
	"""
#	test "exactly 21 reqeusts ok" do
#		result = Task.async(fn -> PoolboyApp.Usage.start end) |> Task.await()
#		IO.puts "::test.result -> #{ inspect result }"
#		IO.puts "::len #{inspect length result }"
#		IO.puts "::len == 21 -> #{ inspect (length result) == 21 }"
#		assert (length result) == 21
#	end

#  test "run several task simultaniously" do
#		complete = 
#			1..2
#			 |> Enum.map(fn _ -> Task.async(fn -> PoolboyApp.Usage.start end) end)
#			 |> Enum.reduce([], fn task,acc  -> [Task.await(task)|acc] end)
#		IO.puts "::complete -> #{ inspect complete }"
#		assert true == true 
#  end


	test "queue server test" do
		IO.puts "::async deq -> #{ inspect PoolboyApp.Queue.dequeue_a({self(), :test}) }"
		IO.puts "::sync deq	-> #{ inspect PoolboyApp.Queue.dequeue }"	
		assert true == true 
	end



#	test "TDD test case ok" do
#		result = Task.async(fn -> 1..12 |> Enum.to_list |> PoolboyApp.Usage.start end) |> Task.await()
#		IO.puts "::test.result -> #{ inspect result }"
#		assert true == true 
#	end


  # property

#  property "always works" do
#    forall type <- term() do
#      boolean(type)
#    end
#  end

	

	# per test by setting "@tag timeout: x" (accepts :infinity)
	@tag timeout: :infinity
	property "huge loading immitation", [:verbose] do
		forall load
			#<- list(pos_integer()) # this test pass well

			# the ?SIZED(VarName, Expression) macro, which
			# introduces the variable VarName into the scope of Expression , bound to the
			# internal size value for the current execution. This size value changes with
			# every test, so what we do with the macro is change its scale, rather than
			# replacing it wholesale.
			<- sized(sz, resize(sz * Enum.random(1..100), list(pos_integer())))
		do
			res = PoolboyApp.Usage.start load
			aggregate(true, result: {res, :erlang.length(load)})
		end
	end


  # helpers

  def boolean(_) do
    true
  end

	@doc """
		The to_range/2 function places a value M into a given bucket of size N .
	"""
	def to_range(m, n) do
		base = div(n, m)
		{base * m, (base + 1) * m}
	end


  # generators

  # oneof([ListOfGenerators]) will randomly pick one of the generators whithin the
  # list passed to it
  #def (), do: oneof([range(1,100), integer()])

  # models
  #TODO:

end # oef mudule

