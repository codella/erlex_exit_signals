defmodule Process.NotTrapping do
  use ExUnit.Case, async: true

  setup do
    {:ok, process: Puppet.start(trap_exit: false)}
  end

  test "dies when receives :normal signal by self", %{process: process} do
    Puppet.self_exit(process, :normal)

    refute Puppet.alive?(process)
  end

  test "lives when receives :normal signal", %{process: process} do
    Process.exit(process, :normal)

    assert Puppet.alive?(process)
  end

  test "dies receives :exception signal", %{process: process} do
    Process.exit(process, :exception)

    refute Puppet.alive?(process)
  end

  test "dies when receives :kill signal", %{process: process} do
    Process.exit(process, :kill)

    refute Puppet.alive?(process)
  end
end
