defmodule E2eWeb.AdminDialogStackingTest do
  use E2eWeb.FeatureCase, async: false

  import E2e.AccountsFixtures
  import Wallaby.Browser

  alias E2eWeb.DataTableModel, as: DataTable
  alias E2eWeb.DialogModel, as: Dialog
  alias E2eWeb.FormHelpers

  setup do
    admin = admin_fixture(%{name: "Delete Target Admin"})
    _other = admin_fixture(%{name: "Other Row Admin"})
    {:ok, admin: admin}
  end

  feature "delete dialog backdrop covers table header and action column", %{
    session: session,
    admin: admin
  } do
    host = "admin-delete-#{admin.id}"

    session
    |> FormHelpers.visit_path("/en/admins")
    |> Dialog.wait_root_dialog_ready(host)
    |> execute_script(
      """
      var table = document.getElementById("admins");
      var trigger = document.querySelector(
        "##{host} [data-scope='dialog'][data-part='trigger']"
      );
      if (trigger) trigger.scrollIntoView({ block: "center", inline: "center" });
      if (table) table.scrollTop = 0;
      return true;
      """,
      [],
      fn _ -> :ok end
    )
    |> Dialog.open_dialog_by_host_id(host)
    |> Dialog.wait_dialog_open_by_host_id(host, timeout: 8_000)
    |> DataTable.assert_open_dialog_covers_table_chrome("admins")
  end
end
