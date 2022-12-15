defmodule ScroogeWeb.Layouts do
  use ScroogeWeb, :html

  @dev_routes? Application.compile_env(:scrooge, :dev_routes)
  @gravatar_domain "gravatar.com"

  embed_templates "layouts/*"

  def dev_routes?(), do: @dev_routes?

  @doc """
  Shows the app navigation on mobile.
  """
  def show_navigation(js \\ %JS{}) do
    js
    |> JS.remove_class("hidden", to: "#mobile-navigation")
    |> JS.show(
      to: "#mobile-navigation-bg",
      transition: {"transition-opacity ease-linear duration-300", "opacity-0", "opacity-100"},
      time: 300
    )
    |> JS.show(
      display: "flex",
      to: "#mobile-navigation-container",
      transition:
        {"transition-all transform ease-out duration-300", "-translate-x-full", "translate-x-0"},
      time: 300
    )
    |> JS.show(
      to: "#mobile-navigation-close",
      transition: {"transition-opacity ease-linear duration-200", "opacity-0", "opacity-100"},
      time: 200
    )
    |> JS.focus_first(to: "#mobile-navigation")
  end

  def hide_navigation(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#mobile-navigation-bg",
      transition: {"transition-opacity ease-linear duration-300", "opacity-100", "opacity-0"},
      time: 300
    )
    |> JS.hide(
      to: "#mobile-navigation-container",
      transition:
        {"transition-all transform ease-out duration-300", "translate-x-0", "-translate-x-full"},
      time: 300
    )
    |> JS.hide(
      to: "#mobile-navigation-close",
      transition: {"transition-opacity ease-linear duration-200", "opacity-100", "opacity-0"},
      time: 200
    )
    |> JS.add_class("hidden",
      to: "#mobile-navigation",
      transition: {"flex", "flex", "hidden"},
      time: 300
    )
    |> JS.pop_focus()
  end

  @doc """
  Returns a friendly human name for a user based on their set name field,
  or their email field as a fallback.
  """
  def friendly_name(user) do
    if is_nil(user.name), do: user.email, else: user.name
  end

  @doc """
  Generates a gravatar url for a user's email address.
  """
  def gravatar(user, opts \\ []) do
    {secure, opts} =
      opts
      |> Keyword.merge(default: :retro, rating: :x)
      |> Keyword.pop(:secure, true)

    %URI{}
    |> gravatar_host(secure)
    |> gravatar_hash_email(user.email)
    |> gravatar_options(opts)
    |> to_string
  end

  defp gravatar_options(uri, []), do: %URI{uri | query: nil}
  defp gravatar_options(uri, opts), do: %URI{uri | query: URI.encode_query(opts)}

  defp gravatar_host(uri, true),
    do: %URI{uri | scheme: "https", host: "secure.#{@gravatar_domain}"}

  defp gravatar_host(uri, false), do: %URI{uri | scheme: "http", host: @gravatar_domain}

  defp gravatar_hash_email(uri, email) do
    hash = :crypto.hash(:md5, String.downcase(email)) |> Base.encode16(case: :lower)
    %URI{uri | path: "/avatar/#{hash}"}
  end
end
