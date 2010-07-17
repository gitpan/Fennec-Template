package Fennec::Template::Basic;
use strict;
use warnings;

use Fennec::Template;

S({ name => 'Basic Template' });

tests load {
    my $package = $self->fennec_meta->stash->{ testing };
    if ( $package ) {
        eval 'require_ok( $package ); 1' || die( $@ );
    }
    else {
        SKIP(
            sub { 1 },
            'Could not determine package to test, set: S( testing => $CLASS )',
        );
    }
}

1;

__END__

=pod

=head1 NAME

Fennec::Template::Basic - The most basic template

=head1 DESCRIPTION

This template will require_ok() the package specified in your tests meta data
stash under the key 'testing'.

=head1 SEE ALSO

L<Fennec> and L<Fennec::Template>

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec-Template is free software; Standard perl licence.

Fennec-Template is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
