package MouseSOM::Schema::ResultSet::Peak;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_peaks {
    my ($self, $neuron, $peaks_genes, $factors, $show) = @_;

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
            $peaks_rs = $peaks_genes->search(
                { 'id_neurons' => $neuron,
                  -or => [
                      'is_orth' => { ">" => '2' },
                      'is_orth' => 0
                      ]
                },
                { join => 'peaks',
		  select => ['peaks.id_peaks', 'peaks.species', 'peaks.cell', 'peaks.chrom',
			     'peaks.chromstart', 'peaks.chromend',
			     'me.targetgenedist'],
		  as => ['id_peaks', 'species', 'cell', 'chrom', 'chromstart',
			 'chromend', 'targetgenedist']
                }
                );
	    
        } else {

            $peaks_rs = $peaks_genes->search(
                { 'id_neurons' => $neuron,
                  'is_orth' => $show
                },
                { join => 'peaks',
                  select => ['peaks.id_peaks', 'peaks.species', 'peaks.cell', 'peaks.chrom',
                             'peaks.chromstart', 'peaks.chromend',
                             'me.targetgenedist'],
                  as => ['id_peaks', 'species', 'cell', 'chrom', 'chromstart',
                         'chromend', 'targetgenedist']
                }
                );
	}
	    
    } else {
	$peaks_rs = $peaks_genes->search(
            { 'id_neurons' => $neuron },
	    { join => 'peaks',
	      select => ['peaks.id_peaks', 'peaks.species', 'peaks.cell', 'peaks.chrom',
			 'peaks.chromstart', 'peaks.chromend',
			 'me.targetgenedist'],
	      as => ['id_peaks', 'species', 'cell', 'chrom', 'chromstart',
		     'chromend', 'targetgenedist']
	    }
	    );
    }

    my @factors_a = ("Species", "N Peaks");
    my @factors_b = ("Cell", "Location", "TssDist");

    my $i = 0;
    my $n_hg19 = 0;
    my $n_mm9 = 0;
    my $n_K562 = 0;
    my $n_MEL = 0;
    my $n_GM12878 = 0;
    my $n_CH12 = 0;

    while (my $peak = $peaks_rs->next) {
        my @row;

	my $id_peaks = $peak->get_column('id_peaks');
	
	my $cell = $row[0] = $peak->get_column('cell');

	my $loc = $peak->get_column('chrom') . ':'
            . $peak->get_column('chromstart') . '-'
            . $peak->get_column('chromend');
	
	$row[1] = $loc;

	my $tss_dist = $peak->get_column('targetgenedist');
	if (defined($tss_dist)) {
	    $row[2] = $tss_dist;
	} else {
	    $row[2] = "NA";
	}

        my $factors_rs = $factors->search(
            { 'id_peaks' => $id_peaks },
            { join => 'peaks_factors',
	      select => ['me.name', 'peaks_factors.score'],
	      as => ['name', 'score']
	    }
            );
       
        my %tmp_hash;
        while (my $col = $factors_rs->next) {
            my $tf = $col->get_column('name');	    
            $tmp_hash{$tf} = $col->get_column('score'); 
        }
        foreach my $key (sort(keys(%tmp_hash))) {
            if ($i == 0) {
		my $f = $key;
		if ($key eq "POLR2A") {
		    $f = "POL2";
		} elsif ($key eq "POLR2AphosphoS2") {
		    $f = "POL2pS2";
		}
                push @factors_a, $f;
                push @factors_b, $f;
            }
            push @row, $tmp_hash{$key};
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
	$total_K562[$j] = sprintf "%.4f", $total_K562[$j] / $n_K562;
        $total_MEL[$j] = sprintf "%.4f", $total_MEL[$j] / $n_MEL;
        $total_GM12878[$j] = sprintf "%.4f", $total_GM12878[$j] / $n_GM12878;
        $total_CH12[$j] = sprintf "%.4f", $total_CH12[$j] / $n_CH12;
        $total_hg19[$j] = sprintf "%.4f", $total_hg19[$j] / $n_hg19;
        $total_mm9[$j] = sprintf "%.4f", $total_mm9[$j] / $n_mm9;
    }

#    foreach my $row (@peaks_mm9) {
#        print STDERR "@{$row}\n";
#    }

# Sorting now handled client-side by tablesorter.js
#    @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#			     $a->[2] <=> $b->[2] } @peaks_hg19;
#    @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
#			    $a->[2] <=> $b->[2] } @peaks_mm9;

    $peaks{factors_a} = \@factors_a;
    $peaks{factors_b} = \@factors_b;
    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{peaks_mm9} = \@peaks_mm9;
    $peaks{total} = \@total;
    $peaks{total_K562} = \@total_K562;
    $peaks{total_MEL} = \@total_MEL;
    $peaks{total_GM12878} = \@total_GM12878;
    $peaks{total_CH12} = \@total_CH12;
    $peaks{total_hg19} = \@total_hg19;
    $peaks{total_mm9} = \@total_mm9;
    $peaks{n_peaks} = $i;
    $peaks{n_factors_a} = $#factors_a - 2;
    $peaks{n_factors_b} = $#factors_b - 2;
    
    return %peaks;
}

