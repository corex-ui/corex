---
title: "Anatomy of a Corex Component"
description: "Most component libraries decide for you how much markup is yours. Anatomy is what happens when a library lets you change your mind, page by page."
date: "2026-05-21 12:00:00 +0000"
permalink: /en/blog/anatomy-of-a-corex-component/
tags:
  - Corex
  - Phoenix
  - Anatomy
sitemap:
  priority: 0.9
  changefreq: monthly
---

There is a question every UI library answers in private, usually without telling you: *how much of the markup belongs to me*?

When somebody ships a UI library, they decide, on your behalf, where the boundary lives between *behavior* and *appearance*. Behavior is the part you cannot see: arrow keys, focus rings that move at the right time, the ARIA attributes that screen readers actually read, the small state machine that decides when an item counts as open. Appearance is everything else.

Some libraries glue those two together. The component owns both the keystrokes and the chevron. You get a beautiful accordion out of the box, with reasonable defaults, and that is the whole story until you want a different chevron. Then you read the source. Then you fork. Then you write a CSS override that probably works.

Other libraries split them apart. Behavior in one headless package. Appearance in your own code, or in a styling layer somebody bolted on later. You can put any chevron you want. You can also write a hundred lines of HTML and ARIA before anything appears on the screen. Both approaches are honest. Both also make a choice on your behalf about how much of the markup is yours, and that choice is hard to undo later. The first time a design changes, you find out which one you actually bought.

I built Corex because I wanted that choice to stay open. Not *swap libraries* open. *Edit this one file* open. That is what *anatomy* means in this library, and it is the only word I want to define before we go any further.

## A third option, on purpose

Every Corex interactive component is, internally, already two things. There is a small state machine, written once, that knows how the component should behave. And there is a set of named parts, marked up with `data-scope` and `data-part` attributes, that the machine attaches itself to. The machine does not look at the surrounding HTML. It does not care about your wrappers, your classes, your extra paragraphs. It only needs its parts to exist, with the right names.

That separation is the whole reason for this post. It gives the author of the page, which is to say you, room to negotiate. You can let Corex emit the markup for you, the way most libraries do, and never look at the HTML it generates. Or you can author the markup yourself, by hand, and the same machine still finds its parts and runs the same behavior on top.

I picked the word *anatomy* on purpose. Anatomy is what something is made of, not what it does. The behavior of an accordion is the same no matter how much HEEx you decided to write yourself today. The anatomy is the form around that behavior, and it is yours to shape.

## Where the idea comes from

