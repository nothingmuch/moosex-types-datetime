#!/usr/bin/perl -w

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'MooseX::Types::DateTime',
	VERSION_FROM => 'lib/MooseX/Types/DateTime.pm',
	INSTALLDIRS  => 'site',
	SIGN         => 1,
	PL_FILES     => { },
    PREREQ_PM => {
        'Moose'              => '0.41', # class_type
        'DateTime'           => 0,
        'DateTime::Locale'   => 0,
        'DateTime::TimeZone' => 0,
        'Test::use::ok'      => 0,
        'Test::Exception'    => 0,
    },
);

