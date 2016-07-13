package MouseSOM::Schema::ResultSet::PeaksGwa;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_peaks {
    my ($self, $neuron, $gwas_db, $peaks_db, $show) = @_; 
    
    my %peaks;
    my @peaks_hg19;
    my @terms;
    my @peaks_sum_hg19;
    

    my $gwas_rs;
    my $peaks_rs;
    if ($show >= 0) {
	if ($show == 0) {
            $gwas_rs = $self->search(
                { 'peaks.id_neurons' => $neuron,
		  'peaks.species' => 'hg19',
                  -or => [
                      'is_orth' => { ">" => '2' },
                      'is_orth' => 0
                      ]
                },
		{ join => {'peaks_genes' => 'peaks',
			   => 'gwas'},
		  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'peaks_genes.targetgenedist',
			     'me.id_peaks', 'gwas.rsid', 'gwas.loc',
			     'gwas.ontology_term', 'gwas.ontology_url',
			     'gwas.category'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist', 'id_peaks', 'rsid', 'loc',
			 'ontology_term', 'ontology_url', 'category']
		}
                );
	    
	    $peaks_rs = $peaks_db->search(
		{ 'id_neurons' => $neuron,
		  'species' => 'hg19',
		  -or => [
                      'is_orth' => { ">" => '2' },
                      'is_orth' => 0
                      ]
                },
		{ select => 'id_peaks',
		  as => 'id_peaks' }
		);
	    
	} else {
	    
            $gwas_rs = $self->search(
                { 'peaks.id_neurons' => $neuron,
                  'is_orth' => $show,
		  'peaks.species' => 'hg19'
                },
		{ join => {'peaks_genes' => 'peaks',
			   => 'gwas'},
		  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'peaks_genes.targetgenedist',
			     'me.id_peaks', 'gwas.rsid', 'gwas.loc',
			     'gwas.ontology_term', 'gwas.ontology_url',
			     'gwas.category'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist', 'id_peaks', 'rsid', 'loc',
			 'ontology_term', 'ontology_url', 'category']
		}
                );
	    
	    $peaks_rs = $peaks_db->search(
		{ 'id_neurons' => $neuron,
		  'species' => 'hg19',
		  'is_orth' => $show
                },
		{ select => 'id_peaks',
		  as => 'id_peaks' }
		);
        }

    } else {
        $gwas_rs = $self->search(
            { 'peaks.id_neurons' => $neuron,
	      'peaks.species' => 'hg19'},
	    { join => {'peaks_genes' => 'peaks',
		       => 'gwas'},
	      select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			 'peaks.chromstart', 'peaks.chromend',
			 'peaks_genes.targetgenedist',
			 'me.id_peaks', 'gwas.rsid', 'gwas.loc',
			 'gwas.ontology_term', 'gwas.ontology_url',
			 'gwas.category'],
	      as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
		     'targetgenedist', 'id_peaks', 'rsid', 'loc',
		     'ontology_term', 'ontology_url', 'category']
	    }
            );
	$peaks_rs = $peaks_db->search(
	    { 'id_neurons' => $neuron,
	      'species' => 'hg19' },
	    { select => 'id_peaks',
	      as => 'id_peaks' }
	    );
    }
    
    my @header_a = ("Ontology Term", "Category", "N Peaks");
    my @header_b = ("Cell", "Location", "TssDist", "RefSNP ID",
		    "Location", "Ontology Term", "Category");
    my @header_c = ("Source", "N Peaks");
    my @header_d = ("Cell", "Location", "TssDist", "N SNPs", "N Terms");
    
    my $n_gwas_peaks = 0;
    my $n_K562 = 0;
    my $n_GM12878 = 0;
    my $n_gwas = 0;
    
    my %terms; # Counters for GWAS terms
    my %peaks_rsids; # Tracks SNP-peak associations
    
    my $n_peaks = $peaks_rs->count;
    
    while (my $peak = $gwas_rs->next) {	
	my $id_peaks =  $peak->get_column('id_peaks');
	my $cell = $peak->get_column('cell');
        my $loc = $peak->get_column('chrom') . ':'
            . $peak->get_column('chromstart') . '-'
            . $peak->get_column('chromend');
	
	my $tssDist = $peak->get_column('targetgenedist');
	if (!defined($tssDist)) {
            $tssDist = "NA";
	}
	
	my $rsid = $peak->get_column('rsid');
	$rsid =~ s/rs//g;
	my $snp_loc = $peak->get_column('loc');
	my $term = $peak->get_column('ontology_term');
	my $url = $peak->get_column('ontology_url');
	my $category = $peak->get_column('category');
	if (exists($terms{$term}) && !exists($peaks{$id_peaks})) {
	    ${$terms{$term}}[0]++;
	} else {
	    $terms{$term} = [1, $url, $category];
	}
	
	my @row = ($cell, $loc, $tssDist, $rsid, $snp_loc, $term, $url, $category);	    
#	print STDERR "@row\n";
	    
	push @peaks_hg19, \@row;
	$n_gwas++;

	if (!exists($peaks{$id_peaks})) {
	    $peaks{$id_peaks} = [$cell, $loc, $tssDist, 1, 1];
	} else {
	    $peaks{$id_peaks}->[4]++;
	}

	$peaks_rsids{$id_peaks}{$rsid} = $rsid;

	if ($cell eq "K562") {
            $n_K562++;
        } elsif ($cell eq "GM12878") {
            $n_GM12878++;
        }
    }
    
    foreach my $key (keys(%peaks)) {
	$peaks{$key}->[3] = keys($peaks_rsids{$key});
	push @peaks_sum_hg19, $peaks{$key};
	$n_gwas_peaks++;
    }

    foreach my $key (sort(keys(%terms))) {
	push @terms, [$key, ${$terms{$key}}[2], ${$terms{$key}}[0], ${$terms{$key}}[1]];
    }

    $peaks{header_a} = \@header_a;
    $peaks{header_b} = \@header_b;
    $peaks{header_c} = \@header_c;
    $peaks{header_d} = \@header_d;
    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{terms} = \@terms;
    $peaks{peaks_sum_hg19} = \@peaks_sum_hg19;
    $peaks{n_peaks} = $n_peaks;
    $peaks{n_gwas_peaks} = $n_gwas_peaks;
    $peaks{n_gwas} = $n_gwas;
    $peaks{n_terms} = $#terms+1;    
    
    return %peaks;
}

1;
