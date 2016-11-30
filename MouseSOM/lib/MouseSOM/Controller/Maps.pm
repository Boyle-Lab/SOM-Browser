package MouseSOM::Controller::Maps;
use Moose;
use namespace::autoclean;
use JSON;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

MouseSOM::Controller::Maps - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Menu sources
    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);
    # The main display template
    $c->stash(template => 'maps/welcome.tt2');
}

sub map :Path :Local :Args(1) {
    my ( $self, $c , $map_id ) = @_;

    # Menu sources
    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'), $c->model('DB::MapsMenus'))]);

    # Store the map ID
    $c->stash(map_id => $map_id);

    # Currently-selected Neuron
    $c->stash(neuron => '');

    # The main display template
    $c->stash(template => 'maps/som_main.tt2');

    my %params = %{$c->request->params};
    if (exists($params{neuron})) {
        return $c->res->redirect( $c->secure_uri_for('neuron', $map_id, $params{neuron}));
    }
}

sub get_map_info :Path :Local :Args(1) {
    my ($self, $c, $map_id) = @_;

    my $fields = $c->model('DB::Map')->find($map_id);
    my $map_title = $fields->get_column('name');
    my $map_info = $fields->get_column('map_description');

    $c->stash(title => $map_title);
    $c->stash(info => $map_info);
    $c->stash(template => 'maps/map_info.tt2');
    $c->stash(no_wrapper => 1);
}

sub update_map :Path :Local :Args(1) {
    my ( $self, $c, $map_id ) = @_;

    my $fields = $c->model('DB::Map')->find($map_id);
    my $map_file = $fields->get_column('map_file');
#    print STDERR "$map_file\n";
    my $returnUrl = $c->secure_uri_for('/static/svg', $map_file);
#    print STDERR "$returnUrl\n";
    $c->res->content_type("text/plain");
    $c->res->body($returnUrl);
}

sub get_tab_info :Path :Local :Args(1) {
    my ($self, $c, $tab_id) = @_;

    my $fields = $c->model('DB::TabInfo')->find($tab_id);
    my $title = $fields->get_column('tab_title');
    my $info = $fields->get_column('tab_info');

    $c->stash(title => $title);
    $c->stash(info => $info);
    if ($tab_id == 4) { # GO Tab
	$c->stash(template => 'maps/tab_info_go.tt2');
    } else {
	$c->stash(template => 'maps/tab_info.tt2');
    }
    $c->stash(no_wrapper => 1);
}

sub load_tab :Path :Local :ARGS(2) {
    my ( $self, $c, $tab_id, $neuron ) = @_;
    
    # For showing orth/non-orth/all rows
    my $show = -1; # -1 = all, 0 = non-orth, 1 = 1:1 orth, 2 = 1:many orth
    my %params = %{$c->request->params};

    $tab_id = $params{activeTab};
    
    if (exists($params{show})) {
	if ($params{show} eq "non-orth") {
	    $show = 0;
	} elsif ($params{show} eq "orth-1") {
	    $show = 1;
	} elsif ($params{show} eq "orth-2") {
	    $show = 2;
	} else {
	    $show = -1;
	}
    }

    # For specifying gene expression normalization
    my $gnorm = "tpm";
    if (exists($params{geneSelect})) {
	$gnorm = $params{geneSelect};
    }

    # For specifying GO Source
    my $go_source = "bioProc";
    if (exists($params{goSource})) {
	$go_source = $params{goSource};
    }

    $c->stash(show => $show);
    $c->stash(activeTab => $tab_id);
    $c->stash(geneSelect => $gnorm);
    $c->stash(goSource => $go_source);

    # Toggle the page wrapper off
    $c->stash(no_wrapper => 1);

    # Currently-selected Neuron
    $c->stash(neuron => {$c->model('DB::Neuron')->get_neuron_data($neuron,
								  $c->model('DB::Factor'))});

    # Default template
    $c->stash(template => 'default.tt2');

    if (${$c->stash->{neuron}}{pattern} ne "Non-Significant Pattern") {
	if ($tab_id == 0) {
	    # TF Usage Tab
	    $c->stash(template => 'maps/peaks.tt2');
	    $c->stash(peaks => {$c->model('DB::Peak')->get_peaks($neuron, $c->model('DB::PeaksGene'),
								 $c->model('DB::Factor'), $show)});
	} elsif ($tab_id == 1) {
	    # Orthologs Tab
	    $c->stash(template => 'maps/orthologs.tt2');
            $c->stash(orthologs => {$c->model('DB::Peak')->get_orthologs($neuron,
									 $c->model('DB::OrthPeak'),
									 $c->model('DB::Factor'),
									 $c->model('DB::PeaksGene'),
									 $show)});

	} elsif ($tab_id == 2) {
	    # Selection Tab
	    $c->stash(template => 'maps/selection.tt2');
	    $c->stash(selection => {$c->model('DB::PeaksSelection')->get_selection($neuron, $show)});
	    
	} elsif ($tab_id == 3) {
	    # Gene Expression Tab
	    $c->stash(template => 'maps/genes.bnorm.tt2');
	    if ($gnorm eq "tpm") {
	        $c->stash(genes_bnorm => {$c->model('DB::PeaksGene')->get_genes_bnorm($neuron,
										      $c->model('DB::Gene'),
										      $show)});
	    } elsif ($gnorm eq "qnorm") {
		$c->stash(genes_bnorm => {$c->model('DB::PeaksGene')->get_genes_bnorm($neuron,
										      $c->model('DB::GenesQnorm'),
										      $show)});
	    } elsif ($gnorm eq "bnorm") {
		$c->stash(genes_bnorm => {$c->model('DB::PeaksGene')->get_genes_bnorm($neuron,
										      $c->model('DB::GenesBnorm'),
										      $show)});		
	    }
	    
	} elsif ($tab_id == 4) {
	    # Gene Ontology Tab
	    print STDERR "$go_source\n";
	    $c->stash(template => 'maps/go_data.tt2');
	    if ($go_source eq "bioProc") {
		$c->stash(go_data => {$c->model('DB::GoNeuron')->get_go_data($neuron,
									     $c->model('DB::GoData'),
									     "bp")});
	    } elsif ($go_source eq "cellComp") {
		$c->stash(go_data => {$c->model('DB::GoNeuron')->get_go_data($neuron,
									     $c->model('DB::GoData'),
									     "cc")});
	    } elsif ($go_source eq "molFunc") {
		$c->stash(go_data => {$c->model('DB::GoNeuron')->get_go_data($neuron,
									     $c->model('DB::GoData'),
									     "mf")});
	    }

	} elsif ($tab_id == 5) {
	    # Histone Modifications Tab
	    $c->stash(template => 'maps/hist_mod.tt2');
	    $c->stash(neuron => $neuron);
	    $c->stash(histone_mod => {$c->model('DB::PeaksHistmod')->get_selection($neuron, $show)});
	    
	} elsif ($tab_id == 6) {
	    # Chromatin State Tab
	    $c->stash(template => 'maps/chromstate.tt2');
	    $c->stash(chromstate => {$c->model('DB::PeaksChromstate')->get_selection($neuron, $show)});
	    
        } elsif ($tab_id == 7) {
            # GWAS Tab
	    $c->stash(template => 'maps/gwas.tt2');
            $c->stash(gwas => {$c->model('DB::PeaksGwa')->get_peaks($neuron,
								    $c->model('DB::Gwa'),
								     $c->model('DB::Peak'),
								    $show)});
        } elsif ($tab_id == 8) {
            # DNase Tab
	    
	    $c->stash(template => 'maps/dnase.tt2');
            $c->stash(dnase => {$c->model('DB::PeaksDnase')->get_peaks($neuron, $show)});

	} else {
	    # Invalid Tab -- return a 404 error
	    return $c->res->redirect( $c->secure_uri_for('/default'));
	}
    }
}

