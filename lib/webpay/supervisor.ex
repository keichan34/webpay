defmodule Webpay.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(opts) do
    children = [
    ]

    if Webpay.memory_adapter_enabled? do
      children = children ++ [
        worker(Webpay.MemoryServer, [])
      ]
    end

    supervise(children, strategy: :one_for_one)
  end
end
