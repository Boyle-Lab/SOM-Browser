use utf8;
package MouseSOM::Schema::Result::BgPeaksGwa;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::BgPeaksGwa

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

=head1 TABLE: C<bg_peaks_gwas>

=cut

__PACKAGE__->table("bg_peaks_gwas");

=head1 ACCESSORS

=head2 id_peaks

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 id_gwas

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_peaks",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "id_gwas",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_peaks>

=item * L</id_gwas>

=back

=cut

__PACKAGE__->set_primary_key("id_peaks", "id_gwas");

=head1 RELATIONS

=head2 id_gwa

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::BgGwa>

=cut

__PACKAGE__->belongs_to(
  "id_gwa",
  "MouseSOM::Schema::Result::BgGwa",
  { id_gwas => "id_gwas" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 id_peak

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::BgPeak>

=cut

__PACKAGE__->belongs_to(
  "id_peak",
  "MouseSOM::Schema::Result::BgPeak",
  { id_peaks => "id_peaks" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-11 21:09:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EiN445OpEk63VwpF9v8tQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
