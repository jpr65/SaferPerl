# perl
#
# Safer Perl: Example for function calls
#
# Sat Aug 30 13:07:24 2014

use strict;
use warnings;

$| = 1;

use Data::Dumper;

use Scalar::Validation qw(:all);
use MyValidation;                # add own rules

local ($Scalar::Validation::fail_action) = prepare_validation_mode(warn => 1);

#------------------------------------------------------------------------------
#
#  subs
#
#------------------------------------------------------------------------------

# create person by positional parameters
sub create_person_pos {
    my $trouble_level = p_start;

    my $prename = par prename => Filled    => shift;
    my $surname = par surname => Filled    => shift;
    my $birth   = par birth   => BirthDate => shift;

    p_end \@_;
 
    # fire exit, if validation does not die
    return undef if validation_trouble($trouble_level); 
 
    # --- run sub -------------------------------------------------

    return {
	prename => $prename,
	surname	=> $surname,
	birth  	=> $birth  
    };
}

# create person by named parameters
sub create_person_named {
    my $trouble_level = p_start;

    my %pars = convert_to_named_params \@_;

    my $person = {};

    $person->{prename} = npar -prename => Filled => \%pars;
    $person->{surname} = npar -surname => Filled => \%pars;
    $person->{birth}   = npar -birth   => BirthDate   => \%pars;

    p_end \%pars;
 
    # fire exit, if validation does not die
    return undef if validation_trouble($trouble_level);
 
    # --- run sub -------------------------------------------------

    return $person;
}

# create a living person by named parameters
sub create_living_person_named {
    my $trouble_level = p_start;

    my $person = validate person => HashRef         => create_person_named(@_)
	=> sub { "could not create a person!" };

    # fire exit, if validation does not die
    return undef if validation_trouble($trouble_level);

    # --- additional validation -------------------------------------------------

    validate 'living_person'     => LivingBirthDate => $person->{birth}
	=> sub { "$person->{prename} $person->{surname} "
		     ."with birth day of $_ cannot be living, "
		     ."her/his birth is more than 150 years ago!"
	};

    # fire exit, if validation does not die
    return undef if validation_trouble($trouble_level);
 
    # --- run sub -------------------------------------------------

    return $person;
}

#------------------------------------------------------------------------------
#
#  main
#
#------------------------------------------------------------------------------

my $me = create_person_pos(Ralf => Peine => "1965-12-29");

my $me_living = create_living_person_named(
    -prename => Ralf  =>
    -surname => Peine => 
    -birth   => "1965-12-29"
);

my $gauss = create_person_named(
    -prename => 'Johann Carl Friedrich',
    -surname => 'Gauß', 
    -birth   => "1777-12-29");

print '$me = '.Dumper($me);
print '$me_living = '.Dumper($me_living);
print '$gauss     = '.Dumper($gauss);

my $gauss_dead = create_living_person_named(
    -prename => 'Johann Carl Friedrich',
    -surname => 'Gauß', 
    -birth   => "1777-12-29"
);

# This code line will not be reached in validation mode "die"
print 'Gauss is not living ($gauss_living = undef)!'."\n" unless defined $gauss_dead;

my $no_person;
$no_person = create_person_pos();
$no_person = create_person_pos(Ralf => Peine => "1965-12-29" => 'additional_parameter');

$no_person = create_person_named(
    -prename => Ralf  =>
    -surname => Peine => 
    -birth   => "1965-12-29",
    -bla     => 1
);

$no_person = create_living_person_named(
    -prename => Ralf  =>
    -surname => Peine => 
    -birth   => "1965-12-29",
    -blubb   => 1
);
