Definitions.

WHITESPACE  =   [\s\t\n\r]
DIGIT       =   [0-9]
LETTER      =   [a-z,A-Z]
CHAR        =   ({LETTER}|{DIGIT})
INT         =   {DIGIT}+
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
NOT             =   not
FORALL          =   forall
EXISTS          =   exists

Rules.

{AND}           : {token, {'and', TokenLine}}.
{OR}            : {token, {'or', TokenLine}}.
{NOT}           : {token, {'not', TokenLine}}.
{FORALL}        : {token, {'forall', TokenLine}}.
{EXISTS}        : {token, {'exists', TokenLine}}.

{DEFINE}        : {token, {define, TokenLine}}.
{DOMAIN}        : {token, {domain, TokenLine}}.
{PREDICATES}    : {token, {predicates, TokenLine}}.
{ACTION}        : {token, {action, TokenLine}}.
{PRECONDITION}  : {token, {precondition, TokenLine}}.
{EFFECT}        : {token, {effect, TokenLine}}.
{TYPES}         : {token, {types, TokenLine}}.
{REQUIREMENTS}  : {token, {requirements, TokenLine}}.

\(              : {token, {'(', TokenLine}}.
\)              : {token, {')', TokenLine}}.
\-              : {token, {'-', TokenLine}}.

{INT}           : {token, {int, TokenLine, TokenChars}}.
{NAME}          : {token, {name, TokenLine, list_to_binary(TokenChars)}}.
{IDENTIFIER}    : [$?|ID] = TokenChars, {token, {name, TokenLine, list_to_binary(ID)}}.

{WHITESPACE}+   : skip_token.

Erlang code.
