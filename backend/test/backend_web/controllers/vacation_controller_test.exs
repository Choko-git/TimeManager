defmodule BackendWeb.VacationControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Vacations
  alias Backend.Vacations.Vacation

  @create_attrs %{
    accepted: true,
    end: ~N[2010-04-17 14:00:00],
    seen: true,
    start: ~N[2010-04-17 14:00:00]
  }
  @update_attrs %{
    accepted: false,
    end: ~N[2011-05-18 15:01:01],
    seen: false,
    start: ~N[2011-05-18 15:01:01]
  }
  @invalid_attrs %{accepted: nil, end: nil, seen: nil, start: nil}

  def fixture(:vacation) do
    {:ok, vacation} = Vacations.create_vacation(@create_attrs)
    vacation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all vacations", %{conn: conn} do
      conn = get(conn, Routes.vacation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create vacation" do
    test "renders vacation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.vacation_path(conn, :create), vacation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.vacation_path(conn, :show, id))

      assert %{
               "id" => id,
               "accepted" => true,
               "end" => "2010-04-17T14:00:00",
               "seen" => true,
               "start" => "2010-04-17T14:00:00"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.vacation_path(conn, :create), vacation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update vacation" do
    setup [:create_vacation]

    test "renders vacation when data is valid", %{conn: conn, vacation: %Vacation{id: id} = vacation} do
      conn = put(conn, Routes.vacation_path(conn, :update, vacation), vacation: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.vacation_path(conn, :show, id))

      assert %{
               "id" => id,
               "accepted" => false,
               "end" => "2011-05-18T15:01:01",
               "seen" => false,
               "start" => "2011-05-18T15:01:01"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, vacation: vacation} do
      conn = put(conn, Routes.vacation_path(conn, :update, vacation), vacation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete vacation" do
    setup [:create_vacation]

    test "deletes chosen vacation", %{conn: conn, vacation: vacation} do
      conn = delete(conn, Routes.vacation_path(conn, :delete, vacation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.vacation_path(conn, :show, vacation))
      end
    end
  end

  defp create_vacation(_) do
    vacation = fixture(:vacation)
    %{vacation: vacation}
  end
end
