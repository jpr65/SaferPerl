# perl
#
# Safer Perl: Example for save call
#
# Ralf Peine, Mon Sep 29 12:08:09 2014

use strict;
use warnings;

$| = 1;

use Scalar::Validation qw(par);

sub add {
    my $sum = 0;
    foreach (@_) { $sum += par (add => Float => $_); }
    return $sum;
}

print 'add(1, 2, 3) = '.add(1,2,3)."\n";
print 'add()        = '.add()."\n";

my $values = [];
print 'add(@[])     = '.add(@$values)."\n";

# perl uses reference address instead of content of reference!
print 'add([])      = '.add( $values)."    # !! should == 0 !!\n";

# Script aborted, this line is not reached!
print "Script aborted\n";
