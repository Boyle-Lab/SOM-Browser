use utf8;
package MouseSOM::Schema::Result::MapsMenus;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::MapsMenus

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

=head1 TABLE: C<maps_menus>

=cut

__PACKAGE__->table("maps_menus");

=head1 ACCESSORS

=head2 id_maps

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 id_menus

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_maps",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "id_menus",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_maps>

=item * L</id_menus>

=back

=cut

__PACKAGE__->set_primary_key("id_maps", "id_menus");

=head1 RELATIONS

=head2 id_map

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Map>

=cut

__PACKAGE__->belongs_to(
  "id_map",
  "MouseSOM::Schema::Result::Map",
  { id_maps => "id_maps" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-11 21:09:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dD+XAGUNDy957XeiE1Juqg

__PACKAGE__->has_many(
    "maps",
    "MouseSOM::Schema::Result::Map",
    {
        "foreign.id_maps" => "self.id_maps"
    }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
