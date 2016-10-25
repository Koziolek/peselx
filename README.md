# peselx

Elixir parser and validator for PESEL numbers

## PESEL number

[PESEL](https://pl.wikipedia.org/wiki/PESEL) is Polish national ID number. It has specific structure:

 |Birth date|Serial|Sex  |Control digit|
 |----------|------|-----|-------------|
 |440514    |014   |5    |8            |

### Birth date

 Birth date in number has format yymmdd.

 * for years 1800-1899 add 8 to month e.g. january is 81
 * for years 1900-1999 month has 'standard' number e.g. january is 01
 * for years 2000-2099 add 2 to month e.g. january is 21
 * for years 2100-2199 add 6 to month e.g. january is 61

### Sex

 Even for girls odd for boys. Easy :)

### Control digit

 To calculate control digit we need:

 * calculate sum of numbers from position 1 to 10 (date, serial, sex) with weights.
 * calculate modulo 10
 * substract result from 10.

If result is 0 OR 10 if modulo gives 0 then PESEL is valid.

#### Weigths

Weights for calculating CD:

|A  |B  |C  |D  |E  |F  |G  |H  |I  |J  |
|---|---|---|---|---|---|---|---|---|---|
|1  |3  |7  |9  |1  |3  |7  |9  |1  |3  |

## Usage

```elixir
iex> Peselx.validate("04231115629")
{:ok, "Valid"}
```
