use utf8;
package MouseSOM::Schema::Result::Gwa;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::Gwa

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

=head1 TABLE: C<gwas>

=cut

__PACKAGE__->table("gwas");

=head1 ACCESSORS

=head2 id_gwas

  data_type: 'integer'
  is_nullable: 0

=head2 rsid

  data_type: 'varchar'
  is_nullable: 1
  size: 25

=head2 loc

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ontology_term

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 ontology_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 category

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "id_gwas",
  { data_type => "integer", is_nullable => 0 },
  "rsid",
  { data_type => "varchar", is_nullable => 1, size => 25 },
  "loc",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ontology_term",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "ontology_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "category",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_gwas>

=back

=cut

__PACKAGE__->set_primary_key("id_gwas");

=head1 RELATIONS

=head2 peaks_gwas

Type: has_many

Related object: L<MouseSOM::Schema::Result::PeaksGwa>

=cut

__PACKAGE__->has_many(
  "peaks_gwas",
  "MouseSOM::Schema::Result::PeaksGwa",
  { "foreign.id_gwas" => "self.id_gwas" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 id_peaks

Type: many_to_many

Composing rels: L</peaks_gwas> -> id_peak

=cut

__PACKAGE__->many_to_many("id_peaks", "peaks_gwas", "id_peak");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-05-17 13:11:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WsbK7/pCHJ7LDjF5dPy7Kw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
