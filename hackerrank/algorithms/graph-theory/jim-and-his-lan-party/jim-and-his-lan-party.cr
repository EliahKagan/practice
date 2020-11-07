# Jim and his LAN Party
# https://www.hackerrank.com/challenges/jim-and-his-lan-party

INCOMPLETE = -1

class Network
  def initialize(group_count : Int32, element_groups)
    element_groups = element_groups.to_a
    total_size = element_groups.size

    @time = 0

    @group_sizes = [0] * group_count
    element_groups.each { |group| @group_sizes[group] += 1 }

    @group_completion_times = @group_sizes.map do |size|
      size < 2 ? @time : INCOMPLETE
    end

    @elem_contributions = element_groups.map_with_index do |group, elem|
      @group_completion_times[group] == INCOMPLETE ? {group => 1} : nil
    end

    @elem_parents = Array(Int32).new(total_size) { |elem| elem }
    @elem_ranks = Array(Int32).new(total_size, 0)
  end

  def completion_times
    @group_completion_times.each
  end

  def connect(elem1, elem2)
    @time += 1

    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

    # Unite by rank, merging contributions.
    if @elem_ranks[elem1] < @elem_ranks[elem2]
      join(parent: elem2, child: elem1)
    else
      @elem_ranks[elem1] += 1 if @elem_ranks[elem1] == @elem_ranks[elem2]
      join(parent: elem1, child: elem2)
    end
  end

  private def find_set(elem)
    # Find the ancestor.
    leader = elem
    while leader != @elem_parents[leader]
      leader = @elem_parents[leader]
    end

    # Compress the path.
    while elem != leader
      parent = @elem_parents[elem]
      @elem_parents[elem] = leader
      elem = parent
    end

    leader
  end

  private def join(parent, child)
    @elem_parents[child] = parent

    @elem_contributions[parent] = merge_contributions(
                                    @elem_contributions[parent],
                                    @elem_contributions[child])
    @elem_contributions[child] = nil

    nil
  end

  private def merge_contributions(contrib1, contrib2)
    # If either are both are nil, there is nothing to do.
    return contrib1 || contrib2 unless contrib1 && contrib2

    # Merge to the bigger one (so we loop over the smaller).
    if contrib1.size < contrib2.size
      do_merge_contributions(sink: contrib2, source: contrib1)
    else
      do_merge_contributions(sink: contrib1, source: contrib2)
    end
  end

  private def do_merge_contributions(sink, source)
    source.each do |group, source_count|
      sink_count = sink[group]?

      if sink_count.nil?
        sink[group] = source_count
      elsif sink_count + source_count < @group_sizes[group]
        sink[group] = sink_count + source_count
      else
        sink.delete(group)
        @group_completion_times[group] = @time
      end
    end

    sink.empty? ? nil : sink
  end

  @time : Int32
  @group_sizes : Array(Int32)
  @group_completion_times : Array(Int32)
  @elem_contributions : Array(Hash(Int32, Int32)?)
  @elem_parents : Array(Int32)
  @elem_ranks : Array(Int32)
end

def read_record
  gets.as(String).split.map(&.to_i)
end

player_count, game_count, wire_count = read_record

network = Network.new(game_count + 1, read_record.unshift(0))

wire_count.times do
  elem1, elem2 = read_record
  network.connect(elem1, elem2)
end

network.completion_times.skip(1).each { |time| puts time }
