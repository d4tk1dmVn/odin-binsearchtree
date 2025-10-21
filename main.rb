require_relative 'lib/binarytree'

def pretty_print_rec(node = @root, prefix = '', is_left = true)
  pretty_print_rec(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
  puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
  pretty_print_rec(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
end

def pretty_print(tree)
  pretty_print_rec(tree.root)
end

input_array = Array.new(15) { rand(1..100) }
tree = BinaryTree.new(input_array)
pretty_print(tree)
puts "Is the tree balanced? #{tree.balanced?}"
5.times do
  tree.insert(rand(100...150))
end
pretty_print(tree)
puts "Is the tree balanced? #{tree.balanced?}"
puts 'Rebalancing tree...'
tree.rebalance
puts 'Tree rebalanced!!!'
pretty_print(tree)
puts "Is the tree balanced? #{tree.balanced?}"
puts "Level order:\n\t#{tree.level_order}\n"
puts "Pre order:\n\t#{tree.pre_order}\n"
puts "In order:\n\t#{tree.in_order}\n"
puts "Post order:\n\t#{tree.post_order}\n"
