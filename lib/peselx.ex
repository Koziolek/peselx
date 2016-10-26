defmodule Peselx do
    @moduledoc """
    Provides function validate/1 to check PESEL number.
    """

    import Enum, except: [to_list: 1]
    import Tuple, only: [to_list: 1]
    import String, only: [split: 3, to_integer: 1]
    import List, except: [to_integer: 1]

    @weigths [1,3,7,9,1,3,7,9,1,3]

    @doc """
       Validate PESEL number.

       ## Parameters
        - pesel: String represents PESEL number

       ## Examples

            iex> Peselx.validate("04231115629")
            {:ok, "Valid"}

            iex> Peselx.validate("04231115628")
            {:error, "Wrong checksum"}
    """
    @spec validate(String.t) :: {atom, String.t}
    def validate(pesel) when is_binary(pesel) do
      pesel_digits = pesel |> split("", trim: true) |> map(&(to_integer &1))
      sum_of_digits = [pesel_digits, @weigths] |> zip |> map(&r_t_m/1) |> sum

      verify_cd(cal_cd(sum_of_digits), last(pesel_digits))
    end

    defp cal_cd(s)do
      10 - rem(s, 10)
    end

    #
    # if sum mod 10 gives 0 then md will be 10 and we need to normalize it to 0.
    #
    defp verify_cd(md, cd) when (md == 10 and cd == 0) or (md == cd) do
      {:ok, "Valid"}
    end

    defp verify_cd(md, cd) when md != cd do
      {:error, "Wrong checksum"}
    end

    defp r_t(tuple, f) when is_tuple(tuple) do
        tuple |> to_list |> reduce(f)
    end

    defp r_t_m(tuple) when is_tuple(tuple) do
       r_t(tuple, &Kernel.*/2)
    end

end
