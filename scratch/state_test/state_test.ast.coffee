
class TabRootElement
  constructor: (elements = [], loc = null, options = {}) ->
    @type = "TabRootElement"
    @elements = elements

  addElement: (elem) ->
    @elements.push(elem)

  toString: ->
    result = "#{@type}\n"
    result += (element + "\n") for element in @elements
    result

class TabSection
  constructor: (elements = [], loc = null, options={}) ->
    @type = "TabSection"
    @loc = loc
    @options = options
    @elements = elements

  addElement: (elem) ->
    @elements.push(elem)

  toString: ->
    result = "#{@type}: #{JSON.stringify(@loc)}\n  "
    result += (option + " ") for own key,option of @options
    result += (element + "\n") for element in @elements
    result

class TabElement
  constructor: (loc, options = {}) ->
    @type = "TabElement"
    @loc = loc
    @options = options

  toString: ->
    "#{@type}: #{JSON.stringify(@loc)}"

class OptionElement
  constructor: (key, value, loc) ->
    @type = "OptionElement"
    @key = key
    @value = value

  toString: ->
    "#{@key}=#{@value}"

class PredefinedElement
  constructor: (id, statements = [], loc) ->
    @type = "PredefinedElement"
    @loc = loc
    @id = id
    @statements = statements

  toString: ->
    result = "#{@type}: #{@id}"
    result += "\n  #{statement}" for statement in @statements
    result

class PredefinedInvokeElement
  constructor: (node, loc, options = {}) ->
    @type = "PredefinedInvokeElement"
    @loc = loc
    @id = node.id
    @options = options
    @options.repeat ?= 1
    @statements = node.statements

  toString: ->
    result = "#{@type}: #{@id}"
    for i in [0...@options.repeat]
      result += "\n    -- #{i+1}x --" if i != 0
      result += "\n    #{statement}" for statement in @statements
    result

class GroupElement
  constructor: (statements, loc, options = {}) ->
    @type = "GroupElement"
    @loc = loc
    @statements = statements
    
    @options = options
    @options.repeat ?= 1

  toString: ->
    result = "#{@type}: #{JSON.stringify(@loc)}"
    for i in [0...@options.repeat]
      result += "\n    -- #{i+1}x --" if i != 0
      result += "\n    #{statement}" for statement in @statements
    result

# Duration Elements
# =================

class DurationElement extends TabElement
  constructor: (length, loc, options = {}) ->
    super loc, options
    @type = "DurationElement"
    @length = length

  toString: ->
    "#{@type}: #{@length} #{JSON.stringify(@loc)}"

# Fret Elements
# =============
class FretNoteElement extends TabElement
  constructor: (string, fret, loc, options = {}) ->
    super loc, options
    @type = "FretNoteElement"
    @string = string
    @fret = fret
    @options = options

  toString: ->
    "#{@type}: string-#{@string} fret-#{@fret} #{JSON.stringify(@options)}"

class FretMuteElement extends TabElement
  constructor: (string, loc, options = {}) ->
    super loc, options
    @type = "MuteNoteElement"
    @string = string

class FretHammerOnNoteElement extends FretNoteElement
  constructor: (string, fret, loc, options = {}) ->
    super string, fret, loc, options
    @type = "FretHammerOnNoteElement"

class FretPullOffNoteElement extends FretNoteElement
  constructor: (string, fret, loc, options = {}) ->
    super string, fret, loc, options
    @type = "FretPullOffNoteElement"

class FretBendNoteElement extends FretNoteElement
  constructor: (string, fret, loc, options = {}) ->
    super string, fret, loc, options
    @type = "FretBendNoteElement"

class FretSlideDownNoteElement extends FretNoteElement
  constructor: (string, fret, loc, options = {}) ->
    super string, fret, loc, options
    @type = "FretSlideDownNoteElement"

class FretSlideUpNoteElement extends FretNoteElement
  constructor: (string, fret, loc, options = {}) ->
    super string, fret, loc, options
    @type = "FretSlideUpNoteElement"

# Chord Elements
# ==============

class ChordElement extends TabElement
  constructor: (notes, loc, options) ->
    super loc, options
    @type = "ChordElement"
    @notes = notes

  toString: ->
    result = "#{@type}: #{JSON.stringify(@loc)}"
    result += "\n  #{note}" for note in @notes
    result

# Rest Elements
# =============
class RestElement extends TabElement
  constructor: (loc) ->
    super loc
    @type = "RestElement"

# Bar Elements
# ============
class BarElement extends TabElement
  constructor: (loc) ->
    super loc
    @type = "BarElement"

class SingleBarElement extends BarElement
  constructor: (loc) ->
    super loc
    @type = "SingleBarElement"

class DoubleBarElement extends BarElement
  constructor: (loc) ->
    super loc
    @type = "DoubleBarElement"

class RepeatCloseOpenBarElement extends BarElement
  constructor: (loc) ->
    super loc
    @type = "RepeatCloseOpenBarElement"

class RepeatOpenBarElement extends BarElement
  constructor: (loc) ->
    super loc
    @type = "RepeatOpenBarElement"

class RepeatCloseBarElement extends BarElement
  constructor: (loc) ->
    super loc
    @type = "RepeatCloseBarElement"

# Miscellaneous
# =============
class RepeatMeasureElement extends TabElement
  constructor: (loc) ->
    super loc
    @type = "RepeatMeasureElement"


module.exports = 
  TabRootElement: TabRootElement
  TabSection: TabSection
  TabElement: TabElement
  OptionElement: OptionElement
  PredefinedElement: PredefinedElement
  PredefinedInvokeElement: PredefinedInvokeElement
  GroupElement: GroupElement

  FretNoteElement: FretNoteElement
  FretMuteElement: FretMuteElement
  FretHammerOnNoteElement: FretHammerOnNoteElement
  FretBendNoteElement: FretBendNoteElement
  FretPullOffNoteElement: FretPullOffNoteElement
  FretSlideUpNoteElement: FretSlideUpNoteElement
  FretSlideDownNoteElement: FretSlideDownNoteElement
  
  RestElement: RestElement
  DurationElement: DurationElement

  ChordElement: ChordElement

  BarElement: BarElement
  SingleBarElement: SingleBarElement
  DoubleBarElement: DoubleBarElement
  RepeatCloseOpenBarElement: RepeatCloseOpenBarElement
  RepeatOpenBarElement: RepeatOpenBarElement
  RepeatCloseBarElement: RepeatCloseBarElement

  RepeatMeasureElement: RepeatMeasureElement