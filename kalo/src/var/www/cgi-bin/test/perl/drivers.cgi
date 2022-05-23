#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use DBI;

my $cgi = new CGI();


my @driver_names = DBI->available_drivers;
print $cgi->header();
for my $driver (@driver_names) {        print $cgi->span($driver, $cgi->br); }

