# Testing Erlang Exit Signals with Elixir
When I started wondering how to create a supervision tree using Elixir, I ended up having so many questions about exit signals, and how they impact processes.

Then, I stumbled upon [Understanding Exit Signals in Erlang/Elixir](http://crypt.codemancers.com/posts/2016-01-24-understanding-exit-signals-in-erlang-slash-elixir/), published by Emil Soman on February 29th, 2016.

Since I tend to dive into some code to verify what I read, I wrote some tests using Elixir (ExUnit) to closely observe how processes react to exit signals.

Also, I started to wonder how a process linked to another one would react in different termination scenario, and I ended up writing some more tests to investigate further.

This repository is basically containing those tests, that are implemented making extensive use of the `Puppet` module.

The `Puppet` module has been created to ease writing tests around spawning processes, linking them, killing them and questioning wether those processes are still alive or not.

Hope you'll enjoy it!
