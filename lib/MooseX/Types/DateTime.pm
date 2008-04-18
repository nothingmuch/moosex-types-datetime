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
class_type "DateTime::TimeZone";
class_type "DateTime::Locale::root" => { name => "DateTime::Locale" };

coerce "DateTime" => (
    from "Int",
    via { DateTime->from_epoch( epoch => $_ ) },
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

A coercion from C<Int> using L<DateTime/from_epoch> is defined.

=item L<DateTime::Locale>

Coerces from C<Str>, where the string is the language tag, e.g. C<en> etc. See
L<DateTime::Locale/load>.

=item L<DateTime::TimeZone>

Coerces from C<Str> where the string is any time zone name.

The string may also be a number of special values (C<local>, C<floating>,
offsets, etc). See L<DateTime::TimeZone/USAGE> for details.

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
