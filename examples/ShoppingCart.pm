# perl
#
# Safer Perl: Example for method calls
#
# ShoppingCart
#
# Sat Jan  9 18:52:26 2016

package ShoppingCart;

use warnings;
use strict;

use Data::Dumper;

use Scalar::Validation qw(:all);
use MyValidation;

my ($is_self) = is_a __PACKAGE__; # parentesis are needed!!

# --- create Instance --------------------------------------------------
sub new
{
    my $caller = shift;
    my $class  = ref($caller) || $caller;
    
    # let the class go
    my $self = {};
    bless $self, $class;

    $self->{articles} = {};

    return $self->_init(@_);
}

# ----------------------------------------------------------------------
sub _init {
    my $trouble_level = p_start;

    my $self = par  self => $is_self  => shift;

    my %pars = convert_to_named_params \@_;

    my $ID   = npar -ID  => -Optional => PositiveInt => \%pars;

    p_end \%pars;

    # no setting of parameters, if something wrong
    return $self if validation_trouble $trouble_level; 
 
    # --- run sub -------------------------------------------------

    $ID = 4712 unless $ID;

    $self->{ID} = $ID;
    return $self;
}

# ----------------------------------------------------------------------
sub put_in {
    my $trouble_level = p_start;

    my $self    = par self    => $is_self  => shift;
    my $article = par article => ArticleId => shift;

    p_end (\@_);
 
    return undef if validation_trouble $trouble_level; 
 
    # --- run sub -------------------------------------------------

    $self->{articles}->{$article}++;
    # print "ShoppingCart.put_in($article);\n";
}

# ----------------------------------------------------------------------
sub content {
    my $trouble_level = p_start;

    my $self    = par self => $is_self => shift;

    p_end \@_;
 
    return undef if validation_trouble $trouble_level; 
 
    # --- run sub -------------------------------------------------

    my $result = '';
    foreach my $article (sort(keys(%{$self->{articles}}))) {
	$result .= $self->{articles}->{$article}." * $article\n";
    }
    return $result;
}

# ----------------------------------------------------------------------
sub count_articles {
    my $trouble_level = p_start;

    my $self    = par self => $is_self => shift;

    p_end \@_;
 
    return undef if validation_trouble $trouble_level; 
 
    # --- run sub -------------------------------------------------

    my $article_count = 0;

    foreach my $article (sort(keys(%{$self->{articles}}))) {
	$article_count += $self->{articles}->{$article};
    }

    return $article_count;
}

1;
