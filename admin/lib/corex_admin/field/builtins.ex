defmodule CorexAdmin.Field.Id do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Text do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Textarea do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Email do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Url do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Password do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Number do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Boolean do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Select do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Date do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.Datetime do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end

defmodule CorexAdmin.Field.EmbedsMany do
  @moduledoc false
  @behaviour CorexAdmin.Field
  def input(assigns), do: CorexAdmin.Field.Renderer.input(assigns)
  def display(assigns), do: CorexAdmin.Field.Renderer.display(assigns)
  def export(field, record), do: CorexAdmin.Field.export_value(field, record)
end
