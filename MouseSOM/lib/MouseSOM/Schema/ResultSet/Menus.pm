package MouseSOM::Schema::ResultSet::Menus;
 
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

# Build a hash of hashes for menu generation
sub build_menu {
    my ($self, $maps, $maps_menus) = @_;

    my @menus;
    my $j = 0;
    while (my $row = $self->next) {

        my $id = $row->get_column('id_menus');
        my $name = $row->get_column('name');
        my $sub = $maps->search(
            { 'id_menus' => $id },
            { join =>'maps_menus' }
        );   
 
#        $menus[$id-1]{name} = $name;
	$menus[$j]{name} = $name;

#        print STDERR "$name\n";
        my @menu;
        my $i = 0;
        while (my $m = $sub->next) {
#            print STDERR $m->get_column('id_maps'), ", ";
#            print STDERR $m->get_column('name'), ", ";
#            print STDERR $m->get_column('map_file'), "\n";
            $menu[$i]{id_maps} = $m->get_column('id_maps');
            $menu[$i]{name} = $m->get_column('name');
            $menu[$i]{map_file} = $m->get_column('map_file');
            $i++;
        }
    
        $menus[$j]{maps} = \@menu;
	$j++;
    }

    return @menus;
}

sub build_submenu {
    my ($self, $maps, $maps_menus, $id) = @_;

    my @out;

    my $menu = $maps->search(
	{ 'id_menus' => $id },
	{ join =>'maps_menus' }
	);

    while (my $m = $menu->next) {
	my @tmp;
	$tmp[0] = $m->get_column('id_maps');
	$tmp[1] = $m->get_column('name');
	print STDERR "@tmp\n";
	push @out, \@tmp;
    }

    return @out;
}

1;
