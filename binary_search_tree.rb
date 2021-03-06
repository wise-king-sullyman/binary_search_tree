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

  def insert(value, node = @root)
    return if level_order.include?(value)

    new_node = Node.new(value, node)
    next_node = new_node < node ? node.left_child : node.right_child
    return insert(value, next_node) if next_node

    new_node < node ? node.left_child = new_node : node.right_child = new_node
  end

  def delete(value)
    node = find(value)
    delete_no_children(node) if node.child_count.zero?
    delete_one_child(node) if node.child_count == 1
    delete_two_children(node) if node.child_count == 2
  end

  def find(value, node = @root)
    return node if node.value == value

    if node.left_child && value < node.value
      find(value, node.left_child)
    elsif node.right_child && value > node.value
      find(value, node.right_child)
    else
      puts "#{value} not in tree"
    end
  end

  def level_order(node = @root, values = [], queue = [])
    values.push(node.value)
    queue.push(node.left_child) if node.left_child
    queue.push(node.right_child) if node.right_child
    level_order(queue.shift, values, queue) unless queue.empty?
    values
  end

  def inorder(node = @root, values = [])
    inorder(node.left_child, values) if node.left_child
    values.push(node.value)
    inorder(node.right_child, values) if node.right_child
    values
  end

  def preorder(node = @root, values = [])
    values.push(node.value)
    preorder(node.left_child, values) if node.left_child
    preorder(node.right_child, values) if node.right_child
    values
  end

  def postorder(node = @root, values = [])
    postorder(node.left_child, values) if node.left_child
    postorder(node.right_child, values) if node.right_child
    values.push(node.value)
  end

  def height(node)
    level_order_tree = level_order
    level_order_tree.reverse.each do |value|
      return depth(find(value), node) if descendant_of?(find(value), node)
    end
  end

  def depth(node, root = @root)
    depth_counter = 0
    while node.parent
      break if node == root

      depth_counter += 1
      node = node.parent
    end
    depth_counter
  end

  def balanced?
    level_order.each do |value|
      node = find(value)
      left_sub = node.left_child ? height(node.left_child) : 0
      right_sub = node.right_child ? height(node.right_child) : 0
      return false if (left_sub - right_sub).abs > 1
    end
    true
  end

  def rebalance
    @root = build_tree(level_order)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end

  private

  def build_tree(array, start_index = 0, end_index = array.uniq.size - 1, parent = nil)
    return if start_index > end_index

    clean_array = array.uniq.sort
    middle_index = ((start_index + end_index) / 2).floor
    root = Node.new(clean_array[middle_index], parent)
    root.left_child = build_tree(clean_array, start_index, middle_index - 1, root)
    root.right_child = build_tree(clean_array, middle_index + 1, end_index, root)
    root
  end

  def delete_no_children(node)
    parent = node.parent
    node < parent ? parent.left_child = nil : parent.right_child = nil
  end

  def delete_one_child(node)
    child = node.left_child || node.right_child
    delete(child.value)
    node.value = child.value
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

  def descendant_of?(node, super_parent)
    return true if node == super_parent

    descendant_of?(node.parent, super_parent) if node.parent
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
puts "Tree balanced? #{tree.balanced?}"
tree.pretty_print
puts "Level order traversal result: #{tree.level_order}"
puts "Inorder traversal result: #{tree.inorder}"
puts "Preorder traversal result: #{tree.preorder}"
puts "Postorder traversal result: #{tree.postorder}"
tree.insert(105)
tree.insert(404)
tree.insert(200)
tree.insert(1234)
puts "Tree balanced? #{tree.balanced?}"
tree.rebalance
puts "Tree balanced? #{tree.balanced?}"
tree.pretty_print
puts "Level order traversal result: #{tree.level_order}"
puts "Inorder traversal result: #{tree.inorder}"
puts "Preorder traversal result: #{tree.preorder}"
puts "Postorder traversal result: #{tree.postorder}"
