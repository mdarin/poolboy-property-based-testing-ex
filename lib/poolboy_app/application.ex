defmodule PoolboyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: PoolboyApp.Worker.start_link(arg)
      # {PoolboyApp.Worker, arg}
			:poolboy.child_spec(:worker, poolboy_config()),
			PoolboyApp.Queue # The same as {PoolboyApp.Queue, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoolboyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

	defp poolboy_config do
		[{:name, {:local, :worker}},
		 {:worker_module, PoolboyApp.Worker},
     {:size, 5},
		 {:max_overflow,2}]
	end

end # eof module

