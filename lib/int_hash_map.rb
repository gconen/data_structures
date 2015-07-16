class IntHashMap
  def initialize
    @count = 0
    @store = Array.new(8) { [] }
  end
  attr_reader :count

  def []=(key, value)
    bucket_for(key).each do |kv_pair|
      if kv_pair[0] == key
        kv_pair[1] = value
        return
      end
    end
    self.insert(key, value)
  end

  def [](key)
    bucket_for(key).each do |kv_pair|
      if kv_pair[0] == key
        return kv_pair[1]
      end
    end
  end

  def has_key?(key)
    bucket_for(key).any? { |kv_pair| kv_pair[0] == key }
  end

  alias_method :include?, :has_key?

  def insert(key, value = true)
    if has_key?(key)
      raise "key already present"
    end

    resize! if count == @store.length

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

  def resize!
    old_store = @store
    @store = Array.new(@store.length * 2) { [] }
    old_store.each do |bucket|
      bucket.each { |kv_pair| bucket_for(kv_pair[0]).push(kv_pair) }
    end
  end
end
