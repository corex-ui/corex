defmodule E2eWeb.App.Shell do
  @moduledoc false

  def body,
    do:
      "typo flex flex-col min-h-dvh min-w-0 bg-root text-ink antialiased overflow-x-hidden scrollbar scrollbar--sm [scrollbar-gutter:stable]"

  def header,
    do: "sticky top-0 z-20 h-size-lg flex items-center border-b border-border bg-surface"

  def header_content,
    do:
      "mx-auto w-full max-w-9xl flex items-center justify-between gap-space-lg px-space-xl h-size-lg"

  def footer, do: "bg-surface border-t border-border flex items-center min-h-size-lg"

  def footer_content,
    do:
      "mx-auto w-full max-w-9xl flex flex-col gap-space-xl px-space-xl pt-space-xl pb-space min-h-size-lg"

  def wrapper, do: "flex flex-1 min-h-0 w-full min-w-0 bg-root relative mx-auto"

  def side,
    do:
      "sticky top-0 self-start hidden lg:flex flex-col w-full max-w-2xs h-dvh border-r border-border scrollbar scrollbar--sm overflow-y-auto py-size gap-size [scrollbar-gutter:stable]"

  def main, do: "flex flex-1 flex-col min-w-0 w-full relative mx-auto"

  def docs_body, do: "flex flex-1 flex-col min-h-dvh w-full pb-size-xl"

  def content,
    do: "mx-auto flex w-full max-w-6xl flex-1 flex-col items-center gap-size px-space-xl py-size"

  def admin_content,
    do: "mx-auto flex w-full min-w-0 flex-1 flex-col gap-size px-space-xl py-size"

  def article,
    do:
      "mx-auto flex w-full min-w-0 max-w-6xl flex-col items-center gap-size-lg text-ink rounded-md"

  def content_marketing, do: "w-full px-space-xl pb-size-xl"

  def content_blog,
    do: "mx-auto w-full max-w-none px-space-xl py-size pb-size-xl"

  def row, do: "flex items-center gap-space"

  def section,
    do: "my-size-lg flex min-w-md flex-col items-start justify-center gap-space-xl"

  def stack, do: "flex flex-col gap-space"

  def aside_tree, do: "tree-view navigation max-w-xs aside-nav-tree"
end
