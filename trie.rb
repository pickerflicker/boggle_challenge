class Trie
  class TrieNode
    attr_accessor :value, :complete, :children

    def initialize(char, complete=false)
      @value = char
      @complete = complete
      @children = []
    end

    def insert_child(char, complete_word=false)
      new_node = TrieNode.new(char, complete_word)
      @children << new_node
      new_node
    end
  end

  def initialize
    @tree = TrieNode.new('[root]') # create null root node
  end

  def include?(word)
    node_ptr = @tree
    complete = false

    word.chars.each do |char|
      hit = false
      node_ptr.children.each do |child|
        if child.value == char
          node_ptr = child
          hit = true
          complete = child.complete
          break
        end
      end
      return false, false unless hit #no child has current char
    end

    return true, complete
  end

  def insert_word(word)
    last_index = word.length - 1
    node_ptr = @tree
    word.chars.each_with_index do |char, idx|
      hit = false
      node_ptr.children.each do |child|
        if child.value == char
          node_ptr = child
          hit = true
          break
        end
      end

      complete_word = (idx == word.length-1)
      node_ptr = node_ptr.insert_child(char, complete_word) unless hit
    end
  end

  def print_trie
    q = []  # use Array methods push, shift to achieve queue behavior
    q.push @tree
    q.push(TrieNode.new('\n')) #push newline token for printing new row

    while !q.empty?
      node = q.shift
      if node.value == '\n'
        puts ''
        q.push(node)
        next
      end

      print node.value + ' '
      q.push(*node.children)
      break if q.size == 1  # if only special level printing token exists, then we are done
    end
  end
end