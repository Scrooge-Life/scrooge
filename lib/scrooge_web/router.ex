defmodule ScroogeWeb.Router do
  use ScroogeWeb, :router

  import ScroogeWeb.UserAuth

  @csp_rules %{
    "default-src" => ["'none'"],
    "script-src" => ["'self'", "'unsafe-inline'"],
    "style-src" => ["'self'", "'unsafe-inline'"],
    "font-src" => ["'self'", "data:"],
    "img-src" => ["'self'", "data:", "https:"],
    "manifest-src" => ["'self'"],
    "connect-src" => ["'self'"],
    "frame-src" => ["'self'"],
    "object-src" => ["'none'"],
    "base-uri" => ["'none'"]
  }

  @csp_header_string Enum.map_join(@csp_rules, " ", fn {key, rules} ->
                       "#{key} #{Enum.join(rules, " ")};"
                     end)

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScroogeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp_header_string}
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Static pages
  scope "/", ScroogeWeb do
    pipe_through :browser

    get "/", MarketingController, :home
  end

  # API endpoints
  scope "/api/v1", ScroogeWeb do
    pipe_through :api
  end

  # App pages
  scope "/", ScroogeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :budgets, on_mount: [{ScroogeWeb.UserAuth, :ensure_authenticated}] do
      live "/budgets", BudgetLive, :index
      live "/budgets/create", BudgetLive, :new
      live "/budgets/:id", BudgetLive.Index, :edit
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:scrooge, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: Scrooge.Telemetry

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # Authentication routes
  scope "/", ScroogeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ScroogeWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/join", UserRegistrationLive, :new
      live "/sign-in", UserLoginLive, :new
      live "/reset-password", UserForgotPasswordLive, :new
      live "/reset-password/:token", UserResetPasswordLive, :edit
    end

    post "/sign-in", UserSessionController, :create
  end

  scope "/", ScroogeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ScroogeWeb.UserAuth, :ensure_authenticated}] do
      live "/settings", UserSettingsLive, :edit
      live "/settings/confirm-email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", ScroogeWeb do
    pipe_through [:browser]

    delete "/sign-out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ScroogeWeb.UserAuth, :mount_current_user}] do
      live "/settings/confirm-account/:token", UserConfirmationLive, :edit
      live "/settings/confirm-account", UserConfirmationInstructionsLive, :new
    end
  end
end
