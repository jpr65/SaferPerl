# perl
#
# Safer Perl: Example for method calls
#
# Sat Aug 30 13:07:24 2014

use strict;
use warnings;

$| = 1;

use Data::Dumper;

use Scalar::Validation qw(:all);
use MyValidation;

use ShoppingCart;

my $sc = ShoppingCart->new();

{
    my $validation_mode = 'die'; # default, die at first invalid value
    $validation_mode = 'warn'  ; # check all parameters before exit
    # $validation_mode = 'silent'; # for testing: don't warn!
    # $validation_mode = 'off'   ; # Very dangerous!! See results!!

    print "Start block with special validation mode '$validation_mode' ...\n";

    local ($Scalar::Validation::fail_action, $Scalar::Validation::off)
	= prepare_validation_mode($validation_mode);
    
    $sc->put_in("ID12345");
    $sc->put_in("ID12345");
    $sc->put_in("ID12345");
    $sc->put_in("ID6789");
    
    print "==============================\n";
    print "Content of Shopping Cart\n";
    print $sc->get_content();
    print "==============================\n";

    $sc->put_in();
    $sc->put_in("bla");
    $sc->put_in(["bla"]);
    $sc->put_in(qw(ID1 ID2 ID3 ID4));
    
    eval { # wrong $self

	ShoppingCart::put_in(qw(bla ID4711));

    }; print "$@" if $validation_mode ne 'silent';

    print "==============================\n";
    print "Content of Shopping Cart should be same as before!\n";
    print $sc->get_content();
    print "==============================\n";

}

print "\nvalidation_mode falls back to default, that is 'die'\n\n";

$sc->put_in(["bla"]); # dies!
