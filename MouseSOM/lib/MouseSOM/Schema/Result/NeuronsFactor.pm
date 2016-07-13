use utf8;
package MouseSOM::Schema::Result::NeuronsFactor;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::NeuronsFactor

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

=head1 TABLE: C<neurons_factors>

=cut

__PACKAGE__->table("neurons_factors");

=head1 ACCESSORS

=head2 id_neurons

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 id_factors

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_neurons",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "id_factors",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_neurons>

=item * L</id_factors>

=back

=cut

__PACKAGE__->set_primary_key("id_neurons", "id_factors");

=head1 RELATIONS

=head2 id_factor

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Factor>

=cut

__PACKAGE__->belongs_to(
  "id_factor",
  "MouseSOM::Schema::Result::Factor",
  { id_factors => "id_factors" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 id_neuron

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Neuron>

=cut

__PACKAGE__->belongs_to(
  "id_neuron",
  "MouseSOM::Schema::Result::Neuron",
  { id_neurons => "id_neurons" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-01 19:58:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HoURXfCmRvyn8pDpOFGdcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
