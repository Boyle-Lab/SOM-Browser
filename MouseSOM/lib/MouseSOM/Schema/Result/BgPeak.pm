use utf8;
package MouseSOM::Schema::Result::BgPeak;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::BgPeak

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

=head1 TABLE: C<bg_peaks>

=cut

__PACKAGE__->table("bg_peaks");

=head1 ACCESSORS

=head2 id_peaks

  data_type: 'integer'
  is_nullable: 0

=head2 id_neurons

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 species

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 cell

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 chrom

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 chromstart

  data_type: 'integer'
  is_nullable: 1

=head2 chromend

  data_type: 'integer'
  is_nullable: 1

=head2 is_orth

  data_type: 'integer'
  is_nullable: 1

=head2 is_bound_orth

  data_type: 'integer'
  is_nullable: 1

=head2 orth_coords

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 pair_id

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_peaks",
  { data_type => "integer", is_nullable => 0 },
  "id_neurons",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "species",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "cell",
  { data_type => "varchar", is_nullable => 1, size => 10 },
  "chrom",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "chromstart",
  { data_type => "integer", is_nullable => 1 },
  "chromend",
  { data_type => "integer", is_nullable => 1 },
  "is_orth",
  { data_type => "integer", is_nullable => 1 },
  "is_bound_orth",
  { data_type => "integer", is_nullable => 1 },
  "orth_coords",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "pair_id",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_peaks>

=back

=cut

__PACKAGE__->set_primary_key("id_peaks");

=head1 RELATIONS

=head2 bg_orth_peaks_id_peaks

Type: has_many

Related object: L<MouseSOM::Schema::Result::BgOrthPeak>

=cut

__PACKAGE__->has_many(
  "bg_orth_peaks_id_peaks",
  "MouseSOM::Schema::Result::BgOrthPeak",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bg_orth_peaks_orths

Type: has_many

Related object: L<MouseSOM::Schema::Result::BgOrthPeak>

=cut

__PACKAGE__->has_many(
  "bg_orth_peaks_orths",
  "MouseSOM::Schema::Result::BgOrthPeak",
  { "foreign.orth_id" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bg_peaks_dnase

Type: might_have

Related object: L<MouseSOM::Schema::Result::BgPeaksDnase>

=cut

__PACKAGE__->might_have(
  "bg_peaks_dnase",
  "MouseSOM::Schema::Result::BgPeaksDnase",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bg_peaks_gene

Type: might_have

Related object: L<MouseSOM::Schema::Result::BgPeaksGene>

=cut

__PACKAGE__->might_have(
  "bg_peaks_gene",
  "MouseSOM::Schema::Result::BgPeaksGene",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 bg_peaks_gwas

Type: has_many

Related object: L<MouseSOM::Schema::Result::BgPeaksGwa>

=cut

__PACKAGE__->has_many(
  "bg_peaks_gwas",
  "MouseSOM::Schema::Result::BgPeaksGwa",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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

=head2 id_gwas

Type: many_to_many

Composing rels: L</bg_peaks_gwas> -> id_gwa

=cut

__PACKAGE__->many_to_many("id_gwas", "bg_peaks_gwas", "id_gwa");

=head2 id_peaks

Type: many_to_many

Composing rels: L</bg_orth_peaks_orths> -> id_peak

=cut

__PACKAGE__->many_to_many("id_peaks", "bg_orth_peaks_orths", "id_peak");

=head2 orths

Type: many_to_many

Composing rels: L</bg_orth_peaks_id_peaks> -> orth

=cut

__PACKAGE__->many_to_many("orths", "bg_orth_peaks_id_peaks", "orth");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-11 21:09:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ajg2JqSxET2v4a7LzvEvQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
