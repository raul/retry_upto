# See README.md for usage explanations

def retry_upto(max_retries = 1, opts = {})
  yield
rescue *(opts[:rescue] || Exception)
  attempt = attempt ? attempt+1 : 1
  raise if (attempt == max_retries)
  if interval = opts[:interval]
    secs = interval.respond_to?(:call) ? interval.call(attempt) : interval
    sleep(secs)
  end
  retry
end

class Enumerator
  def retry(opts = {}, &blk)
    retry_upto(self.count, opts, &blk)
  end
end