Definitions.

WHITESPACE  =   [\s\t\n\r]
DIGIT       =   [0-9]
LETTER      =   [a-z,A-Z]
CHAR        =   {LETTER}|{DIGIT}
INT         =   {DIGIT}+
NAME        =   {LETTER}({CHAR})+

DEFINE          =   define
DOMAIN          =   domain
PREDICATES      =   :predicates
ACTION          =   :action
PARAMETERS      =   :parameters
PRECONDITION    =   :precondition
EFFECT          =   :effect

Rules.

{INT}           : {token, {int, TokenLine, TokenChars}}.
{NAME}          : {token, {name, TokenLine, TokenChars}}.

\(              : {token, {'(', TokenLine}}.
\)              : {token, {')', TokenLine}}.
\-              : {token, {'-', TokenLine}}.
\?              : {token, {'?', TokenLine}}.

{DEFINE}        : {token, {define, TokenLine}}.
{DOMAIN}        : {token, {domain, TokenLine}}.
{PREDICATES}    : {token, {predicates, TokenLine}}.
{ACTION}        : {token, {action, TokenLine}}.
{PRECONDITION}  : {token, {precondition, TokenLine}}.
{EFFECT}        : {token, {effect, TokenLine}}.

{WHITESPACE}+   : skip_token.

Erlang code.
