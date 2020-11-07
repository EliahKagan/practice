# Jim and his LAN Party
# https://www.hackerrank.com/challenges/jim-and-his-lan-party

NOT_CONNECTED = -1

# A network of elements representing users or machines, each of whom is a
# member of exactly one group, which can meet/play when all members are
# connected in a component (possibly shared with members of other groups).
class Network
  # Creates a new network with groups in [0, group_count) and elements in
  # [0, element_groups.size). Element i is a member of element_groups[i].
  def initialize(group_count : Int32, element_groups)
    element_groups = element_groups.to_a
    total_size = element_groups.size

    @time = 0

    @group_sizes = [0] * group_count
    element_groups.each { |group| @group_sizes[group] += 1 }

    @group_completion_times = @group_sizes.map do |size|
      size < 2 ? @time : NOT_CONNECTED
    end

    @elem_contributions = element_groups.map do |group|
      @group_completion_times[group] == NOT_CONNECTED ? {group => 1} : nil
    end

    @elem_parents = (0...total_size).to_a
    @elem_ranks = [0] * total_size
  end

  # Retrieves the times at which each group finished becoming connected.
  # For groups that were never connected, NOT_CONNECTED is returned.
  def completion_times
    @group_completion_times.each
  end

  # Adds an edge/wire connecting elem1 and elem2.
  def connect(elem1, elem2)
    @time += 1

    # Find the ancestors and stop if they are already the same.
    elem1 = find_set(elem1)
    elem2 = find_set(elem2)
    return if elem1 == elem2

    # Union by rank, merging contributions.
    if @elem_ranks[elem1] < @elem_ranks[elem2]
      join(parent: elem2, child: elem1)
    else
      @elem_ranks[elem1] += 1 if @elem_ranks[elem1] == @elem_ranks[elem2]
      join(parent: elem1, child: elem2)
    end
  end

  # Union-find "findset" operation with full path compression.
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

  # Makes child a child of parent and merges their contributions into parent.
  private def join(parent, child)
    @elem_parents[child] = parent

    @elem_contributions[parent] = merge_contributions(
                                    @elem_contributions[parent],
                                    @elem_contributions[child])
    @elem_contributions[child] = nil

    nil
  end

  # Merges contributions into whichever contribution hash started out larger,
  # recording and removing items that become complete as a result.
  # Returns the resulting hash, or nil if that hash is ultimately empty.
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

  # Merges the source hash into the sink hash. Helper for merge_contributions.
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

# Reads a line as a sequence of integers.
def read_record
  gets.as(String).split.map(&.to_i)
end

# Read the problem parameters. (_player_count is currently not checked.)
_player_count, game_count, wire_count = read_record

# Make the LAN. The extra 0 element and 0 group facilitate 1-based indexing.
network = Network.new(game_count + 1, read_record.unshift(0))

# Read and apply all the connections.
wire_count.times do
  elem1, elem2 = read_record
  network.connect(elem1, elem2)
end

# Skip the extra 0 group and print the other groups' completion times.
network.completion_times.skip(1).each { |time| puts time }