sub neuron :Path :Local :Args(2) {
    my ( $self, $c, $map_id, $neuron ) = @_;

    # Menu sources
    $c->stash(menus => [$c->model('DB::Menus')->build_menu($c->model('DB::Map'),
							   $c->model('DB::MapsMenus'))]);

    # Store the map ID
    $c->stash(map_id => $map_id);

    my %params = %{$c->request->params};
#    if (exists($params{neuron})) {
#        return $c->res->redirect( $c->secure_uri_for('neuron', $map_id, $params{neuron}));
#    }
    if (exists($params{activeTab})) {
        $c->stash(activeTab => $params{activeTab});
    } else {
        $c->stash(activeTab => 0);
    }
    if (exists($params{show})) {
	$c->stash(show => $params{show});
    } else {
	$c->stash(show => "all");
    }
    if (exists($params{geneSelect})) {
	$c->stash(geneSelect => $params{geneSelect});
    } else {
	$c->stash(geneSelect => "tpm");
    }
    if (exists($params{goSource})) {
	$c->stash(goSource => $params{goSource});
    } else {
	$c->stash(goSource => "bioProc");
    }
    

    # Currently-selected Neuron
    $c->stash(neuron => {$c->model('DB::Neuron')->get_neuron_data($neuron,
								  $c->model('DB::Factor'))});

    # The main display template
    $c->stash(template => 'maps/som_neuron.tt2');
}

sub update_neuron :Path :Local :Args(1) {
    my ( $self, $c, $neuron ) = @_;
    
    # Use the neuron-tabs template
    $c->stash(template => 'maps/neuron_tabs.tt2');
    # Toggle the wrapper off
    $c->stash(no_wrapper => 1);

    # Check for an open tab
    my %params = %{$c->request->params};
    if (exists($params{activeTab})) {
	$c->stash(activeTab => $params{activeTab});
    } else {
	$c->stash(activeTab => 0);
    }
    if (exists($params{show})) {
	$c->stash(show => $params{show});
    } else {
	$c->stash(show => "all");
    }
    if (exists($params{geneSelect})) {
	$c->stash(geneSelect => $params{geneSelect});
    } else {
	$c->stash(geneSelect => "tpm");
    }
    if (exists($params{goSource})) {
	$c->stash(goSource => $params{goSource});
    } else {
	$c->stash(goSource => "bioProc");
    }    

    # Currently-selected Neuron
    $c->stash(neuron => {$c->model('DB::Neuron')->get_neuron_data($neuron,
								  $c->model('DB::Factor'))});

}

sub update_neuron_summary :Path :Local :Args(1) {
    my ( $self, $c, $neuron ) = @_;

    # Use the neuron-summary template
    $c->stash(template => 'maps/neuron_summary.tt2',
	      no_wrapper => 1);

    # Currently-selected Neuron
    $c->stash(neuron => {$c->model('DB::Neuron')->get_neuron_data($neuron,
								  $c->model('DB::Factor'))});

    if (${$c->stash->{neuron}}{pattern} ne "Non-Significant Pattern") {
        # Retrieve the target genes data
        $c->stash(genes => {$c->model('DB::PeaksGene')->get_genes_summary($neuron)});
    }
}

sub show_loading_msg :Path :Local :Args(1) {
    my ($self, $c, $neuron) = @_;

    $c->stash(template => 'maps/loading.tt2');
    $c->stash(no_wrapper => 1);
    $c->stash(neuron => $neuron);
}

=head1 AUTHOR

catalyst,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
