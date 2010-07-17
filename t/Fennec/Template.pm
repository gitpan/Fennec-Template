package TEST::Fennec::Template;
use strict;
use warnings;
use Fennec;
use Fennec::Runner;

tests load {
    ok( !'Fennec::Runner'->can( 'templates' ), "Can't 'templates'" );
    require_ok( 'Fennec::Template' );
    can_ok( 'Fennec::Runner', 'templates' );
}

1;
