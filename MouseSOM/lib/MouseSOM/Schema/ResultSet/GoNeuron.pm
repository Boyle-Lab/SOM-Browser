package MouseSOM::Schema::ResultSet::GoNeuron;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_go_data {
    my ($self, $neuron, $go_data_db, $cat) = @_; 

    my %go_data = (
        hg19_img => "NULL",
        mm9_img => "NULL",
    );

    
    # images
    my $hg19_img = "NULL";
    my $mm9_img = "NULL";
    # detailed data
    my @hg19_data;
    my @mm9_data;
    # input data files
    my $hg19_in = "NULL";
    my $mm9_in = "NULL";

    my $go_res = $self->find(
        { 'id_neurons' => $neuron }
    );

    if (!defined($go_res)) {
        return %go_data;
    }

    my @header = ("GO ID", "Name", "Log P-Value");

    if ($cat eq "bp") {
	if ($go_res->get_column('hg19_bp_img') ne "NULL") {
	    $hg19_img = $go_res->get_column('hg19_bp_img');
	}
	if ($go_res->get_column('mm9_bp_img') ne "NULL") {
	    $mm9_img = $go_res->get_column('mm9_bp_img');
	}
    } elsif ($cat eq "cc") {
	if ($go_res->get_column('hg19_cc_img') ne "NULL") {
	    $hg19_img = $go_res->get_column('hg19_cc_img');
	}
	if ($go_res->get_column('mm9_cc_img') ne "NULL") {
	    $mm9_img = $go_res->get_column('mm9_cc_img');
	}
    } else {
	if ($go_res->get_column('hg19_mf_img') ne "NULL") {
	    $hg19_img = $go_res->get_column('hg19_mf_img');
	}
	if ($go_res->get_column('mm9_mf_img') ne "NULL") {
	    $mm9_img = $go_res->get_column('mm9_mf_img');
	}
    }
    
    if ($go_res->get_column('hg19_input') ne "NULL") {
        $hg19_in = $go_res->get_column('hg19_input');
    }
    if ($go_res->get_column('mm9_input') ne "NULL") {
        $mm9_in = $go_res->get_column('mm9_input');
    }

    my $go_data_rs = $go_data_db->search(
        { 'id_neurons' => $neuron,
	  'cat' => $cat},
    );

    while (my $dat = $go_data_rs->next) {
        my @row;
        my $spp = $dat->get_column('species');

        $row[0] = $dat->get_column('goid');
        $row[1] = $dat->get_column('name');
        $row[2] = $dat->get_column('pval');
    
        if ($spp eq "hg19") {
            push @hg19_data, \@row;
        } else {
            push @mm9_data, \@row;
        }
    }   

    if (!defined($hg19_data[0])) {
        push @hg19_data, "NULL";
    } else {
        @hg19_data = sort { $a->[2] <=> $b->[2] } @hg19_data;
    }
    if (!defined($mm9_data[0])) {
        push @mm9_data, "NULL";
    } else {
        @mm9_data = sort { $a->[2] <=> $b->[2] } @mm9_data;
    }

    $go_data{header} = \@header;
    $go_data{hg19_img} = $hg19_img;
    $go_data{mm9_img} = $mm9_img;
    $go_data{hg19_data} = \@hg19_data;
    $go_data{mm9_data} = \@mm9_data;
    $go_data{hg19_in} = $hg19_in;
    $go_data{mm9_in} = $mm9_in;

    return %go_data;
}

1;
