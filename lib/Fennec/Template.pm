package Fennec::Template;
use strict;
use warnings;
use Fennec::Runner;
use Fennec::Template::Runner;
use Fennec::Util::PackageFinder;
use Fennec::Workflow;

our $VERSION = 0.001;

sub import {
    my $class = shift;
    my %proto = @_;
    my( $caller, $line, $file ) = caller;
    Fennec->import( %proto, caller => [ $caller, $line, $file ]);
    my $meta = $caller->fennec_meta;
    my $stash = $meta->stash || {};
    $meta->root_workflow(
        Fennec::Workflow->new(
            "Template{$caller}" => sub { 1 }
        )
    );
    no strict 'refs';
    no warnings 'redefine';
    *{ $caller . '::_process' } = \&_process;
}

sub _process {
    my ( $class ) = shift;
    my ( $test ) = @_;
    my $workflow = $class->fennec_meta->root_workflow->clone();
    my $stash = $class->fennec_meta->stash;
    $workflow->name( $stash->{ name } )
        if $stash and $stash->{ name };
    $workflow->parent( $test );
    'Fennec::Runner'->singleton->process_workflow( $workflow );
};

1;

__END__

=pod

=head1 NAME

Fennec::Template - Test set and workflow templates that can be included in any
Fennec test.

=head1 DESCRIPTION

This allows you to write fennec test files that act as templates instead of
being run independantly. These tests can be included in any Fennec test much
like a role or mixin. These test may contain workflows and testsets, but not
package level assertions. The test files that include templates will run the
test sets and worklfows from that template.

A template is identical to a fennec test file except that it uses
L<Fennec::Template> instead of L<Fennec>. You also may not include package
level tests. S() and M() refer to the templates meta data, and DO NOT effect
any packages that include the template. Use $self->fennec_meta() to gain access
to the test files meta data instead of the templates.

=head1 TEMPLATE SYNOPSIS

    package Fennec::Template::Basic;
    use strict;
    use warnings;

    use Fennec::Template;

    S({ name => 'My Template' });

    # Load the package if the test's meta specifies one.
    # Otherwise skip and provide a diag message explaining how to correct the
    # issue.
    tests load {
        my $package = $self->fennec_meta->stash->{ testing };
        if ( $package ) {
            # This needs to be eval'd to prevent the begin_lift magic from
            # running it too early.
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

=head1 USING THE TEMPLATE

In your Runner script (t/Fennec.t) you should use 'Fennec::Template::Runner'.
Alternatively you can use it at the beginning of any test file that needs
templates. You may also load this for L<Fennec::Standalone> tests.

There are 2 ways to use a template in a test.

=over 4

=item Include a template globaly

In your t/Fennec.t file:

    ...
    use Fennec::Template::Runner;
    'Fennec::Runner'->init(
        ...
        templates => \@Template_Package_List,
    );
    ...

=item Include a template in a specific test only

t/Some/Test.pm

    ...
    use Fennec::Template::Runner; # Or put this in t/Fennec.t
    S( templates => \@Template_Package_List )
    ...

=back

=head1 CAVEATS AND PITFALLS

=over 4

=item No package level tests

This will not work like you expect:

    use strict;
    use warnings;
    use Fennec::Template;

    ok( 1, "This will not appy to test files." );

=item S() and M() are for the template, not the test file

S() and M() refer to the templates meta data, and DO NOT effect any packages
that include the template. Use $self->fennec_meta() to gain access to the test
files meta data instead of the templates.

=back

=head1 INCLUDED TEMPLATES

=over 4

=item L<Fennec::Template::Basic>

The basic template, used to require_ok the package you are testing.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec-Template is free software; Standard perl licence.

Fennec-Template is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
