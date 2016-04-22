defmodule Linker.NotTrapping do
  use ExUnit.Case, async: true

  setup do
    process = Puppet.start(trap_exit: false)
    linker = Puppet.start(trap_exit: false) |> Puppet.link(process)

    {:ok, process: process, linker: linker}
  end

  test "lives when process termiantes normally", %{process: process, linker: linker} do
    Puppet.terminate(process)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
  end

  test "lives when process receives :normal from self", %{process: process, linker: linker} do
    Puppet.self_exit(process, :normal)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
  end

  test "dies when process raises an exception", %{process: process, linker: linker} do
    Puppet.raise(process, "exception")

    refute Puppet.alive?(process)
    refute Puppet.alive?(linker)
  end

  test "dies when process receives :exception from another process", %{process: process, linker: linker} do
    Process.exit(process, :exception)

    refute Puppet.alive?(process)
    refute Puppet.alive?(linker)
  end

  test "dies when process receives :kill", %{process: process, linker: linker} do
    Process.exit(process, :kill)

    refute Puppet.alive?(process)
    refute Puppet.alive?(linker)
  end
end
