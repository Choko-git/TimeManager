defmodule Backend.VacationsTest do
  use Backend.DataCase

  alias Backend.Vacations

  describe "vacations" do
    alias Backend.Vacations.Vacation

    @valid_attrs %{accepted: true, end: ~N[2010-04-17 14:00:00], seen: true, start: ~N[2010-04-17 14:00:00]}
    @update_attrs %{accepted: false, end: ~N[2011-05-18 15:01:01], seen: false, start: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{accepted: nil, end: nil, seen: nil, start: nil}

    def vacation_fixture(attrs \\ %{}) do
      {:ok, vacation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vacations.create_vacation()

      vacation
    end

    test "list_vacations/0 returns all vacations" do
      vacation = vacation_fixture()
      assert Vacations.list_vacations() == [vacation]
    end

    test "get_vacation!/1 returns the vacation with given id" do
      vacation = vacation_fixture()
      assert Vacations.get_vacation!(vacation.id) == vacation
    end

    test "create_vacation/1 with valid data creates a vacation" do
      assert {:ok, %Vacation{} = vacation} = Vacations.create_vacation(@valid_attrs)
      assert vacation.accepted == true
      assert vacation.end == ~N[2010-04-17 14:00:00]
      assert vacation.seen == true
      assert vacation.start == ~N[2010-04-17 14:00:00]
    end

    test "create_vacation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vacations.create_vacation(@invalid_attrs)
    end

    test "update_vacation/2 with valid data updates the vacation" do
      vacation = vacation_fixture()
      assert {:ok, %Vacation{} = vacation} = Vacations.update_vacation(vacation, @update_attrs)
      assert vacation.accepted == false
      assert vacation.end == ~N[2011-05-18 15:01:01]
      assert vacation.seen == false
      assert vacation.start == ~N[2011-05-18 15:01:01]
    end

    test "update_vacation/2 with invalid data returns error changeset" do
      vacation = vacation_fixture()
      assert {:error, %Ecto.Changeset{}} = Vacations.update_vacation(vacation, @invalid_attrs)
      assert vacation == Vacations.get_vacation!(vacation.id)
    end

    test "delete_vacation/1 deletes the vacation" do
      vacation = vacation_fixture()
      assert {:ok, %Vacation{}} = Vacations.delete_vacation(vacation)
      assert_raise Ecto.NoResultsError, fn -> Vacations.get_vacation!(vacation.id) end
    end

    test "change_vacation/1 returns a vacation changeset" do
      vacation = vacation_fixture()
      assert %Ecto.Changeset{} = Vacations.change_vacation(vacation)
    end
  end
end
