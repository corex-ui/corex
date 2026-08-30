defmodule Corex.NativeAccordion.Ids do
  @moduledoc false

  # Match Zag accordion DOM id scheme from Corex.Accordion.Connect so Design CSS
  # and mental models stay aligned.

  @spec root_id(String.t()) :: String.t()
  def root_id(id), do: "accordion:#{id}"

  @spec item_id(String.t(), String.t()) :: String.t()
  def item_id(id, value), do: "accordion:#{id}:item:#{value}"

  @spec content_id(String.t(), String.t()) :: String.t()
  def content_id(id, value), do: "accordion:#{id}:content:#{value}"

  @spec trigger_id(String.t(), String.t()) :: String.t()
  def trigger_id(id, value), do: "accordion:#{id}:trigger:#{value}"

  @spec indicator_id(String.t(), String.t()) :: String.t()
  def indicator_id(id, value), do: "accordion:#{id}:indicator:#{value}"

  @spec region_label_id(String.t(), String.t()) :: String.t()
  def region_label_id(id, value), do: "accordion:#{id}:region-label:#{value}"
end
