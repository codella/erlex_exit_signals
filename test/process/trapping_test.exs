defmodule Process.Trapping do
  use ExUnit.Case, async: true

  setup do
    {:ok, process: Puppet.start(trap_exit: true)}
  end

  test "lives when receives :normal signal by self", %{process: process} do
    Puppet.self_exit(process, :normal)

    assert Puppet.alive?(process)
  end

  test "lives when receives :normal signal", %{process: process} do
    Process.exit(process, :normal)

    assert Puppet.alive?(process)
  end

  test "lives when receives :exception signal", %{process: process} do
    Process.exit(process, :exception)

    assert Puppet.alive?(process)
  end

  test "dies when receives :kill signal", %{process: process} do
    Process.exit(process, :kill)

    refute Puppet.alive?(process)
  end
end
