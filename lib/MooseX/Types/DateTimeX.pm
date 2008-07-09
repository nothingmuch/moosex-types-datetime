package MooseX::Types::DateTimeX;

use strict;
use warnings;

use DateTime;
use DateTime::Duration;
use DateTimeX::Easy; 
use Time::Duration::Parse qw(parse_duration);
use MooseX::Types::DateTime ();
use MooseX::Types::Moose qw/Num HashRef Str/;

use namespace::clean;

use MooseX::Types -declare => [qw( DateTime Duration)];

=head1 NAME

MooseX::Types::DateTimeX - Extensions to L<MooseX::Types::DateTime>

=head1 SYNOPSIS

    package MyApp::MyClass;

    use MooseX::Types::DateTimeX qw( DateTime );

    has created => (
        isa => DateTime,
        is => "rw",
        coerce => 1,
    );

    my $instance = MyApp::MyClass->new(created=>'January 1, 1980');
    print $instance->created->year; # is 1980

    ## Coercions from the base type continue to work as normal.
    my $instance = MyApp::MyClass->new(created=>{year=>2000,month=>1,day=>10});

Please see the test case for more example usage.

=head1 DESCRIPTION

This module builds on L<MooseX::Types::DateTime> to add additional custom
types and coercions.  Since it builds on an existing type, all coercions and
constraints are inherited.

=head1 SUBTYPES

This module defines the following additional subtypes.

=head2 DateTime

Subtype of 'DateTime'.  Adds an additional coercion from strings.

Uses L<DateTimeX::Easy> to try and convert strings, like "yesterday" into a 
valid L<DateTime> object.  Please note that due to ambiguity with how different
systems might localize their timezone, string parsing may not always return 
the most expected value.  IN general we try to localize to UTC whenever
possible.  Feedback welcomed!

=cut

subtype DateTime, as MooseX::Types::DateTime::DateTime;

coerce( DateTime,
    @{ $MooseX::Types::DateTime::coercions{DateTime} },
    from Str, via { DateTimeX::Easy->new($_) },
);


=head2 Duration

Subtype of 'DateTime::Duration' that coerces from a string.  We use the module
L<Time::Duration::Parse> to attempt this.

=cut

subtype Duration, as MooseX::Types::DateTime::Duration;

coerce( Duration,
    @{ $MooseX::Types::DateTime::coercions{"DateTime::Duration"} },
    from Str, via { 
        DateTime::Duration->new( 
            seconds => parse_duration($_)
        );
    },
);

=head1 AUTHOR

John Napiorkowski E<lt>jjn1056 at yahoo.comE<gt>

=head1 LICENSE

    Copyright (c) 2008 John Napiorkowski.

    This program is free software; you can redistribute
    it and/or modify it under the same terms as Perl itself.

=cut

1;
