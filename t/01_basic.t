#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

use ok 'MooseX::Types::DateTime';

use Moose::Util::TypeConstraints;

isa_ok( find_type_constraint($_), "Moose::Meta::TypeConstraint" ) for qw(DateTime DateTime::TimeZone DateTime::Locale);

{
    {
        package Foo;
        use Moose;

        has date => (
            isa => "DateTime",
            is  => "rw",
            coerce => 1,
        );
    }

    my $epoch = time;

    my $coerced = Foo->new( date => $epoch )->date;

    isa_ok( $coerced, "DateTime", "coerced epoch into datetime" );

    is( $coerced->epoch, $epoch, "epoch is correct" );

    throws_ok { Foo->new( date => "junk1!!" ) } qr/DateTime/, "constraint";
}

{
    {
        package Bar;
        use Moose;

        has time_zone => (
            isa => "DateTime::TimeZone",
            is  => "rw",
            coerce => 1,
        );
    }

    my $tz = Bar->new( time_zone => "Africa/Timbuktu" )->time_zone;

    isa_ok( $tz, "DateTime::TimeZone", "coerced string into time zone object" );

    like( $tz->name, qr/^Africa/, "correct time zone" );

    dies_ok { Bar->new( time_zone => "Space/TheMoon" ) } "bad time zone";
}

{
    {
        package Gorch;
        use Moose;

        has loc => (
            isa => "DateTime::Locale",
            is  => "rw",
            coerce => 1,
        );
    }

    my $loc = Gorch->new( loc => "he_IL" )->loc;

    isa_ok( $loc, "DateTime::Locale::he" );

    dies_ok { Gorch->new( loc => "not_a_place_or_a_locale" ) } "bad locale name";

    SKIP: {
        skip "No Locale::Maketext", 2 unless eval { require Locale::Maketext };
        
        {
            package Some::L10N;
            our @ISA = qw(Locale::Maketext);

            package Some::L10N::ja;
            our @ISA = qw(Some::L10N);

            our %Lexicon = (
                goodbye => "sayonara",
            );
        }

        my $handle = Some::L10N->get_handle("ja");

        isa_ok( $handle, "Some::L10N", "maketext handle" );

        isa_ok( Gorch->new( loc => $handle )->loc, "DateTime::Locale::ja", "coerced from maketext" );;
    }
}
