# retry_upto: retry with steroids

If you need to use `retry` in ruby, you probably want to retry some code only a **maximum number of times**,
and sometimes **wait an interval of time** between the attempts to avoid external resources hiccups or usage limits.

Therefore **Your Important Code** ends surrounded by counters, conditions and calls to `sleep`.

This gem deals elegantly with this common scenario:

    retry_upto(5) do
      # Your Important Code
    end

Under Ruby 1.9 it also allows:

    5.times.retry do
      # Your Important Code
    end

Keep reading to see all the options available.

## Usage

### Basic usage

Retries up to 5 times catching any exception, doesn't wait between attempts:

    retry_upto(5)

### Time intervals between attempts

For fixed intervals, an `:interval` parameter can be passed indicating the time in seconds.
The following example will sleep two seconds between attempts:

    retry_upto(5, :interval => 2)

For customized intervals, the `:interval` parameter can be a lambda, which will be applied
to the number of each attempt. For instance, the following code will sleep 3 seconds after
the first attempt, 6 after the second, 9 after the third...

    retry_upto(5, :interval => lambda{ |attempt| attempt * 3 })

### Retrying only when certain Exceptions get raised

Retries up to 5 times only after a ZeroDivisionError, raising any other Exception:

    retry_upto(5, :rescue => ZeroDivisionError)

Retries up to 5 times only after a ZeroDivisionError or a NameError, raising any other Exception:

    retry_upto(5, :rescue => [ZeroDivisionError, NameError])

All the options described above can be combined together.

### More sugar!

In ruby 1.9, the `Enumerator` class gets enhanced to use `retry_upto` this way:

    5.times.retry

This syntax accepts the same options:

    5.times.retry(:interval => 10)

## License

See the LICENSE file included in the distribution.

## Authors

This gem was born from gists by Raul Murciano, Glenn Gillen, Pedro Belo, Jaime Iniesta, Lleïr Borras and ideas taken from Aitor García Rey and Jim Remsik.

Yes, so many brain cells and so few lines of code. Great, isn't it?

