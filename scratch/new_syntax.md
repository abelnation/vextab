# VexTab "Just-tab" Syntax Proposal
Author: Abel Allison

## Goals
- Easy to remember.  Use ascii tab conventions where possible
- Easy to read.  Easy to make changes to.
- Avoid unnecessary work
- Focus on TAB, as opposed to notation
- Design a syntax that is made for auto-wrapping.  
- 

# = = = = = = = = = = = = = = = = = = = = 
# Def want variable whitespace between tokens
# Fret first feels nice for readability and typing.
#   - I think in frets first, then string
#   - Makes it harder to set string for multiple frets
#   - How often do you have that many consecutive notes 
#     per string?
# Dots make numbers syntax highlight nicer
# Keep hammers/pulls/bends separate tokens? or
#   allow to be stuck to fret numbers?
#   - sticking makes the sequence more readable
#   - timing wise, can just lump into initial note...?
# Allow hammers/bends/pulls to omit string?
#   - Doesn't read super intuitively...
# 

section type=tab tuning=standard
t8  0.4 0.5 0.6 0.4 0.5 0.6 0.4 0.6 |
t8  0.4 0.5 0.6 0.4 t4  0.4 0.6 |
t1  (0.1 2.2 2.3 1.4 0.5 0.6) |
t8  0.4 0.5 0.6 0.4 t4 0.4 0.6 | t1 0.1 |
t8  0.4 h12 p0  0.5 0.6 0.4 t4 0.4 0.6 | t1 0.1 |

# Timing
t1 t2 t4 t8 t16 t32
tw th tq
# Dotted
[t.4 0.1 t8 0.1]*4

# Comments
# full line comment
t8  0.4 h2 p0 0.5 0.6 b2 0.4 t4 0.4 0.6 | # end of line

# hammers / pulls /bends
t8  0.4 h2.4 p0.4 0.5 0.6 b2.6 0.4 t4 0.4 0.6 |
# should work in fret groupings
t8  0h2p0.4 0.5 0b2.6 0.4 t4 0.4 0.6 |

# slides
t8  0.4 /2.4 \0.4 0.5 0.6 b2 0.4 t4 0.4 0.6 |
t8  0/2\0.4 0.5 0.6 b2 0.4 t4 0.4 0.6 |

# mutes
t8  0.4 h2 p0 x.5 x.6 b2 0.4 t4 0.4 0.6 |

# upstroke / downstroke
t8  [0u 1d 3u 1d 0u].6  |
t8  [("e")u ("e")d]*2

# grouping notes has no effect by itself
t8  [0.4 0.5 0.6] [0.4 0.5 0.6] [0.4 0.6] |
t8  [0.4 0.5] [0.6 0.4 0.5 0.6 0.4] [0.6] |

# triplets
t8  [0.4 0.5 0.6]3 [0.4 0.5 0.6]3 [0.4 0.5 0.6]3 [0.4 0.5 0.6]3 |
t8  [0.4 0.5 0.6]^3*4 |

# repeat an element
t8  [0.4 0.5 0.6]^3*4
t8  |: 0.4*4 1.4*4 3.4*4 1.4*4 :|

# NOTE: not sure how i feel about the hyphen
# multiple notes per string
t8  0-2.3 t4 0-1-3.4
t8  [0 2].3 t4 [0 1 3].4

# pre-def syntax
# NOTE: I think i like the single arrow
c_to_g::    t4 3.1 3.1 0.2 2.2 |
c_to_g:     t4 3.1 3.1 0.2 2.2 |
c_to_g:=    t4 3.1 3.1 0.2 2.2 |
c_to_g=>    t4 3.1 3.1 0.2 2.2 |
c_to_g->    t4 3.1 3.1 0.2 2.2 |

# re-usable sections
# pre-defines are not included until you invoke them
#   with square brackets
# should work recursively
# should be able to use already defined pre-defs in
#   subsequent pre-defs
# scope pre-defs to each section?

g_chord::   (3.1 2.2 0.3 0.4 0.5 3.6)

section type=tab
g_bass_1::  t4 [3.1 0.3]x2 |
g_bass_2::  t4 [3.1 t8 ["g_chord"]x2]x2 |
c_bass::    t4 [3.2 2.3]x2 |
fill_1::    t4 3.1 3.1 0.2 2.2 |
["g_bass_1"]x3 ['ctog'] ["c_bass"]x4 ["g_bass_2"]x3 t1 3.1

section type=tab
fill_1::    t4 3.1 3.1 0.2 2.2 |
[t4 ["g_chord"]x4 ["fill_1"]]x2

# repeat measures
t4  0.1 chord(e) 0.1 chord(e) | % | % | % |

# chords above tab
# NOTE: should make it easy just to use whatever
#       text you want, yeah?
section type=tab
g_bass::    t4 [3.1 0.3]x2 |
c_bass::    t4 [3.2 2.3]x2 |

[chord("G") ["g_bass"] chord("C") ["c_bass"]]x4
[c("G") ["g_bass"] c("C") ["c_bass"]]x4

# fingering
# NOTE: i think 'f' is the most memberable
t8 (1.1f1 3.2f4 3.3f3 2.4f2 1.5f1 1.6f1)
t8 (1.1^1 3.2^4 3.3^3 2.4^2 1.5^1 1.6^1)
t8 (1.1_1 3.2_4 3.3_3 2.4_2 1.5_1 1.6_1)
t8 (1.1?1 3.2?4 3.3?3 2.4?2 1.5?1 1.6?1)

# fingers with upstroke/downstroke
# NOTE: not a huge fan
t8 (1.1f1u 3.2f4d 3.3f3u 2.4f2d 1.5f1u 1.6f1d)

# rests take same time
t8 [0.1]x3 r t4 0.1 0.3 r 0.3 |

# = = = = = = = = = = = = = = = = = = = =
# Too hard to type and arrange and make changes to

tabsection
t8  0_4 0_5 0_6 0_4 0_5 0_6 0_4 0_6


# = = = = = = = = = = = = = = = = = = = =
# Too hard to type and arrange and make changes to

tabsection
t8                                t4
    0      0     0    | 0      0            |
      0      0        |   0          0      |
        0      0   0  |     0          0    |
                      |                     |      
                      |                     |      
                      |                     |      


# = = = = = = = = = = = = = = = = = = = =
# Still complex
# Doesn't necessarily read easier...

tabsection
t8  4  5  6  4  _  _  4  6 |
    0  0  0  0  1  3  0  0 |
