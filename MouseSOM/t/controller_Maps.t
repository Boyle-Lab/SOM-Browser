use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MouseSOM';
use MouseSOM::Controller::Maps;

ok( request('/maps')->is_success, 'Request should succeed' );
done_testing();
