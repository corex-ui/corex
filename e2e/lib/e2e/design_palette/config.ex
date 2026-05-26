defmodule E2e.DesignPalette.Config do
  @moduledoc false

  @theme_order ~W(neo uno duo leo)

  def defaults do
    nl = neo_light()
    nd = neo_dark()

    %{
      "semantic_ratio_base" => %{
        "active" => 1.0,
        "default" => -1.15,
        "hover" => -1.08,
        "muted" => -1.8
      },
      "state_lightness_offsets" => %{
        "active" => -7,
        "default" => 0,
        "hover" => -4,
        "muted" => 3.5
      },
      "state_order" => ["muted", "default", "hover", "active"],
      "themes" => %{
        "neo-light" => nl,
        "neo-dark" => nd,
        "uno-light" =>
          nl |> merge_overrides(uno_light_overrides()) |> Map.put("seeds", uno_seeds()),
        "uno-dark" =>
          nd |> merge_overrides(uno_dark_overrides()) |> Map.put("seeds", uno_seeds()),
        "duo-light" =>
          nl |> merge_overrides(duo_light_overrides()) |> Map.put("seeds", duo_seeds()),
        "duo-dark" =>
          nd |> merge_overrides(duo_dark_overrides()) |> Map.put("seeds", duo_seeds()),
        "leo-light" =>
          nl |> merge_overrides(leo_light_overrides()) |> Map.put("seeds", leo_seeds()),
        "leo-dark" => nd |> merge_overrides(leo_dark_overrides()) |> Map.put("seeds", leo_seeds())
      },
      "ui_ratio_base" => %{"default" => -1.12, "hover" => -1.08, "muted" => -1.2}
    }
  end

  defp neo_seeds do
    %{
      "accent" => "#4B4B4B",
      "alert" => "#A43C3C",
      "base" => "#F0F0F0",
      "brand" => "#32479C",
      "info" => "#1F77D4",
      "success" => "#059669"
    }
  end

  defp uno_seeds do
    %{
      "accent" => "#475569",
      "alert" => "#B91C1C",
      "base" => "#EEF2F7",
      "brand" => "#0E7490",
      "info" => "#0369A1",
      "success" => "#047857"
    }
  end

  defp duo_seeds do
    %{
      "accent" => "#57534E",
      "alert" => "#9F1239",
      "base" => "#FAF7F2",
      "brand" => "#5B21B6",
      "info" => "#1D4ED8",
      "success" => "#15803D"
    }
  end

  defp leo_seeds do
    %{
      "accent" => "#3F3F46",
      "alert" => "#991B1B",
      "base" => "#F4F4F5",
      "brand" => "#B45309",
      "info" => "#1E40AF",
      "success" => "#166534"
    }
  end

  defp neo_light do
    %{
      "seeds" => neo_seeds(),
      "ink" => %{
        "accent" => %{"color" => "accent", "ratio" => 6},
        "alert" => %{"color" => "alert", "ratio" => 6},
        "brand" => %{"color" => "brand", "ratio" => 6},
        "default" => %{"color" => "base", "ratio" => 8},
        "info" => %{"color" => "info", "ratio" => 6},
        "link" => %{"color" => "info", "ratio" => 6},
        "muted" => %{"color" => "base", "ratio" => 5.15},
        "success" => %{"color" => "success", "ratio" => 6}
      },
      "output" => "tokens/themes/neo/color/light.json",
      "semantic" => %{
        "accent" => %{
          "bg" => "accent",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 40
        },
        "alert" => %{
          "bg" => "alert",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 40
        },
        "brand" => %{
          "bg" => "brand",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 40
        },
        "info" => %{
          "bg" => "info",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 40
        },
        "selected" => %{
          "bg" => "base",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 85
        },
        "success" => %{
          "bg" => "success",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 40
        }
      },
      "surface" => %{
        "layer" => %{"color" => "base", "lightness" => 97},
        "root" => %{"color" => "base", "lightness" => 98},
        "ui" => %{"color" => "base", "lightness" => 94, "states" => true}
      },
      "utility" => %{
        "border" => %{"color" => "base", "ratio" => 1.3},
        "shadow" => %{"color" => "base", "ratio" => 1.05}
      }
    }
  end

  defp neo_dark do
    %{
      "seeds" => neo_seeds(),
      "ink" => %{
        "accent" => %{"color" => "accent", "ratio" => 7},
        "alert" => %{"color" => "alert", "ratio" => 7},
        "brand" => %{"color" => "brand", "ratio" => 7},
        "default" => %{"color" => "base", "ratio" => 12},
        "info" => %{"color" => "info", "ratio" => 7},
        "link" => %{"color" => "info", "ratio" => 7},
        "muted" => %{"color" => "base", "ratio" => 5},
        "success" => %{"color" => "success", "ratio" => 7}
      },
      "output" => "tokens/themes/neo/color/dark.json",
      "semantic" => %{
        "accent" => %{
          "bg" => "accent",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 45
        },
        "alert" => %{
          "bg" => "alert",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 38
        },
        "brand" => %{
          "bg" => "brand",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 38
        },
        "info" => %{
          "bg" => "info",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 38
        },
        "selected" => %{
          "bg" => "base",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 30
        },
        "success" => %{
          "bg" => "success",
          "ink" => %{"color" => "base", "ratio" => 7},
          "lightness" => 38
        }
      },
      "surface" => %{
        "layer" => %{"color" => "base", "lightness" => 15},
        "root" => %{"color" => "base", "lightness" => 8},
        "ui" => %{"color" => "base", "lightness" => 20, "states" => true}
      },
      "utility" => %{
        "border" => %{"color" => "base", "ratio" => 1.4},
        "shadow" => %{"color" => "base", "ratio" => 1.2}
      }
    }
  end

  defp uno_light_overrides do
    %{
      "output" => "tokens/themes/uno/color/light.json",
      "surface" => %{
        "layer" => %{"lightness" => 97},
        "root" => %{"lightness" => 100},
        "ui" => %{"lightness" => 94}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.32},
        "shadow" => %{"ratio" => 1.1}
      },
      "ink" => %{"default" => %{"ratio" => 8.5}},
      "semantic" => %{
        "accent" => %{
          "bg" => "base",
          "lightness" => 89,
          "ink" => %{"color" => "accent", "ratio" => 5.5}
        },
        "alert" => %{
          "bg" => "base",
          "lightness" => 89,
          "ink" => %{"color" => "alert", "ratio" => 5.5}
        },
        "brand" => %{
          "bg" => "base",
          "lightness" => 95,
          "ink" => %{"color" => "brand", "ratio" => 5.5}
        },
        "info" => %{
          "bg" => "base",
          "lightness" => 89,
          "ink" => %{"color" => "info", "ratio" => 5.5}
        },
        "selected" => %{
          "bg" => "base",
          "lightness" => 26,
          "ink" => %{"color" => "accent", "ratio" => 10}
        },
        "success" => %{
          "bg" => "base",
          "lightness" => 89,
          "ink" => %{"color" => "success", "ratio" => 5.5}
        }
      }
    }
  end

  defp uno_dark_overrides do
    %{
      "output" => "tokens/themes/uno/color/dark.json",
      "surface" => %{
        "layer" => %{"lightness" => 14},
        "root" => %{"lightness" => 7},
        "ui" => %{"lightness" => 19}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.42},
        "shadow" => %{"ratio" => 1.22}
      },
      "ink" => %{"default" => %{"ratio" => 12.25}}
    }
  end

  defp duo_light_overrides do
    %{
      "output" => "tokens/themes/duo/color/light.json",
      "surface" => %{
        "layer" => %{"lightness" => 97},
        "root" => %{"lightness" => 99},
        "ui" => %{"lightness" => 92}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.34},
        "shadow" => %{"ratio" => 1.07}
      },
      "ink" => %{"default" => %{"ratio" => 8.25}}
    }
  end

  defp duo_dark_overrides do
    %{
      "output" => "tokens/themes/duo/color/dark.json",
      "surface" => %{
        "layer" => %{"lightness" => 16},
        "root" => %{"lightness" => 10},
        "ui" => %{"lightness" => 21}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.43},
        "shadow" => %{"ratio" => 1.23}
      },
      "ink" => %{"default" => %{"ratio" => 12.1}}
    }
  end

  defp leo_light_overrides do
    %{
      "output" => "tokens/themes/leo/color/light.json",
      "surface" => %{
        "layer" => %{"lightness" => 96},
        "root" => %{"lightness" => 98},
        "ui" => %{"lightness" => 92}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.34},
        "shadow" => %{"ratio" => 1.07}
      },
      "ink" => %{"default" => %{"ratio" => 8.25}}
    }
  end

  defp leo_dark_overrides do
    %{
      "output" => "tokens/themes/leo/color/dark.json",
      "surface" => %{
        "layer" => %{"lightness" => 16},
        "root" => %{"lightness" => 9},
        "ui" => %{"lightness" => 21}
      },
      "utility" => %{
        "border" => %{"ratio" => 1.43},
        "shadow" => %{"ratio" => 1.23}
      },
      "ink" => %{"default" => %{"ratio" => 12.1}}
    }
  end

  def merge_overrides(base, overrides), do: deep_merge(base, overrides)

  defp deep_merge(a, b) do
    Map.merge(a, b, fn _, va, vb ->
      if is_map(va) and is_map(vb), do: deep_merge(va, vb), else: vb
    end)
  end

  def theme_slug(theme_mode_id) do
    case Regex.run(~r/^(.+)-(light|dark)$/, theme_mode_id) do
      [_, slug, _] -> slug
      _ -> theme_mode_id
    end
  end

  def theme_slugs(config) do
    have = for {k, _} <- config["themes"], into: MapSet.new(), do: theme_slug(k)
    Enum.filter(@theme_order, &MapSet.member?(have, &1))
  end
end
