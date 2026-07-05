% vim: ft=prolog fdm=marker

% Figure 3: The type language for complete types. This is a regular language.
% ------------------------------------------------------------------------------ {{{
%
% τ ::= M μ
% μ ::= H η | K κ | AV  | HV  | CV  | IO
% η ::= : AV, HV, CV, IO, κ
% κ ::= P τ | N ν | PV
% ν ::= IV  | DV
% }}}

% Table 1: Terminal Types and their Meaning
% ------------------------------------------------------------------------------ {{{
%
% Perl Type | Overlay Type | Meaning
% ----------+--------------+--------------------------------
%      AV   | M AV         | Array
%      HV   | M HV         | Hash (associative array)
%      CV   | M CV         | Code (subroutine, usually)
%      IO   | M IO         | File Handle
%      PV   | M K PV       | String
%      IV   | M K N IV     | Integer
%      NV   | M K N DV     | Double Floating Point
% }}}


% Figure 4: The type language after introducing type variables.
% ------------------------------------------------------------------------------ {{{
%
% τ ::= M µ | α_τ
% μ ::= H η |  K κ |  AV | HV | CV | IO
% η ::= : AV, HV, CV, IO, κ
% κ ::= P τ | N ν  | PV  | α_κ
% ν ::= IV  | DV   | α_ν
% }}}
