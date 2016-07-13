package MouseSOM::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

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

    # Table to field mapping (JSON)
#    $c->stash(table_cols => $c

    # The search form template
    $c->stash(template => 'search.tt2');
}

sub base :Chained('/') :PathPart('search') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub search_results :Chained('base') :PathPart('search_results') :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);

    # Pass query params to the model and retrieve search results...
    $c->stash(results => {$c->model('DB::Peak')->get_search_res(
			      $c->model('DB::Neuron'), $c->model('DB::Peak'),
			      $c->model('DB::Factor'), $c->model('DB::PeaksFactor'),
			      $c->model('DB::PeaksGene'), $c->model('DB::PeaksSelection'),
			      $c->model('DB::PeaksHistmod'), $c->request->params,
			      $c->model( 'DB' )->storage->dbh)});

    if ($c->stash->{results}->{error}) {
	# Invalid query. Redirect to error page.
#	return $c->res->redirect("https://www.fbi.gov/about-us/investigate/cyber");
	return $c->res->body("<p><b>Error: Invalid Query!</b></p><p>Use your browser's \"back\" button to return to the previous page and try again.</p>");
    }
    
    # The search results template          
    $c->stash(template => 'search_results.tt2');
}

# Get table to field mapping as a JSON
sub get_fields :Path :Local :Args(1) {
    my ($self, $c, $table) = @_;
    my $dbh = $c->model( 'DB' )->storage->dbh;
    my $qry = "SELECT column_name FROM information_schema.columns WHERE table_name = '" .
	$table . "';";
    # we'll have none of that nasty SQL injection-vulnerable code here...
    my $result = "";
    my @res = @{$dbh->selectall_arrayref($qry, { Slice => {} })};
    map { $result .= sprintf("<option>%s</option>", $_->{column_name} ) } @res;
    $c->res->body($result);
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
