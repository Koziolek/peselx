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

  test "Use random pesel with wrong length 4231115620" do
    assert Peselx.validate("4231115628") == {:error, "Wrong length"}
  end

  test "Use random pesel with wrong length 004231115620" do
    assert Peselx.validate("004231115628") == {:error, "Wrong length"}
  end

  test "Should extract date from PESEL for XIX century" do
    assert Peselx.DateUtils.to_date([0, 4, 8, 3, 1, 1, 1, 5, 6, 2, 8])  == {:ok, ~D[1804-03-11]}
  end

  test "Should extract date from PESEL for XX century" do
      assert Peselx.DateUtils.to_date([0, 4, 0, 3, 1, 1, 1, 5, 6, 2, 8])  == {:ok, ~D[1904-03-11]}
  end

  test "Should extract date from PESEL for XXI century" do
      assert Peselx.DateUtils.to_date([0, 4, 2, 3, 1, 1, 1, 5, 6, 2, 8])  == {:ok, ~D[2004-03-11]}
  end

  test "Should extract date from PESEL for XXII century" do
      assert Peselx.DateUtils.to_date([0, 4, 4, 3, 1, 1, 1, 5, 6, 2, 8])  == {:ok, ~D[2104-03-11]}
  end

  test "Should extract date from PESEL for XXIII century" do
      assert Peselx.DateUtils.to_date([0, 4, 6, 3, 1, 1, 1, 5, 6, 2, 8])  == {:ok, ~D[2204-03-11]}
  end

end
