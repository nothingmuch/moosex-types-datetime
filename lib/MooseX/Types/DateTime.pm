#!/usr/bin/perl

package MooseX::Types::DateTime;

use strict;
use warnings;

our $VERSION = "0.01";

use DateTime ();
use DateTime::Locale ();
use DateTime::TimeZone ();

use Moose::Util::TypeConstraints;

class_type "DateTime";
class_type "DateTime::Duration";
class_type "DateTime::TimeZone";
class_type "DateTime::Locale::root" => { name => "DateTime::Locale" };

coerce "DateTime" => (
    from "Num",
    via { DateTime->from_epoch( epoch => $_ ) },
    from "HashRef",
    via { DateTime->new( %$_ ) },
    Moose::Meta::TypeConstraint->new(
        name => "__ANON__",
        parent => find_type_constraint("Str"),
        constraint => sub { $_ eq 'now' },
        optimise_as => sub { no warnings 'uninitialized'; !ref($_[0]) and $_[0] eq 'now' },
    ),
    via { DateTime->now },
);

coerce "DateTime::Duration" => (
    from "Num",
    via { DateTime::Duration->new( seconds => $_ ) },
    from "HashRef",
    via { DateTime::Duration->new( %$_ ) },
);

coerce "DateTime::TimeZone" => (
    from "Str",
    via { DateTime::TimeZone->new( name => $_ ) },
);

coerce "DateTime::Locale" => (
    from Moose::Util::TypeConstraints::find_or_create_isa_type_constraint("Locale::Maketext"),
    via { DateTime::Locale->load($_->language_tag) },
    from "Str",
    via { DateTime::Locale->load($_) },
);

__PACKAGE__

__END__

=pod

=head1 NAME

MooseX::Types::DateTime - L<DateTime> related constraints and coercions for
Moose

=head1 SYNOPSIS

	use MooseX::Types::DateTime;

    has time_zone => (
        isa => "DateTime::TimeZone",
        is => "rw",
        coerce => 1,
    );

    Class->new( time_zone => "Africa/Timbuktu" );

=head1 DESCRIPTION

This module packages several L<Moose::Util::TypeConstraints> with coercions,
designed to work with the L<DateTime> suite of objects.

=head1 CONSTRAINTS

=over 4

=item L<DateTime>

A class type for L<DateTime>.

=over 4

=item from C<Num>

Uses L<DateTime/from_epoch>. Floating values will be used for subsecond
percision, see L<DateTime> for details.

=item from C<HashRef>

Calls L<DateTime/new> with the hash entries as arguments.

=back

=item L<DateTime::Duration>

A class type for L<DateTime::Duration>

=over 4

=item from C<Num>

Uses L<DateTime::Duration/new> and passes the number as the C<seconds> argument.

Note that due to leap seconds, DST changes etc this may not do what you expect.
For instance passing in C<86400> is not always equivalent to one day, although
there are that many seconds in a day. See L<DateTime/"How Date Math is Done">
for more details.

=item from C<HashRef>

Calls L<DateTime::Duration/new> with the hash entries as arguments.

=back

=item L<DateTime::Locale>

A class type for L<DateTime::Locale::root> with the name L<DateTime::Locale>.

=over 4

=item from C<Str>

The string is treated as a language tag (e.g. C<en> or C<he_IL>) and given to
L<DateTime::Locale/load>.

=item from L<Locale::Maktext>

The C<Locale::Maketext/language_tag> attribute will be used with L<DateTime::Locale/load>.

=item L<DateTime::TimeZone>

A class type for L<DateTime::TimeZone>.

=over 4

=item from C<Str>

Treated as a time zone name or offset. See L<DateTime::TimeZone/USAGE> for more
details on the allowed values.

Delegates to L<DateTime::TimeZone/new> with the string as the C<name> argument.

=back

=head1 VERSION CONTROL

L<http://code2.0beta.co.uk/moose/svn/MooseX-Types-DateTime/trunk>. Ask on
#moose for commit bits.

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=head1 COPYRIGHT

	Copyright (c) 2008 Yuval Kogman. All rights reserved
	This program is free software; you can redistribute
	it and/or modify it under the same terms as Perl itself.

=cut
