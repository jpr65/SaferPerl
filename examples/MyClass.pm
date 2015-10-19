package MyClass;

use Scalar::Validation qw(:all);

# --- create Instance --------------------------------------------------
sub new
{
    my $caller = $_[0];
    my $class  = ref($caller) || $caller;
    
    # let the class go
    my $self = {};
    $self->{position} = {};
    bless $self, $class;

    return $self;
}

sub my_sub {
    my $trouble_level = p_start;
    
    my $first_par = par first_par => Int => shift;
    # additional parameters ...
    
    my %pars = convert_to_named_params \@_;
    
    my $max_potenz = npar -first_named => PositiveFloat => \%pars;
    # additional named parameters ...
    
    p_end \%pars;
    
    # needed to exit sub in meta extraction mode
    return undef if validation_trouble($trouble_level);
    
    # ------------------
    
    # Code of sub doing something
}

sub my_next_sub {
    my $trouble_level = p_start;
    
    p_end \%pars;
    
    # needed to exit sub in meta extraction mode
    return undef if validation_trouble($trouble_level);

    # ------------------
    
    # Code of sub doing something
}
1;
