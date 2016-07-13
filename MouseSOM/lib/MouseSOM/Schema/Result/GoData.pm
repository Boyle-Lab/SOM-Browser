use utf8;
package MouseSOM::Schema::Result::GoData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::GoData

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

=head1 TABLE: C<go_data>

=cut

__PACKAGE__->table("go_data");

=head1 ACCESSORS

=head2 id_neurons

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 id_go_data

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 cat

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 goid

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pval

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_neurons",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "id_go_data",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "cat",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "goid",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pval",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_go_data>

=back

=cut

__PACKAGE__->set_primary_key("id_go_data");

=head1 RELATIONS

=head2 id_neuron

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Neuron>

=cut

__PACKAGE__->belongs_to(
  "id_neuron",
  "MouseSOM::Schema::Result::Neuron",
  { id_neurons => "id_neurons" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-01 19:58:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:n2nx0beTIKqFKnbJaQ8PWQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
