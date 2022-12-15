defmodule ScroogeWeb.BudgetLive do
  use ScroogeWeb, :live_view

  alias Scrooge.Accounts
  alias Scrooge.Accounts.Budget

  alias ScroogeWeb.BudgetComponents

  def render(assigns) do
    ~H"""
    <main class="flex min-h-screen flex-col justify-center">
      <div :if={@live_action == :index}>
        <.header class="text-center px-4">
          Select your budget
          <:subtitle>This stores all of your transactions</:subtitle>
        </.header>

        <ul role="list" class="mx-auto max-w-lg mt-6 divide-y divide-gray-200 border-t border-b border-gray-200">
          <li :for={budget <- @budgets}>
            <.link
              class={"flex items-center h-16 flex-shrink-0 px-4 border-b border-gray-200 text-neutral-900 gap-2 group"}
              href="#"
            >
              <div class={"h-8 w-8 rounded #{BudgetComponents.strong_bg_class(budget)} #{BudgetComponents.strong_text_class(budget)} grid justify-center items-center font-bold"}>
                <span><%= budget.symbol %></span>
              </div>
              <span class="font-semibold flex-grow">
                <%= budget.name %>
              </span>
              <div class="flex-shrink-0 self-center">
                <Heroicons.chevron_right class="h-5 w-5 text-gray-400 group-hover:text-gray-500" />
              </div>
            </.link>
          </li>
        </ul>
      </div>

      <div :if={@live_action in [:new, :edit]}>
        <.header class="text-center px-4">
          Create a Budget
          <:subtitle>This will store all of your transactions</:subtitle>
        </.header>

        <.simple_form
          :let={f}
          id="budget_form"
          for={@changeset}
          action={if @live_action == :new, do: ~p"/budgets/create?_action=save", else: ~p"/budgets/#{@changeset.data.id}?_action=save"}
          method="post"
          phx-change="validate"
          phx-submit="save"
        >
          <.error
            :if={@changeset.action == :insert}
            message="Oops, something went wrong! Please check the errors below."
          />

          <.input
            field={{f, :name}}
            type="text"
            label="Name"
            value={input_value(f, :name)}
            required
          />

          <.input
            field={{f, :symbol}}
            type="text"
            label="Symbol"
            value={input_value(f, :symbol)}
            required
          />

          <fieldset>
            <legend class="block text-sm font-semibold leading-6 text-zinc-800">Choose a label color</legend>
            <div class="mt-4 flex flex-wrap items-center gap-3">
              <%= for color <- Budget.colors() do %>
                <label phx-feedback-for={Phoenix.HTML.Form.input_name(f, :color)} class="flex items-center gap-2 text-sm leading-6 text-zinc-800">
                  <input
                    type="radio"
                    id={Phoenix.HTML.Form.input_id(f, :color)}
                    name={Phoenix.HTML.Form.input_name(f, :color)}
                    class={"h-7 w-7 rounded-full border-0 #{BudgetComponents.strong_bg_class(color)} #{BudgetComponents.text_class(color)} focus:#{BudgetComponents.ring_class(color)}"}
                    value={color}
                  />
                  <span class="sr-only"><%= color %></span>
                </label>
              <% end %>
            </div>
            <.error :for={msg <- translate_errors(f.errors || [], :color)} message={msg} />
          </fieldset>

          <:actions>
            <%= if @live_action == :new do %>
              <.button phx-disable-with="Creating...">
                Create budget
              </.button>
            <% else %>
              <.button phx-disable-with="Changing...">
                Update budget
              </.button>
            <% end %>
          </:actions>
        </.simple_form>
      </div>
    </main>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    budgets = Accounts.list_budgets(socket.assigns.current_user)
    {:ok, assign(socket, :budgets, budgets), temporary_assigns: [changeset: nil]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    budget = Accounts.get_budget!(id)
    changeset = Accounts.change_budget(budget)

    socket
    |> assign(:page_title, "Edit Budget")
    |> assign(:budget, budget)
    |> assign(:changeset, changeset)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create a Budget")
    |> assign(:budget, %Budget{})
    |> assign(:changeset, Accounts.change_budget(%Budget{}))
  end

  defp apply_action(socket, :index, _params) do
    if length(socket.assigns.budgets) == 0 do
      redirect(socket, to: ~p"/budgets/create")
    else
      socket
      |> assign(:page_title, "Budgets")
      |> assign(:budget, nil)
      |> assign(:changeset, nil)
    end
  end

  @impl true
  def handle_event("validate", %{"budget" => budget_params}, socket) do
    budget_changeset = Accounts.change_budget(socket.assigns.budget, budget_params)
    {:noreply, assign(socket, :changeset, budget_changeset)}
  end

  def handle_event("save", %{"budget" => budget_params}, socket) do
    apply_save(socket, socket.assigns.live_action, budget_params)
  end

  defp apply_save(socket, :new, budget_params) do
    case Accounts.create_budget(socket.assigns.current_user, budget_params) do
      {:ok, _budget} ->
        {:noreply, redirect(socket, to: ~p"/budgets")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp apply_save(socket, :edit, budget_params) do
    case Accounts.update_budget(socket.assigns.budget, budget_params) do
      {:ok, _budget} ->
        {:noreply, redirect(socket, to: ~p"/budgets")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
