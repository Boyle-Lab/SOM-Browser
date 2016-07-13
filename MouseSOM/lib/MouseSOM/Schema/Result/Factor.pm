use utf8;
package MouseSOM::Schema::Result::Factor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Factor

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

=head1 TABLE: C<factors>

=cut

__PACKAGE__->table("factors");

=head1 ACCESSORS

=head2 id_factors

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "id_factors",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_factors>

=back

=cut

__PACKAGE__->set_primary_key("id_factors");

=head1 RELATIONS

=head2 neurons_factors

Type: has_many

Related object: L<MouseSOM::Schema::Result::NeuronsFactor>

=cut

__PACKAGE__->has_many(
  "neurons_factors",
  "MouseSOM::Schema::Result::NeuronsFactor",
  { "foreign.id_factors" => "self.id_factors" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_factors

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksFactor>

=cut

__PACKAGE__->has_many(
  "peaks_factors",
  "MouseSOM::Schema::Result::PeaksFactor",
  { "foreign.id_factors" => "self.id_factors" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 id_neurons

Type: many_to_many

Composing rels: L</neurons_factors> -> id_neuron

=cut

__PACKAGE__->many_to_many("id_neurons", "neurons_factors", "id_neuron");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-01 19:58:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dJKJ1D3haqep4v2unU7ILg

__PACKAGE__->belongs_to(
  "neurons_factors",
  "MouseSOM::Schema::Result::NeuronsFactor",
    { "id_factors" => "id_factors" }
    );

__PACKAGE__->belongs_to(
  "peaks_factors",
  "MouseSOM::Schema::Result::PeaksFactor",
    { "id_factors" => "id_factors" }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
