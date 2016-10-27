defmodule PeselxTest do
  use ExUnit.Case
  doctest Peselx

  test "Use random pesel 04231115629" do
    assert Peselx.validate("04231115629") == {:ok, "Valid"}
  end

  test "Use random pesel 04282702810 CD 0" do
    assert Peselx.validate("04282702810") == {:ok, "Valid"}
  end

  test "Use random pesel with wrong CD 04231115628" do
    assert Peselx.validate("04231115628") == {:error, "Wrong checksum"}
  end

  test "Use random pesel with wrong CD 04231115620" do
    assert Peselx.validate("04231115628") == {:error, "Wrong checksum"}
  end

end
