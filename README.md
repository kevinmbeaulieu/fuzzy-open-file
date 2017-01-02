Fuzzy-search for, and open files.

Uses Spotlight to search for a file containing all the characters in the query in that order (i.e., file name matches the regex `/^.*m.*y.*q.*u.*e.*r.*y.*$/`. Built for macOS.

I recommend creating an alias such as `alias fof=fuzzy-open-file`.

Usage: `fuzzy-open-file [-a <application>] [-h] [-p <path>] [--vim] query`
    
Options:

    -a        Opens with the specified application.

    -h, --help    Print this help message and exit.

    -p, --path    Search only within the specified path (default: ~).

    --vim        Opens file with vim.

Examples:

    ~$ fuzzy-open-file curdes.ske # open ~/Documents/CurrentDesign.sketch
    
    ~$ fuzzy-open-file sl.p # open ~/Documents/Friday's\ Presentation/slides.pdf
    
   
Install (using Prezto/zsh):
    
1. Clone this repo into `~/.zprezto/modules/fuzzy-open-file
        
2. Append 'fuzzy-open-file' to the line in your `~/.zprezto/runcoms/zpreztorc` which starts with `zstyle ':prezto:load'...`

Install (manually):

1. Clone this repo

2. Add `source <path to this repo>/init.zsh` to your shell's runcom (e.g., `~/.bashrc`, `~/.zshrc`
