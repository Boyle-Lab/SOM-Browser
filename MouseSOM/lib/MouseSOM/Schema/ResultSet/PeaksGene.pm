package MouseSOM::Schema::ResultSet::PeaksGene;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_genes_summary {
    # Gets only data needed for the neuron summary block
    my ($self, $neuron) = @_;

    my %peaks;

    my (@tss, @tss_hg19, @tss_mm9, @tss_K562, @tss_GM12878, @tss_MEL,
	@tss_CH12);

    my $peaks_rs = $self->search(
	{ 'peaks.id_neurons' => $neuron },
	{ join => 'peaks',
              select => ['peaks.species', 'peaks.cell', 
                         'me.targetgenedist'],
              as => ['species', 'cell', 'targetgenedist']
	}
	);
    
    while (my $peak = $peaks_rs->next) {

	my $tss_dist = $peak->get_column('targetgenedist');
	push @tss, $tss_dist;

        my $spp = $peak->get_column('species');
	my $cell = $peak->get_column('cell');

        if ($spp eq "hg19") {
            push @tss_hg19, $tss_dist;
            if ($cell eq "K562") {
                push @tss_K562, $tss_dist;
            } elsif ($cell eq "GM12878") {
                push @tss_GM12878, $tss_dist;
            }
        } else {
            push @tss_mm9, $tss_dist;
            if ($cell eq "MEL") {
                push @tss_MEL, $tss_dist;
            } elsif ($cell eq "CH12") {
                push @tss_CH12, $tss_dist;
            }
        }

    }

    my $tss_dist_med = "NA";
    my $tss_dist_med_hg19 = "NA";
    my $tss_dist_med_mm9 = "NA";
    my $tss_dist_med_K562 = "NA";
    my $tss_dist_med_GM12878 = "NA";
    my $tss_dist_med_MEL = "NA";
    my $tss_dist_med_CH12 = "NA";

    if ($#tss > -1) {
        $tss_dist_med = &calc_median(\@tss);
    }
    if ($#tss_hg19 > -1) {
        $tss_dist_med_hg19 = &calc_median(\@tss_hg19);
    }
    if ($#tss_mm9 > -1) {
        $tss_dist_med_mm9 = &calc_median(\@tss_mm9);
    }
    if ($#tss_K562 > -1) {
	$tss_dist_med_K562 = &calc_median(\@tss_K562);
    }
    if ($#tss_GM12878 > -1) {
        $tss_dist_med_GM12878 = &calc_median(\@tss_GM12878);
    }
    if ($#tss_MEL > -1) {
        $tss_dist_med_MEL = &calc_median(\@tss_MEL);
    }
    if ($#tss_CH12 > -1) {
        $tss_dist_med_CH12 = &calc_median(\@tss_CH12);
    }

    $peaks{tss_dist_med} = $tss_dist_med;
    $peaks{tss_dist_med_hg19} = $tss_dist_med_hg19;
    $peaks{tss_dist_med_mm9} = $tss_dist_med_mm9;
    $peaks{tss_dist_med_K562} = $tss_dist_med_K562;
    $peaks{tss_dist_med_GM12878} = $tss_dist_med_GM12878;
    $peaks{tss_dist_med_MEL} = $tss_dist_med_MEL;
    $peaks{tss_dist_med_CH12} = $tss_dist_med_CH12;

    return %peaks;
}

