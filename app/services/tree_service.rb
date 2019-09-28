class TreeService
  attr_reader :tree
  def initialize(tree)
    @tree = tree
    @id_data = nil
  end

  def build_parent_child_list
    list = build_id_child_parent_list(
                              @tree[:child],
                              @tree[:id]) << get_root
    build_id_childs_parents(list)
  end

  def get_parants(id)
    build_parent_child_list
    @id_data[id.to_i][:parents]
  end

  def get_child(id)
    build_parent_child_list
    @id_data[id.to_i][:childs]
  end

  private

  def get_root
    { 
      parent: nil,
      id: @tree[:id],
      child: @tree[:child].map {|child| child[:id]}
    }
  end
  
  # build list of ids with there childs and parent ids in a Hash
  def build_id_childs_parents(list)
    @id_data = Hash.new { |h, k| h[k] = Hash.new }
    list.each do |value|
      if @id_data.has_key? value[:id]
        @id_data[value[:id]][:parents].push(*find_parents(list, value))
      else
        @id_data[value[:id]].merge!({ childs: value[:child], parents: find_parents(list, value) })
      end
    end
  end

  def find_parents(list, item)
    list.select { |x| x[:id] == item[:id] && item[:parent] }
        .map { |x| x[:parent] }
  end

  # build an array with parent-node data with the tree
  def build_id_child_parent_list(child, parent, list = [])
    child.each do |tree|
      list << {
          parent: parent,
          id: tree[:id],
          child: tree[:child].map {|item| { id: item[:id] } }
      }
      if tree[:child].any?
        build_id_child_parent_list(tree[:child], tree[:id], list)
      end
    end
    list
  end
end