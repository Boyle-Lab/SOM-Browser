package MouseSOM::Schema::ResultSet::PeaksChromstate;

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
			     'me.states'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist', 'states']
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
			     'me.states'],
		  as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
			 'targetgenedist', 'states']
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
			 'me.states'],
	      as => ['species', 'cell', 'chrom', 'chromstart', 'chromend',
		     'targetgenedist', 'states']
	    }
            );
    }
    
    for (my $c = 2; $c <= 8; $c++) {
	$total[$c] = $total_K562[$c] = $total_MEL[$c] = $total_GM12878[$c] =
	    $total_CH12[$c] = 0;
    }

    my @header_a = ("Source", "N Peaks", "K4me3", "K4me1+K4me3", "K4me1", "K4me1+K36me3", "K36me3", "Unmarked", "K27me3");
    my @header_b = ("Cell", "Location", "TssDist", "ChromStates");

    my $i = 0;
    my $n_K562 = 0;
    my $n_MEL = 0;
    my $n_GM12878 = 0;
    my $n_CH12 = 0;
    while (my $peak = $peaks_rs->next) {
        my @row;

        my $loc = $peak->get_column('chrom') . ':'
            . $peak->get_column('chromstart') . '-'
            . $peak->get_column('chromend');

	$row[0]= $peak->get_column('cell');
        $row[1] = $loc;

	my $tssDist = $peak->get_column('targetgenedist');
	if (defined($tssDist)) {
	    $row[2] = $tssDist;
        } else {
            $row[2] = "NA";
	}

#	print STDERR "@row\n";

	my $start = $peak->get_column('chromstart');
	my $end = $peak->get_column('chromend');
	my $len = $end - $start;
	
	my $states_str = $peak->get_column('states');
	my @tmp = split /,/, $states_str;

	my $last = 0;
	my $col;
	foreach my $state (@tmp) {
	    my @tmp1 = split /:/, $state;
	    my ($s, $e) = split /-/, $tmp1[0];
	    if ($s < $start) {
		$s = $start;
	    }
	    if ($e > $end) {
		$e = $end;
	    }

	    my $l = $e - $s;
	    my $f = ($l / $len) * 100;
	    my $dec = sprintf("%.2f", $f - int($f));
	   
#	    print STDERR "$f, $dec, ";
	    if ($dec < 0.5) {
		$f = int($f);
	    } else {
		$f = int($f) + 1;
	    }
#            print STDERR " $s, $e, $f, $last\n";
	    
	    my $j;
	    for ($j = $last; $j < ($last + $f); $j++) { 
		if ($j > 99) {
		    # Avoids jagged rows
		    last;
		}
		if ($tmp1[1] == 1) {
		    $col = $row[$j+3] = "255,0,0";
		} elsif ($tmp1[1] == 2) {
		    $col = $row[$j+3]= "255,153,0";
		} elsif($tmp1[1] == 3) {
                    $col = $row[$j+3]= "255,255,0";
		} elsif($tmp1[1] == 4) {
                    $col = $row[$j+3]= "153,204,0";
		} elsif($tmp1[1] == 5) {
                    $col = $row[$j+3]= "0,153,102";
		} elsif($tmp1[1] == 6) {
                    $col = $row[$j+3]= "155,155,155";
		} elsif($tmp1[1] == 7) {
                    $col = $row[$j+3]= "0,0,255";
		}
	    }
	    $last = $j;
	    
	    $total[$tmp1[1]+1]++;
	    
	    if ($row[0] eq "K562") {
		$total_K562[$tmp1[1]+1]++;
	    } elsif ($row[0] eq "MEL") {
		$total_MEL[$tmp1[1]+1]++;
	    } elsif ($row[0] eq "GM12878") {
		$total_GM12878[$tmp1[1]+1]++;
	    } else {
		$total_CH12[$tmp1[1]+1]++;
	    }

	}

	# Avoids jagged rows
	while ($last <= 99) {
	    $row[$last+3] = $col;
	    $last++;
	}

#	print STDERR "@row\n";

	my $spp = $peak->get_column('species');
        if ($spp eq "hg19") {
            push @peaks_hg19, \@row;
        } else {
            push @peaks_mm9, \@row;
        }
	
	if ($row[0] eq "K562") {
	    $n_K562++;
	} elsif ($row[0] eq "MEL") {
	    $n_MEL++;
	} elsif ($row[0] eq "GM12878") {
	    $n_GM12878++;
	} else {
	    $n_CH12++;
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
        $total[$j] = sprintf "%.4f", $total[$j] / $i;
        $total_K562[$j] = sprintf "%.4f", $total_K562[$j] / $n_K562;
        $total_MEL[$j] = sprintf "%.4f", $total_MEL[$j] / $n_MEL;
	$total_GM12878[$j] = sprintf "%.4f", $total_GM12878[$j] / $n_GM12878;
	$total_CH12[$j] = sprintf "%.4f", $total_CH12[$j] / $n_CH12;
    }

    @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] } @peaks_hg19;
    @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] } @peaks_mm9;

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
