
%start root

%ebnf

%{
  var ast = require("./state_test.ast")
%}

%%

root
  : sections EOF
    { $$ = new ast.TabRootElement($1, @1); console.log($$.toString()); }
  | EOF
    { $$ = new ast.TabRootElement(); }
  ;

sections
  : statements
    { $$ = new ast.TabSection($1, @1); }
  | sections section
    { $$ = $1; $$.push($2); }
  | section
    { $$ = [$1]; }
  ;

section
  : SECTION options NL statements
    { $$ = new ast.TabSection($4, @1, $2); }
  | SECTION NL statements
    { $$ = new ast.TabSection($3, @1); }
  ;

statements
  : statement
    { 
      if ($1 != undefined) { $$ = [$1]; } 
      else { $$ = []; }
    }
  | statements statement
    { 
      $$ = $1; 
      if($1) { $1.push($2); } 
    }
  ;

statement
  : statement_group
    { $$ = $1; }
  | DEFINE statements NL
    { 
      defines[$1] = new ast.PredefinedElement($1, $2, @1);
      $$ = defines[$1]
    }
  | predefine_invoke
    { $$ = $1; }
  | chord
    { $1 = $1; }
  | bar_token
    { $$ = $1; }
  | REPEAT_MEASURE
    { $$ = new ast.RepeatMeasureElement(@1); }
  | REST
    { $$ = new ast.RestElement(@1); }
  | DURATION
    { $$ = new ast.DurationElement($1, @1); }
  | note_token
    { $$ = $1; }
  ;

statement_group
  : "[" statements "]"
    { $$ = new ast.GroupElement($2, @1); }
  | "[" statements "]" "*" INTEGER
    { $$ = new ast.GroupElement($2, @2, { repeat: parseInt($5) }); }
  ;

predefine_invoke
  : "[" QUOTED_ID "]"
    %{ 
      if (defines[$2]) { $$ = new ast.PredefinedInvokeElement(defines[$2], @2); } 
      else { $$ = undefined; }
    %}
  | "[" QUOTED_ID "]" "*" INTEGER
    %{ 
      if (defines[$2]) { $$ = new ast.PredefinedInvokeElement(defines[$2], @2, { repeat: parseInt($5) }); } 
      else { $$ = undefined; }
    %}
  ;

chord
  : "(" note_tokens ")"
    { $$ = new ast.ChordElement($2, @2); }
  ;

note_tokens
  : note_token
    { $$ = [$1]; }
  | note_tokens note_token
    { $$ = $1; $1.push($2); }
  ;

note_token
  : string_fret_marker
    { $$ = $1; }
  ;

string_fret_marker
  : fret_group "." INTEGER
    { 
      $$ = [];
      for (var i=0; i<$1.length; i++) {
        $$.push( fretElemForValues($3, $1[i], @1) )
      }
      $$ = $$.join("\n");
    }
  ;

fret_group
  : fret_group "-" fret_note 
    { $$ = $1; $$.push($3); }
  | fret_group articulated_fret_note
    { $$ = $1; $$.push($2); }
  | fret_note
    { $$ = [$1]; }
  | articulated_fret_note
    { $$ = [$1]; }
  ;

fret_note
  : INTEGER
    { $$ = ["",$1]; }
  | MUTE
    { $$ = ["x"]; }
  | INTEGER FINGER
    { $$ = ["", $1, {"finger": $2}] }
  | MUTE FINGER
    { $$ = ["x","x", {"finger": $2}] }
  ;

articulated_fret_note
  : BEND
    { $$ = ["b",$1]; }
  | HAMMERON
    { $$ = ["h",$1]; }
  | PULLOFF
    { $$ = ["p",$1]; }
  | SLIDE_UP
    { $$ = ["/",$1]; }
  | SLIDE_DOWN
    { $$ = ["\\",$1]; }
  ;

bar_token
  : SINGLE_BAR
    { $$ = new ast.SingleBarElement(@1); }
  | DOUBLE_BAR
    { $$ = new ast.DoubleBarElement(@1); }
  | REPEAT_CLOSEOPEN
    { $$ = new ast.RepeatCloseOpenBarElement(@1); }
  | REPEAT_OPEN
    { $$ = new ast.RepeatOpenBarElement(@1); }
  | REPEAT_CLOSE
    { $$ = new ast.RepeatCloseBarElement(@1); }
  ;

/* OPTIONS State */
/* ============= */
options
  : options OPTION
    %{ 
      $$ = $1
      var tokens = $2.split("=");
      $$[tokens[0]] = new ast.OptionElement(tokens[0], tokens[1], @2); 
    %}
  | OPTION
    %{ 
      var tokens = $1.split("=");
      $$ = {};
      $$[tokens[0]] = new ast.OptionElement(tokens[0], tokens[1], @1); 
    %}
  ;

%% 

var defines = {};

function fretElemForValues(string, fret_values, loc) {
  var type = fret_values[0];
  var fretNum = fret_values[1];
  var options = fret_values[2];
  if (type == "") {
    return new ast.FretNoteElement(string, fretNum, loc, options);
  } else if (type === "x") {
    return new ast.FretMuteElement(string, loc, options);
  } else if (type === "b") {
    return new ast.FretBendNoteElement(string, fretNum, loc, options);
  } else if (type === "h") {
    return new ast.FretHammerOnNoteElement(string, fretNum, loc, options);
  } else if (type === "p") {
    return new ast.FretPullOffNoteElement(string, fretNum, loc, options);
  } else if (type === "\\") {
    return new ast.FretSlideDownNoteElement(string, fretNum, loc, options);
  } else if (type === "/") {
    return new ast.FretSlideUpNoteElement(string, fretNum, loc, options);
  } 
}
