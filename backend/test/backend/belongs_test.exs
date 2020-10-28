defmodule Backend.BelongsTest do
  use Backend.DataCase

  alias Backend.Belongs

  describe "belongs" do
    alias Backend.Belongs.Belong

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def belong_fixture(attrs \\ %{}) do
      {:ok, belong} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Belongs.create_belong()

      belong
    end

    test "list_belongs/0 returns all belongs" do
      belong = belong_fixture()
      assert Belongs.list_belongs() == [belong]
    end

    test "get_belong!/1 returns the belong with given id" do
      belong = belong_fixture()
      assert Belongs.get_belong!(belong.id) == belong
    end

    test "create_belong/1 with valid data creates a belong" do
      assert {:ok, %Belong{} = belong} = Belongs.create_belong(@valid_attrs)
    end

    test "create_belong/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Belongs.create_belong(@invalid_attrs)
    end

    test "update_belong/2 with valid data updates the belong" do
      belong = belong_fixture()
      assert {:ok, %Belong{} = belong} = Belongs.update_belong(belong, @update_attrs)
    end

    test "update_belong/2 with invalid data returns error changeset" do
      belong = belong_fixture()
      assert {:error, %Ecto.Changeset{}} = Belongs.update_belong(belong, @invalid_attrs)
      assert belong == Belongs.get_belong!(belong.id)
    end

    test "delete_belong/1 deletes the belong" do
      belong = belong_fixture()
      assert {:ok, %Belong{}} = Belongs.delete_belong(belong)
      assert_raise Ecto.NoResultsError, fn -> Belongs.get_belong!(belong.id) end
    end

    test "change_belong/1 returns a belong changeset" do
      belong = belong_fixture()
      assert %Ecto.Changeset{} = Belongs.change_belong(belong)
    end
  end
end
