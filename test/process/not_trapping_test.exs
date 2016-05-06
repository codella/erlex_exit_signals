defmodule Process.NotTrapping do
  use ExUnit.Case, async: true

  setup do
    {:ok, process: Puppet.start(trap_exit: false)}
  end

  test "lives when receives :normal signal", %{process: process} do
    Process.exit(process, :normal)

    assert Puppet.alive?(process)
  end

  test "dies when receives :exception signal", %{process: process} do
    Process.exit(process, :exception)

    refute Puppet.alive?(process)
  end

  test "dies when receives :kill signal", %{process: process} do
    Process.exit(process, :kill)

    refute Puppet.alive?(process)
  end
end
