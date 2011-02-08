# Boggle

Very dirty program to let you play 4x4 boggle and learn new words. Has the following options:

		opts = Trollop::options do
		  opt :define, "Show a definition dump at the end", :short => 'd'
		  opt :interactive, "Continue printing games", :short => 'i'
		  opt :dictionary, "Change the default dictionary", :default => 'dicts/just_words.dict'
		  opt :board, "Give a string as input to be the board", :default => ""
		end

Where `--interactive` has yet to be implemented, but the idea behind if would be that instead of loading up a dict each time you could continue to play with the same dictionary. Has no timer going on right now, just use a watch to time the three minutes. Use 'XYZZY' to exit any prompt (TODO: should be control-D or something as well).

As it stands, with a full scrabble dictionary load (dicts/osw.txt) it takes about 2.6 seconds to load up on

	Darwin mac.local 10.6.0 Darwin Kernel Version 10.6.0: Wed Nov 10 18:13:17 PST 2010; root:xnu-1504.9.26~3/RELEASE_I386 i386

with intel core 2 duo 2.4ghz. It takes about 200MB of ram to load the dictionary into memory. With this dictionary a given board takes around 0.14 seconds to solve (same specs). 'just_words' only has around 40k words as opposed to 260k, so it ends up being considerably faster. There are some ways to optimize the solving, but at 0.14 seconds thats not really the problem, the problem is the loading which even then isn't *horrid*.

## Usage

Not actually a gem, just

    git clone git://github.com/scheibo/boggle.git
    cd boggle
    ./boggle

## Future

- timer (3 min countdown)
- interactive mode (save loading the dict)
- Ctrl+D to exit

## Copyright

Hopefully Parker Brothers (Hasbro) isn't going to get mad I've recreated their game. All copyright, trademarks, etc belong to them.

All the dictionaries are property of whoever compiled them, and hopefully I'm not breaking any copyright by including them in this program (I just took most of them off of [wordlists.sourceforge.com](http://wordlists.sourceforge.com)).

As for the code to the game itself:

`boggle` is Copyright (c) 2011 [Kirk Scheibelhut](http://scheibo.com/about) and distributed under the MIT license.<br />
See the `LICENSE` file for further details regarding licensing and distribution.
