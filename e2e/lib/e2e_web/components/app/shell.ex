defmodule E2eWeb.App.Shell do
  @moduledoc false

  def body,
    do:
      "typo flex flex-col min-h-dvh min-w-0 bg-root text-ink antialiased overflow-x-hidden scrollbar scrollbar--sm [scrollbar-gutter:stable]"

  def header,
    do: "sticky top-0 z-10 h-size-lg bg-layer border-b border-border flex items-center"

  def header_content,
    do:
      "mx-auto w-full flex flex-wrap items-center justify-between gap-space px-space-xl py-space-lg min-h-size-lg"

  def footer, do: "bg-layer border-t border-border flex items-center min-h-size-lg"

  def footer_content,
    do:
      "mx-auto w-full flex flex-wrap items-center justify-between gap-space px-space-xl py-space-lg min-h-size-lg"

  def wrapper, do: "flex flex-1 min-h-0 w-full min-w-0 bg-root relative mx-auto"

  def side,
    do:
      "sticky top-size-lg self-start hidden lg:flex flex-col w-full max-w-2xs h-[calc(100dvh-var(--spacing-size-lg))] bg-layer border-r border-border scrollbar scrollbar--sm overflow-y-auto py-size gap-size [scrollbar-gutter:stable]"

  def main, do: "flex flex-1 flex-col min-w-0 min-h-0 w-full relative mx-auto"

  def content,
    do: "mx-auto flex w-full max-w-6xl flex-1 flex-col items-center gap-size px-space-xl py-size"

  def article,
    do:
      "mx-auto flex w-full min-w-0 max-w-6xl flex-col items-center gap-size-lg text-ink rounded-md"

  def content_marketing,
    do: "mx-auto w-full max-w-7xl px-space-xl py-size"

  def content_blog,
    do: "mx-auto w-full max-w-none px-space-xl py-size"

  def row, do: "flex flex-wrap items-center gap-space"

  def section,
    do: "my-size-lg flex min-w-md flex-col items-start justify-center gap-space-xl"

  def stack, do: "flex flex-col gap-space"

  def aside_tree, do: "tree-view navigation max-w-xs aside-nav-tree"
end
