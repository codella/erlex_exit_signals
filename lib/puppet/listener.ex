defmodule Puppet.Listener do
  def run(trap_exit, spawner) do
    Process.flag(:trap_exit, trap_exit)
    send(spawner, {:started, self()})
    listen(%{spawner: spawner, latest_unhandled_message: nil})
  end

  defp listen(state) do
    receive do
      # COMMAND: requests a :pong message to be sent back
      {:ping, sender} ->
        send(sender, {:pong, self()})
        listen(state)
      # COMMAND: requests the process to establish a link with another process
      {:link, sender, pid} ->
        Process.link(pid)
        send sender, {:linked, self()}
        listen(state)
      # COMMAND: request the last unhandled received message
      {:fetch_latest_unhandled_message, sender} ->
        send sender, {:fetched, self(), state.latest_unhandled_message}
        listen(state)
      # COMMAND: requests a signal to be sent to self() via Process.exit/2
      {:self_process_exit, signal} ->
        Process.exit(self(), signal)
        listen(state)
      # COMMAND: requests a signal to be sent to self() via Kernel.exit/1
      {:kernel_exit, signal} ->
        exit(signal)
        listen(state)
      # COMMAND: requests an exception to be raised
      {:raise, message} ->
        raise message
      # COMMAND: requests a normal termination
      :terminate ->
        nil
      # stores the latest unhandled message
      message ->
        listen(%{state | latest_unhandled_message: message})
    end
  end
end
