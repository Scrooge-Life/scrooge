defmodule ScroogeWeb.BudgetLive.Index do
  use ScroogeWeb, :live_view

  alias Scrooge.Accounts
  alias Scrooge.Accounts.Budget

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :accounts_budgets, list_accounts_budgets(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Budget")
    |> assign(:budget, Accounts.get_budget!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Budget")
    |> assign(:budget, %Budget{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Accounts budgets")
    |> assign(:budget, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    budget = Accounts.get_budget!(id)
    {:ok, _} = Accounts.delete_budget(budget)

    {:noreply, assign(socket, :accounts_budgets, list_accounts_budgets(socket.assigns.current_user))}
  end

  defp list_accounts_budgets(user) do
    Accounts.list_budgets(user)
  end
end
