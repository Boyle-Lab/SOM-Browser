use utf8;
package MouseSOM::Schema::Result::Gene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Gene

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

=head1 TABLE: C<genes>

=cut

__PACKAGE__->table("genes");

=head1 ACCESSORS

=head2 id_genes

  data_type: 'integer'
  is_nullable: 0

=head2 name_mm9

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 name_hg19

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 strand

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 exp_g

  data_type: 'float'
  is_nullable: 1

=head2 exp_k

  data_type: 'float'
  is_nullable: 1

=head2 exp_c

  data_type: 'float'
  is_nullable: 1

=head2 exp_m

  data_type: 'float'
  is_nullable: 1

=head2 fc_gk

  data_type: 'float'
  is_nullable: 1

=head2 fc_mc

  data_type: 'float'
  is_nullable: 1

=head2 fc_cg

  data_type: 'float'
  is_nullable: 1

=head2 fc_mk

  data_type: 'float'
  is_nullable: 1

=head2 q_g

  data_type: 'integer'
  is_nullable: 1

=head2 q_k

  data_type: 'integer'
  is_nullable: 1

=head2 q_c

  data_type: 'integer'
  is_nullable: 1

=head2 q_m

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_genes",
  { data_type => "integer", is_nullable => 0 },
  "name_mm9",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "name_hg19",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "strand",
  { data_type => "char", is_nullable => 1, size => 1 },
  "exp_g",
  { data_type => "float", is_nullable => 1 },
  "exp_k",
  { data_type => "float", is_nullable => 1 },
  "exp_c",
  { data_type => "float", is_nullable => 1 },
  "exp_m",
  { data_type => "float", is_nullable => 1 },
  "fc_gk",
  { data_type => "float", is_nullable => 1 },
  "fc_mc",
  { data_type => "float", is_nullable => 1 },
  "fc_cg",
  { data_type => "float", is_nullable => 1 },
  "fc_mk",
  { data_type => "float", is_nullable => 1 },
  "q_g",
  { data_type => "integer", is_nullable => 1 },
  "q_k",
  { data_type => "integer", is_nullable => 1 },
  "q_c",
  { data_type => "integer", is_nullable => 1 },
  "q_m",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_genes>

=back

=cut

__PACKAGE__->set_primary_key("id_genes");

=head1 RELATIONS

=head2 bg_peaks_genes

Type: has_many

Related object: L<MouseSOM::Schema::Result::BgPeaksGene>

=cut

__PACKAGE__->has_many(
  "bg_peaks_genes",
  "MouseSOM::Schema::Result::BgPeaksGene",
  { "foreign.id_genes" => "self.id_genes" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genes_bnorm

Type: might_have

Related object: L<MouseSOM::Schema::Result::GenesBnorm>

=cut

__PACKAGE__->might_have(
  "genes_bnorm",
  "MouseSOM::Schema::Result::GenesBnorm",
  { "foreign.id_genes" => "self.id_genes" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genes_qnorm

Type: might_have

Related object: L<MouseSOM::Schema::Result::GenesQnorm>

=cut

__PACKAGE__->might_have(
  "genes_qnorm",
  "MouseSOM::Schema::Result::GenesQnorm",
  { "foreign.id_genes" => "self.id_genes" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 peaks_genes

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksGene>

=cut

__PACKAGE__->has_many(
  "peaks_genes",
  "MouseSOM::Schema::Result::PeaksGene",
  { "foreign.id_genes" => "self.id_genes" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-05-17 13:11:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xKRd3FzV0A7lijQ70aYQtw

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
