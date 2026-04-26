defmodule Mix.Corex.Install.Endpoint do
  @moduledoc false

  def patch_endpoint_dev_plugs(igniter, web_mod, mcp?) do
    if mcp? == false do
      igniter
    else
      mod = Module.concat(web_mod, Endpoint)
      path = Igniter.Project.Module.proper_location(igniter, mod)

      Igniter.update_file(igniter, path, fn source ->
        content = source.content
        patched = Mix.Corex.Install.EndpointDevPlugs.apply(content, mcp: mcp?)

        if patched == content and mcp? and not String.contains?(content, "plug Corex.MCP") do
          {:warning,
           "Could not insert `plug Corex.MCP` in #{inspect(mod)}. Add this near the dev-only plugs:\n\nif Mix.env() == :dev do\n  plug Corex.MCP\nend\n"}
        else
          %{source | content: patched}
        end
      end)
    end
  end
end
