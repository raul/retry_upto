# See README.md for usage explanations

def retry_upto(max_retries = 1, options = {})
  yield
rescue *(options[:rescue] || Exception)
  raise if (max_retries -= 1) == 0

  if options[:interval].is_a?(Array) && options[:interval].length == 2
    options[:interval], options[:growth] = *options[:interval]
  end

  sleep(options[:interval] || 0)
  if options[:growth].respond_to?('*')
    options[:interval] = options[:interval] * options[:growth]
  elsif options[:growth].respond_to?(:call)
    options[:interval] = options[:growth].call(options[:interval])
  end
  retry
end

class Enumerator
  def retry(options = {}, &blk)
    retry_upto(self.count, options, &blk)
  end
end