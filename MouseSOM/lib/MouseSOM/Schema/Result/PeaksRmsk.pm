use utf8;
package MouseSOM::Schema::Result::PeaksRmsk;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::PeaksRmsk

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

=head1 TABLE: C<peaks_rmsk>

=cut

__PACKAGE__->table("peaks_rmsk");

=head1 ACCESSORS

=head2 id_rmsk

  data_type: 'integer'
  is_nullable: 0

=head2 id_peaks

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 repchrom

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 repstart

  data_type: 'integer'
  is_nullable: 1

=head2 repend

  data_type: 'integer'
  is_nullable: 1

=head2 repname

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 repclass

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 repfamily

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id_rmsk",
  { data_type => "integer", is_nullable => 0 },
  "id_peaks",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "repchrom",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "repstart",
  { data_type => "integer", is_nullable => 1 },
  "repend",
  { data_type => "integer", is_nullable => 1 },
  "repname",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "repclass",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "repfamily",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_rmsk>

=back

=cut

__PACKAGE__->set_primary_key("id_rmsk");

=head1 RELATIONS

=head2 id_peak

Type: belongs_to

Related object: L<MouseSOM::Schema::Result::Peak>

=cut

__PACKAGE__->belongs_to(
  "id_peak",
  "MouseSOM::Schema::Result::Peak",
  { id_peaks => "id_peaks" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-03-08 14:57:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IDCZeSWKCyUJZTqYn6tCvg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
