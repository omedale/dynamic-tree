class TreeService
  attr_reader :tree
  def initialize(tree)
    @tree = tree
    @id_details = nil
  end

  # use hash to reconstruct the tree
  def build_id_hash
    list = build_id_child_parent_list(
                              @tree[:child],
                              @tree[:id]) << get_root
    build_id_details(list)
  end

  def get_parants(id)
    build_id_hash
    @id_details[id.to_i][:parents]
  end

  def get_child(id)
    build_id_hash
    @id_details[id.to_i][:childs]
  end

  private

  def get_root
    { 
      parent: nil,
      id: @tree[:id],
      child: @tree[:child].map {|child| child[:id]}
    }
  end

  def build_id_details(id_child_parent_list)
    @id_details = Hash.new { |h, k| h[k] = Hash.new }
    id_child_parent_list.each do |value|
      @id_details[value[:id]].merge!({
                                childs: value[:child],
                                parents: find_ancestor(value, id_child_parent_list)
                              })
    end
  end

  def find_ancestor(node, lists, parents = [])
    unless node[:parent].nil?
      parents << node[:parent]
      new_node = lists.find { |x| node[:parent] == x[:id] }
      find_ancestor(new_node, lists, parents)
    end    
    parents
  end

  # build list with parent - id data with the tree
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