use utf8;
package MouseSOM::Schema::Result::Map;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Map

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<maps>

=cut

__PACKAGE__->table("maps");

=head1 ACCESSORS

=head2 id_maps

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 map_file

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 map_description

  data_type: 'longtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_maps",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "map_file",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "map_description",
  { data_type => "longtext", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_maps>

=back

=cut

__PACKAGE__->set_primary_key("id_maps");

=head1 RELATIONS

=head2 maps_menuses

Type: has_many

Related object: L<MouseSOM::Schema::Result::MapsMenus>

=cut

__PACKAGE__->has_many(
  "maps_menuses",
  "MouseSOM::Schema::Result::MapsMenus",
  { "foreign.id_maps" => "self.id_maps" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-11 21:09:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l7hHBUPFdpZacbtOohPZ6A

__PACKAGE__->belongs_to(
    "maps_menus",
    "MouseSOM::Schema::Result::MapsMenus",
    {
        "id_maps" => "id_maps"
    }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
