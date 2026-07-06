% vim: ft=prolog fdm=marker
% prolog-dialect: SWI-Prolog

% Figure 3: The type language for complete types. This is a regular language.
% ------------------------------------------------------------------------------ {{{
%
% τ ::= M μ                                  % tau
% μ ::= H η | K κ | AV  | HV  | CV  | IO     % mu
% η ::= : AV, HV, CV, IO, κ                  % eta
% κ ::= P τ | N ν | PV                       % kappa
% ν ::= IV  | DV                             % nu
% }}}

% p_o( ?PerlType, ?OverlayType ).
%
% Table 1: Terminal Types and their Meaning
% ------------------------------------------------------------------------------ {{{
%
% Perl Type | Overlay Type | Meaning
% ----------+--------------+--------------------------------
%      AV   | M AV         | Array
p_o( p_AV   , m(av)        ).
%      HV   | M HV         | Hash (associative array)
p_o( p_HV   , m(hv)        ).
%      CV   | M CV         | Code (subroutine, usually)
p_o( p_CV   , m(cv)        ).
%      IO   | M IO         | File Handle
p_o( p_IO   , m(io)        ).
%      PV   | M K PV       | String
p_o( p_PV   , m(k(pv))     ).
%      IV   | M K N IV     | Integer
p_o( p_IV   , m(k(n(iv)))  ).
%      NV   | M K N DV     | Double Floating Point
p_o( p_NV   , m(k(n(dv)))  ).
% }}}


% Figure 4: The type language after introducing type variables.
% ------------------------------------------------------------------------------ {{{
%
% τ ::= M µ | α_τ                            % tau
% μ ::= H η |  K κ |  AV | HV | CV | IO      % mu
% η ::= : AV, HV, CV, IO, κ                  % eta
% κ ::= P τ | N ν  | PV  | α_κ               % kappa
% ν ::= IV  | DV   | α_ν                     % nu
% }}}


% type_of(+Gamma, +Expression, -Type). {{{

% Look up variable. {{{
type_of(Gamma, var(X), T) :-
	memberchk(X-T, Gamma).
% }}}

% Constant (literals) {{{
type_of(_, const_IV(_), T) :- p_o(p_IV, T).
type_of(_, const_NV(_), T) :- p_o(p_NV, T).
type_of(_, const_PV(_), T) :- p_o(p_PV, T).
% TODO need the boolean SPECIAL: sv_yes, sv_no
% }}}
