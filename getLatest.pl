#!/usr/bin/perl

use LWP::Simple;
use JSON::PP;
use Data::Dump qw(dump);

use warnings;
use strict;

my $allPicturesRaw = get("https://epic.gsfc.nasa.gov/api/natural/all?year=2019&month=6");
my $allPictures = decode_json $allPicturesRaw;

#print dump $allPictures;
my $latestDay = $allPictures->[0]->{'date'};
my ($year, $month, $day) = split /-/, $latestDay;

# https://epic.gsfc.nasa.gov/api/enhanced/date/20190627
my $imagesForLatestDayRaw = get("https://epic.gsfc.nasa.gov/api/enhanced/date/$year$month$day");
my $imagesForLatestDay = decode_json $imagesForLatestDayRaw;

my $latestImage = $imagesForLatestDay->[-1]->{'identifier'};

#   identifier => 20190627131403,
#   image => "epic_RGB_20190627131403",
print $latestImage.$/;
my $url = "https://epic.gsfc.nasa.gov/archive/natural/$year/$month/$day/png/epic_1b_$latestImage.png";

print "$url\n";

getstore("https://epic.gsfc.nasa.gov/archive/natural/$year/$month/$day/png/epic_1b_$latestImage.png", "$latestImage.png");
