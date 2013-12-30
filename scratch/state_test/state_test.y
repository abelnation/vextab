
%start root

%ebnf

%{
  
%}

%%

root
  : statements EOF
    { $$ = $1.join("\n"); console.log($$); }
  | EOF
    { $$ = ""; }
  ;

statements
  : statement
    { $$ = [$1]; }
  | statements statement
    { $$ = $1; $1.push($2); }
  ;

statement
  : "[" statements "]"
    { $$ = $2.join("\n"); }
  | "[" QUOTED_ID "]"
    { $$ = (defines[$2] ? defines[$2] : ""); }
  | bar_token
    { $$ = $1; }
  | REPEAT_MEASURE
    { $$ = "REPEAT"; }
  | DURATION
    { $$ = "d" + $1; }
  | note_token
    { $$ = $1; }
  | SECTION options
    { $$ = "sec: " + $2; }
  | DEFINE  REST_OF_LINE
    { 
      defines[$1] = $2;
      // $$ = $1 + ": " + $2; 
    }
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
        $$.push("st: " + $3 + " fr: " + $1[i]);
      }
      $$ = $$.join("\n");
    }
  | fret_group "." INTEGER finger_annotation
    { 
      $$ = [];
      for (var i=0; i<$1.length; i++) { 
        $$.push("st: " + $3 + " fr: " + $1[i] + "fi: " + $4);
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
    { $$ = $1; }
  | MUTE
    { $$ = "x"; }
  | INTEGER FINGER
    { $$ = $1 + "f" + $2; }
  | MUTE FINGER
    { $$ = "x" + "f" + $2; }
  ;

articulated_fret_note
  : BEND
    { $$ = "b"+$1; }
  | HAMMERON
    { $$ = "h"+$1; }
  | PULLOFF
    { $$ = "p"+$1; }
  | SLIDE_UP
    { $$ = "/"+$1; }
  | SLIDE_DOWN
    { $$ = "\\"+$1; }
  ;

bar_token
  : SINGLE_BAR
    { $$ = "SINGLE_BAR"; }
  | DOUBLE_BAR
    { $$ = "DOUBLE_BAR"; }
  | REPEAT_CLOSEOPEN
    { $$ = "REPEAT_OPENCLOSE"; }
  | REPEAT_OPEN
    { $$ = "REPEAT_OPEN"; }
  | REPEAT_CLOSE
    { $$ = "REPEAT_CLOSE"; }
  ;

/* OPTIONS State */
/* ============= */
options
  : options OPTION
    { $$ = $1; $$.push($2); }
  | OPTION
    { $$ = [$1]; }
  ;

%% 

var defines = {};
