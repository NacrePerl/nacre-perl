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

% OP I_ADD {{{
%
%  Γ ⊢ t1 : M K N IV    Γ ⊢ t2 : M K N IV
% ────────────────────────────────────────
%       Γ ⊢ I_ADD(t1, t2) : M K N IV
type_of(Gamma, binop_I_ADD(T1, T2), T_IV) :-
	p_o(p_IV, T_IV),
	type_of(Gamma, T1, T_IV),
	type_of(Gamma, T2, T_IV).
% }}}

% OP ADD {{{
%
% T_DV dominates over T_IV
type_of(Gamma, binop_ADD(T1, T2), T_DV) :-
	p_o(p_NV, T_DV), p_o(p_IV, T_IV),
	(
%   Γ ⊢ t1 : M K N DV   Γ ⊢ t2 : M K N DV
% ────────────────────────────────────────
%     Γ ⊢ ADD(t1 , t2 ) : M K N DV
	  type_of(Gamma, T1, T_DV), type_of(Gamma, T2, T_DV)
%   Γ ⊢ t1 : M K N IV   Γ ⊢ t2 : M K N DV
% ────────────────────────────────────────
%     Γ ⊢ ADD(t1 , t2 ) : M K N DV
	; type_of(Gamma, T1, T_IV), type_of(Gamma, T2, T_DV)
%   Γ ⊢ t1 : M K N DV   Γ ⊢ t2 : M K N IV
% ────────────────────────────────────────
%     Γ ⊢ ADD(t1 , t2 ) : M K N DV
	; type_of(Gamma, T1, T_DV), type_of(Gamma, T2, T_IV)
	).

%   Γ ⊢ t1 : M K N IV   Γ ⊢ t2 : M K N IV
% ────────────────────────────────────────
%     Γ ⊢ ADD(t1 , t2 ) : M K N IV
%
% IV + IV -> IV
%
% NOTE: This does not take into account the overflow semantics
% where IV ⇒ UV ⇒ NV.
type_of(Gamma, binop_ADD(T1, T2), T_IV) :-
	p_o(p_IV, T_IV),
	type_of(Gamma, T1, T_IV), type_of(Gamma, T2, T_IV).
% }}}


% }}}

:- begin_tests(binop_ADD). % {{{

:- set_test_options([format(log),output(on_failure)]).

test(const_iv_const_iv,
	[
		setup(
			p_o(p_IV, T_IV)
		),
		set( R == [T_IV] )
	]) :-
	type_of([], binop_ADD(const_IV(1), const_IV(2)), R).

test(var_iv_var_iv,
	[
		setup(
			p_o(p_IV, T_IV)
		),
		set( R == [T_IV] )
	]) :-
	type_of([x-T_IV,y-T_IV], binop_ADD(var(x), var(y)), R).

test(var_dv_var_iv,
	[
		setup((
			p_o(p_NV, T_DV), p_o(p_IV, T_IV)
		)),
		set( R == [T_DV] )
	]) :-
	type_of([x-T_DV,y-T_IV], binop_ADD(var(x), var(y)), R).

:- end_tests(binop_ADD). % }}}
