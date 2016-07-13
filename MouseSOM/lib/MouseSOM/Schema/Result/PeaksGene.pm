use utf8;
package MouseSOM::Schema::Result::PeaksGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::PeaksGene

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

=head1 TABLE: C<peaks_genes>

=cut

__PACKAGE__->table("peaks_genes");

=head1 ACCESSORS

=head2 id_peaks

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 targetgene

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 targetgenedist

  data_type: 'integer'
  is_nullable: 1

=head2 targetgenestrand

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 id_genes

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_peaks",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "targetgene",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "targetgenedist",
  { data_type => "integer", is_nullable => 1 },
  "targetgenestrand",
  { data_type => "char", is_nullable => 1, size => 1 },
  "id_genes",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_peaks>

=back

=cut

__PACKAGE__->set_primary_key("id_peaks");

=head1 RELATIONS

=head2 id_gene

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "id_gene",
  "MouseSOM::Schema::Result::Gene",
  { id_genes => "id_genes" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "CASCADE",
  },
);

=head2 id_peak

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Peak>

=cut

__PACKAGE__->belongs_to(
  "id_peak",
  "MouseSOM::Schema::Result::Peak",
  { id_peaks => "id_peaks" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-04-15 19:35:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nhH8PWt2Mkz0rnrDcBRV0g

__PACKAGE__->belongs_to(
    "genes",
    "MouseSOM::Schema::Result::Gene",
    {
        "foreign.id_genes" => "self.id_genes"
    }
    );

__PACKAGE__->belongs_to(
    "genes_bnorm",
    "MouseSOM::Schema::Result::GenesBnorm",
    {
        "foreign.id_genes" => "self.id_genes"
    }
    );

__PACKAGE__->belongs_to(
    "genes_qnorm",
    "MouseSOM::Schema::Result::GenesQnorm",
    {
        "foreign.id_genes" => "self.id_genes"
    }
    );

__PACKAGE__->belongs_to(
  "peaks",
  "MouseSOM::Schema::Result::Peak",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
  "peaks_selection",
  "MouseSOM::Schema::Result::PeaksSelection",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_histmods",
    "MouseSOM::Schema::Result::PeaksHistmod",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_chromstates",
    "MouseSOM::Schema::Result::PeaksChromstat",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_gwas",
    "MouseSOM::Schema::Result::PeaksGwa",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_rmsk",
    "MouseSOM::Schema::Result::PeaksRmsk",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_dnase",
    "MouseSOM::Schema::Result::PeaksDnase",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

__PACKAGE__->belongs_to(
    "peaks_gwas",
    "MouseSOM::Schema::Result::PeaksGwa",
    { "foreign.id_peaks" => "self.id_peaks" }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
