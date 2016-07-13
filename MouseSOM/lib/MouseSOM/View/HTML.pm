package MouseSOM::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
        # Set the location for TT files
    INCLUDE_PATH => [
            MouseSOM->path_to( 'root', 'src' ),
        ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER              => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt2',
    # Set absolute paths
    ABSOLUTE => 1,

    render_die => 1,
);

=head1 NAME

MouseSOM::View::HTML - TT View for MouseSOM

=head1 DESCRIPTION

TT View for MouseSOM.

=head1 SEE ALSO

L<MouseSOM>

=head1 AUTHOR

catalyst,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
