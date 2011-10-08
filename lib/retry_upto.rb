#  retry with steroids
#
#  Basic usage:
#
#  - retries up to 5 times catching any exception, doesn't wait between attempts
#
#      retry_upto(5) do ... end
#
#
#  Waiting time between attempts:
#
#  - retries up to 5 times, waits 2 seconds between attempts
#
#     retry_upto(5, :interval => 2) do ... end
#
#
#  Varying waiting time between attempts:
#
#  - retries up to 5 times, waits 1 second after the first attempt and increases
#    the time between the following attempts (2, 4, 8, ...)
#
#      retry_upto(5, :interval => 1, :growth => 2) do ... end
#
#  - retries up to 5 times, waits 1 second after the first attempt and decreases
#    the time between the following attempts (0.5, 0.25, 0.125, ...)
#
#      retry_upto(5, :interval => 1, :growth => 0.5) do ... end
#
#  - retries up to 5 times, waits 1 second after the first attempt and increases
#    randomly the time between the following attempts
#
#      retry_upto(5, :interval => 1, :growth => lambda{ |x| x + rand(3) } ) do ... end
#
#
#  Retrying only when certain Exceptions get raised:
#
#  - retries up to 5 times only after a ZeroDivisionError, raising any other Exception
#
#      retry_upto(5, :rescue => ZeroDivisionError) do ... end
#
#
#  All the described options can be combined together.

def retry_upto(max_retries = 1, options = {})
  yield
rescue (options[:rescue] || Exception)
  raise if (max_retries -= 1) == 0
  sleep(options[:interval] || 0)
  if options[:growth].respond_to?('*')
    options[:interval] = options[:interval] * options[:growth]
  elsif options[:growth].respond_to?(:call)
    options[:interval] = options[:growth].call(options[:interval])
  end
  retry
end



# Extends enumerator to allow usage like:
#
#    5.times.retry do
#      ...
#    end
#

class Enumerator
  def retry(options = {}, &blk)
    retry_upto(self.count, options, &blk)
  end
end