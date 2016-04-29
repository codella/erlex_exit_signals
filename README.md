# Erlang Exit Signals Tests in Elixir
When I started looking into the Elixir API to create a supervision tree, I ended up having so many questions about how exit signals impact processes, and how this affects the linked processes.

Then, I stumbled upon [Understanding Exit Signals in Erlang/Elixir](http://crypt.codemancers.com/posts/2016-01-24-understanding-exit-signals-in-erlang-slash-elixir/), published by Emil Soman on February 29th, 2016.

After reading this nicely made article, I've certainly got a better understanding of the exit signals mechanism, and wether they should be handled, whenever possible.

Nonetheless, I felt the need of writing some code to observe how processes react to signals, at hand. Also, I started to wonder how processes linked to other receiving signals react - so I decided to write down some tests myself, to implements those scenarios.

Of course, when it boils down to talk about exit signals, what we are really talking about are Erlang signals, but the tests have an Elixir twist.

I wrote the tests using Elixir, using ExUnit as test framework.

## What happens to a not-trapping process linked to a process...
### ...  receiving `:normal` signal?

```
[P (lives)] ⇆ [L]
 ⇧
Process.exit(P, :normal)
```
