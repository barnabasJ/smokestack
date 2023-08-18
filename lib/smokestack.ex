defmodule Smokestack do
  alias Spark.{Dsl, Dsl.Extension}

  @moduledoc """

  <!--- ash-hq-hide-start --> <!--- -->

  ## DSL Documentation

  ### Index

  #{Extension.doc_index(Smokestack.Dsl.sections())}

  ### Docs

  #{Extension.doc(Smokestack.Dsl.sections())}

  <!--- ash-hq-hide-stop --> <!--- -->
  """

  use Dsl, default_extensions: [extensions: [Smokestack.Dsl]]
  alias Ash.Resource
  alias Smokestack.Builder

  @type t :: module

  @doc """
  Runs a factory and uses it to build a map or list of results.

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.params/5` for more information.
  """
  @callback params(Resource.t(), map, atom, Builder.param_options()) ::
              {:ok, Builder.param_result()} | {:error, any}

  @doc """
  Raising version of `params/4`.

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.params/5` for more information.
  """
  @callback params!(Resource.t(), map, atom, Builder.param_options()) ::
              Builder.param_result() | no_return

  @doc """
  Runs a factory and uses it to insert an Ash Resource into it's data layer. 

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.insert/5` for more information.
  """
  @callback insert(Resource.t(), map, atom, Builder.insert_options()) ::
              {:ok, Resource.record()} | {:error, any}

  @doc """
  Raising version of `insert/4`.

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.insert/5` for more information.
  """
  @callback insert!(Resource.t(), map, atom, Builder.insert_options()) ::
              Resource.record() | no_return

  @doc """
  Runs a factory a number of times and returns a list of created records.

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.insert_many/5` for more information.
  """
  @callback insert_many(Resource.t(), pos_integer, atom, Builder.insert_options()) ::
              {:ok, [Resource.record()]} | {:error, any}

  @doc """
  Raising version of `insert_many/4`.

  Automatically implemented by modules which `use Smokestack`.

  See `Smokestack.Builder.insert_many/5` for more information.
  """
  @callback insert_many!(Resource.t(), pos_integer, atom, Builder.insert_options()) ::
              [Resource.record()] | no_return

  @doc false
  defmacro __using__(opts) do
    [
      quote do
        @behaviour Smokestack

        @doc """
        Execute the matching factory and return a map or list of params.

        See `Smokestack.Builder.params/5` for more information.
        """
        @spec params(Resource.t(), map, atom, Builder.param_options()) ::
                {:ok, Builder.param_result()} | {:error, any}
        def params(resource, overrides \\ %{}, variant \\ :default, options \\ []),
          do: Builder.params(__MODULE__, resource, overrides, variant, options)

        @doc """
        Raising version of `params/4`.

        See `Smokestack.Builder.params/5` for more information.
        """
        @spec params!(Resource.t(), map, atom, Builder.param_options()) ::
                Builder.param_result() | no_return
        def params!(resource, overrides \\ %{}, variant \\ :default, options \\ []),
          do: Builder.params!(__MODULE__, resource, overrides, variant, options)

        @doc """
        Execute the matching factory and return an inserted Ash Resource record.

        See `Smokestack.Builder.insert/5` for more information.
        """
        @spec insert(Resource.t(), map, atom, Builder.insert_options()) ::
                {:ok, Resource.record()} | {:error, any}
        def insert(resource, overrides \\ %{}, variant \\ :default, options \\ []),
          do: Builder.insert(__MODULE__, resource, overrides, variant, options)

        @doc """
        Raising version of `insert/4`.

        See `Smokestack.Builder.insert/5` for more information.
        """
        @spec insert!(Resource.t(), map, atom, Builder.insert_options()) ::
                Resource.record() | no_return
        def insert!(resource, overrides \\ %{}, variant \\ :default, options \\ []),
          do: Builder.insert!(__MODULE__, resource, overrides, variant, options)

        @doc """
        Execute the matching factory a number of times and return a list of Ash Resource records.

        See `Smokestack.Builder.insert_many/5` for more information.
        """
        @spec insert_many(Resource.t(), pos_integer, atom, Builder.insert_options()) ::
                {:ok, [Resource.record()]} | {:error, any}
        def insert_many(resource, count, variant \\ :default, options \\ []),
          do: Builder.insert_many(__MODULE__, resource, count, variant, options)

        @doc """
        Raising version of `insert_many/4`.

        See `Smokestack.Builder.insert_many/5` for more information.
        """
        @spec insert_many!(Resource.t(), pos_integer, atom, Builder.insert_options()) ::
                [Resource.record()] | no_return
        def insert_many!(resource, count, variant \\ :default, options \\ []),
          do: Builder.insert_many!(__MODULE__, resource, count, variant, options)

        defoverridable params: 4,
                       params!: 4,
                       insert: 4,
                       insert!: 4,
                       insert_many: 4,
                       insert_many!: 4
      end
    ] ++ super(opts)
  end
end