sub get_genes_bnorm {
    my ($self, $neuron, $genes_db, $show) = @_;

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

    $total[0] = "Overall";
    $total_hg19[0] = "Human";
    $total_mm9[0] = "Mouse";
    $total_K562[0] = "Human K562";
    $total_MEL[0] = "Mouse MEL";
    $total_GM12878[0] = "Human GM12878";
    $total_CH12[0] = "Mouse CH12";

    $total[1] =  $total_K562[1] = $total_MEL[1] = $total_GM12878[1] =
	$total_CH12[1] = $total_hg19[1] =$total_mm9[1] = 0;

    my (@tss, @tss_hg19, @tss_mm9, @tss_K562, @tss_GM12878, @tss_MEL,
        @tss_CH12);
    my (@fpkm, @fpkm_hg19, @fpkm_mm9, @fpkm_K562, @fpkm_GM12878,
        @fpkm_MEL, @fpkm_CH12);

    my $peaks_rs;
    if ($show >= 0) {
        if ($show == 0) {
	    $peaks_rs = $genes_db->search(
		{ 'peaks.id_neurons' => $neuron,
		  -or => [
		      'is_orth' => { ">" => '2' },
		      'is_orth' => 0
		      ]
		},
		{ join => { 'peaks_genes' => 'peaks' },
		  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'peaks_genes.targetgenedist',
			     'me.name_mm9', 'me.name_hg19',
			     'me.exp_m', 'me.exp_c', 'me.exp_k', 'me.exp_g',
			     'me.fc_gk', 'me.fc_mc', 'me.fc_cg', 'me.fc_mk'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist', 'name_mm9', 'name_hg19',
			 'exp_m', 'exp_c', 'exp_k', 'exp_g',
			 'fc_gk', 'fc_mc', 'fc_cg', 'fc_mk']
		}
		);
	    
        } else {
	    
	    $peaks_rs = $genes_db->search(
		{ 'peaks.id_neurons' => $neuron,
		  'is_orth' => $show
                },
                { join => { 'peaks_genes' => 'peaks' },
                  select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
                             'peaks.chromstart', 'peaks.chromend',
                             'peaks_genes.targetgenedist',
                             'me.name_mm9', 'me.name_hg19',
                             'me.exp_m', 'me.exp_c', 'me.exp_k', 'me.exp_g',
                             'me.fc_gk', 'me.fc_mc', 'me.fc_cg', 'me.fc_mk'],
                  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
                         'targetgenedist', 'name_mm9', 'name_hg19',
                         'exp_m', 'exp_c', 'exp_k', 'exp_g',
                         'fc_gk', 'fc_mc', 'fc_cg', 'fc_mk']
                }
                );
        }

    } else {
        $peaks_rs = $genes_db->search(
            { 'peaks.id_neurons' => $neuron },
	    { join => { 'peaks_genes' => 'peaks' },
	      select => ['peaks.species', 'peaks.cell', 'peaks.chrom',
			 'peaks.chromstart', 'peaks.chromend',
			 'peaks_genes.targetgenedist',
			 'me.name_mm9', 'me.name_hg19',
			 'me.exp_m', 'me.exp_c', 'me.exp_k', 'me.exp_g',
			 'me.fc_gk', 'me.fc_mc', 'me.fc_cg', 'me.fc_mk'],
	      as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
		     'targetgenedist', 'name_mm9', 'name_hg19',
		     'exp_m', 'exp_c', 'exp_k', 'exp_g',
		     'fc_gk', 'fc_mc', 'fc_cg', 'fc_mk']
	    }
            );
    }
    
    my @header = ("Species/Cell", "N Peaks", "Med TSS Dist", "Med Norm Expr");

    my @header_1 = ("Cell", "Location", "Target Gene",
                    "TssDist", "GM12878 Expr", "K562 Expr", 
		    "CH12 Expr", "MEL Expr",
                    "log2 FC K562/GM12878", "Log2 FC MEL/CH12",
		    "Log2 FC CH12/GM12878", "Log2 FC MEL/K562");

    my $fpkm_max = -9999;
    my $tss_max = -999999999999999999999999999999999;
    my $fc_max = -9999;

    my $n = 0;
    while (my $peak = $peaks_rs->next) {

        my @row;

        my $cell = $row[0] = $peak->get_column('cell');

        my $loc = $peak->get_column('chrom') . ':'
            . $peak->get_column('chromstart') . '-'
            . $peak->get_column('chromend');
        $row[1] = $loc;

	if ($peak->get_column('species') eq "mm9") {
	    $row[2] = $peak->get_column('name_mm9');
	} else {
	    $row[2] = $peak->get_column('name_hg19');
	}
        $row[3] = $peak->get_column('targetgenedist');

        if (abs($row[3]) > $tss_max) {
            $tss_max = abs($row[3]);
        }

        # Gene expression values
        $row[4] = $peak->get_column('exp_g');
        $row[5] = $peak->get_column('exp_k');
	$row[6] = $peak->get_column('exp_c');
        $row[7] = $peak->get_column('exp_m');
        $row[8] = $peak->get_column('fc_gk');
	$row[9] = $peak->get_column('fc_mc');
	$row[10] = $peak->get_column('fc_cg');
	$row[11] = $peak->get_column('fc_mk');

        if (defined($row[4]) && $row[4] ne "NA" && $row[4] > $fpkm_max) {
            $fpkm_max = $row[4];
        }
        if (defined($row[5]) && $row[5] ne "NA" && $row[5] > $fpkm_max) {
            $fpkm_max = $row[5];
        }
	if (defined($row[6]) && $row[6] ne "NA" && $row[6] > $fpkm_max) {
            $fpkm_max = $row[6];
        }
        if (defined($row[7]) && $row[7] ne "NA" && $row[7] > $fpkm_max) {
            $fpkm_max = $row[7];
        }

	if (defined($row[8]) && $row[8] ne "NA") {
	    if (abs($row[8]) > $fc_max) {
		$fc_max = abs($row[8]);
	    }
	}
	if (defined($row[9]) && $row[9] ne "NA") {
	    if (abs($row[9]) > $fc_max) {
		$fc_max = abs($row[9]);
	    }
	}
	if (defined($row[10]) && $row[10] ne "NA") {
	    if (abs($row[10]) > $fc_max) {
		$fc_max = abs($row[10]);
	    }
	}
	if (defined($row[11]) && $row[11] ne "NA") {
	    if (abs($row[11]) > $fc_max) {
		$fc_max = abs($row[11]);
	    }
	}


        push @tss, $row[3];
        $total[1]++;

        my $spp = $peak->get_column('species');
        if ($spp eq "hg19") {
            push @peaks_hg19, \@row;
            push @tss_hg19,$row[3];
            $total_hg19[1]++;
            if ($cell eq "K562") {
                push @tss_K562, $row[3];
		if (defined($row[7]) && $row[7] ne "NA") {
		    push @fpkm, $row[5];
		    push @fpkm_hg19, $row[5];
		    push @fpkm_K562, $row[5];
		}
                $total_K562[1]++;
            } elsif ($cell eq "GM12878") {
                push @tss_GM12878,$row[3];
		if (defined($row[6]) && $row[6] ne "NA") {
		    push @fpkm, $row[4];
		    push @fpkm_hg19, $row[4];
		    push @fpkm_GM12878, $row[4];
		}
                $total_GM12878[1]++;
            }
        } else {
            push @peaks_mm9, \@row;
            push @tss_mm9,$row[3];
            $total_mm9[1]++;
            if ($cell eq "MEL") {
                push @tss_MEL,$row[3];
		if (defined($row[9]) && $row[9] ne "NA") {
		    push @fpkm, $row[7];
		    push @fpkm_mm9, $row[7];
		    push @fpkm_MEL, $row[7];
		}
                $total_MEL[1]++;
            } elsif ($cell eq "CH12") {
                push @tss_CH12,$row[3];
		if (defined($row[8]) && $row[8] ne "NA") {
		    push @fpkm, $row[6];
		    push @fpkm_mm9, $row[6];
		    push @fpkm_CH12, $row[6];
		}
                $total_CH12[1]++;
            }
        }
        $n++;
    }

    if ($n == 0) {
        $n++;
    }

    my $tss_dist_med = "NA";
    my $tss_dist_med_hg19 = "NA";
    my $tss_dist_med_mm9 = "NA";
    my $tss_dist_med_K562 = "NA";
    my $tss_dist_med_GM12878 = "NA";
    my $tss_dist_med_MEL = "NA";
    my $tss_dist_med_CH12 = "NA";

    if ($#tss > -1) {
        $tss_dist_med = &calc_median(\@tss);
    }
    if ($#tss_hg19 > -1) {
        $tss_dist_med_hg19 = &calc_median(\@tss_hg19);
    }
    if ($#tss_mm9 > -1) {
        $tss_dist_med_mm9 = &calc_median(\@tss_mm9);
    }
    if ($#tss_K562 > -1) {
	$tss_dist_med_K562 = &calc_median(\@tss_K562);
    }
    if ($#tss_GM12878 > -1) {
        $tss_dist_med_GM12878 = &calc_median(\@tss_GM12878);
    }
    if ($#tss_MEL > -1) {
        $tss_dist_med_MEL = &calc_median(\@tss_MEL);
    }
    if ($#tss_CH12 > -1) {
        $tss_dist_med_CH12 = &calc_median(\@tss_CH12);
    }

    $total[2] = $tss_dist_med;
    $total_hg19[2] = $tss_dist_med_hg19;
    $total_mm9[2] = $tss_dist_med_mm9;
    $total_K562[2] = $tss_dist_med_K562;
    $total_GM12878[2] = $tss_dist_med_GM12878;
    $total_CH12[2] = $tss_dist_med_CH12;
    $total_MEL[2] = $tss_dist_med_MEL;

    my $fpkm_med = "NA";
    my $fpkm_med_hg19 = "NA";
    my $fpkm_med_mm9 = "NA";
    my $fpkm_med_K562 = "NA";
    my $fpkm_med_GM12878 = "NA";
    my $fpkm_med_MEL = "NA";
    my $fpkm_med_CH12 = "NA";

    if ($#fpkm > -1) {
        $fpkm_med = &calc_median(\@fpkm);
    }
    if ($#fpkm_hg19 > -1) {
        $fpkm_med_hg19 = &calc_median(\@fpkm_hg19);
    }
    if ($#fpkm_mm9 > -1) {
        $fpkm_med_mm9 = &calc_median(\@fpkm_mm9);
    }
    if ($#fpkm_K562 > -1) {
        $fpkm_med_K562 = &calc_median(\@fpkm_K562);
    }
    if ($#fpkm_GM12878 > -1) {
        $fpkm_med_GM12878 = &calc_median(\@fpkm_GM12878);
    }
    if ($#fpkm_MEL > -1) {
        $fpkm_med_MEL = &calc_median(\@fpkm_MEL);
    }
    if ($#fpkm_CH12 > -1) {
        $fpkm_med_CH12 = &calc_median(\@fpkm_CH12);
    }

    $total[3] = $fpkm_med;
    $total_hg19[3] = $fpkm_med_hg19;
    $total_mm9[3] = $fpkm_med_mm9;
    $total_K562[3] = $fpkm_med_K562;
    $total_GM12878[3] = $fpkm_med_GM12878;
    $total_CH12[3] = $fpkm_med_CH12;
    $total_MEL[3] = $fpkm_med_MEL;

