require_relative 'binarynode'

class BinaryTree
  include IterativeTreeBuilder

  attr_reader :root

  def initialize(array = [])
    filtered_array = array.uniq.sort
    @length = filtered_array.length
    @root = build_tree(filtered_array)
  end

  def empty?
    @root.nil?
  end

  def find(value)
    return if empty?

    nomad = @root
    until nomad.nil? || nomad.value == value
      nomad = nomad.value > value ? nomad.left : nomad.right
    end
    nomad
  end

  def delete(value)
    node_to_delete = find(value)
    return if node_to_delete.nil?

    delete_node(node_to_delete)
  end

  def insert(value)
    return unless find(value).nil?

    if empty?
      @root = BinaryNode.new(value)
    else
      nomad = @root
      nomad = nomad.value > value ? nomad.left : nomad.right until nomad.can_sire?(value)
      nomad.sire_child(BinaryNode.new(value))
    end
  end


  private

  def build_tree(array)
    return nil if array.empty?

    IterativeTreeBuilder.divide_and_conquer(array)
  end

  def delete_node_with_children(node)
    node_to_insert_at = node.left
    node_to_insert_at = node_to_insert_at.right until node_to_insert_at.right.nil?
    node_to_insert_at.right = node.right
    replace_with_child(node, node.left)
  end

  def replace_with_child(node, child)
    if node == @root
      @root = child
      @root.parent = nil
    else
      parent = node.parent
      node.ostracize
      parent.sire_child(child)
    end
  end

  def delete_node(node)
    case node
    when node.leaf?
      @root == node ? @root = nil : node.ostracize
    when node.two_children?
      delete_node_with_children(node)
    else
      replace_with_child(node, node.left || node.right)
    end
  end
end