sub get_search_res {
    my ($self, $neruons_db, $peaks_db, $factors_db, $peaks_factors_db,
	$peaks_genes_db,
	$peaks_selection_db, $peaks_histmods_db, $params, $dbh) = @_;

    my $show_map = 1; # Change this to form-supplied argument!

    my %res;
    my @query_params;
    my @header;
    my @out_rows;

    # Transliteration of db table names to plain English names used in the
    # search menus
    my %tbl_names = (
	"neurons" => "Patterns",
	"factors" => "Transcription Factors",
	"peaks_genes" => "Target Genes",
	"genes" => "Gene Expression (tpm)",
	"genes_bnorm" => "Gene Expression (batch norm tpm)",
	"genes_qnorm" => "Gene Expression (quantile norm tpm)",
	"peaks" => "Modules",
	"peaks_selection" => "Selection",
	"peaks_histmods" => "Histone Modifications",
	"go_data" => "GO Term Enrichment",
	"gwas" => "Gwas",
	"peaks_dnase" => "DNase Hypersensitivity",
	"neurons" => "Patterns",
	"peaks" => "Modules"
    );

    my $n_fields = $params->{n_fields};
    my $n_orders = $params->{n_orders};
    my $n_groups = $params->{n_groups};
    my $factors_q = 0;
    my $peaks_factors_q = 0;
    my $gwas_q = 0;
    my $peaks_gwas_q = 0;

    my $base_table = $params->{base_table};

#    my $group_by_table = $params->{group_by_t};
#    my $group_by_field = $params->{group_by_f};

    my $qry;
    if ($n_groups == 0) {
	$qry = "SELECT * FROM $base_table";
    } else {
	$qry = "SELECT *, COUNT(*) AS count FROM $base_table";
    }

    my %tables;
    for (my $i = 0; $i < $n_fields; $i++) {
	my $tname = "table_" . $i;
	my $tbl = $params->{$tname};
#	print STDERR "$tbl\n";
	if (defined($tbl)) {
	    $tables{$tbl} = "";
	}
    }

    if (!keys(%tables)) {
	$res{error} = 1;
	return -1;
    }

#    if ($group_by_table ne "NULL" && $group_by_table ne $base_table) {
#	my $gb_table_found = 0;
#	foreach my $table (keys(%tables)) {
#	    if ($table eq $group_by_table
#		|| ( ($table eq "geneexp" ||
#		      $table eq "genexp_qnorm" ||
#		      $table eq "genexp_bnorm") &&
#		    $group_by_table eq "peaks_genes")) {
#		$gb_table_found = 1;
#		last;
#	    }
#	}
#	if (!$gb_table_found) {
#	    $res{error} = 1;
#	    return %res;
#	    return -1;
#	}
#    }

    my $base_qry = $qry;
    
    # Set up joins
    foreach my $table (keys(%tables)) {
#	    print STDERR "$table\n";
	if ($base_table eq "peaks") {
	    if ($table eq "peaks") {
		next;
	    } elsif ($table eq "factors") {
		$factors_q = 1;
		if ($peaks_factors_q) {
		    $qry .= " INNER JOIN factors on factors.id_factors = peaks_factors.id_factors";
		} else  {
		    $qry .= " INNER JOIN peaks_factors ON peaks_factors.id_peaks = peaks.id_peaks INNER JOIN factors on factors.id_factors = peaks_factors.id_factors";
		}
		next;
	    } elsif ($table eq "peaks_factors") {
		$peaks_factors_q = 1;
		if ($factors_q) {
		    next;
		}
	    } elsif ($table eq "neurons") {
		$qry .= " INNER JOIN neurons ON neurons.id_neurons = peaks.id_neurons";
		next;
	    } elsif ($table eq "go_data") {
		$qry .= " INNER JOIN go_data ON go_data.id_neurons = peaks.id_neurons";
		next;
	    } elsif ($table eq "genes") {
		if (!($qry =~ m/peaks_genes\.id_peaks/)) {
		    $qry .= " INNER JOIN peaks_genes ON peaks_genes.id_peaks = peaks.id_peaks";
		}
		$qry .= " INNER JOIN genes ON genes.id_genes = peaks_genes.id_genes";
		next;
	    } elsif ($table eq "genes_qnorm") {
                if (!($qry =~ m/peaks_genes\.id_peaks/)) {
                    $qry .= " INNER JOIN peaks_genes ON peaks_genes.id_peaks = peaks.id_peaks";
                }
		$qry .= " INNER JOIN genes_qnorm ON genes_qnorm.id_genes = peaks_genes.id_genes";
		next;
            } elsif ($table eq "genes_bnorm") {
                if (!($qry =~ m/peaks_genes\.id_peaks/)) {
                    $qry .= " INNER JOIN peaks_genes ON peaks_genes.id_peaks = peaks.id_peaks";
		    }
                $qry .= " INNER JOIN genes_bnorm ON genes_bnorm.id_genes = peaks_genes.id_genes";
		next;
            } elsif ($table eq "gwas") {
		$gwas_q = 1;
		if ($peaks_gwas_q) {
                    $qry .= " INNER JOIN gwas on gwas.id_gwas = peaks_gwas.id_gwas";
                } else  {
		    $qry .= " INNER JOIN peaks_gwas ON peaks_gwas.id_peaks = peaks.id_peaks INNER JOIN gwas ON peaks_gwas.id_gwas = gwas.id_gwas";
		}
	    } elsif ($table eq "peaks_gwas") {
                $peaks_gwas_q = 1;
                if ($gwas_q) {
                    next;
                }
	    }

	    if (!($qry =~ m/$table\.id_peaks/)) {
		$qry .= " INNER JOIN $table ON $table.id_peaks = peaks.id_peaks";
	    }
	} elsif ($base_table eq "neurons") {
	
	    if ($table eq "neurons") {
		next;
	    } elsif ($table eq "factors") {
		$factors_q = 1;
		$qry .= " INNER JOIN neurons_factors on neurons_factors.id_neurons = neurons.id_neurons INNER JOIN factors ON factors.id_factors = neurons_factors.id_factors";
		next;
	    } elsif ($table eq "peaks_factors" ||
#		     $table eq "peaks_genes" ||
		     $table eq "peaks_selection"||
		     $table eq "peaks_histmods") {
		$qry .= " INNER JOIN peaks ON peaks.id_neurons = neurons.id_neurons INNER JOIN $table ON $table.id_peaks = peaks.id_peaks";
		next;
#	    } elsif ($table eq "genes" || $table eq "genes_bnorm" || $table eq "genes_qnorm") {
#		$qry .= " INNER JOIN peaks ON peaks.id_neurons = neurons.id_neurons INNER JOIN peaks_genes ON peaks_genes.id_peaks = peaks.id_peaks INNER JOIN $table ON $table.id_genes = peaks_genes.id_genes";
#		next;
	    } elsif ($table eq "gwas") {
                $gwas_q = 1;
                if ($peaks_gwas_q) {
                    $qry .= " INNER JOIN gwas on gwas.id_gwas = peaks_gwas.id_gwas";
		} else  {
                    $qry .= " INNER JOIN peaks_gwas ON peaks_gwas.id_peaks = peaks.id_peaks INNER JOIN gwas ON peaks_gwas.id_gwas = gwas.id_gwas";
                }
		next;
            } elsif ($table eq "peaks_gwas") {
                $peaks_gwas_q = 1;
                if ($gwas_q) {
                    next;
                }
            } elsif ($table eq "peaks_genes" ||
		     $table eq "genes" ||
		     $table eq "genes_bnorm" ||
		     $table eq "genes_qnorm") {
		# Do not add any base-level joins for these tables because they have too large
		# an impact on query efficiency for "like" comparisons!
		next;
	    }

	    $qry .= " INNER JOIN $table ON $table.id_neurons = neurons.id_neurons";
	}
    }

    my $is_group = 0;
    for (my $i = 0; $i < $n_fields; $i++) {
        my $tname = "table_" . $i;

	if (!defined($params->{$tname})) {
	    next;
	}

        my $fname = "field_" . $i;
        my $cname = "constraint_" . $i;
        my $vname = "value_" . $i;
	my $chain = "chain_" . $i;
	my $group = "cond_group_" . $i;
        my $tbl = $params->{$tname};
        my $fld = $params->{$fname};
        my $cnd = $params->{$cname};
        my $val = $params->{$vname};
	my $cgp = $params->{$group};

#	if ($cgp && !$is_group) {
#	    $is_group = 1;
#	    $qry =~ m/(\S+\s>*<*!*=*[XOR]*[NOT]*[LIKE]*\s\S+$)/;
#	    print STDERR "$1\n"
#	    my $m = $1;;
#	    $qry =~ s/$m/\($m/;
#	}
#	if ($is_group && !$cgp) {
#	    $is_group = 0;
#	    $qry .= ')';  
#	}

	my $gwp = "";
	if ($cgp) {
	    $gwp = "TRUE";
	}

	if ($i == 0) {
	    $qry = $qry. " WHERE";
	    push @query_params, ["", $tbl_names{$tbl}, $fld, $cnd, $val, $gwp];
	} else {
	    my $chn = $params->{$chain};
#	    print STDERR "$chn\n";
	    if ($chn eq "NOT") {
		$qry .= " AND NOT";
	    } else {
		$qry .= " $chn";
	    }
	    push @query_params, [$chn, $tbl_names{$tbl}, $fld, $cnd, $val, $gwp];
	}

	if ($cgp && !$is_group){
	    $qry .= ' (';
	    $is_group = 1;
	}
	
	# Add the query terms
	if ($base_table eq "neurons" && $tbl =~ m/genes/ &&
	    ($fld eq "targetGene" || $fld eq "name_hg19" || $fld eq "name_mm9") &&
	    ($cnd eq "=" || $cnd eq "!=" || $cnd eq "LIKE")) {
	    if ($cnd eq "=") {
		$qry .= ' "' . $val . '" IN (SELECT pg.targetGene FROM peaks p INNER JOIN peaks_genes pg ON pg.id_peaks = p.id_peaks INNER JOIN neurons n ON n.id_neurons = p.id_neurons WHERE p.id_neurons = neurons.id_neurons)';
	    } elsif ($cnd eq "LIKE") {
		$qry .= ' EXISTS (SELECT 1 FROM peaks p INNER JOIN peaks_genes pg ON pg.id_peaks = p.id_peaks INNER JOIN neurons n ON n.id_neurons = p.id_neurons WHERE p.id_neurons = neurons.id_neurons AND pg.targetGene LIKE "%' . $val . '%")';
	    } else {
		$qry .= ' "' . $val . '" NOT IN (SELECT pg.targetGene FROM peaks p INNER JOIN peaks_genes pg ON pg.id_peaks = p.id_peaks INNER JOIN neurons n ON n.id_neurons = p.id_neurons WHERE p.id_neurons = neurons.id_neurons)';
	    }
	} elsif ($tbl eq "factors") {
	    if ($qry !~ m/factors\.name/) {
		$qry =~ s/\*/\*, factors\.name AS TF/;
	    }
	    if ($cnd eq "=" || $cnd eq "!=" || $cnd eq "LIKE") {
		if ($base_table eq "peaks") {
		    if ($cnd eq "=") {
			$qry .= ' "' . $val . '" IN (SELECT f.name FROM factors f INNER JOIN peaks_factors pf ON pf.id_factors = f.id_factors WHERE pf.id_peaks = peaks.id_peaks AND pf.score = 1)';
		    } elsif ($cnd eq "LIKE") {			
			$qry .= ' EXISTS (SELECT 1 FROM factors f INNER JOIN peaks_factors pf ON pf.id_factors = f.id_factors WHERE pf.id_peaks = peaks.id_peaks AND pf.score = 1 AND f.name LIKE "%' . $val . '%")';
		    } else {
			$qry .= ' "' . $val . '" NOT IN (SELECT f.name FROM factors f INNER JOIN peaks_factors pf ON pf.id_factors = f.id_factors WHERE pf.id_peaks = peaks.id_peaks AND pf.score = 1)';
		    }
		} elsif ($base_table eq "neurons") {
		    if ($cnd eq "=") {
			$qry .= ' "' . $val . '" IN (SELECT f.name FROM factors f INNER JOIN neurons_factors nf ON nf.id_factors = f.id_factors WHERE nf.id_neurons = neurons.id_neurons)';
		    } elsif ($cnd eq "LIKE") {
			$qry .= ' EXISTS (SELECT 1 FROM factors f INNER JOIN neurons_factors nf ON nf.id_factors = f.id_factors WHERE nf.id_neurons = neurons.id_neurons AND f.name LIKE "%' . $val . '%")';
		    } else {
			$qry .= ' "' . $val . '" NOT IN (SELECT f.name FROM factors f INNER JOIN neurons_factors nf ON nf.id_factors = f.id_factors WHERE nf.id_neurons = neurons.id_neurons)';
		    }
		}
	    }
	} else {
	    if ($tbl eq "go_data") {	    
		if ($qry !~ m/go_data\.name/) {
		    $qry =~ s/\*/\*, go_data\.name AS "GO Term"/;
		}
	    }
	    if ($cnd eq "LIKE") {
		$qry .= " $tbl.$fld $cnd" . ' "%' . $val. '%"';
	    } else {
		$qry .= " $tbl.$fld $cnd" . ' "' . $val. '"';
	    }
	}

	if ($is_group && !$cgp) {
	    $is_group = 0;
	    $qry .= ')';
	}	
    }
    if ($is_group) {
	$qry .= ')';
    }

    for (my $i = 0; $i < $n_orders; $i++) {
	my $tname = "order_by_t_" . $i;
        my $fname = "order_by_f_" . $i;
	my $order = "order_by_order_" . $i;
	my $tbl = $params->{$tname};
        my $fld = $params->{$fname};
        my $ord = $params->{$order};

	if ($i == 0) {
	    $qry .= " ORDER BY $tbl.$fld $ord";
	    push @query_params, ["ORDER BY", $tbl_names{$tbl}, $fld, $ord, "", ""];
	} else {
	    $qry .= ", $tbl.$fld $ord";
	    push @query_params, ["then", $tbl_names{$tbl}, $fld, $ord, "", ""];
	}
    }

    my $gb_tbl_found = 1;
    for (my $i = 0; $i < $n_groups; $i++) {
	my $tname = "group_by_t_" . $i;
        my $fname = "group_by_f_" . $i;
	my $tbl = $params->{$tname};
        my $fld = $params->{$fname};

	if ($tbl ne $base_table) {
	    foreach my $table (keys(%tables)) {
		if ($tbl eq $table || ( $tbl eq "peaks_genes" && ( 
					    $table eq "genes" ||
					    $table eq "genes_bnorm" ||
					    $table eq "genes_qnorm" ) )
		    )
		{
		    $gb_tbl_found = 1;
		    last;
		}
	    }
	}

        if ($i == 0) {
            $qry .= " GROUP BY $tbl.$fld";
            push @query_params, ["GROUP BY", $tbl_names{$tbl}, $fld, "", "", ""];
        } else {
            $qry .= ", $tbl.$fld";
            push @query_params, ["then", $tbl_names{$tbl}, $fld, "", "", ""];
        }
    }

    # Implicit group-by if we're searching for terms within a set of results (e.g.,
    # neurons targeting one or more genes, peaks containing one or more factors),
    # since multiple results for each peak/neuron would be reported otherwise.
    if (($qry =~ m/IN \(SELECT pg\.targetGene/ ||
	 $qry =~ m/EXISTS \(SELECT 1 FROM peaks/) &&
	$qry !~ m/GROUP BY neurons.id_neurons/) {
	$qry .= " GROUP BY neurons.id_neurons";
    }
    if (($qry =~ m/IN \(SELECT f\.name/ ||
	 $qry =~ m/EXISTS \(SELECT 1 FROM factors/) &&
	$qry !~ m/GROUP BY peaks.id_peaks/ &&
	$qry !~ m/GROUP BY neurons.id_neurons/) {
	if ($base_table eq "peaks") {
	    $qry .= " GROUP BY peaks.id_peaks";
	} else {
	    $qry .= " GROUP BY neurons.id_neurons";
	}
    }

    if (!$gb_tbl_found) {
	return -1;
    }
    
    $qry .= ";";

#    print STDERR "$qry\n";

    # Check SQL statement for "blacklist" terms. This is not the sine qua non
    # of security, but should give a margin of safety from sql injection attacks.
    if ($qry =~ m/drop\s+/i ||
	$qry =~ m/insert\s+/i ||
	$qry =~ m/delete\s+/i ||
	substr($qry, 0, -1) =~ m/;/) {
	# Final regex checks for internal semicolons
	# Return error status
	$res{error} = 1;
	return %res;
    }


    my @rows = @{$dbh->selectall_arrayref($qry, { Slice => {} })};

#    print STDERR "Rows Found: ", $#rows+1, "\n";

    my @peaks_hg19;
    my @peaks_mm9;
    my $n_hg19 = 0;
    my $n_mm9 = 0;

    if ($base_table eq "peaks") {
	@header = ("Cell", "Location", "Pattern ID");
    } elsif ($base_table eq "neurons") {
	@header = ("Pattern ID");
    }

    my %in_header;
    my %neuron_counts;
    foreach my $row (@rows) {
	my @out_row;
	
	if ($base_table eq "peaks") {
	    $out_row[0] = ${$row}{cell};
	    my $loc = ${$row}{chrom} . ':'
		. ${$row}{chromStart} . '-'
		. ${$row}{chromEnd};
	    $out_row[1] = $loc;
	    $out_row[2] = ${$row}{id_neurons};
	} elsif ($base_table eq "neurons") {
	    $out_row[0] = ${$row}{id_neurons};
	}
	
	my $i = 5;
	foreach my $key (sort(keys(%{$row}))) {
#	    print STDERR "$key: ${$row}{$key}\n";
	    # Parse the output to discard what we don't need
	    if ($key eq "cell" ||
		$key =~ m/^chrom/ ||
		$key =~ m/^id_/ ||
		$key =~ m/_id$/ ||
		$key =~ m/q_/ ||
		$key eq "name" ||
		$key eq "species") {
		next;
	    } else {
		my $col = $key;
		$col =~ s/name_mm9/mouse gene/;
		$col =~ s/name_hg19/human gene/;
		if (!exists($in_header{$key})) {
		    $in_header{$key} = "";
		    push @header, $col;
		}
		push @out_row, ${$row}{$key};
	    }
	}

	if ($base_table eq "peaks") {
	    if (${$row}{species} eq "hg19") {
		$n_hg19++;
		push @peaks_hg19, \@out_row;
	    } else {
		$n_mm9++;
		push @peaks_mm9, \@out_row;
	    }
	} elsif ($base_table eq "neurons") {
	    push @out_rows, \@out_row;
	}

	# Keep a count of uses for each neuron.
	if ($base_table eq "peaks") {
	    $neuron_counts{$out_row[2]}++;
	} else {
	    $neuron_counts{$out_row[0]}++;
	}
    }


    unless ($n_orders) {
	if ($base_table eq "peaks") {
	    @peaks_hg19 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
				     $a->[2] <=> $b->[2] } @peaks_hg19;
	    @peaks_mm9 = sort { $a->[0] cmp $b->[0] || $a->[1] cmp $b->[1] ||
				    $a->[2] <=> $b->[2] } @peaks_mm9;
	} elsif ($base_table eq "neurons") {
	    @out_rows = sort { $a->[0] <=> $b->[0] } @out_rows;
	}
    }

    # Prepare the SVG image for the search results
    my $map_svg;
    my %log_counts;
    if ($show_map) {
	my $max_count = 0;
	my $max_log_count = 0;
	foreach my $key (keys(%neuron_counts)) {
#	    print STDERR "$key, $neuron_counts{$key}\n";
	    $log_counts{$key} = log($neuron_counts{$key}+1)/log(2);
	    if ($neuron_counts{$key} > $max_count) {
		$max_count = $neuron_counts{$key};
		$max_log_count = $log_counts{$key};
	    }
	}
	
	open my $SVG_FH, '<', "/var/www/MouseSOM/root/static/svg/template.svg";
	while (<$SVG_FH>) {
	    if ($_ =~ m/id="hex (\d+)/) {
		if (exists($neuron_counts{$1})) {
		    my $op;
		    if ($max_count > 10) {
			$op = $log_counts{$1} / $max_log_count;
		    } else {
			$op = $neuron_counts{$1} / $max_count;
		    }
		    $_ =~ s/opacity:0/opacity:$op/;
#		    print STDERR $_;
		}
	    } elsif ($_ =~ m/Pattern\s(\d+)/) {
		my $n = $1;
		if (exists($neuron_counts{$n})) {
		    if ($neuron_counts{$n} > 1) {
			$_ =~ s/Pattern\s\d+/Pattern $n: $neuron_counts{$n} results/;
		    } else {
			$_ =~ s/Pattern\s\d+/Pattern $n: $neuron_counts{$n} result/;
		    }
		} else {
		    $_ =~ s/Pattern\s\d+/Pattern $n: 0 results/;
		}
	    } elsif ($_ =~ m/legend\smax/) {
		my $glyph_tag = '<use xlink:href="#glyph-0" x="153" y="133.5459" id="use4537" width="80%" height="80%" />';
		my @max_chars;
		if ($max_count <= 10) {
		    @max_chars = split //, $max_count;
		} else {
		    $max_log_count = sprintf "%.2f", $max_log_count;
		    @max_chars = split //, $max_log_count;
		}
		my $x = 153 - ( ($#max_chars) * 8);
		foreach my $char (@max_chars) {
		    if ($char eq '.') {
			$char = "dot";
		    }
		    my $gt = $glyph_tag;
		    $gt =~ s/glyph-0/glyph-$char/;
		    $gt =~ s/153/$x/;
#		    print STDERR "$gt\n";
		    $map_svg .= $gt;
		    if ($char eq "dot") {
			$x += 3;
		    } else {
			$x += 8;
		    }
		}
       	    } elsif ($_ =~ m/legend\stitle/) {
#		print STDERR "$max_count\n";
		if ($max_count < 10) {
		    $map_svg .= '<use xlink:href="#glyph2-7" x="202" y="235"/><use xlink:href="#glyph2-8" x="212" y="235"/><use xlink:href="#glyph2-9" x="220" y="235"/><use xlink:href="#glyph2-10" x="228" y="235"/><use xlink:href="#glyph2-11" x="236" y="235"/>';
		} else {
		    $map_svg .= '<use xlink:href="#glyph2-12" x="177" y="235"/><use xlink:href="#glyph2-8" x="185" y="235"/><use xlink:href="#glyph2-13" x="193" y="235"/><use xlink:href="#glyph2-2" x="201.5" y="235"/><use xlink:href="#glyph2-14" x="209" y="235"/><use xlink:href="#glyph2-7" x="217"  y="235"/><use xlink:href="#glyph2-8" x="227" y="235"/><use xlink:href="#glyph2-9" x="235" y="235"/><use xlink:href="#glyph2-10" x="243" y="235"/><use xlink:href="#glyph2-11" x="251" y="235"/>';
		}
	    }
	    $map_svg .= $_;
	}
	close $SVG_FH;
    }

#    print STDERR "$map_svg\n";

    $res{show_map} = $show_map;
    $res{map_svg} = $map_svg;
    $res{q_header} = ["", "Table", "Field", "Condition", "Value", "Group W/Next"];;
    $res{query} = \@query_params;
    $res{base_table} = $tbl_names{$base_table};
    $res{header} = \@header;
    $res{nrows} = $#rows + 1;
    $res{n_hg19} = $n_hg19;
    $res{n_mm9} = $n_mm9;
    $res{rows} = \@out_rows;
    $res{peaks_hg19} = \@peaks_hg19;
    $res{peaks_mm9} = \@peaks_mm9;
    $res{error} = 0;

    return %res;
}

sub get_orthologs {
    my ($self, $neuron, $orths_db, $factors_db, $peaks_genes, $show) = @_;

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

    my %factor_str;

    my $peaks_rs;
    if ($show >= 0) {
        if ($show == 0) {
	    $peaks_rs = $peaks_genes->search(
		{ 'id_neurons' => $neuron,
		  -or => [
                      'is_orth' => { ">" => '2' },
                      'is_orth' => 0
                      ]
		},
		{ join => 'peaks',
		  select => ['peaks.id_peaks', 'peaks.id_neurons', 'peaks.species', 'peaks.cell',
			     'peaks.chrom', 'peaks.chromstart', 'peaks.chromend',
			     'peaks.is_orth', 'peaks.orth_coords', 'peaks.pair_id', 'me.targetgenedist'],
		  as => ['id_peaks', 'id_neurons', 'species', 'cell',
			 'chrom', 'chromstart', 'chromend',
			 'is_orth', 'orth_coords', 'pair_id', 'targetgenedist']
		}
		);
	    
	} else {
	    
	    $peaks_rs = $peaks_genes->search(
		{ 'id_neurons' => $neuron,
		  'is_orth' => $show
		},
		{ join => 'peaks',
		  select => ['peaks.id_peaks', 'peaks.id_neurons', 'peaks.species', 'peaks.cell',
			     'peaks.chrom', 'peaks.chromstart', 'peaks.chromend',
			     'peaks.is_orth', 'peaks.orth_coords', 'peaks.pair_id', 'me.targetgenedist'],
		  as => ['id_peaks', 'id_neurons', 'species', 'cell',
			 'chrom', 'chromstart', 'chromend',
			 'is_orth', 'orth_coords', 'pair_id', 'targetgenedist']
		}
		);
        }
	
    } else {
        $peaks_rs = $peaks_genes->search(
            { 'id_neurons' => $neuron },
            { join => 'peaks',
	      select => ['peaks.id_peaks', 'peaks.id_neurons', 'peaks.species', 'peaks.cell',
			 'peaks.chrom', 'peaks.chromstart', 'peaks.chromend',
			 'peaks.is_orth', 'peaks.orth_coords', 'peaks.pair_id', 'me.targetgenedist'],
              as => ['id_peaks', 'id_neurons', 'species', 'cell',
		     'chrom', 'chromstart', 'chromend',
		     'is_orth', 'orth_coords', 'pair_id', 'targetgenedist']
            }
            );
    }
    
    my $n = 0;
    while (my $peak = $peaks_rs->next) {
	my @row;
        my $id_peaks = $peak->get_column('id_peaks');

	my $cell = $row[0] = $peak->get_column('cell');
	my $loc = $peak->get_column('chrom') . ':'
	    . $peak->get_column('chromstart') . '-'
	    . $peak->get_column('chromend');
	$row[1] = $loc;
	$row[2] = $peak->get_column('targetgenedist');
	my $is_orth = $peak->get_column('is_orth');
	$row[3] = $is_orth;
	$row[4] = $peak->get_column('orth_coords');


	# Get the pattern id numbers for all the interrelated modules (self, pair and ortholog(s))
	my %pats = (
	    'K562' => '.',
	    'GM12878' => '.',
	    'MEL' => '.',
	    'CH12' => '.'
	    );

	# Self
	$pats{$peak->get_column('cell')} = $peak->get_column('id_neurons');

	# Pair
	my $pair_id = $peak->get_column('pair_id');
	if (!defined($pair_id)) {
	    $pair_id = ".";
	} else {
	    my $pair_peak = $self->find(
		{ 'id_peaks' => $pair_id }
		);
	    $pats{$pair_peak->get_column('cell')} = $pair_peak->get_column('id_neurons');
	}
	
	# Orthologs
	my $orths_rs = $orths_db->search(
	    { 'me.id_peaks' => $id_peaks },
	    { join => 'peaks',
	      select => ['peaks.cell', 'peaks.id_neurons'],
	      as =>['cell', 'id_neurons']
	    }
	    );
	
	while (my $orth = $orths_rs->next()) {
	    $pats{$orth->get_column('cell')} = $orth->get_column('id_neurons');
	}

	# Store the results in the results array
	$row[5] = $pats{GM12878};
	$row[6] = $pats{K562};
	$row[7] = $pats{CH12};
	$row[8] = $pats{MEL};

	# Count up totals for all, orthologs, species and cells
	$n++;
	$total[1]++;
	if ($is_orth) {
	    $total[2]++;
	}

        my $spp = $peak->get_column('species');
        if ($spp eq "hg19") {
            push @peaks_hg19, \@row;
            $total_hg19[1]++;
	    if ($is_orth) {
		$total_hg19[2]++;
	    }

            if ($cell eq "K562") {
                $total_K562[1]++;
		if ($is_orth) {
		    $total_K562[2]++;
		}
            } elsif ($cell eq "GM12878") {
                $total_GM12878[1]++;
		if ($is_orth) {
		    $total_GM12878[2]++;
		}
            }

	} else {
            push @peaks_mm9, \@row;
	    $total_mm9[1]++;
	    if ($is_orth) {
		$total_mm9[2]++;
	    }

	    if ($cell eq "MEL") {
                $total_MEL[1]++;
		if ($is_orth) {
		    $total_MEL[2]++;
		}
            } elsif ($cell eq "CH12") {
                $total_CH12[1]++;
		if ($is_orth) {
		    $total_CH12[2]++;
		}
            }
	}
	
	# Assign pattern factor strings
	for (my $p = 5; $p <= 8; $p++) {
	    my $id = $row[$p];
	    if (!exists($factor_str{$id})) {
		my @tmp;
		my $factors_rs = $factors_db->search(
		    { 'id_neurons' => $id },
		    { join => 'neurons_factors' }
		    );
		while (my $f = $factors_rs->next) {
		    push @tmp, $f->get_column('name'); 
		}
		my $str = join '-', @tmp;
		$factor_str{$id} = $str;
	    }
	    $row[$p+4] = $factor_str{$id};
	}
    }

    $peaks{s_header} = ["Species/Cell", "N Peaks", "N Orth"];
    $peaks{p_header} = ["Cell", "Location", "TssDist", "Orth", "Orth Location",
			"GM12878 Pat", "K562 Pat", "CH12 Pat", "MEL Pat"];
    $peaks{peaks_hg19} = \@peaks_hg19;
    $peaks{peaks_mm9} = \@peaks_mm9;
    $peaks{npeaks} = $n;
    
    $peaks{total} = \@total;
    $peaks{total_hg19} = \@total_hg19;
    $peaks{total_mm9} = \@total_mm9;
    $peaks{total_K562} = \@total_K562;
    $peaks{total_MEL} = \@total_MEL;
    $peaks{total_GM12878} = \@total_GM12878;
    $peaks{total_CH12} = \@total_CH12;


    return %peaks;
}


1;
