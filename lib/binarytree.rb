require_relative 'binarynode'
require_relative 'binarytreeiterativebuilder'

class BinaryTree
  include BinaryTreeIterativeBuilder

  attr_reader :root

  def initialize(array = [])
    @root = build_tree(array.uniq.sort)
  end

  def empty?
    @root.nil?
  end

  def find(value)
    return if empty?

    aux_node = BinaryNode.new(value)
    nomad = @root
    until nomad.nil? || nomad == aux_node
      nomad = nomad > aux_node ? nomad.left : nomad.right
    end
    nomad
  end

  def level_order
    node_array = []
    stack = [@root]
    until empty? || stack.empty?
      node = stack.pop
      stack.push(node.right) if node.right
      stack.push(node.left) if node.left
      yield node if block_given?
      node_array.append(node.value)
    end
    node_array unless block_given?
  end

  def in_order
    node_array = []
    stack = []
    nomad = @root
    until stack.empty? && nomad.nil?
      until nomad.nil?
        stack.push(nomad)
        nomad = nomad.left
      end
      nomad = stack.pop
      node_array.append(nomad.value)
      yield nomad if block_given?
      nomad = nomad.right
    end
    node_array unless block_given?
  end

  def pre_order
    node_array = []
    stack = [@root]
    until stack.empty?
      nomad = stack.pop
      node_array.append(nomad.value)
      yield nomad if block_given?
      stack.push(nomad.right) if nomad.right
      stack.push(nomad.left) if nomad.left
    end
    node_array unless block_given?
  end

  def post_order
    node_array, stack, visited_array = [], [@root], [false]
    until stack.empty?
      node, was_visited = stack.pop, visited_array.pop
      next unless node

      if was_visited
        node_array.append(node.value)
        yield node if block_given?
      else
        stack.push(node, node.right, node.left)
        visited_array.push(true, false, false)
      end
    end
    node_array unless block_given?
  end

  def delete(value)
    node_to_delete = find(value)
    return if node_to_delete.nil?

    delete_node(node_to_delete)
  end

  def insert(value)
    return unless find(value).nil?

    aux_node = BinaryNode.new(value)
    if empty?
      @root = aux_node
    else
      nomad = @root
      nomad = nomad > aux_node ? nomad.left : nomad.right until nomad.can_sire?(aux_node)
      nomad.sire_child(aux_node)
    end
  end

  def height(value)
    node = find(value)
    return if node.nil?

    max_height = 0
    queue = []
    queue.prepend([node.left, 1], [node.right, 1])
    until queue.empty?
      node, height = queue.pop
      next unless node

      max_height = height if max_height < height
      queue.prepend([node.left, height + 1], [node.right, height + 1])
    end
    max_height
  end

  def depth(value)
    node = find(value)
    return if node.nil?

    depth = 0
    until node == @root
      depth += 1
      node = node.parent
    end
    depth
  end

  def balanced?
    heights = all_heights
    post_order do |node|
      left_subtree_height = heights[node.left] || -1
      right_subtree_height = heights[node.right] || -1
      return false if (left_subtree_height - right_subtree_height).abs > 1
    end
    true
  end

  def rebalance
    @root = build_tree(level_order.sort) unless balanced?
  end

  private

  def build_tree(array)
    return nil if array.empty?

    BinaryTreeIterativeBuilder.divide_and_conquer_build(array)
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

  def all_heights
    heights = {}
    post_order do |node|
      pair = []
      pair.append(heights[node.left]) if heights[node.left]
      pair.append(heights[node.right]) if heights[node.right]
      heights[node] = node.leaf? ? 0 : 1 + pair.max
    end
    heights
  end
end
