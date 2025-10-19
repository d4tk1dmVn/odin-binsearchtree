require_relative 'binarynode'

module BinaryTreeIterativeBuilder
  def self.divide_and_conquer_build(array)
    root_node = nil
    stack = [[0, array.length - 1, root_node]]
    until stack.empty?
      parent_node, new_child = manage_stack_segment(stack, array)
      next if new_child.nil?

      parent_node ? parent_node.sire_child(new_child) : root_node = new_child
    end
    root_node
  end

  def self.manage_stack_segment(stack, array)
    left_index, right_index, parent_node = stack.pop
    return if left_index > right_index

    mid_index = (left_index + right_index) / 2
    new_child = BinaryNode.new(array[mid_index])
    stack.push([mid_index + 1, right_index, new_child])
    stack.push([left_index, mid_index - 1, new_child])
    [parent_node, new_child]
  end
end
