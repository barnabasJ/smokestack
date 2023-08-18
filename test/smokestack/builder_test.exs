defmodule Smokestack.BuilderTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Smokestack.Builder
  alias Support.{Factory, Post}

  describe "params/2..5" do
    test "it builds params" do
      assert {:ok, params} = Builder.params(Factory, Post)
      assert params |> Map.keys() |> Enum.sort() == ~w[body sub_title tags title]a
      assert is_binary(params.body)
      assert Enum.all?(params.tags, &is_binary/1)
      assert is_binary(params.title)
    end

    test "it honours the `as: :list` option" do
      assert {:ok, params} = Builder.params(Factory, Post, %{}, :default, as: :list)
      assert is_list(params)
      assert is_binary(params[:body])
      assert Enum.all?(params[:tags], &is_binary/1)
      assert is_binary(params[:title])
    end

    test "it honours the `keys: :string` option" do
      assert {:ok, params} = Builder.params(Factory, Post, %{}, :default, keys: :string)
      assert is_binary(params["body"])
      assert Enum.all?(params["tags"], &is_binary/1)
      assert is_binary(params["title"])
    end

    test "it honours the `keys: :dasherise` option" do
      assert {:ok, params} = Builder.params(Factory, Post, %{}, :default, keys: :dasherise)
      assert is_binary(params["sub-title"])
    end
  end

  describe "insert/2..5" do
    test "it inserts the resource" do
      assert {:ok, record} = Builder.insert(Factory, Post)
      assert is_struct(record, Post)
      assert record.inserted_at
      assert is_binary(record.title)
      assert is_binary(record.sub_title)
      assert Enum.all?(record.tags, &is_struct(&1, Ash.CiString))
    end
  end

  describe "insert_many/3..5" do
    assert {:ok, records} = Builder.insert_many(Factory, Post, 3)
    assert length(records) == 3
    assert Enum.all?(records, &is_struct(&1, Post))
  end
end
