require './trie'

class Solver

   def initialize(trie)
     @found_words = {} # going to use it like a set
     @trie = trie
   end

   def in_trie?(prefix)
     if (d=@trie.match(prefix.upcase)) # not nil = okay
       if d.class == String
         @found_words[prefix] = d
       end
       return true
     end
   end

   def start(board)
     solve(board)
     return @found_words
   end

   def solve(board)
     Game::SIZE.times do |row|
       Game::SIZE.times do |col|
         solve_frame( make_frame("", board, row, col)  )
       end
     end
   end

   private

   def make_frame(prefix, board, row, col)
     frame = []
     frame << (prefix+board[row,col])
     new_board = deepcopy(board)
     new_board[row,col]=nil
     frame << new_board
     frame << row << col
     frame
   end

   def solve_frame(frame)
     next_frames(frame).each do |f|
       prefix,b,r,c = f

       if in_trie? prefix
          # continue
          solve_frame(f)
       end
       # otherwise we're at a dead end!, ignore the frame
       # and continue to the other ones
     end
   end

   def next_frames(frame)
     # unpack
     pre, board, row, col = frame

     frames = []
     # row before
     frames << (board[row-1, col-1] && make_frame(pre, board, row-1, col-1))
     frames << (board[row-1, col  ] && make_frame(pre, board, row-1, col  ))
     frames << (board[row-1, col+1] && make_frame(pre, board, row-1, col+1))

     # same row
     frames << (board[row  , col-1] && make_frame(pre, board, row  , col-1))
     # frames << (board[row  , col  ] && make_frame(pre, board, row, col  ))
     # is guaranteed to be nil, since at row,col we are empty
     frames << (board[row  , col+1] && make_frame(pre, board, row  , col+1))

     # row after
     frames << (board[row+1, col-1] && make_frame(pre, board, row+1, col-1))
     frames << (board[row+1, col  ] && make_frame(pre, board, row+1, col  ))
     frames << (board[row+1, col+1] && make_frame(pre, board, row+1, col+1))

     frames.compact
   end

 end