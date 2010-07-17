package Fennec::Template;
use strict;
use warnings;
use Fennec::Runner qw/add_config add_test_hook/;
use Fennec::Util::PackageFinder;

add_config 'templates';

add_test_hook( sub {
    my ( $runner, $test ) = @_;
    my @templates = (
        @{ $runner->templates || []},
        @{ $test->fennec_meta->stash->{ templates } || []}
    );
    for my $template ( @templates ) {
        my $class = load_package( $template, 'Fennec::Template' );
        $class->_process( $test );
    }
});

1;
