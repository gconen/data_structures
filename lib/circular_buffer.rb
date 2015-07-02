class CircularBuffer
  def initialize
    @store = Array.new(8)
    @length = 0
    @capacity = 8
    @start_index = 0
  end

  attr_reader :length

  def [](index)
    @store[idx(index)]
  end

  def []=(index, value)
    @store[idx(index)] = value
  end

  def each(&proc)
    length.times do |el|
      proc.call(el)
    end
  end

  def pop
    value = self[length-1]
    self[length-1] = nil
    @length -= 1
    value
  end

  def push(value)
    resize! if length == capacity
    @length += 1
    self[length-1] = value
  end

  def shift
    value = self[0]
    self[0] = nil
    @length -= 1
    @start_index = (@start_index + 1) % capacity
    value
  end

  def unshift(value)
    resize! if length == capacity
    @length += 1
    @start_index = (@start_index - 1) % capacity
    self[0] = value
  end

  protected
  attr_accessor :start_index, :capacity
  attr_reader :store

  private
  def idx(logical_index)
    if logical_index >= 0
      raise "index out of bounds" if logical_index >= @length
      (@start_index + logical_index) % store.length
    else
      idx(@length - logical_index) #negative indexing to count from the end
    end
  end

  def resize!
    @capacity *= 2
    new_store = Array.new(@capacity)
    @length.times { |i| new_store[i] = self[i] }
    @start_index = 0
    @store = new_store
  end
end
