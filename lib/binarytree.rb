require_relative 'binarynode'

class BinaryTree
  attr_reader :root

  def initialize(array = [])
    filtered_array = array.uniq.sort
    @length = filtered_array.length
    @root = build_tree(filtered_array)
  end

  def empty?
    @root.nil?
  end

  def delete(value)
    node_to_delete = find(value)
    return if node_to_delete.nil?

    delete_node(node_to_delete)
  end

  def insert(value)
    return unless find(value).nil?

    if empty?
      @root.value = value
    else
      nomad = @root
      nomad = nomad.value > value ? nomad.left : nomad.right until nomad.can_sire?(value)
      nomad.sire_child(BinaryNode.new(value))
    end
  end

  private

  def build_tree(array)
    return BinaryNode.new(nil) if array.empty?

    root_node = nil
    stack = [[0, array.length - 1, root_node]]
    until stack.empty?
      parent_node, new_child = manage_stack_segment(stack, array)
      next if new_child.nil?

      parent_node ? parent_node.sire_child(new_child) : root_node = new_child
    end
    root_node
  end

  def manage_stack_segment(stack, array)
    left_index, right_index, parent_node = stack.pop
    return if left_index > right_index

    mid_index = (left_index + right_index) / 2
    new_child = BinaryNode.new(array[mid_index])
    stack.push([mid_index + 1, right_index, new_child])
    stack.push([left_index, mid_index - 1, new_child])
    [parent_node, new_child]
  end

  def delete_node(node)
    case node
    when node.leaf? && node == @root
      @root.value = nil
    when node.leaf?
      node.ostracize
    when node.two_children? && node == @root
      node.left.find_successor.right = node.right
      node.left.parent = nil
      @root = node.left
    when node.two_children?
      node.left.find_successor.right = node.right
      parent = node.parent
      node.ostracize
      parent.sire_child(node.left)
    when @root == node
      @root = @root.left || @root.right
      @root.parent = nil
    else
      child = node.left || node.right
      parent = node.parent
      node.ostracize
      parent.sire_child(child)
    end
  end
end
