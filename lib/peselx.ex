defmodule Peselx do
    @moduledoc """
    Provides function validate/1 to check PESEL number.

    Checks:
      - Control digit
      - Length

    Control digit check base on algorithm descibed in
    [this article](https://pl.wikipedia.org/wiki/PESEL).
    """

    import Enum, except: [to_list: 1, zip: 1]
    import Tuple, only: [to_list: 1]
    import String, only: [split: 3, to_integer: 1, length: 1]
    import List, except: [to_integer: 1]
    import Kernel, except: [length: 1]

    alias Peselx.DateUtils, as: DateUtils

    @weigths [1, 3, 7, 9, 1, 3, 7, 9, 1, 3]

    @doc """
       Validate PESEL number.

       ## Parameters
        - pesel: String represents PESEL number.

       ## Examples

            iex> Peselx.validate("04231115629")
            {:ok, "Valid"}

            iex> Peselx.validate("04231115628")
            {:error, "Wrong checksum"}

            iex> Peselx.validate("4231115629")
            {:error, "Wrong length"}

            iex> Peselx.validate("004231115629")
            {:error, "Wrong length"}
    """
    @spec validate(String.t) :: {atom, String.t}
    def validate(pesel) when is_binary(pesel) do
      pesel_digits = pesel
                      |> split("", trim: true)
                      |> map(&(to_integer &1))
      v = [pesel_digits, @weigths]
        |> zip
        |> map(&r_t_m/1)
        |> sum
        |> cal_cd
        |> verify_cd(last(pesel_digits))
        |> verify_length(pesel)
        |> are_we_czech(pesel_digits)
    end

    defp cal_cd(s)do
      10 - rem(s, 10)
    end


#
#     In PESEL algorythm is small bug. If we change order of year and day in date, from `ddmmyy` to `yymmdd` then checksum will be the same. Year and day has same weigths.
#
#     We could try to recognize that situation in some cases. If first two digits are greater than maximum number of days in month then PESEL is invalid.
#
    defp are_we_czech(current, pesel_digits) when elem(current, 0) == :error do
      current
    end

    defp are_we_czech(current, pesel_digits) when elem(current, 0) == :ok do

        case DateUtils.to_date(pesel_digits) do
                  {:error, reason} -> {:error, "Wrong date"}
                  _ -> {:ok, "Valid"}
         end
    end

    defp verify_length(v, pesel) do
      case length(pesel) do
        11 -> v
        _ ->  {:error, "Wrong length"}
      end
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

    # Reduce tuple using function f
    defp r_t(tuple, f) when is_tuple(tuple) do
        tuple |> to_list |> reduce(f)
    end

    # Reduce tuple by multiplying elements
    defp r_t_m(tuple) when is_tuple(tuple) do
       r_t(tuple, &Kernel.*/2)
    end

end

defmodule Peselx.DateUtils do
  @moduledoc """
      Provides function to_date/1 to extract date from PESEL number.
  """

  import Enum, except: [to_list: 1]

  def to_date(pesel) do
        date_elems = pesel
                        |> chunk(2)
                        |> take(3)
                        |> List.to_tuple
        year = to_string_format(calculate_year(date_elems))
        month = to_string_format(calculate_month(date_elems))
        day = to_string_format(calculate_day(date_elems))

        case Date.from_iso8601("#{year}-#{month}-#{day}") do
            {:ok, result} -> result
            {:error, reason} -> {:error, reason}
            _ -> {:error, "Cannot do that"}
        end
  end

  defp calculate_year({_, [f|_], [d|u]}) when f == 0 or f == 1, do: 1900 + 10 * d + to_integer(u)
  defp calculate_year({_, [f|_], [d|u]}) when f == 2 or f == 3, do: 2000 + 10 * d + to_integer(u)
  defp calculate_year({_, [f|_], [d|u]}) when f == 4 or f == 5, do: 2100 + 10 * d + to_integer(u)
  defp calculate_year({_, [f|_], [d|u]}) when f == 6 or f == 7, do: 2200 + 10 * d + to_integer(u)
  defp calculate_year({_, [f|_], [d|u]}) when f == 8 or f == 9, do: 1800 + 10 * d + to_integer(u)

  defp calculate_month({_, [f|l], _}) when f == 0 or f == 1, do: f * 10 - 0 +  to_integer(l)
  defp calculate_month({_, [f|l], _}) when f == 2 or f == 3, do: f * 10 - 20 + to_integer(l)
  defp calculate_month({_, [f|l], _}) when f == 4 or f == 5, do: f * 10 - 40 + to_integer(l)
  defp calculate_month({_, [f|l], _}) when f == 6 or f == 7, do: f * 10 - 60 + to_integer(l)
  defp calculate_month({_, [f|l], _}) when f == 8 or f == 9, do: f * 10 - 80 + to_integer(l)

  defp calculate_day({[f|l], _, _}) do
       last_d_d = to_integer(l)
       f * 10 + last_d_d
  end

  defp to_integer(l) when is_list(l), do: l |> reduce(&Kernel.+/2)

  defp to_string_format(m) when m < 10, do: "0#{m}"

  defp to_string_format(m) when m >= 10, do: "#{m}"

end
