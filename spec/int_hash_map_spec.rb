require 'int_hash_map'

describe IntHashMap do
  it "starts out empty" do
    hash = IntHashMap.new
    expect(hash.count).to eq(0)
  end

  it "allows insertion/include?" do
    hash = IntHashMap.new
    20.times { |i| hash.insert(i, true) }
    expect(hash.count).to eq(20)
    20.times { |i| expect(hash.include?(i)).to eq(true) }
  end

  it "allows removal" do
    hash = IntHashMap.new
    20.times { |i| hash.insert(i, true) }
    (0...5).to_a.shuffle.each_with_index do |el, num_removed|
      expect(hash.include?(el)).to eq(true)
      hash.remove(el)
      expect(hash.include?(el)).to eq(false)
      expect(hash.count).to eq(20 - (num_removed + 1))
    end
  end

  it "stores values" do
    hash = IntHashMap.new
    20.times { |i| hash[i] =  i ** 2 }
    expect(hash.count).to eq(20)
    20.times { |i| expect(hash[i] == i ** 2).to eq(true) }
  end

  it "allows values to be changed" do
    hash = IntHashMap.new
    20.times { |i| hash[i] =  i ** 2 }
    20.times { |i| hash[i] =  i ** 3 }
    expect(hash.count).to eq(20)
    20.times { |i| expect(hash[i] == i ** 3).to eq(true) }
  end

  describe "internals" do
    it "starts with 8 empty buckets" do
      hash = IntHashMap.new
      expect(hash.send(:store)).to eq([[]] * 8)
    end

    it "places each item in a bucket" do
      hash = IntHashMap.new
      buckets = hash.send(:store)

      8.times do |i|
        val = (8 * i) + i
        hash.insert(val, true)

        expect(buckets[i]).to eq([[val, true]])
      end
    end

    it "performs O(1) include?" do
      hash = IntHashMap.new

      8.times { |i| val = (8 * i) + i; hash.insert(val, true) }

      buckets = hash.send(:store)
      allow(buckets).to receive(:[]).and_call_original
      8.times do |i|
        val = (8 * i) + i
        hash.include?(i)
        expect(buckets).to have_received(:[]).exactly(i + 1).times
      end
    end

    it "performs O(1) insert" do
      hash = IntHashMap.new

      buckets = hash.send(:store)
      allow(buckets).to receive(:[]).and_call_original
      8.times do |i|
        val = (8 * i) + i
        hash.insert(i, true)
        # I'm going to expect you to call this twice in your insert
        expect(buckets).to have_received(:[]).exactly(2 * (i + 1)).times
      end
    end

    it "doubles in size when fully loaded" do
      hash = IntHashMap.new

      buckets = hash.send(:store)
      8.times do |i|
        val = (8 * i) + i
        hash.insert(val, true)

        expect(hash.send(:store)).to eq(buckets)
      end

      9.upto(16) do |i|
        val = (8 * i) + i
        hash.insert(val, true)
      end
      expect(hash.send(:store).length).to eq(16)
    end
  end
end
