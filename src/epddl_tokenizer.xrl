Definitions.

WHITESPACE  =   [\s\t\n\r]
DIGIT       =   [0-9]
LETTER      =   [a-z,A-Z]
CHAR        =   ({LETTER}|{DIGIT})
INT         =   {DIGIT}+
NUMBER      =   {INT}(\.{INT}+)?
NAME        =   {LETTER}{CHAR}*
IDENTIFIER  =   \?{NAME}
STRING      =   \"(\\.|[^"])*\"

DEFINE          =   define
DOMAIN          =   domain
AT              =   at
START           =   start
END             =   end
REQUIREMENTS    =   :requirements
PREDICATES      =   :predicates
ACTION          =   :action
PARAMETERS      =   :parameters
PRECONDITION    =   :precondition
EFFECT          =   :effect
TYPES           =   :types
DURATION        =   :duration
REQUIREMENT     =   :{NAME}

AND             =   and
OR              =   or
PROBABILISTIC   =   probabilistic
NOT             =   not
FORALL          =   forall
EXISTS          =   exists

Rules.

{AND}           : {token, {'and', TokenLine}}.
{OR}            : {token, {'or', TokenLine}}.
{PROBABILISTIC} : {token, {'probabilistic', TokenLine}}.
{NOT}           : {token, {'not', TokenLine}}.
{FORALL}        : {token, {'forall', TokenLine}}.
{EXISTS}        : {token, {'exists', TokenLine}}.

{DEFINE}        : {token, {define, TokenLine}}.
{DOMAIN}        : {token, {domain, TokenLine}}.
{PARAMETERS}    : {token, {parameters, TokenLine}}.
{PREDICATES}    : {token, {predicates, TokenLine}}.
{ACTION}        : {token, {action, TokenLine}}.
{PRECONDITION}  : {token, {precondition, TokenLine}}.
{DURATION}      : {token, {duration, TokenLine}}.
{EFFECT}        : {token, {effect, TokenLine}}.
{TYPES}         : {token, {types, TokenLine}}.
{REQUIREMENTS}  : {token, {requirements, TokenLine}}.
{AT}            : {token, {at, TokenLine}}.
{START}         : {token, {'start', TokenLine}}.
{END}           : {token, {'end', TokenLine}}.

\(              : {token, {'(', TokenLine}}.
\)              : {token, {')', TokenLine}}.
\-              : {token, {'-', TokenLine}}.
\=              : {token, {'=', TokenLine}}.
\>              : {token, {'>', TokenLine}}.
\<              : {token, {'<', TokenLine}}.

{INT}           : {token, {number, TokenLine, list_to_integer(TokenChars)}}.
{NUMBER}        : {token, {number, TokenLine, list_to_float(TokenChars)}}.
{NAME}          : {token, {name, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}    : [$?|ID] = TokenChars, {token, {name, TokenLine, list_to_binary(ID)}}.
{STRING}        : Guts = string:strip(TokenChars, both, $\"),
                  {token, {string, TokenLine, list_to_binary(Guts)}}.

{WHITESPACE}+   : skip_token.

Erlang code.