#    if (@peaks_hg19) {
#        @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#                                 $a->[2] <=> $b->[2] } @peaks_hg19;
#    }
#    if (@peaks_mm9) {
#        @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#                                $a->[2] <=> $b->[2] } @peaks_mm9;
#    }

    $peaks{header} = \@header;
    $peaks{header_1} = \@header_1;


    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{peaks_mm9} = \@peaks_mm9;
    $peaks{npeaks} = $n;

    $peaks{tss_dist_med} = $tss_dist_med;
    $peaks{tss_dist_med_hg19} = $tss_dist_med_hg19;
    $peaks{tss_dist_med_mm9} = $tss_dist_med_mm9;
    $peaks{tss_dist_med_K562} = $tss_dist_med_K562;
    $peaks{tss_dist_med_GM12878} = $tss_dist_med_GM12878;
    $peaks{tss_dist_med_MEL} = $tss_dist_med_MEL;
    $peaks{tss_dist_med_CH12} = $tss_dist_med_CH12;

    $peaks{total} = \@total;
    $peaks{total_hg19} = \@total_hg19;
    $peaks{total_mm9} = \@total_mm9;
    $peaks{total_K562} = \@total_K562;
    $peaks{total_MEL} = \@total_MEL;
    $peaks{total_GM12878} = \@total_GM12878;
    $peaks{total_CH12} = \@total_CH12;

    $peaks{tss_max} = $tss_max;
    $peaks{fpkm_max} = $fpkm_max;
    $peaks{fc_max} = $fc_max;

#    print STDERR "tmax: $tss_max, fmax: $fpkm_max, fcmax: $fc_max\n";

    return %peaks;
}


sub calc_median {
    # Compute the median by sorting the input list. For long lists this
    # may be inefficient.
    my $values = $_[0];

    my @sorted = sort { $a <=> $b } @{$values};

    my $median = 0;
    if ( ($#sorted + 1) % 2) { # Odd-sized list
        $median = $sorted[$#sorted / 2];
    } else { # Even-sized list
        $median = ( ($sorted[ ($#sorted + 1) / 2 ]
                     + $sorted[ (($#sorted + 1) / 2) - 1 ]) / 2 );
    }
    return $median;
}


1;
