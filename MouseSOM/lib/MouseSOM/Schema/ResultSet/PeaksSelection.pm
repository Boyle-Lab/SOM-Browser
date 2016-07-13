package MouseSOM::Schema::ResultSet::PeaksSelection;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_selection {
    my ($self, $neuron, $show) = @_; 

    my %peaks;
    my @peaks_hg19;
    my @peaks_mm9;
    my @total;
    my @total_hg19;
    my @total_mm9;
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
			     'me.pc_cov', 'me.pc_avg',
			     'me.pc_max', 'me.pc_min',
			     'me.pp_avg', 'me.pp_max', 
			     'me.pp_min', 'me.selsites'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist',
			 'pc_cov', 'pc_avg', 'pc_max', 'pc_min',
			 'pp_avg', 'pp_max', 'pp_min', 'selsites']
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
			     'me.pc_cov', 'me.pc_avg',
			     'me.pc_max', 'me.pc_min',
			     'me.pp_avg', 'me.pp_max', 
			     'me.pp_min', 'me.selsites'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist',
			 'pc_cov', 'pc_avg', 'pc_max', 'pc_min',
			 'pp_avg', 'pp_max', 'pp_min', 'selsites']
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
                         'me.pc_cov', 'me.pc_avg',
			 'me.pc_max', 'me.pc_min',
			 'me.pp_avg', 'me.pp_max', 
			 'me.pp_min', 'me.selsites'],
              as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
                     'targetgenedist',  'pc_cov', 'pc_avg', 'pc_max', 'pc_min',
		     'pp_avg', 'pp_max', 'pp_min', 'selsites']
            }
            );
    }

    my @header_a = ("Species", "N Peaks", "PhastCons Coverage", "PhastCons Avg",
                    "PhastCons Max", "PhastCons Min", "PhyloP Avg",
                    "PhyloP Max", "PhyloP Min", "Selected Sites");
    my @header_b = ("Cell", "Location", "TssDist",
		    "PhastCons Coverage", "PhastCons Avg", "PhastCons Max",
		    "PhastCons Min", "PhyloP Avg", "PhyloP Max", "PhyloP Min",
		    "Selected Sites");

    my $pp_max = -999;
    my $pp_min = 999;
    my $ppa_max = -999;

    my $i = 0;
    my $n_hg19 = 0;
    my $n_mm9 = 0;
    my $n_K562 = 0;
    my $n_MEL = 0;
    my $n_GM12878 = 0;
    my $n_CH12 = 0;

    while (my $peak = $peaks_rs->next) {
        my @row;

	my $cell = $row[0] = $peak->get_column('cell');
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

        $row[3] = sprintf "%.4f", $peak->get_column('pc_cov');
        $row[4] = sprintf "%.4f", $peak->get_column('pc_avg');
        $row[5] = sprintf "%.4f", $peak->get_column('pc_max');
        $row[6] = sprintf "%.4f", $peak->get_column('pc_min');
        $row[7] = sprintf "%.4f", $peak->get_column('pp_avg');
        $row[8] = sprintf "%.4f", $peak->get_column('pp_max');
        $row[9] = sprintf "%.4f", $peak->get_column('pp_min');
        $row[10] = sprintf "%.4f", $peak->get_column('selsites');

        if ($row[7] > $ppa_max) {
            $ppa_max = $row[7];
        }   
        if ($row[8] > $pp_max) {
            $pp_max = $row[8];
        }
        if ($row[9] < $pp_min) {
            $pp_min = $row[9];
        }

        my $spp = $peak->get_column('species');
        if ($spp eq "hg19") {
            push @peaks_hg19, \@row;
            $n_hg19++;
	    
        } else {
            push @peaks_mm9, \@row;
            $n_mm9++;
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
            if ($spp eq "hg19") {
                $total_hg19[$j] += $row[$k];
		if ($cell eq "K562") {
                    $total_K562[$j] += $row[$k];
                } elsif ($cell eq "GM12878") {
                    $total_GM12878[$j] += $row[$k];
                }
            } else {
                $total_mm9[$j] += $row[$k];
		if ($cell eq "MEL") {
                    $total_MEL[$j] += $row[$k];
                } elsif ($cell eq "CH12") {
                    $total_CH12[$j] += $row[$k];
                }
            }
        }

        $i++;
    }   

#    print STDERR "i $i, mm9 $n_mm9, hg19 $n_hg19\n";

    $total[1] = $i;
    $total_K562[1] = $n_K562;
    $total_MEL[1] = $n_MEL;
    $total_GM12878[1] = $n_GM12878;
    $total_CH12[1] = $n_CH12;
    $total_hg19[1] = $n_hg19;
    $total_mm9[1]= $n_mm9;
    
    if ($n_hg19 == 0) {
        $n_hg19++;
    }
    if ($n_mm9 == 0) {
        $n_mm9++;
    }
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
    
    $total[0] = "Overall Average";
    $total_hg19[0] = "Human Average";
    $total_mm9[0] = "Mouse Average";
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
        if (!defined($total_hg19[$j])) {
            $total_hg19[$j] = 0;
        }
        if (!defined($total_mm9[$j])) {
            $total_mm9[$j] = 0;
        }

        $total[$j] = sprintf "%.4f", $total[$j] / $i;
        $total_hg19[$j] = sprintf "%.4f", $total_hg19[$j] / $n_hg19;
        $total_mm9[$j] = sprintf "%.4f", $total_mm9[$j] / $n_mm9;
        $total_GM12878[$j] = sprintf "%.4f", $total_GM12878[$j] / $n_GM12878;
        $total_CH12[$j] = sprintf "%.4f", $total_CH12[$j] / $n_CH12;
        $total_K562[$j] = sprintf "%.4f", $total_K562[$j] / $n_K562;
        $total_MEL[$j] = sprintf "%.4f", $total_MEL[$j] / $n_MEL;
    }

#    foreach my $row (@peaks_mm9) {
#        print STDERR "@{$row}\n";
#    }

#    print STDERR "ppa_max $ppa_max, pp_max $pp_max, pp_min $pp_min\n";

# Sorting now handled client-side by tablesorter.js
#    @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#			     $a->[2] <=> $b->[2] } @peaks_hg19;
#    @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#			    $a->[2] <=> $b->[2] } @peaks_mm9;

    $peaks{header_a} = \@header_a;
    $peaks{header_b} = \@header_b;
    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{peaks_mm9} = \@peaks_mm9;
    $peaks{total} = \@total;
    $peaks{total_hg19} = \@total_hg19;
    $peaks{total_mm9} = \@total_mm9;
    $peaks{total_K562} = \@total_K562;
    $peaks{total_MEL} = \@total_MEL;
    $peaks{total_GM12878} = \@total_GM12878;
    $peaks{total_CH12} = \@total_CH12;
    $peaks{pp_max} = $pp_max;
    $peaks{pp_min} = $pp_min;
    $peaks{ppa_max} = $ppa_max;
    $peaks{n_peaks} = $i;

    return %peaks;
}

1;
