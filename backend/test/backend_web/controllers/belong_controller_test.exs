defmodule BackendWeb.BelongControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Belongs
  alias Backend.Belongs.Belong

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:belong) do
    {:ok, belong} = Belongs.create_belong(@create_attrs)
    belong
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all belongs", %{conn: conn} do
      conn = get(conn, Routes.belong_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create belong" do
    test "renders belong when data is valid", %{conn: conn} do
      conn = post(conn, Routes.belong_path(conn, :create), belong: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.belong_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.belong_path(conn, :create), belong: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update belong" do
    setup [:create_belong]

    test "renders belong when data is valid", %{conn: conn, belong: %Belong{id: id} = belong} do
      conn = put(conn, Routes.belong_path(conn, :update, belong), belong: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.belong_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, belong: belong} do
      conn = put(conn, Routes.belong_path(conn, :update, belong), belong: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete belong" do
    setup [:create_belong]

    test "deletes chosen belong", %{conn: conn, belong: belong} do
      conn = delete(conn, Routes.belong_path(conn, :delete, belong))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.belong_path(conn, :show, belong))
      end
    end
  end

  defp create_belong(_) do
    belong = fixture(:belong)
    %{belong: belong}
  end
end
