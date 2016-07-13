package MouseSOM::Controller::Compare;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

=head1 NAME

MouseSOM::Controller::Root - Map Compare Controller for MouseSOM

=head1 DESCRIPTION

Dymically compare map images in the SOM Browser.

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Menu sources
    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);

    # The form template
    $c->stash(template => 'compare.tt2');
}

# Get table to field mapping
sub get_fields :Path :Local :Args(1) {
    my ($self, $c, $id) = @_;

    my @maps = $c->model('DB::Menus')->build_submenu($c->model('DB::Map'), $c->model('DB::MapsMenus'), $id);

    my $result = "<option selected>Choose a map</option>";
    foreach my $row (@maps) {
	print STDERR "@{$row}\n";
	my $line = '<option value="' . ${$row}[0] . '">' . ${$row}[1] . '</option>';
	$result .= $line;
    }
    $c->res->body($result);
}


sub update_map :Path :Local :Args(1) {
    my ( $self, $c, $map_id ) = @_;

    my $fields = $c->model('DB::Map')->find($map_id);
    my $map_file = $fields->get_column('map_file');
#    print STDERR "$map_file\n";                                                                                                                                               

    $map_file =~ s/svg\///;
    $map_file =~ s/\.svg/\.png/;
 
    my $returnUrl = $c->uri_for('/static/images', $map_file);
#    print STDERR "$returnUrl\n";

    my $retval = '<img class="compBuild" src="' . $returnUrl . '"/>';

    $c->res->content_type("text/plain");
    $c->res->body($retval);
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
