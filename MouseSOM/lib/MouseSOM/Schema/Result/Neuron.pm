use utf8;
package MouseSOM::Schema::Result::Neuron;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Neuron

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

=head1 TABLE: C<neurons>

=cut

__PACKAGE__->table("neurons");

=head1 ACCESSORS

=head2 id_neurons

  data_type: 'integer'
  is_nullable: 0

=head2 n_peaks

  data_type: 'integer'
  is_nullable: 1

=head2 n_human

  data_type: 'integer'
  is_nullable: 1

=head2 n_mouse

  data_type: 'integer'
  is_nullable: 1

=head2 frac_human

  data_type: 'float'
  is_nullable: 1

=head2 frac_mouse

  data_type: 'float'
  is_nullable: 1

=head2 classification

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "id_neurons",
  { data_type => "integer", is_nullable => 0 },
  "n_peaks",
  { data_type => "integer", is_nullable => 1 },
  "n_human",
  { data_type => "integer", is_nullable => 1 },
  "n_mouse",
  { data_type => "integer", is_nullable => 1 },
  "frac_human",
  { data_type => "float", is_nullable => 1 },
  "frac_mouse",
  { data_type => "float", is_nullable => 1 },
  "classification",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_neurons>

=back

=cut

__PACKAGE__->set_primary_key("id_neurons");

=head1 RELATIONS

=head2 bg_peaks

Type: has_many

Related object: L<MouseSOM::Schema::Result::BgPeak>

=cut

__PACKAGE__->has_many(
  "bg_peaks",
  "MouseSOM::Schema::Result::BgPeak",
  { "foreign.id_neurons" => "self.id_neurons" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_datas

Type: has_many

Related object: L<MouseSOM::Schema::Result::GoData>

=cut

__PACKAGE__->has_many(
  "go_datas",
  "MouseSOM::Schema::Result::GoData",
  { "foreign.id_neurons" => "self.id_neurons" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_neuron

Type: might_have

Related object: L<MouseSOM::Schema::Result::GoNeuron>

=cut

__PACKAGE__->might_have(
  "go_neuron",
  "MouseSOM::Schema::Result::GoNeuron",
  { "foreign.id_neurons" => "self.id_neurons" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 neurons_factors

Type: has_many

Related object: L<MouseSOM::Schema::Result::NeuronsFactor>

=cut

__PACKAGE__->has_many(
  "neurons_factors",
  "MouseSOM::Schema::Result::NeuronsFactor",
  { "foreign.id_neurons" => "self.id_neurons" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks

Type: has_many

Related object: L<MouseSOM::Schema::Result::Peak>

=cut

__PACKAGE__->has_many(
  "peaks",
  "MouseSOM::Schema::Result::Peak",
  { "foreign.id_neurons" => "self.id_neurons" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 id_factors

Type: many_to_many

Composing rels: L</neurons_factors> -> id_factor

=cut

__PACKAGE__->many_to_many("id_factors", "neurons_factors", "id_factor");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-03-24 13:46:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:x7jgY985QjGrH4OxUasclA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
