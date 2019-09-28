class TreeService
  attr_reader :tree
  def initialize(tree)
    @tree = tree
    @id_data = nil
  end

  def build_parent_child_data
    list = build_id_child_parent_list(
                              @tree[:child],
                              @tree[:id]) << get_root
    @id_data = build_childs_parents(list)
  end

  def get_parants(id)
    @id_data[id.to_i][:parents]
  end

  def get_child(id)
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

  def build_childs_parents(list)
    items = Hash.new { |h, k| h[k] = Hash.new }
    list.each do |value|
      if items.has_key? value[:id]
        items[value[:id]][:parents].push(*find_parents(list, value))
      else
        items[value[:id]].merge!({ childs: value[:child], parents: find_parents(list, value) })
      end
    end
    items
  end

  def find_parents(list, item)
    list.select { |x| x[:id] == item[:id] && item[:parent] }
        .map { |x| x[:parent] }
  end

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