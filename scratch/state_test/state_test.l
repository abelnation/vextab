
%x FINISHLINE OPTIONS

%{
  // Data/Functions made available to lexer actions go here
  var duration_map = {
    'w': '1',
    'h': '2',
    'q': '4',
    '1': '1',
    '2': '2',
    '4': '4',
    '8': '8',
    '16': '16',
    '32': '32',
    '64': '64',
  }
%}

// Lexer macros go here.
// Macros are not an actual rule, just shortcuts used by rules
// Use a macro in the lexer actions by wrapping it in curly brackets
NL                        [\n\r]
HSPC                      [ \t]

DIGIT                     [0-9]
        
DURATION_LENGTH           [qhw]|"16"|"32"|"64"|[1248]

ID                        [a-zA-Z_][a-zA-Z0-9_]*

%%

[\s]                      /* ignore whitespace */
"#".*                     /* ignore comments to end of line */
<<EOF>>                   return "EOF"

/* State-changing identifiers */
/* ========================== */

"section"                 {
                            this.begin("OPTIONS"); 
                            return "SECTION";
                          }
{ID}{HSPC}*"->"           {
                            this.begin("FINISHLINE"); 
                            yytext = yytext.replace("->", "").trim();
                            return "DEFINE";
                          }

/* Tab tokens */
/* ========== */

/* Timing duration tokens */
"t""."?{DURATION_LENGTH}    { 
                            if (yytext.charAt(1) == ".") {
                              yytext = "." + duration_map[yytext.slice(2)];
                            } else {
                              yytext = duration_map[yytext.slice(1)];
                            }
                            if(yytext) {
                              return "DURATION"; 
                            }
                          }

[xX]                      return "MUTE"
"%"                       return "REPEAT_MEASURE"

"||"                      return "DOUBLE_BAR"
":|:"                     return "REPEAT_CLOSEOPEN"
"|:"                      return "REPEAT_OPEN"
":|"                      return "REPEAT_CLOSE"
"|"                       return "SINGLE_BAR"

"b"{DIGIT}+               { yytext = yytext.slice(1); return "BEND" }
"h"{DIGIT}+               { yytext = yytext.slice(1); return "HAMMERON" }
"p"{DIGIT}+               { yytext = yytext.slice(1); return "PULLOFF" }
"/"{DIGIT}+               { yytext = yytext.slice(1); return "SLIDE_UP" }
"\\"{DIGIT}+              { yytext = yytext.slice(1); return "SLIDE_DOWN" }

"f"({DIGIT}|[tT])         { 
                            yytext = yytext.slice(1).toUpperCase();
                            if( !/[tT]/.test(yytext) ) {
                              yytext = parseInt(yytext);
                            } 
                            return "FINGER"
                          }

/* using a pre-def */
('"'{ID}'"')|("'"{ID}"'") { 
                            yytext = yytext.slice(1,-1);
                            return "QUOTED_ID"; 
                          }

/* standard types */
/* ============== */
{DIGIT}+                  return "INTEGER";

/* Special state rules */
/* =================== */

/* After a section token, options are parsed to the end of the line */
<OPTIONS>[ \t]            /* ignore horizontal whitespace */
<OPTIONS>{ID}"="\w*       return "OPTION"
<OPTIONS>{NL}             this.begin("INITIAL")

/* After consuming the rest of a line, return to initial state */      
<FINISHLINE>.*            {
                            this.begin("INITIAL");
                            yytext = yytext.trim();
                            return "REST_OF_LINE";
                          }

"("                       return "("
")"                       return ")"
"."                       return "."
"["                       return "["
"]"                       return "]"
":"                       return ":"
"^"                       return "^"
"-"                       return "-"
'"'                       return '"';
"'"                       return "'"
