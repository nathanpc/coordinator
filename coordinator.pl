#!/usr/bin/env perl

=head1 NAME

C<App::coordinator> - An application to help with tagging photos using GPX files

=cut

package App::coordinator;

use strict;
use warnings;
use autodie;
use utf8;
use OptArgs2 'class_optargs';

use Data::Dumper;
use Image::ExifTool qw(:Public);
use Geo::Gpx;

=head1 METHODS

=over 4

=item I<@points> = C<get_points>(I<$fname>)

Gets all available points from a GPX file given by I<$fname> and returns them
sorted by time (ascending).

=cut

sub get_points {
	my ($fname) = @_;
	my @points = ();

	# Parse GPX file.
	my $gpx = Geo::Gpx->new(input => $fname);

	# Get points from GPX file.
	foreach my $track (@{$gpx->tracks()}) {
		foreach my $segment (@{$track->{segments}}) {
			foreach my $point (@{$segment->{points}}) {
				push @points, $point;
			}
		}
	}

	# Sort points based on time.
	return sort { $a->{time} >= $b->{time} } @points;
}

=item C<main>()

Application's main entry point.

=cut

sub main {
	my @points = get_points('./private/20050117.gpx');
	print Dumper(\@points);

	print Dumper($points[0]->time_datetime());
}

# Run the script.
main();

__END__

=back

=head1 AUTHOR

Nathan Campos <nathan@innoveworkshop.com>

=head1 COPYRIGHT

Copyright (c) 2024- Nathan Campos.

=cut
