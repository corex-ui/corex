# Design

Corex separates **behavior** from **appearance**. Components always expose a styling vocabulary; CSS is optional.

| Guide | Read when you… |
| --- | --- |
| [Unstyled](unstyled.html) | Write your own CSS. Style attrs declare intent; Corex stamps BEM classes you style. |
| [Styled](styled.html) | Use **Corex Design**: compile-time CSS, tokens, and themes. |
| [Design config](design-config.html) | Customize themes, recipes, and `:corex_design` keys. |

**Runtime UX:** [Theming](theming.html) (theme picker) and [Dark mode](dark_mode.html) (light/dark toggle) work with Corex Design on `<html>` via `data-theme` and `data-mode`.

Start with [How styling works](installation.html#how-styling-works) in the installation guide for a short overview.
