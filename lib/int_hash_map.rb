class IntHashMap
  def initialize
    @count = 0
    @store = Array.new(8) { [] }
  end
  attr_reader :count

  def has_key?(key)
    bucket_for(key).any? { |kv_pair| kv_pair[0] == key }
  end

  alias_method :include?, :has_key?

  def insert(key, value)
    if has_key?(key)
      raise "key already present"
    end

    bucket_for(key).push([key, value])
    @count += 1
  end

  def remove(key)
    bucket_for(key).each do |kv_pair|
      if kv_pair[0] == key
        val =  kv_pair[1]
        @count -= 1
        bucket_for(key).delete(kv_pair)
        return val
      end
    end

    return nil
  end


  private
  attr_accessor :store

  def bucket_for(key)
    store[key % store.length]
  end
end