Anatomy is not something I invented for Phoenix. It comes from the static, vanilla version of Corex that lives at [corex-ui.com](https://corex-ui.com/). On the vanilla side there is no Phoenix component to call. You write the HTML by hand. Every `data-scope`, every `data-part`, every wrapper, every label, every attribute the machine looks for. Then you wire the JavaScript hook, and the machine takes over.

That setup works, and it is the foundation everything else stands on. It is also unforgiving. Miss one of those attributes and the accordion does not open. Misspell a value and focus jumps somewhere unrelated. The library cannot help you, because all it sees is the HTML you wrote.

Phoenix Corex is the same model wrapped in a component layer. The defaults emit a correct skeleton for you. You always get the right scopes, the right parts, the right attributes, even on a page where you have not configured anything. The ladder I am about to describe is a way to opt out of those defaults, one piece at a time, while never losing the guarantee that the markup the machine needs is still there underneath.

You can think of vanilla Corex as full responsibility from the first line: every piece of markup is yours. Phoenix Corex starts with the markup already written for you, correctly, and lets you take it back, one piece at a time.

## The ladder, in plain English

Anatomy tends to take five recognisable forms. They line up in a ladder. I do not think of them as features. I think of them as honest admissions about the screen I am building, in the order I usually arrive at them.

At the lightest end, you trust the component to make every decision for you. You hand it a list of titles and bodies and walk away. The component renders the triggers, the panels, the indicators, the whole shape. This is the rung I reach for first, every single time. It looks like a single function call in a template, because it is.

```heex
<.accordion id="faq" items={@topics} />
```

When the design starts asking for a small repeated detail that the default does not include, you keep the list and ask the component to delegate one piece of the markup back to you. The component still owns the structure; you contribute the same little fragment to every row. It is the smallest possible escalation, and most of the time it is enough.

```heex
<.accordion id="faq" items={@topics}>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

When the repeated detail becomes per-row, you keep the list and start authoring the slot yourself, with access to the row's data. The spine of the layout is still the list. The decoration is yours.

```heex
<.accordion id="faq" items={@topics}>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
</.accordion>
```

When the items stop feeling like a list at all, you stop using one. You declare a fixed set of panels by hand, label them with shared values, and the component stitches the triggers and the bodies together. This is the level I reach when I can count the rows on one hand and each panel is its own small world, with its own image, its own paragraph, its own call to action.

```heex
<.accordion id="faq" value="shipping">
  <:trigger value="shipping">Shipping</:trigger>
  <:content value="shipping">
    <p>We ship within <strong>3 business days</strong>.</p>
  </:content>
</.accordion>
```

When even that is too rigid, when the design needs you to wrap things, interleave things, slip an entire marketing block between two items, you take the gloves off and compose the component out of its own sub-components. Same machine, your markup, from the outermost wrapper inward.

```heex
<.accordion :let={ctx} compound id="faq">
  <.accordion_root ctx={ctx}>
    <.accordion_item value="shipping">
      <.accordion_trigger>Shipping</.accordion_trigger>
      <.accordion_content>
        <p>We ship within 3 business days.</p>
      </.accordion_content>
    </.accordion_item>
  </.accordion_root>
</.accordion>
```

I want to be honest about the price. Each step up the ladder is more HEEx in your file, and more responsibility for the markup. I do not climb for fun. I climb when the alternative is fighting the abstraction, and I stop climbing the moment a level matches the design.

## What does not change

The thing I find most freeing, and the reason I keep building this way, is that none of these decisions are runtime decisions.

The user never sees the level you picked. Arrow keys move focus the same way. Tab order is the same. The right item is announced to a screen reader at the right moment. The accordion is the accordion. The work the machine does is invisible from the outside and identical from the inside.

That means picking a level is purely a conversation between you and your future self. It is not a conversation about the product. It is a conversation about how much HEEx you want to maintain in this file, on this screen, for this design that the designer might change again next sprint.

The conversation gets easier the more you have it. After a few months I stopped asking which level was *correct* and started asking which level was *honest* about the screen in front of me. Almost always, the honest answer is the smallest one. Sometimes it isn't, and that is fine too. The library doesn't punish you for either choice.

## When the ladder is not the right metaphor

Anatomy is about first-render shape. It describes the HTML that exists on the page before anyone clicks anything. It is not the answer to every question a component will eventually face.

If the server has to be the source of truth, because you are validating, syncing across tabs, or showing different state to different users, you reach for controlled mode. That is a separate conversation, about who owns the state, and I wrote about it in [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/). If the option list is too large to ship to the client, you reach for a server-fed combobox, which has its own [post](/en/blog/nine-thousand-airports-one-hundred-rows/). If the design system has to look consistent across thirty components and three themes, you reach for tokens, and that lives [here](/en/blog/paint-the-parts-the-machine-already-owns/).

Those layers sit on top of anatomy. They do not replace it. You can turn any of them on or off without rewriting the shape of your markup. That is the part of the design I am proudest of, and it is the part that took the longest to get right.

## The relief

If I had to compress this whole post into one sentence, it would be that anatomy is the moment you realise the library is not going to lock you in.

I did not understand how much I needed that until I shipped a Corex page where the designer changed their mind three times in a single week. Each time I moved one or two rungs on the ladder. The hook never noticed. The user never noticed. I noticed, because each rewrite felt like editing a document, not refactoring a system. Nothing broke. No tests turned red because the markup grew an extra wrapper. The accordion opened and closed exactly the same way it had on Monday.

That is what I want from a UI library now. Not a perfect default. Not infinite knobs. The freedom to keep my opinion fresh as the design evolves, without paying for it twice.

If you want to see the forms side by side, the [accordion anatomy demo](/en/accordion/anatomy) is the most direct path. Open it, flip through the levels, look at the rendered HTML at each step. You will see what I mean. Same machine. Different forms. Your call, every time.

---

Next in the series: how the same component keeps its head when the server and the client both think they own its state, in [Two Brains](/en/blog/two-brains-liveview-assigns-and-zag-machines/). Then [the hook itself](/en/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) for the bridge between Phoenix and the machine. Then [tokens, contrast and the look](/en/blog/paint-the-parts-the-machine-already-owns/). Then [the airport problem](/en/blog/nine-thousand-airports-one-hundred-rows/), for when the catalog is too big to ship.
