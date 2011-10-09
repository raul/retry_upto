# See README.md for usage explanations

def retry_upto(max_retries = 1, options = {})
  yield
rescue *(options[:rescue] || Exception)
  raise if (max_retries -= 1) == 0

  if Array(options[:interval]).length == 2
    options[:interval], growth = *options[:interval]
  end

  sleep(options[:interval] || 0)
  if growth.respond_to?('*')
    options[:interval] *= growth
  elsif growth.respond_to?(:call)
    options[:interval]  = growth.call(options[:interval])
  end
  retry
end

class Enumerator
  def retry(options = {}, &blk)
    retry_upto(self.count, options, &blk)
  end
end