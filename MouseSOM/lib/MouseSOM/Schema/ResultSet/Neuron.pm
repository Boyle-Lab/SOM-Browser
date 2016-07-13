package MouseSOM::Schema::ResultSet::Neuron;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_neuron_data {
    my ($self, $id, $factors) = @_;

    my $factors_rs = $factors->search(
        { 'id_neurons' => $id },
        { join => 'neurons_factors' }
    );

    my $tfs = "";
    my $count = 0;
    while (my $f = $factors_rs->next) {
        $tfs = $tfs . $f->get_column('name') . '-';
        $count++;
    }
    chop $tfs;

    my %data = (
        'id' => $id,
        'pattern' => "Non-Significant Pattern",
        'tf_count' => "",
        'n_peaks' => "",
        'n_human' => "",
        'n_mouse' => "",
        'pct_human' => "",
        'pct_mouse' => "",
        'frac_human' => "",
        'frac_mouse' => "",
        'classification' => "",
    );
    my $neuron = $self->find($id);
    if (!defined($neuron)) {
        # No data for this neuron
        return %data;
    }
    $data{id} = $neuron->get_column('id_neurons');
    $data{pattern} = $tfs;
    $data{tf_count} = $count;
    $data{n_peaks} = $neuron->get_column('n_peaks');
    $data{n_human} = $neuron->get_column('n_human');
    $data{n_mouse} = $neuron->get_column('n_mouse');
    my $pch = sprintf("%.2f", ($data{n_human} / $data{n_peaks}) * 100); 
    my $pcm = sprintf("%.2f", ($data{n_mouse} / $data{n_peaks}) * 100);
    $data{pct_human} = $pch;
    $data{pct_mouse} = $pcm;
    my $fch = sprintf("%.4f", $neuron->get_column('frac_human') * 100);
    my $fcm = sprintf("%.4f", $neuron->get_column('frac_mouse') * 100);
    $data{frac_human} = $fch;
    $data{frac_mouse} = $fcm;
    $data{classification} = $neuron->get_column('classification');

#    print STDERR "Neuron: $neuron\n";
#    foreach my $key (keys %data) {
#        print STDERR "$key: $data{$key}\n";
#    }
        
    return %data;
}


1;
