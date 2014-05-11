# Summary

This is a solution for the boggle challenge: https://gist.github.com/scottburton11/a2d8afcee57d13232ed4.  It used a Trie to implement pruned recursion.


The words list is imported from Letterpress: https://github.com/atebits/Words

"boggle_challenge.rb" is an executable ruby script.  Only argument is the board size.

# Examples
Example call: ./boggle_challenge.rb --size 4

Example output:

    Boggle Board
    - - - -
    r b x w
    m l h d
    t y r r
    e k m c
    - - - -

    Built Trie with 274907 words in 2.283569 seconds
    Solved board in 0.008338 seconds.  Number of Words Found: 23
    ---------------------------------------------------------
    myrrh
    tyke
    tye
    lyte
    lym
    lye
    lym
    yet
    kyte
    kye
    ket
    key
    hyke
    hyte
    hye
    rhy
    ryke
    rye
    myrrh
    why
    dry
    rhy
    cry