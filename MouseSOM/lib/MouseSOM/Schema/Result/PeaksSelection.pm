use utf8;
package MouseSOM::Schema::Result::PeaksSelection;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::PeaksSelection

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

=head1 TABLE: C<peaks_selection>

=cut

__PACKAGE__->table("peaks_selection");

=head1 ACCESSORS

=head2 id_peaks

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 pc_cov

  data_type: 'float'
  is_nullable: 1

=head2 pc_avg

  data_type: 'float'
  is_nullable: 1

=head2 pc_max

  data_type: 'float'
  is_nullable: 1

=head2 pc_min

  data_type: 'float'
  is_nullable: 1

=head2 pp_avg

  data_type: 'float'
  is_nullable: 1

=head2 pp_max

  data_type: 'float'
  is_nullable: 1

=head2 pp_min

  data_type: 'float'
  is_nullable: 1

=head2 selsites

  data_type: 'float'
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
  "pc_cov",
  { data_type => "float", is_nullable => 1 },
  "pc_avg",
  { data_type => "float", is_nullable => 1 },
  "pc_max",
  { data_type => "float", is_nullable => 1 },
  "pc_min",
  { data_type => "float", is_nullable => 1 },
  "pp_avg",
  { data_type => "float", is_nullable => 1 },
  "pp_max",
  { data_type => "float", is_nullable => 1 },
  "pp_min",
  { data_type => "float", is_nullable => 1 },
  "selsites",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_peaks>

=back

=cut

__PACKAGE__->set_primary_key("id_peaks");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-10-01 19:58:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ro7CayF00dI2H6IJvIqJEg

__PACKAGE__->has_one(
    "peaks_genes",
    "MouseSOM::Schema::Result::PeaksGene",
    {
        "foreign.id_peaks" => "self.id_peaks"
    }
    );

__PACKAGE__->has_one(
    "peaks",
    "MouseSOM::Schema::Result::Peak",
    {
        "foreign.id_peaks" => "self.id_peaks"
    }
    );

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
