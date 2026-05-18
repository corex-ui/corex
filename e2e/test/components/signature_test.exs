defmodule E2eWeb.SignatureTest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  import Wallaby.Query

  alias E2eWeb.ComponentBehaviorSpec
  alias E2eWeb.SignatureModel, as: Signature

  @moduletag :signature

  setup do
    Localize.put_locale(:en)
    :ok
  end

  describe "anatomy" do
    feature "minimal  -  stroke adds segment", %{session: session} do
      host = "signature-anatomy-minimal"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature, :anatomy)
        |> Signature.wait_section_signature_ready("signature-anatomy-minimal")
        |> Signature.draw_stroke_in_host(host)
        |> Signature.wait_has_segment_in_host(host, timeout: 8_000)

      assert_has(
        session,
        css(~s|##{host} [data-scope="signature-pad"][data-part="segment"]|, visible: :any)
      )
    end

    feature "with label  -  clear removes stroke", %{session: session} do
      host = "signature-anatomy-labeled"

      session
      |> ComponentBehaviorSpec.visit_ready(Signature, :signature, :anatomy)
      |> Signature.wait_section_signature_ready("signature-anatomy-with-label")
      |> Signature.draw_stroke_in_host(host)
      |> Signature.wait_has_segment_in_host(host, timeout: 8_000)
      |> Signature.click_clear_trigger_in_host(host)
      |> Signature.refute_segment_in_host(host)
    end
  end

  describe "api" do
    feature "client binding  -  Clear removes stroke", %{session: session} do
      host = "signature-api-cb"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature, :api)
        |> Signature.wait_host_signature_ready(host)
        |> Signature.draw_stroke_in_host(host)
        |> Signature.wait_has_segment_in_host(host, timeout: 8_000)

      session
      |> Signature.click_in_section("signature-api-clear-client-binding", "Clear")
      |> Signature.refute_segment_in_host(host)
    end

    feature "server  -  Clear removes stroke", %{session: session} do
      host = "signature-api-srv"

      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature, :api)
        |> Signature.prepare_live_form()
        |> Signature.wait_host_signature_ready(host)
        |> Signature.draw_stroke_in_host(host)
        |> Signature.wait_has_segment_in_host(host, timeout: 8_000)

      session
      |> Signature.click_in_section("signature-api-clear-server", "Clear (server)")
      |> Signature.refute_segment_in_host(host)
    end
  end

  describe "events" do
    feature "server  -  draw end appends log row", %{session: session} do
      session =
        session
        |> ComponentBehaviorSpec.visit_ready(Signature, :signature, :events)
        |> Signature.prepare_live_form()
        |> Signature.wait_host_signature_ready("signature-events-server")

      session
      |> Signature.draw_stroke_in_host("signature-events-server")
      |> Signature.wait_for_has(
        css("#signature-events-log-server tr[data-part='row']"),
        timeout: 12_000
      )

      assert Signature.signature_events_server_log_has_row?(session)
    end
  end
end
