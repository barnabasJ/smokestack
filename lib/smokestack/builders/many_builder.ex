defmodule Smokestack.ManyBuilder do
  @moduledoc """
  Handles repeatedly building.
  """

  alias Smokestack.{Builder, Dsl.Factory, RelatedBuilder}
  alias Spark.OptionsHelpers
  @behaviour Builder

  @type option :: count_option | RelatedBuilder.option()

  @typedoc """
  How many times should we call the builder?
  """
  @type count_option :: {:count, pos_integer()}

  @type result :: [RelatedBuilder.result()]
  @type error :: RelatedBuilder.error() | Exception.t()

  @doc """
  Run the factory a number of times.
  """
  @impl true
  @spec build(Factory.t(), [option]) :: {:ok, result} | {:error, error}
  def build(factory, options) do
    {how_many, options} = Keyword.pop(options, :count, 1)

    do_build(factory, how_many, options)
  end

  @doc false
  @impl true
  @spec option_schema(Factory.t()) :: {:ok, OptionsHelpers.schema()} | {:error, error}
  def option_schema(factory) do
    with {:ok, schema} <- RelatedBuilder.option_schema(factory) do
      {:ok, Keyword.put(schema, :count, type: :pos_integer, required: true)}
    end
  end

  defp do_build(factory, how_many, options) when how_many > 0 and is_integer(how_many) do
    1..how_many
    |> Enum.reduce_while({:ok, []}, fn _, {:ok, results} ->
      case Builder.build(RelatedBuilder, factory, options) do
        {:ok, attrs} -> {:cont, {:ok, [attrs | results]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp do_build(_factory, how_many, _options) do
    {:error,
     ArgumentError.exception(
       message: "Invalid `count` option: `#{inspect(how_many)}`:  Must be a positive integer."
     )}
  end
end
