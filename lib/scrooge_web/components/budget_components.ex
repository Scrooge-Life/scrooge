defmodule ScroogeWeb.BudgetComponents do
  @moduledoc """
  Provides some base UI components related to Scrooge.Accounts.Budget.
  """
  use Phoenix.Component

  alias Scrooge.Accounts.Budget

  @doc """
  Returns a very saturated strong tailwind background class for a budget.
  """
  def strong_bg_class(%Budget{color: color}), do: strong_bg_class(color)
  def strong_bg_class(:neutral), do: "bg-neutral-400"
  def strong_bg_class(:red), do: "bg-red-400"
  def strong_bg_class(:orange), do: "bg-orange-400"
  def strong_bg_class(:yellow), do: "bg-yellow-400"
  def strong_bg_class(:green), do: "bg-green-400"
  def strong_bg_class(:teal), do: "bg-teal-400"
  def strong_bg_class(:blue), do: "bg-blue-400"
  def strong_bg_class(:purple), do: "bg-purple-400"
  def strong_bg_class(:pink), do: "bg-pink-400"

  @doc """
  Returns a very saturated strong tailwind text class for a budget.
  """
  def strong_text_class(%Budget{color: color}), do: strong_text_class(color)
  def strong_text_class(:neutral), do: "text-neutral-900"
  def strong_text_class(:red), do: "text-red-900"
  def strong_text_class(:orange), do: "text-orange-900"
  def strong_text_class(:yellow), do: "text-yellow-900"
  def strong_text_class(:green), do: "text-green-900"
  def strong_text_class(:teal), do: "text-teal-900"
  def strong_text_class(:blue), do: "text-blue-900"
  def strong_text_class(:purple), do: "text-purple-900"
  def strong_text_class(:pink), do: "text-pink-900"

  @doc """
  Returns a tailwind text class for a budget.
  """
  def text_class(%Budget{color: color}), do: text_class(color)
  def text_class(:neutral), do: "text-neutral-500"
  def text_class(:red), do: "text-red-500"
  def text_class(:orange), do: "text-orange-500"
  def text_class(:yellow), do: "text-yellow-500"
  def text_class(:green), do: "text-green-500"
  def text_class(:teal), do: "text-teal-500"
  def text_class(:blue), do: "text-blue-500"
  def text_class(:purple), do: "text-purple-500"
  def text_class(:pink), do: "text-pink-500"

  @doc """
  Returns a tailwind ring class for a budget.
  """
  def ring_class(%Budget{color: color}), do: ring_class(color)
  def ring_class(:neutral), do: "ring-neutral-500"
  def ring_class(:red), do: "ring-red-500"
  def ring_class(:orange), do: "ring-orange-500"
  def ring_class(:yellow), do: "ring-yellow-500"
  def ring_class(:green), do: "ring-green-500"
  def ring_class(:teal), do: "ring-teal-500"
  def ring_class(:blue), do: "tringblue-500"
  def ring_class(:purple), do: "ring-purple-500"
  def ring_class(:pink), do: "ring-pink-500"
end
