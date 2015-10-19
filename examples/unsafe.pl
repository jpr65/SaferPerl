# perl
#
# Safer Perl: Example for unsafe call
#
# Ralf Peine, Mon Sep 29 12:08:09 2014

use strict;
use warnings;

$| = 1;

sub add {
    my $sum = 0;
    foreach (@_) { $sum += $_}
    return $sum;
}

print 'add(1, 2, 3) = '.add(1,2,3)."\n";
print 'add()        = '.add()."\n";

my $values = [];
print 'add(@[])     = '.add(@$values)."\n";

# perl uses reference address instead of content of reference!
print 'add([])      = '.add( $values)."    # !! should be == 0 !!\n";

print "Script ended without failure!\n";
