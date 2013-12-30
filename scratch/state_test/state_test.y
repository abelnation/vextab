
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
  | BEND
    { $$ = "bend: " + $1; }
  | HAMMERON
    { $$ = "hammer: " + $1; }
  | PULLOFF
    { $$ = "pulloff: " + $1; }
  | SLIDE_UP
    { $$ = "slideup: " + $1; }
  | SLIDE_DOWN
    { $$ = "slidedown: " + $1; }
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
  : fret_marker
    {}
  ;

fret_marker
  : fret_group "." INTEGER
    { 
      $$ = [];
      for (var i=0; i<$1.length; i++) { 
        $$.push("st: " + $3 + " fr: " + $1[i]);
      }
      $$ = $$.join("\n");
    }
  ;

fret_group
  : fret_group "-" INTEGER
    { $$ = $1; $$.push($3); }
  | INTEGER
    { $$ = [$1]; }
  ;

finger_annotation
  : "f" INTEGER
    { $$ = "fi: " + $2; }
  | "f" MUTE
    { $$ = "fi: x"; }
  | "f" THUMB
    { $$ = "fi: T"; }
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
