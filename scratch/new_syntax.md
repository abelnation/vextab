# VexTab "Just-tab" Syntax Proposal
Author: Abel Allison

### Goals
- Easy to remember.  Use ascii tab conventions where possible
- Easy to read.  Easy to make changes to.
- Avoid unnecessary work
- Focus on TAB, as opposed to notation
- Design a syntax that is made for auto-wrapping.  
- Support all manner of variable whitespace

### ToDo
- Up/down strokes
- Finger annotations for pulls/bends/hammers
- Tuples (triplets, etc.)
- chord labels
- Build AST
    - Add elements to section node
    - Modifiers
        - Up/downstroke
- Integrate with Renderer (VexArtist, etc.)
- Section options

### Done
- Improve section parsing to not require globals
- Option parsing shift/reduce conflict
- Time durations
- Sections
- Pre-def substitution and parsing
- Notes
    - Strings
    - Fret groups
    - Fingerings
    - Mutes
- Bars
- Hammers/pulls/bends/slides
- Comments
- Identify pre-def lines
- Repeat measure
- Group modifiers
    - multiply
- Rests
- AST
    - Fret notes
    - Durations
    - Bars
    - Section Statements
    - Groups
    - Pre-defs
    - Chords
    - Rests

### Syntax Examples

```
# sections define a break in the staves.  otherwise, wrap naturally
section type=tab tuning=standard
t8  0.4 0.5 0.6 0.4 0.5 0.6 0.4 0.6 |
t8  0.4 0.5 0.6 0.4 t4  0.4 0.6 |
t1  (0.1 2.2 2.3 1.4 0.5 0.6) |
t8  0.4 0.5 0.6 0.4 t4 0.4 0.6 | t1 0.1 |
t8  0h12p0.4 0.5 0.6 0.4 t4 0.4 0.6 | t1 0.1 |

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
t8  0h2p0.4 0.5 2b3b2.4 t4 0.4 0.6 |

# slides
t8  0.4 /2.4 \0.4 0.5 0.6 0.4 t4 0.4 0.6 |
t8  0/2\0.4 0.5 0.6 0.4 t4 0.4 0.6 |

# mutes
t8  0.4 x.5 x.6 0.4 t4 0.4 0.6 |

# upstroke / downstroke
t8  [0u-1d-3u-1d-0u.6]  |
t8  [("e")u ("e")d]*2

# grouping notes has no effect by itself
t8  [0.4 0.5 0.6] [0.4 0.5 0.6] [0.4 0.6] |
t8  [0.4 0.5] [0.6 0.4 0.5 0.6 0.4] [0.6] |

# triplets
t8  [0.4 0.5 0.6]^3*4 |

# repeat an element
t8  [0.4 0.5 0.6]^3*4
t8  |: 0.4*4 1.4*4 3.4*4 1.4*4 :|

# multiple notes per string
t8  0-2.3 t4 0-1-3.4

# pre-def syntax
c_to_g->    t4 3.1 3.1 0.2 2.2 |

# re-usable code snippets
# pre-defines are not included until you invoke them
#   with square brackets
# should work recursively
# should be able to use already defined pre-defs in
#   subsequent pre-defs
# scope pre-defs to each section?

g_chord->   (3.1 2.2 0.3 0.4 0.5 3.6)

section type=tab
g_bass_1->  t4 [3.1 0.3]x2 |
g_bass_2->  t4 [3.1 t8 ["g_chord"]x2]x2 |
c_bass->    t4 [3.2 2.3]x2 |
fill_1->    t4 3.1 3.1 0.2 2.2 |
["g_bass_1"]x3 ['ctog'] ["c_bass"]x4 ["g_bass_2"]x3 t1 3.1

section type=tab
fill_1->    t4 3.1 3.1 0.2 2.2 |
[t4 ["g_chord"]x4 ["fill_1"]]x2

# repeat measures
t4  0.1 chord(e) 0.1 chord(e) | % | % | % |

# chords above tab
# NOTE: should make it easy just to use whatever
#       text you want, yeah?
section type=tab
g_bass->    t4 [3.1 0.3]x2 |
c_bass->    t4 [3.2 2.3]x2 |

[chord("G") ["g_bass"] chord("C") ["c_bass"]]x4
# shorthand?
[c("G") ["g_bass"] c("C") ["c_bass"]]x4

# fingering
t8 (1.1f1 3.2f4 3.3f3 2.4f2 1.5f1 1.6f1)

# fingers with upstroke/downstroke
# NOTE: not a huge fan
t8 (1f1u.1 3f4d.2 3f3u.3 2f2d.4 1f1u.5 1f1d.6)

# rests take same time
t8 [0.1]x3 r t4 0.1 0.3 r 0.3 |

```