defmodule Puppet do
  def start(options) do
    {:ok, trap_exit} = Keyword.fetch(options, :trap_exit)
    puppet = spawn(Puppet.Listener, :run, [trap_exit, self()])

    receive do
      {:started, ^puppet} -> puppet
    end
  end

  def link(puppet, pid) do
    send(puppet, {:link, self(), pid})

    receive do
      {:linked, ^puppet} -> puppet
    end
  end

  def latest_unhandled_message(puppet) do
    send(puppet, {:fetch_latest_unhandled_message, self()})

    receive do
      {:fetched, ^puppet, message} -> message
    end
  end

  def self_process_exit(puppet, signal) do
    send(puppet, {:self_process_exit, signal})
  end

  def kernel_exit(puppet, signal) do
    send(puppet, {:kernel_exit, signal})
  end

  def raise(puppet, message) do
    send(puppet, {:raise, message})
  end

  def terminate(puppet) do
    send(puppet, :terminate)
  end

  def alive?(puppet) do
    send(puppet, {:ping, self()})

    receive do
      {:pong, ^puppet} -> nil
    after
      10 -> nil
    end

    Process.alive?(puppet)
  end
end
