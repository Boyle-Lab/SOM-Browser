use utf8;
package MouseSOM::Schema::Result::TabInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MouseSOM::Schema::Result::TabInfo

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

=head1 TABLE: C<tab_info>

=cut

__PACKAGE__->table("tab_info");

=head1 ACCESSORS

=head2 id_tabs

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 tab_title

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 tab_info

  data_type: 'longtext'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_tabs",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "tab_title",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "tab_info",
  { data_type => "longtext", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_tabs>

=back

=cut

__PACKAGE__->set_primary_key("id_tabs");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-11-17 18:09:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zuLftqH1QRbyMZVfS7IOdA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
