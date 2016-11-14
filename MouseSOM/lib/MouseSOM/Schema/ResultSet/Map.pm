package MouseSOM::Schema::ResultSet::Map;
 
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Select a random map for the cover page
sub random_map {
    my ($self) = @_;

    my @maps = &get_maps($self);
    my $map = $maps[int(rand($#maps+1))];

    return $map;
}

# Get an array of all the map files
sub get_maps {
    my ($self) = @_;

    my @maps;

    while (my $row = $self->next) {
	push @maps, join ',', ($row->get_column('map_file'), $row->get_column('id_maps'));
#        push @maps, $row->get_column('map_file');
    }

    return @maps;
}


1;
