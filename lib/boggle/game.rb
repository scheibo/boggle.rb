$:.unshift(File.dirname(__FILE__) + '/../boggle')

require 'zlib'
require 'trie'

class Boggle::Game

  def self.create_dictionary(file_name)
    trie = Boggle::Trie.new
    File.open(file_name).each_line do |line|
      idx = line.index " " # get first space
      if idx.nil? # no definition
        word, defn = line, "no definition available"
      else
        word, defn = line[0..idx-1], line[idx+1..line.size]
      end
      #word.chomp! # case where we had just words on the line

      # skip words that are too small for boggle
      if word.size > 2
        trie[word.upcase] = defn
      end
    end

    dump = Marshal.dump(trie)
    dict_file = File.new(File.expand_path("../../../dicts/#{file_name.chomp('.txt')}.dict", __FILE__), "w")
    dict_file = Zlib::GzipWriter.new(dict_file)
    dict_file.write dump
    dict_file.close
  end

  def initialize(board=nil, opts=nil)
    if ! board.nil?
      @board = board
    else
      @board = Boggle::Board.new
    end
    @opts = opts
    @words = []
    @trie = Boggle::Trie.new
  end

  def start
    dict = @opts[:dictionary]
    fill_trie(dict) # need to only load this once
    s = Boggle::Solver.new(@trie)
    @found_pairs = s.start(@board)

    display

    good = []
    bad = []
    @words.uniq.each do |w|
      if @found_pairs.delete w
        good << w
      else
        bad << w
      end
    end

    finish good, bad
  end

  private

  def score(words)
    words.reduce(0) { |a,w| a+score_word(w) }
  end

  def finish(good, bad)
    puts "Your score was: #{score(good)}"
    puts "The following words were bad:"
    bad.each { |b| print "#{b} " }
    puts

    puts "You missed the following words"
    dump_words
 end

  def dump_words
    already_done = []
    words = []
    @found_pairs.keys.sort.each do |word|
      if @found_pairs.include? word+"S"
        words << [word, "#{word}(S)"]
        already_done << word+"S"
      else
        words << [word, word] unless already_done.include? word
      end
    end

    # now we need to make our groups
    groups =[[],[],[],[],[],[]] # 3, 4, 5, 6, 7, 8+
    words.sort_by { |e| e.first.size }.each do |pk|
      case pk[0].size
        when 3 then groups[0] << pk[1]
        when 4 then groups[1] << pk[1]
        when 5 then groups[2] << pk[1]
        when 6 then groups[3] << pk[1]
        when 7 then groups[4] << pk[1]
        else        groups[5] << pk[1]
      end
    end

    puts
    groups.each do |group|
      break_after = 0
      group.each do |rep|
        print "#{rep} "
        break_after+=rep.size
        if break_after > 80
          print "\n"
          break_after = 0
        end
      end
      print "\n\n" unless group.empty?
    end

    if @opts[:define]
      @found_pairs.keys.sort.each { |word| puts "#{word}: #{@found_pairs[word]}" }
    else

      while true
        print "Define: "
        word = STDIN.gets.chomp.upcase
        if word == "XYZZY"
          break
        else
          puts "#{word}: #{@trie[word]}"
        end
      end

    end
  end

  def display
    puts @board
    while true
      word = STDIN.gets.chomp.upcase
      if word == "XYZZY"
        break
      else
        @words << word
      end
    end
    puts "Finished, you put down #{@words.size} words"
  end

  def fill_trie(file_name)
    file = Zlib::GzipReader.open(File.expand_path("../../../dicts/#{file_name}", __FILE__))
    @trie = Marshal.load file.read
    file.close
  end

  def score_word(word)
    case word.size
      when 0,1,2 then 0
      when 3,4 then 1
      when 5 then 2
      when 6 then 3
      when 7 then 5
      else 11
    end
 end
end
