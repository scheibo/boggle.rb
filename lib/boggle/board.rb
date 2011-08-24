class Boggle::Board
  attr_reader :size

  def initialize(opts={})
    @size = opts[:size]
    if opts[:board].empty?
      letters = Boggle::Board.distributions(@size, opts[:variant]).sort_by{ rand }.map { |d| d.sample }
    else
      letters = letters_from_string opts[:board]
    end

    @board = []
    @size.times do
      @board << letters.pop(@size)
    end
  end

  def to_s
    s = ""
    @size.times { s<<"+"; s<<"-"*3 }; s<<"+\n"
    @size .times do |row|
      s << "|"
      @size.times do |col|
        (l=@board[row][col]) == "Qu" ? s << " #{l}|" : s << " #{l} |"
      end
      s<<"\n"; @size.times { s<<"+"; s<<"-"*3 }; s<<"+\n"
    end
    s
  end

  def [](row, col)
    ( (row < 0) || (col < 0) || (row >= @size) || (col >= @size) ) ? nil : @board[row][col]
  end

  # deepcopy first
  def []=(row, col, val)
    @board[row][col]=val
  end

  def deepcopy
    Marshal.load( Marshal.dump(self) )
  end

  def self.distributions( size, variant ) # 4,0 gives standard distrubtion

    distros = [[
      # http://everything2.com/title/Boggle
      %w{
        ASPFFK NUIHMQ OBJOAB LNHNRZ
        AHSPCO RYVDEL IOTMUC LREIXD
        TERWHV TSTIYD WNGEEH ERTTYL
        OWTOAT AEANEG EIUNES TOESSI
      },

      # http://www.boardgamegeek.com/thread/300565/review-from-a-boggle-veteran-and-beware-differen
      %w{
        AAEEGN ELRTTY AOOTTW ABBJOO
        EHRTVW CIMOTV DISTTY EIOSST
        DELRVY ACHOPS HIMNQU EEINSU
        EEGHNW AFFKPS HLNNRZ DEILRX
      },

      %w{
        AACIOT AHMORS EGKLUY ABILTY
        ACDEMP EGINTV GILRUW ELPSTU
        DENOSW ACELRS ABJMOQ EEFHIY
        EHINPS DKNOTU ADENVZ BIFORX
      }
    ],[

      # http://boardgamegeek.com/thread/300883/letter-distribution
      %w{
        aaafrs aaeeee aafirs adennn aeeeem
        aeegmu aegmnn afirsy bjkqxz ccenst
        ceiilt ceilpt ceipst ddhnot dhhlor
        dhlnor dhlnor eiiitt emottt ensssu
        fiprsy gorrvw iprrry nootuw ooottu
      }.map(&:upcase),

      %w{
        AAAFRS	AAEEEE	AAFIRS	ADENNN	AEEEEM
        AEEGMU	AEGMNN	AFIRSY	BJKQXZ	CCNSTW
        CEIILT	CEILPT	CEIPST	DHHNOT	DHHLOR
        DHLNOR	DDLNOR	EIIITT	EMOTTT	ENSSSU
        FIPRSY	GORRVW	HIPRRY	NOOTUW	OOOTTU
      }
    ]]

    min_size = 4
    distros[size-min_size].map { |dist|
      dist.map { |die|
        die.split(//).map { |letter|
          # our distrubutions return Qu, not Q's
          letter == 'Q' ? 'Qu' : letter
        }
      }
    }[variant]
  end

  private

  def letters_from_string(string)
    letters = []
    row = []
    string.each_char do |c|
      if c == "Q"
        row << "Qu"
      elsif c == "u"
        row
      else
        row << c
      end
      if row.size == @size
        letters << row
        row = []
      end
    end
    letters.reverse.flatten
  end

end
