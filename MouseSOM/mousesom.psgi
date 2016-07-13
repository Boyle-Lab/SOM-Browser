use strict;
use warnings;

use MouseSOM;

my $app = MouseSOM->apply_default_middlewares(MouseSOM->psgi_app);
$app;

