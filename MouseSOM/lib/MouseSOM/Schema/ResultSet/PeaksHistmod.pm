package MouseSOM::Schema::ResultSet::PeaksHistmod;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_selection {
    my ($self, $neuron, $show) = @_; 

    my %peaks;
    my @peaks_hg19;
    my @peaks_mm9;
    my @total;
    my @total_K562;
    my @total_MEL;
    my @total_GM12878;
    my @total_CH12;
    
    my $peaks_rs;
    if ($show >= 0) {
	if ($show == 0) {
            $peaks_rs = $self->search(
                { 'peaks.id_neurons' => $neuron,
                  -or => [
                      'is_orth' => { ">" => '2' },
                      'is_orth' => 0
                      ]
                },
		{ join => {'peaks_genes' => 'peaks' },
		  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'peaks_genes.targetgenedist',
			     'me.h3k9ac', 'me.h3k79me2',
			     'me.h3k4me3', 'me.h3k4me1',
			     'me.h3k36me3', 'me.h3k27me3', 
			     'me.h3k27ac'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist',
			 'me.h3k9ac', 'me.h3k79me2', 'me.h3k4me3', 'me.h3k4me1',
			 'me.h3k36me3', 'me.h3k27me3', 'h3k27ac']
		}
                );
	    
	} else {
	    
            $peaks_rs = $self->search(
                { 'peaks.id_neurons' => $neuron,
                  'is_orth' => $show
                },
		{ join => {'peaks_genes' => 'peaks' },
		  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'peaks_genes.targetgenedist',
			     'me.h3k9ac', 'me.h3k79me2',
			     'me.h3k4me3', 'me.h3k4me1',
			     'me.h3k36me3', 'me.h3k27me3', 
			     'me.h3k27ac'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist',
			 'me.h3k9ac', 'me.h3k79me2', 'me.h3k4me3', 'me.h3k4me1',
			 'me.h3k36me3', 'me.h3k27me3', 'h3k27ac']
		}
                );
        }
    } else {
        $peaks_rs = $self->search(
            { 'peaks.id_neurons' => $neuron },
	    { join => {'peaks_genes' => 'peaks' },
	      select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			 'peaks.chromstart', 'peaks.chromend',
			 'peaks_genes.targetgenedist',
			 'me.h3k9ac', 'me.h3k79me2',
			 'me.h3k4me3', 'me.h3k4me1',
			 'me.h3k36me3', 'me.h3k27me3', 
			 'me.h3k27ac'],
	      as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
		     'targetgenedist',
		     'me.h3k9ac', 'me.h3k79me2', 'me.h3k4me3', 'me.h3k4me1',
		     'me.h3k36me3', 'me.h3k27me3', 'h3k27ac']
	    }
            );
    }
    
    my @header_a = ("Source", "N Peaks", "H3K9ac", "H3K79me2", "H3K4me3", "H3K4me1", "H3K36me3", "H3K27me3", "H3K27ac");
    my @header_b = ("Cell", "Location", "TssDist", "H3K9ac", "H3K79me2", "H3K4me3", "H3K4me1", "H3K36me3", "H3K27me3", "H3K27ac");

    my $i = 0;
    my $n_K562 = 0;
    my $n_MEL = 0;
    my $n_GM12878 = 0;
    my $n_CH12 = 0;
    my $global_max = 0;
    my @max = (0, 0, 0, 0, 0, 0, 0);
    while (my $peak = $peaks_rs->next) {
        my @row;

	my $loc = $peak->get_column('chrom') . ':'
            . $peak->get_column('chromstart') . '-'
            . $peak->get_column('chromend');
	
        $row[1] = $loc;

	my $tssDist = $peak->get_column('targetgenedist');
	if (defined($tssDist)) {
	    $row[2] = $tssDist;
        } else {
            $row[2] = "NA";
	}
	
	my $cell = $row[0]= $peak->get_column('cell');

	my $tmp = $peak->get_column('h3k9ac');
	if (!defined($tmp)) {
	    $row[3] = 0;
	} else {
	    $row[3] = sprintf "%.4f", $peak->get_column('h3k9ac');
	}
	$tmp = $peak->get_column('h3k79me2');
	if (!defined($tmp)) {
            $row[4] = 0;
	} else {
	    $row[4] = sprintf "%.4f", $peak->get_column('h3k79me2');
	}
	$tmp = $peak->get_column('h3k4me3');
	if (!defined($tmp)) {
            $row[5] = 0;
        } else {
	    $row[5] = sprintf "%.4f", $peak->get_column('h3k4me3');
	}
	$tmp = $peak->get_column('h3k4me1');
	if (!defined($tmp)) {
            $row[6] = 0;
        } else {
	    $row[6] = sprintf "%.4f", $peak->get_column('h3k4me1');
	}
	$tmp = $peak->get_column('h3k36me3');
	if (!defined($tmp)) {
            $row[7] = 0;
        } else {
	    $row[7] = sprintf "%.4f", $peak->get_column('h3k36me3');
	}
	$tmp = $peak->get_column('h3k27me3');
        if (!defined($tmp)) {
            $row[8] = 0;
        } else {
	    $row[8] = sprintf "%.4f", $peak->get_column('h3k27me3');
	}
	$tmp = $peak->get_column('h3k27ac');
        if (!defined($tmp)) {
            $row[9] = 0;
        } else {
	    $row[9] = sprintf "%.4f", $peak->get_column('h3k27ac');
	}

	for (my $k = 3, my $l = 0; $l < 7; $k++, $l++) {
	    if ($row[$k] > $global_max) {
		$global_max = $row[$k];
	    }
	    if ($row[$k] > $max[$l]) {
		$max[$l] = $row[$k];
	    }
	}

	my $spp = $peak->get_column('species');
        if ($spp eq "hg19") {
            push @peaks_hg19, \@row;
        } else {
            push @peaks_mm9, \@row;
        }

	if ($cell eq "K562") {
	    $n_K562++;
	} elsif ($cell eq "MEL") {
	    $n_MEL++;
	} elsif ($cell eq "GM12878") {
	    $n_GM12878++;
	} else {
	    $n_CH12++;
	}
	
	my $j;
        my $k;
        for ($j = 2, $k = 3; $k <= $#row; $j++, $k++) {
            $total[$j] += $row[$k];
            if ($cell eq "K562") {
                $total_K562[$j] += $row[$k];
	    } elsif ($cell eq "MEL") {
		$total_MEL[$j] += $row[$k];
	    } elsif ($cell eq "GM12878") {
		$total_GM12878[$j] += $row[$k];
            } else {
                $total_CH12[$j] += $row[$k];
            }
        }

        $i++;
    }    

    $total[1] = $i;
    $total_K562[1] = $n_K562;
    $total_MEL[1] = $n_MEL;
    $total_GM12878[1] = $n_GM12878;
    $total_CH12[1] = $n_CH12;

    if ($n_K562 == 0) {
        $n_K562++;
    }
    if ($n_MEL == 0) {
        $n_MEL++;
    }
    if ($n_GM12878 == 0) {
	$n_GM12878++;
    }
    if ($n_CH12 == 0) {
	$n_CH12++;
    }
    if ($i == 0) {
        $i++;
    }

    $total[0] = "Average";
    $total_K562[0] = "Human K562";
    $total_MEL[0] = "Mouse MEL";
    $total_GM12878[0] = "Human GM12878";
    $total_CH12[0] = "Mouse CH12";

    my $j;
    for ($j = 2; $j <= $#total; $j++) {
	if (!defined($total[$j])) {
	    $total[$j] = 0;
	}
	if (!defined($total_K562[$j])) {
            $total_K562[$j] = 0;
        }
	if (!defined($total_MEL[$j])) {
            $total_MEL[$j] = 0;
        }
	if (!defined($total_GM12878[$j])) {
            $total_GM12878[$j] = 0;
        }
	if (!defined($total_CH12[$j])) {
            $total_CH12[$j] = 0;
        }
        $total[$j] = sprintf "%.4f", $total[$j] / $i;
        $total_K562[$j] = sprintf "%.4f", $total_K562[$j] / $n_K562;
        $total_MEL[$j] = sprintf "%.4f", $total_MEL[$j] / $n_MEL;
	$total_GM12878[$j] = sprintf "%.4f", $total_GM12878[$j] / $n_GM12878;
	$total_CH12[$j] = sprintf "%.4f", $total_CH12[$j] / $n_CH12;
    }

#    print STDERR "@total_K562\n";
#    print STDERR "@total_MEL\n";
#    print STDERR "@total_GM12878\n";
#    print STDERR "@total_CH12\n";

    ($peaks{H3K9ac_max}, $peaks{H3K79me2_max}, $peaks{H3K4me3_max},
     $peaks{H3K4me1_max}, $peaks{H3K36me3_max},	$peaks{H3K27me3_max},
     $peaks{H3K27ac_max}) = @max;
    $peaks{global_max} = $global_max;

# Sorting now handled client-side by tabelsorter.js
#    @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] } @peaks_hg19;
#    @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] } @peaks_mm9;

    $peaks{n_peaks} = $i;
    $peaks{header_a} = \@header_a;
    $peaks{header_b} = \@header_b;
    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{peaks_mm9} = \@peaks_mm9;
    $peaks{total} = \@total;
    $peaks{total_K562} = \@total_K562;
    $peaks{total_MEL} = \@total_MEL;
    $peaks{total_GM12878} = \@total_GM12878;
    $peaks{total_CH12} = \@total_CH12;

    return %peaks;
}

1;
