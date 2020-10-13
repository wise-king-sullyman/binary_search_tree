# frozen_string_literal: true

# responsible for creating and comparing node instances
class Node
  include Comparable
  attr_accessor :value, :parent, :left_child, :right_child

  def initialize(value = nil, parent = nil, left_child = nil, right_child = nil)
    @value = value
    @parent = parent
    @left_child = left_child
    @right_child = right_child
  end

  def <=>(other)
    value <=> other.value
  end

  def child_count
    child_counter = 0
    child_counter += 1 if @left_child
    child_counter += 1 if @right_child
    child_counter
  end
end

# creates and manages the binary search tree
class Tree
  attr_accessor :root
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array, start_index = 0, end_index = array.size - 1, parent = nil)
    return if start_index > end_index

    middle_index = ((start_index + end_index) / 2).floor
    root = Node.new(array[middle_index], parent)
    root.left_child = build_tree(array, start_index, middle_index - 1, root)
    root.right_child = build_tree(array, middle_index + 1, end_index, root)

    root
  end

  def insert(value, node = @root)
    new_node = Node.new(value, node)
    next_node = new_node < node ? node.left_child : node.right_child
    return insert(value, next_node) if next_node

    new_node < node ? node.left_child = new_node : node.right_child = new_node
  end

  def delete(value)
    node = find(value)
    delete_one_child_or_less(node) if node.child_count < 2
    delete_two_children(node) if node.child_count == 2
  end

  def delete_one_child_or_less(node)
    parent = node.parent
    child_is = node.left_child || node.right_child || nil
    node < parent ? parent.left_child = child_is : parent.right_child = child_is
  end

  def delete_two_children(node)
    replacement = find_lowest_child(node.right_child)
    delete(replacement.value)
    node.value = replacement.value
  end

  def find_lowest_child(node)
    return node unless node.left_child

    find_lowest_child(node.left_child)
  end

  def find(value, node = @root)
    return node if node.value == value

    if node.left_child && value < node.value
      find(value, node.left_child)
    elsif node.right_child && value > node.value
      find(value, node.right_child)
    else
      puts 'Value not in tree'
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
tree.delete(25)
tree.pretty_print
