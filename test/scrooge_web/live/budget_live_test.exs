defmodule ScroogeWeb.BudgetLiveTest do
  use ScroogeWeb.ConnCase

  import Phoenix.LiveViewTest
  import Scrooge.AccountsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_budget(_) do
    budget = budget_fixture()
    %{budget: budget}
  end

  describe "Index" do
    setup [:create_budget]

    test "lists all accounts_budgets", %{conn: conn, budget: budget} do
      {:ok, _index_live, html} = live(conn, ~p"/accounts_budgets")

      assert html =~ "Listing Accounts budgets"
      assert html =~ budget.name
    end

    test "saves new budget", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts_budgets")

      assert index_live |> element("a", "New Budget") |> render_click() =~
               "New Budget"

      assert_patch(index_live, ~p"/accounts_budgets/new")

      assert index_live
             |> form("#budget-form", budget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#budget-form", budget: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/accounts_budgets")

      assert html =~ "Budget created successfully"
      assert html =~ "some name"
    end

    test "updates budget in listing", %{conn: conn, budget: budget} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts_budgets")

      assert index_live |> element("#accounts_budgets-#{budget.id} a", "Edit") |> render_click() =~
               "Edit Budget"

      assert_patch(index_live, ~p"/accounts_budgets/#{budget}/edit")

      assert index_live
             |> form("#budget-form", budget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#budget-form", budget: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/accounts_budgets")

      assert html =~ "Budget updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes budget in listing", %{conn: conn, budget: budget} do
      {:ok, index_live, _html} = live(conn, ~p"/accounts_budgets")

      assert index_live |> element("#accounts_budgets-#{budget.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#budget-#{budget.id}")
    end
  end

  describe "Show" do
    setup [:create_budget]

    test "displays budget", %{conn: conn, budget: budget} do
      {:ok, _show_live, html} = live(conn, ~p"/accounts_budgets/#{budget}")

      assert html =~ "Show Budget"
      assert html =~ budget.name
    end

    test "updates budget within modal", %{conn: conn, budget: budget} do
      {:ok, show_live, _html} = live(conn, ~p"/accounts_budgets/#{budget}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Budget"

      assert_patch(show_live, ~p"/accounts_budgets/#{budget}/show/edit")

      assert show_live
             |> form("#budget-form", budget: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#budget-form", budget: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/accounts_budgets/#{budget}")

      assert html =~ "Budget updated successfully"
      assert html =~ "some updated name"
    end
  end
end
