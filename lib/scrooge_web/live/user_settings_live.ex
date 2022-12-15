defmodule ScroogeWeb.UserSettingsLive do
  use ScroogeWeb, :live_view

  alias Scrooge.Accounts

  def render(assigns) do
    ~H"""
    <main class="flex-1">
      <div class="relative mx-auto max-w-4xl md:px-8 xl:px-0">
        <div class="pt-10 pb-16">
          <.header class="px-4 md:px-0">
            Account Settings
          </.header>

          <div class="py-6">
            <div class="mt-10 divide-y divide-gray-200">
              <div class="space-y-1">
                <h3 class="text-lg font-medium leading-6 text-gray-900 px-4 md:px-0">
                  Update Email Address
                </h3>
              </div>

              <div class="mt-6">
                <.simple_form
                  :let={f}
                  id="email_form"
                  for={@email_changeset}
                  phx-submit="update_email"
                  phx-change="validate_email"
                >
                  <.error
                    :if={@email_changeset.action == :insert}
                    message="Oops, something went wrong! Please check the errors below."
                  />

                  <.input
                    field={{f, :email}}
                    type="email"
                    label="Email"
                    required
                    value={input_value(f, :email)}
                  />

                  <.input
                    field={{f, :current_password}}
                    name="current_password"
                    id="current_password_for_email"
                    type="password"
                    label="Current password"
                    value={@email_form_current_password}
                    required
                  />
                  <:actions>
                    <.button phx-disable-with="Changing...">Change Email</.button>
                  </:actions>
                </.simple_form>
              </div>
            </div>

            <div class="mt-10 divide-y divide-gray-200">
              <div class="space-y-1">
                <h3 class="text-lg font-medium leading-6 text-gray-900 px-4 md:px-0">
                  Update Password
                </h3>
              </div>

              <div class="mt-6">
                <.simple_form
                  :let={f}
                  id="password_form"
                  for={@password_changeset}
                  action={~p"/sign-in?_action=password_updated"}
                  method="post"
                  phx-change="validate_password"
                  phx-submit="update_password"
                  phx-trigger-action={@trigger_submit}
                >
                  <.error
                    :if={@password_changeset.action == :insert}
                    message="Oops, something went wrong! Please check the errors below."
                  />

                  <.input field={{f, :email}} type="hidden" value={@current_email} />

                  <.input
                    field={{f, :password}}
                    type="password"
                    label="New password"
                    value={input_value(f, :password)}
                    required
                  />
                  <.input
                    field={{f, :password_confirmation}}
                    type="password"
                    label="Confirm new password"
                    value={input_value(f, :password_confirmation)}
                  />
                  <.input
                    field={{f, :current_password}}
                    name="current_password"
                    type="password"
                    label="Current password"
                    id="current_password_for_password"
                    value={@current_password}
                    required
                  />
                  <:actions>
                    <.button phx-disable-with="Changing...">Change Password</.button>
                  </:actions>
                </.simple_form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    email_changeset = Accounts.change_user_email(socket.assigns.current_user, user_params)

    socket =
      assign(socket,
        email_changeset: Map.put(email_changeset, :action, :validate),
        email_form_current_password: password
      )

    {:noreply, socket}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    password_changeset = Accounts.change_user_password(socket.assigns.current_user, user_params)

    {:noreply,
     socket
     |> assign(:password_changeset, Map.put(password_changeset, :action, :validate))
     |> assign(:current_password, password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> assign(:trigger_submit, true)
          |> assign(:password_changeset, Accounts.change_user_password(user, user_params))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_changeset, changeset)}
    end
  end
end
