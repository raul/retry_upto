# retry_upto: retry with steroids

## Usage

Basic usage

- retries up to 5 times catching any exception, doesn't wait between attempts:

    retry_upto(5) do ... end

Waiting time between attempts

- retries up to 5 times, waits 2 seconds between attempts:

   retry_upto(5, :interval => 2) do ... end

Varying waiting time between attempts

- retries up to 5 times, waits 1 second after the first attempt and increases
  the time between the following attempts (2, 4, 8, ...):

    retry_upto(5, :interval => 1, :growth => 2) do ... end

- retries up to 5 times, waits 1 second after the first attempt and decreases
  the time between the following attempts (0.5, 0.25, 0.125, ...):

    retry_upto(5, :interval => 1, :growth => 0.5) do ... end

- retries up to 5 times, waits 1 second after the first attempt and increases
  randomly the time between the following attempts:

    retry_upto(5, :interval => 1, :growth => lambda{ |x| x + rand(3) } ) do ... end

Retrying only when certain Exceptions get raised

- retries up to 5 times only after a ZeroDivisionError, raising any other Exception:

    retry_upto(5, :rescue => ZeroDivisionError) do ... end

All the options described above can be combined together.

## License

See the LICENSE file included in the distribution.

## Authors

This gem was born from gists by Raul Murciano, Glenn Gillen, Pedro Belo, Jaime Iniesta, Lleïr Borras and ideas taken from Aitor García Rey.

Yes, so many brain cells and so few lines of code. Great, isn't it?

