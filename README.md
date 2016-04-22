# Erlang Exit Signals Tests in Elixir
When I started looking into the Elixir API to create a supervision tree, I ended up having so many questions about how exit signals impact processes, and how this affects the linked processes.

Then, I stumbled upon [Understanding Exit Signals in Erlang/Elixir](http://crypt.codemancers.com/posts/2016-01-24-understanding-exit-signals-in-erlang-slash-elixir/), published by Emil Soman on February 29th, 2016.

## What happens to a not-trapping process linked to a process...
### ...  receiving `:normal` signal?

```
[P (lives)] ⇆ [L]
 ⇧
Process.exit(P, :normal)
```
