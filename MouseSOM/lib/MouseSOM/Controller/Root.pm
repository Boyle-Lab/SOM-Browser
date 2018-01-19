package MouseSOM::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

MouseSOM::Controller::Root - Root Controller for MouseSOM

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Menu sources
    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);

    # The main display template
    $c->stash(template => 'main.tt2');

#    $c->stash(map_file => $c->model('DB::Map')->random_map());
    $c->stash(maps_list => [$c->model('DB::Map')->get_maps()]);
    
}

sub SOMbrowser :Path :Local :Args(1) {
    my ( $self, $c ) = @_;
    return $c->res->redirect( $c->uri_for('/'));
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

catalyst,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
