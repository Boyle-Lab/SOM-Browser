use utf8;
package MouseSOM::Schema::Result::Peak;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Peak

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

=head1 TABLE: C<peaks>

=cut

__PACKAGE__->table("peaks");

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

=head2 orth_peaks

Type: has_many

Related object: L<MouseSOM::Schema::Result::OrthPeak>

=cut

__PACKAGE__->has_many(
  "orth_peaks",
  "MouseSOM::Schema::Result::OrthPeak",
  { "foreign.orth_id" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 orth_peaks_id_peaks

Type: has_many

Related object: L<MouseSOM::Schema::Result::OrthPeak>

=cut

__PACKAGE__->has_many(
  "orth_peaks_id_peaks",
  "MouseSOM::Schema::Result::OrthPeak",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_chromstate

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksChromstate>

=cut

__PACKAGE__->might_have(
  "peaks_chromstate",
  "MouseSOM::Schema::Result::PeaksChromstate",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_dbsnp

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksDbsnp>

=cut

__PACKAGE__->might_have(
  "peaks_dbsnp",
  "MouseSOM::Schema::Result::PeaksDbsnp",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_dnase

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksDnase>

=cut

__PACKAGE__->might_have(
  "peaks_dnase",
  "MouseSOM::Schema::Result::PeaksDnase",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_factors

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksFactor>

=cut

__PACKAGE__->has_many(
  "peaks_factors",
  "MouseSOM::Schema::Result::PeaksFactor",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_gene

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksGene>

=cut

__PACKAGE__->might_have(
  "peaks_gene",
  "MouseSOM::Schema::Result::PeaksGene",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_gwas

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksGwa>

=cut

__PACKAGE__->has_many(
  "peaks_gwas",
  "MouseSOM::Schema::Result::PeaksGwa",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_histmod

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksHistmod>

=cut

__PACKAGE__->might_have(
  "peaks_histmod",
  "MouseSOM::Schema::Result::PeaksHistmod",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_rmsks

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksRmsk>

=cut

__PACKAGE__->has_many(
  "peaks_rmsks",
  "MouseSOM::Schema::Result::PeaksRmsk",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_selection

Type: might_have

Related object: L<MouseSOM::Schema::Result::PeaksSelection>

=cut

__PACKAGE__->might_have(
  "peaks_selection",
  "MouseSOM::Schema::Result::PeaksSelection",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pos_peak

Type: might_have

Related object: L<MouseSOM::Schema::Result::PosPeak>

=cut

__PACKAGE__->might_have(
  "pos_peak",
  "MouseSOM::Schema::Result::PosPeak",
  { "foreign.id_peaks" => "self.id_peaks" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 id_gwas

Type: many_to_many

Composing rels: L</peaks_gwas> -> id_gwa

=cut

__PACKAGE__->many_to_many("id_gwas", "peaks_gwas", "id_gwa");

=head2 id_peaks

Type: many_to_many

Composing rels: L</orth_peaks> -> id_peak

=cut

__PACKAGE__->many_to_many("id_peaks", "orth_peaks", "id_peak");

=head2 orths

Type: many_to_many

Composing rels: L</orth_peaks_id_peaks> -> orth

=cut

__PACKAGE__->many_to_many("orths", "orth_peaks_id_peaks", "orth");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-04-15 19:35:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FTcxJ0VM9tLrQA8+RABhTQ

__PACKAGE__->belongs_to(
  "peaks_factor",
  "MouseSOM::Schema::Result::PeaksFactor",
    { "id_peaks" => "id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_genes",
    "MouseSOM::Schema::Result::PeaksGene",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "orth_peaks",
    "MouseSOM::Schema::Result::OrthPeak",
    { "foreign.orth_id" => "self.id_peaks" }
    );



# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
