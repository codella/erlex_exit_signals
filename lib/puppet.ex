defmodule Puppet do
  def start(options) do
    {:ok, trap_exit} = Keyword.fetch(options, :trap_exit)
    puppet = spawn(Puppet.Listener, :run, [trap_exit, self])

    receive do
      {:started, ^puppet} -> puppet
    end
  end

  def link(puppet, pid) do
    send(puppet, {:link, self, pid})

    receive do
      {:linked, ^puppet} -> puppet
    end
  end

  def latest_unhandled_message(puppet) do
    send(puppet, {:fetch_latest_unhandled_message, self})

    receive do
      {:fetched, ^puppet, latest_unhandled_message} -> latest_unhandled_message
    end
  end

  def self_exit(puppet, signal) do
    send(puppet, {:self_exit, signal})
  end

  def raise(puppet, message) do
    send(puppet, {:raise, message})
  end

  def terminate(puppet) do
    send(puppet, :terminate)
  end

  def alive?(puppet) do
    send(puppet, {:ping, self})

    receive do
      {:pong, ^puppet} -> nil
    after
      5 -> nil
    end

    Process.alive?(puppet)
  end

  #
  # Puppet process related logic
  #
  defmodule Listener do
    def run(trap_exit, spawner) do
      Process.flag(:trap_exit, trap_exit)
      send(spawner, {:started, self})
      listen(%{spawner: spawner, latest_unhandled_message: nil})
    end

    defp listen(state) do
      receive do
        # COMMAND: requests a :pong message to be sent back
        {:ping, sender} ->
          send(sender, {:pong, self})
          listen(state)

        # COMMAND: requests the process to establish a link
        #   with another process
        {:link, sender, pid} ->
          Process.link(pid)
          send sender, {:linked, self}
          listen(state)

        # COMMAND: request the last unhandled received message
        {:fetch_latest_unhandled_message, sender} ->
          send sender, {:fetched, self, state.latest_unhandled_message}
          listen(state)

        # COMMAND: requests a signal to be sent to self
        {:self_exit, signal} ->
          Process.exit(self, signal)
          listen(state)

        # COMMAND: requests an exception to be raised
        {:raise, message} ->
          raise message

        # COMMAND: requests a normal termination
        :terminate ->
          nil

        # stores the last unhandled message
        message ->
          listen(%{state | latest_unhandled_message: message})
      end
    end
  end
end
