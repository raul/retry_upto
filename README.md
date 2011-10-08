# retry_upto: retry with steroids

If you need to use `retry` in ruby, you probably want to retry some code only a **maximum number of times**,
and sometimes **wait a bit** between the attempts to avoid external resources hiccups or usage limits.

Therefore **Your Important Code** ends surrounded by counters, conditions and calls to `sleep`.

This gem deals elegantly with this common scenario:

    5.times.retry do
      # Your Important Code
    end

Keep reading to see all the options available.

## Usage

### Basic usage

Retries up to 5 times catching any exception, doesn't wait between attempts:

    retry_upto(5)

### Waiting time between attempts

Retries up to 5 times, waits 2 seconds between attempts:

    retry_upto(5, :interval => 2)

### Varying waiting time between attempts

Retries up to 5 times, waits 1 second after the first attempt and increases
the time between the following attempts (2, 4, 8, ...):

    retry_upto(5, :interval => 1, :growth => 2)

Retries up to 5 times, waits 1 second after the first attempt and decreases
the time between the following attempts (0.5, 0.25, 0.125, ...):

    retry_upto(5, :interval => 1, :growth => 0.5)

Retries up to 5 times, waits 1 second after the first attempt and increases
randomly the time between the following attempts:

    retry_upto(5, :interval => 1, :growth => lambda{ |x| x + rand(3) } )

### Retrying only when certain Exceptions get raised

Retries up to 5 times only after a ZeroDivisionError, raising any other Exception:

    retry_upto(5, :rescue => ZeroDivisionError)

Retries up to 5 times only after a ZeroDivisionError or a NameError, raising any other Exception:

    retry_upto(5, :rescue => [ZeroDivisionError, NameError])

All the options described above can be combined together.

### More sugar!

In ruby 1.9, the `Enumerator` class gets enhanced to use `retry_upto` this way:

    5.times.retry

And yes, this accepts the same options:

    5.times.retry(:interval => 10)

## License

See the LICENSE file included in the distribution.

## Authors

This gem was born from gists by Raul Murciano, Glenn Gillen, Pedro Belo, Jaime Iniesta, Lleïr Borras and ideas taken from Aitor García Rey.

Yes, so many brain cells and so few lines of code. Great, isn't it?

