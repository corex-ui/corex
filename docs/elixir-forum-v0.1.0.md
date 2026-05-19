# Corex v0.1.0 is live

Building corex has been a long and bumpy journey, many versions, even more mistakes, and some precious learning from the community.
Today the **first stable release** of Corex is on Hex.

**Hex:** https://hex.pm/packages/corex  
**Demo:** https://corex.gigalixirapp.com/en  
**GitHub:** https://github.com/corex-ui/corex

## What that means for you

Pin Corex in `mix.exs`:

```elixir
{:corex, "~> 0.1.0"}
```

With `~> 0.1.0`, `mix deps.update` pulls **0.1.x** patches only, not 0.2.0. I will keep patch releases safe to upgrade, and anything you need to know will be in the CHANGELOG.

If the API needs to change in a breaking way, that goes in a new minor (like `0.2.0`). You choose when to bump the constraint.

## A personal note

Building in public the alpha and beta versions were not always easy.
Downloads were very low on Hex, the API was still finding its shape, and I had real doubts where I wondered if I was on the right track.
But I never stopped believing in what Corex could be: the foundation, the philosophy, the idea that it might help someone build something good.


That is why this release matters to me. Now you can pin `~> 0.1.0` and try Corex in a real project. I hope it is easier to adopt, and I would love to see the library grow with your feedback.
 
If you look at the [repository](https://github.com/corex-ui/corex) and like what you see, a GitHub star or a feedback here would mean a lot. 

Feedback, suggestions and questions are always welcome.

Happy coding :folded_hands:
