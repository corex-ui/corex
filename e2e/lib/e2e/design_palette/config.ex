defmodule E2e.DesignPalette.Config do
  @moduledoc false

  @theme_order ~w(neo uno duo leo)

  def defaults do
    %{
      "seeds" => %{
        "accent" => "#4B4B4B",
        "alert" => "#A43C3C",
        "base" => "#F0F0F0",
        "brand" => "#32479C",
        "info" => "#1F77D4",
        "success" => "#059669"
      },
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
        "duo-dark" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6.5},
            "alert" => %{"color" => "alert", "ratio" => 6.5},
            "brand" => %{"color" => "brand", "ratio" => 6.5},
            "default" => %{"color" => "base", "ratio" => 12.5},
            "info" => %{"color" => "info", "ratio" => 6.5},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 6.5}
          },
          "output" => "tokens/themes/duo/color/dark.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 32
            },
            "alert" => %{
              "bg" => "alert",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 32
            },
            "brand" => %{
              "bg" => "brand",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 32
            },
            "info" => %{
              "bg" => "info",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 36
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 9},
              "lightness" => 24
            },
            "success" => %{
              "bg" => "success",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 34
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 10},
            "root" => %{"color" => "base", "lightness" => 6},
            "ui" => %{"color" => "base", "lightness" => 17, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.62},
            "shadow" => %{"color" => "base", "ratio" => 1.26}
          }
        },
        "duo-light" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6},
            "alert" => %{"color" => "alert", "ratio" => 6},
            "brand" => %{"color" => "brand", "ratio" => 6},
            "default" => %{"color" => "base", "ratio" => 8.5},
            "info" => %{"color" => "info", "ratio" => 6},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 6}
          },
          "output" => "tokens/themes/duo/color/light.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 36
            },
            "alert" => %{
              "bg" => "alert",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 36
            },
            "brand" => %{
              "bg" => "brand",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 36
            },
            "info" => %{
              "bg" => "info",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 40
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 84
            },
            "success" => %{
              "bg" => "success",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 38
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 97},
            "root" => %{"color" => "brand", "lightness" => 99},
            "ui" => %{"color" => "base", "lightness" => 88, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.34},
            "shadow" => %{"color" => "base", "ratio" => 1.05}
          }
        },
        "leo-dark" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6},
            "alert" => %{"color" => "alert", "ratio" => 6},
            "brand" => %{"color" => "brand", "ratio" => 6},
            "default" => %{"color" => "base", "ratio" => 12.25},
            "info" => %{"color" => "info", "ratio" => 6},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 6}
          },
          "output" => "tokens/themes/leo/color/dark.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 30
            },
            "alert" => %{
              "bg" => "alert",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 30
            },
            "brand" => %{
              "bg" => "brand",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 30
            },
            "info" => %{
              "bg" => "info",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 34
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 9},
              "lightness" => 20
            },
            "success" => %{
              "bg" => "success",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 32
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 9},
            "root" => %{"color" => "base", "lightness" => 5},
            "ui" => %{"color" => "base", "lightness" => 14, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.65},
            "shadow" => %{"color" => "base", "ratio" => 1.28}
          }
        },
        "leo-light" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6},
            "alert" => %{"color" => "alert", "ratio" => 6},
            "brand" => %{"color" => "brand", "ratio" => 6},
            "default" => %{"color" => "base", "ratio" => 9.25},
            "info" => %{"color" => "info", "ratio" => 6},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 6}
          },
          "output" => "tokens/themes/leo/color/light.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 34
            },
            "alert" => %{
              "bg" => "alert",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 34
            },
            "brand" => %{
              "bg" => "brand",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 34
            },
            "info" => %{
              "bg" => "info",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 38
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 82
            },
            "success" => %{
              "bg" => "success",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 36
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 94},
            "root" => %{"color" => "base", "lightness" => 99},
            "ui" => %{"color" => "base", "lightness" => 83, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.38},
            "shadow" => %{"color" => "base", "ratio" => 1.09}
          }
        },
        "neo-dark" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 7},
            "alert" => %{"color" => "alert", "ratio" => 7},
            "brand" => %{"color" => "brand", "ratio" => 7},
            "default" => %{"color" => "base", "ratio" => 12},
            "info" => %{"color" => "info", "ratio" => 7},
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
        },
        "neo-light" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6},
            "alert" => %{"color" => "alert", "ratio" => 6},
            "brand" => %{"color" => "brand", "ratio" => 6},
            "default" => %{"color" => "base", "ratio" => 8},
            "info" => %{"color" => "info", "ratio" => 6},
            "muted" => %{"color" => "base", "ratio" => 5},
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
        },
        "uno-dark" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 6.5},
            "alert" => %{"color" => "alert", "ratio" => 6.5},
            "brand" => %{"color" => "brand", "ratio" => 6.5},
            "default" => %{"color" => "base", "ratio" => 12.5},
            "info" => %{"color" => "info", "ratio" => 6.5},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 6.5}
          },
          "output" => "tokens/themes/uno/color/dark.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 34
            },
            "alert" => %{
              "bg" => "alert",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 34
            },
            "brand" => %{
              "bg" => "brand",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 34
            },
            "info" => %{
              "bg" => "info",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 38
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 9},
              "lightness" => 22
            },
            "success" => %{
              "bg" => "success",
              "ink" => %{"color" => "base", "ratio" => 8},
              "lightness" => 36
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 9},
            "root" => %{"color" => "base", "lightness" => 6},
            "ui" => %{"color" => "base", "lightness" => 14, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.58},
            "shadow" => %{"color" => "base", "ratio" => 1.24}
          }
        },
        "uno-light" => %{
          "ink" => %{
            "accent" => %{"color" => "accent", "ratio" => 7},
            "alert" => %{"color" => "alert", "ratio" => 7},
            "brand" => %{"color" => "brand", "ratio" => 7},
            "default" => %{"color" => "base", "ratio" => 9.5},
            "info" => %{"color" => "info", "ratio" => 7},
            "muted" => %{"color" => "base", "ratio" => 5},
            "success" => %{"color" => "success", "ratio" => 7}
          },
          "output" => "tokens/themes/uno/color/light.json",
          "semantic" => %{
            "accent" => %{
              "bg" => "accent",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 75
            },
            "alert" => %{
              "bg" => "base",
              "ink" => %{"color" => "alert", "ratio" => 7},
              "lightness" => 90
            },
            "brand" => %{
              "bg" => "base",
              "ink" => %{"color" => "brand", "ratio" => 7},
              "lightness" => 90
            },
            "info" => %{
              "bg" => "base",
              "ink" => %{"color" => "info", "ratio" => 7},
              "lightness" => 90
            },
            "selected" => %{
              "bg" => "base",
              "ink" => %{"color" => "base", "ratio" => 7},
              "lightness" => 84
            },
            "success" => %{
              "bg" => "base",
              "ink" => %{"color" => "success", "ratio" => 7},
              "lightness" => 90
            }
          },
          "surface" => %{
            "layer" => %{"color" => "base", "lightness" => 99},
            "root" => %{"color" => "base", "lightness" => 99},
            "ui" => %{"color" => "base", "lightness" => 93, "states" => true}
          },
          "utility" => %{
            "border" => %{"color" => "base", "ratio" => 1.32},
            "shadow" => %{"color" => "base", "ratio" => 1.12}
          }
        }
      },
      "ui_ratio_base" => %{"default" => -1.12, "hover" => -1.08, "muted" => -1.2}
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
