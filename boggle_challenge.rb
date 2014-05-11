#!/usr/bin/ruby
require 'optparse'
require_relative 'trie'

def with_timing
  t = Time.now
  yield
  return "#{(Time.now - t)} seconds"
end

class BoggleChallenge

  attr_accessor :size

  class GameState
    def initialize(size)
      @size = size
      @state = []
      size.times do
        @state << size.times.map{false}
      end
    end

    def set_state(state_matrix)
      @state = state_matrix
    end

    def dup # deep copy
      state_matrix = []
      @state.each do |row|
        state_matrix << row.dup
      end

      state = GameState.new(@size)
      state.set_state(state_matrix)

      return state
    end

    def [](x,y)
      @state[y][x]
    end
    def []=(*params)
      x, y, value = params
      @state[y][x]=value
    end
  end

  def initialize
    @trie = Trie.new
    @results = []
  end
  def create_board(size=4)
    @board = []
    letters = ('a'..'z').to_a

    size.times do
      @board << (0...size).map{letters[rand(26)]}
    end

    @board.freeze
  end

  def show_board
    puts 'Boggle Board'
    @board.size.times {print '- '}
    puts ''
    @board.each do |row|
      row.each {|k| print k + ' '}
      puts ''
    end
    @board.size.times {print '- '}
    puts "\n\n"
  end

  def build_trie
    word_count = 0
    seconds = with_timing do
      File.open('en.txt', 'r').each do |k|
        @trie.insert_word(k.chomp)
        word_count+=1
      end
    end
    puts "Built Trie with #{word_count} words in #{seconds}"
  end

  def solve_board
    seconds = with_timing do
      size = @board.size
      state = GameState.new(size)

      #solve for each starting board position
      @board.size.times do |y|
        @board.size.times do |x|
          solve(y, x, "", state)
        end
      end
    end

    puts "Solved board in #{seconds}.  Number of Words Found: #{@results.size}"
    puts '---------------------------------------------------------'
    @results.each do |word|
      puts word
    end

  end

  def solve(x,y, old_word, old_state)
    # base cases
    # 1) out of bounds
    return if ( (x < 0) || (x >= @board.size) )
    return if ( (y < 0) || (y >= @board.size) )
    return if old_state[x,y]

    state = old_state.dup # each iteration has its own state
    state[x,y] = true

    word = old_word.dup
    word << @board[y][x]

    #puts "trying: #{word}"

    if word.length >= 3 # only count words at least 3 characters
      includes, complete = @trie.include? word
      return unless includes # terminate search path if trie branch ends
      @results << word if complete
    end

    # recurse through 8 possible directions
    solve(x,y+1, word, state)
    solve(x,y-1, word, state)
    solve(x+1,y, word, state)
    solve(x-1,y, word, state)
    solve(x+1,y+1, word, state)
    solve(x+1,y-1, word, state)
    solve(x-1,y+1, word, state)
    solve(x-1,y-1, word, state)
  end

end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: boggle_challenge [options]"
  opts.on('-size', '--size size', 'Size') do |size|
    options[:size] = Integer(size)
  end
end

parser.parse!
if options[:size].nil?
  print 'Enter integer board size: '
  options[:size] = Integer(gets.chomp)
end

puts "board size: #{options[:size]}"


bc = BoggleChallenge.new
bc.create_board(options[:size])
bc.show_board
bc.build_trie
bc.solve_board
