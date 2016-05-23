Definitions.

WHITESPACE  =   [\s\t\n\r]
DIGIT       =   [0-9]
LETTER      =   [a-z,A-Z]
CHAR        =   ({LETTER}|{DIGIT})
INT         =   {DIGIT}+
FLOAT       =   {INT}\.{INT}
NAME        =   {LETTER}{CHAR}*
IDENTIFIER  =   \?{NAME}

DEFINE          =   define
DOMAIN          =   domain
REQUIREMENTS    =   :requirements
PREDICATES      =   :predicates
ACTION          =   :action
PARAMETERS      =   :parameters
PRECONDITION    =   :precondition
EFFECT          =   :effect
TYPES           =   :types
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
{EFFECT}        : {token, {effect, TokenLine}}.
{TYPES}         : {token, {types, TokenLine}}.
{REQUIREMENTS}  : {token, {requirements, TokenLine}}.

\(              : {token, {'(', TokenLine}}.
\)              : {token, {')', TokenLine}}.
\-              : {token, {'-', TokenLine}}.

{FLOAT}         : {token, {float, TokenLine, list_to_float(TokenChars)}}.
{INT}           : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{NAME}          : {token, {name, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}    : [$?|ID] = TokenChars, {token, {name, TokenLine, list_to_binary(ID)}}.

{WHITESPACE}+   : skip_token.

Erlang code.
