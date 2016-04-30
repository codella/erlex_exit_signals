defmodule Linker.Trapping do
  use ExUnit.Case, async: true

  setup do
    process = Puppet.start(trap_exit: false)
    linker = Puppet.start(trap_exit: true) |> Puppet.link(process)

    {:ok, process: process, linker: linker}
  end

  test "lives when process termiantes normally", %{process: process, linker: linker} do
    Puppet.terminate(process)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, :normal}, Puppet.latest_unhandled_message(linker)
  end

  test "lives when process invokes exit(:normal)", %{process: process, linker: linker} do
    Puppet.kernel_exit(process, :normal)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
  end

  test "lives when process invokes exit(:exception)", %{process: process, linker: linker} do
    Puppet.kernel_exit(process, :exception)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
  end

  test "lives when process invokes Process.exit(self, :normal)", %{process: process, linker: linker} do
    Puppet.self_process_exit(process, :normal)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, :normal}, Puppet.latest_unhandled_message(linker)
  end

  test "lives when process invokes Process.exit(self, :exception)", %{process: process, linker: linker} do
    Puppet.self_process_exit(process, :exception)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, :exception}, Puppet.latest_unhandled_message(linker)
  end

  test "lives when process raises an exception", %{process: process, linker: linker} do
    Puppet.raise(process, "exception")

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, _details}, Puppet.latest_unhandled_message(linker)
  end

  test "lives when process receives :exception from another process", %{process: process, linker: linker} do
    Process.exit(process, :exception)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, :exception}, Puppet.latest_unhandled_message(linker)
  end

  test "lives when process receives :kill", %{process: process, linker: linker} do
    Process.exit(process, :kill)

    refute Puppet.alive?(process)
    assert Puppet.alive?(linker)
    assert match? {:EXIT, ^process, :killed}, Puppet.latest_unhandled_message(linker)
  end
end
