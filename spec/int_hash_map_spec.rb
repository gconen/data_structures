require 'int_hash_map'

describe IntHashMap do
  it "starts out empty" do
    set = IntHashMap.new
    expect(set.count).to eq(0)
  end

  it "allows insertion/include?" do
    set = IntHashMap.new
    20.times { |i| set.insert(i, true) }
    expect(set.count).to eq(20)
    20.times { |i| expect(set.include?(i)).to eq(true) }
  end

  it "allows removal" do
    set = IntHashMap.new
    20.times { |i| set.insert(i, true) }
    (0...5).to_a.shuffle.each_with_index do |el, num_removed|
      expect(set.include?(el)).to eq(true)
      set.remove(el)
      expect(set.include?(el)).to eq(false)
      expect(set.count).to eq(20 - (num_removed + 1))
    end
  end

  describe "internals" do
    it "starts with 8 empty buckets" do
      set = IntHashMap.new
      expect(set.send(:store)).to eq([[]] * 8)
    end

    it "places each item in a bucket" do
      set = IntHashMap.new
      buckets = set.send(:store)

      8.times do |i|
        val = (8 * i) + i
        set.insert(val, true)

        expect(buckets[i]).to eq([[val, true]])
      end
    end

    it "performs O(1) include?" do
      set = IntHashMap.new

      8.times { |i| val = (8 * i) + i; set.insert(val, true) }

      buckets = set.send(:store)
      allow(buckets).to receive(:[]).and_call_original
      8.times do |i|
        val = (8 * i) + i
        set.include?(i)
        expect(buckets).to have_received(:[]).exactly(i + 1).times
      end
    end

    it "performs O(1) insert" do
      set = IntHashMap.new

      buckets = set.send(:store)
      allow(buckets).to receive(:[]).and_call_original
      8.times do |i|
        val = (8 * i) + i
        set.insert(i, true)
        # I'm going to expect you to call this twice in your insert
        expect(buckets).to have_received(:[]).exactly(2 * (i + 1)).times
      end
    end

    it "doubles in size when fully loaded" do
      set = IntHashMap.new

      buckets = set.send(:store)
      8.times do |i|
        val = (8 * i) + i
        set.insert(val, true)

        expect(set.send(:store)).to eq(buckets)
      end

      9.upto(16) do |i|
        val = (8 * i) + i
        set.insert(val, true)
      end
      expect(set.send(:store).length).to eq(16)
    end
  end
end
