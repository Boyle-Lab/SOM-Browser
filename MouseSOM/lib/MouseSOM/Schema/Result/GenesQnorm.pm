use utf8;
package MouseSOM::Schema::Result::GenesQnorm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::GenesQnorm

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

=head1 TABLE: C<genes_qnorm>

=cut

__PACKAGE__->table("genes_qnorm");

=head1 ACCESSORS

=head2 id_genes

  data_type: 'integer'
  is_foreign_key: 1
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
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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

=head2 id_gene

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "id_gene",
  "MouseSOM::Schema::Result::Gene",
  { id_genes => "id_genes" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-04-15 19:35:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ikIaomdgK61kADltBsftiQ

__PACKAGE__->belongs_to(
    "peaks_genes",
    "MouseSOM::Schema::Result::PeaksGene",
    {
        "id_genes" => "id_genes"
    }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
