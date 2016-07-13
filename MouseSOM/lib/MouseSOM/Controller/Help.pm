package MouseSOM::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

=head1 NAME

MouseSOM::Controller::Help - Controller for MouseSOM Help Pages

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut


sub index :Path :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);

    # The display template
    $c->stash(template => 'help/help.tt2');

    my %params = %{$c->request->params};
    if (exists($params{topic})) {
	$c->stash(topic => $params{topic});
    }
}

sub help_load :Path :Local :Args(1) {
    my ( $self, $c, $topic ) = @_;

    $c->stash(no_wrapper => 1);
    
    my %topics = (
	"about" => "",
	"som_data_prep" => "",
	"annotations" => "",
	"navigation" => "",
	"getting_help" => ""
    );

    if (exists($topics{$topic})) {
	my $src = 'help/' . $topic . '.tt2';
	print STDERR "$src\n";
        $c->stash(template => $src);
    } else {
	$c->stash(template => 'help/default.tt2');
    }

}


__PACKAGE__->meta->make_immutable;

1;
