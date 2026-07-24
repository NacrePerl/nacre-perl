# make-dialect: GNU Make

## check_and_clone {{{
##
## SYNOPSIS
##
##   check_and_clone(git_repository_url,clone_path)
##
## DESCRIPTION
##
## Checks to see if the C<clone_path> is an existing git work tree otherwise
## clone from C<git_repository_url>.
##
define check_and_clone
	{ { [ -d '$(2)' ] \$(ch_empty)
		&& [ `git -C '$(2)' rev-parse --is-inside-work-tree` = 'true' ] \$(ch_empty)
		&& [ -e '$(2)'/.git ] ; } \$(ch_empty)
			|| git clone '$(1)' '$(2)' \$(ch_empty)
		; }
endef
## }}}

## symlink_up_down {{{
##
## SYNOPSIS
##
##   symlink_up_down(repo_slug)
##
## DESCRIPTION
##
## Walks up from the Git repository main working tree as long as directories
## match the C<basename> of the Git repository and looks for the C<basename> of
## C<repo_slug> then descends into repeatedly looking for a Git repository that
## matches the C<basename> of C<repo_slug>.
##
define symlink_up_down_PERL
use autodie;
use Git::Wrapper;
use Path::Tiny;
my $$repo = path(shift);
my $$git_wt = Git::Wrapper->new('.');
my @git_rp_opt = ('--path-format=absolute');
my $$git_cd = Git::Wrapper->new(
	path($$git_wt->rev_parse(@git_rp_opt, '--git-common-dir'))->parent
);
my $$dir_top = path($$git_cd->rev_parse(@git_rp_opt, '--show-toplevel' ));
my $$w = $$dir_top;
$$w = $$w->parent while $$w->basename eq $$dir_top->basename
	&& ! $$w->child($$repo->basename)->is_dir;
my $$t = $$w;
while($$t->is_dir && ! $$t->child('.git')->exists) {
	$$t = $$t->child($$repo->basename);
}
die "No directory @{[ $$repo->basename ]} under $$w to symlink.\n" unless $$t->is_dir;
my $$target_symlink = path('vendor')->child($$repo);
$$target_symlink->parent->mkdir;
$$target_symlink->exists or symlink $$t->relative($$target_symlink->parent), $$target_symlink;
endef
export symlink_up_down_PERL
define symlink_up_down
perl -e "$$symlink_up_down_PERL" '$(1)'
endef
## }}}

# vim: fdm=marker
