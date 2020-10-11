# frozen_string_literal: true

# responsible for creating and comparing node instances
class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def initialize(value = nil, left_child = nil, right_child = nil)
    @value = value
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    value <=> other.value
  end
end

# creates and manages the binary search tree
class Tree
  attr_accessor :root
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array, start_index = 0, end_index = array.size - 1)
    return if start_index > end_index

    middle_index = ((start_index + end_index) / 2).floor
    root = Node.new(array[middle_index])
    root.left_child = build_tree(array, start_index, middle_index - 1)
    root.right_child = build_tree(array, middle_index + 1, end_index)

    root
  end

  def insert(value, node = @root)
    new_node = Node.new(value)
    next_node = new_node < node ? node.left_child : node.right_child
    return insert(value, next_node) if next_node

    new_node < node ? node.left_child = new_node : node.right_child = new_node
  end

  def delete(value)
    node_to_delete = find(value)
  end
  
  def find(value, node = @root)
    return node if node.value == value

    if node.left_child
      find(value, node.left_child)
    elsif node.right_child
      find(value, node.right_child)
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

tree = Tree.new([5, 10, 15])
tree.insert(3)
tree.insert(17)
tree.insert(1)
tree.insert(2)
tree.insert(13)
tree.insert(16)
tree.insert(23)
tree.insert(4)
tree.insert(11)
tree.insert(7)
tree.insert(12)
tree.insert(20)
tree.insert(25)
tree.insert(30)
tree.pretty_print

