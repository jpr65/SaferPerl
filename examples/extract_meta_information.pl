# perl
#
# Safer Perl: extract meta information out of packages
#
# Thu Sep 18 08:04:21 2014

use strict;
use warnings;

$| = 1;

use Data::Dumper;

use lib '../../AndroidPerl/spartanic/lib';

use Scalar::Validation qw(:all);
use Report::Porf qw(:all);

use MyValidation;

my $articleId = validate acticle_id => ArticleId => 'ID123';

local ($Scalar::Validation::fail_action, $Scalar::Validation::off)
    = prepare_validation_mode(warn => 1);

meta_info_clear();

# ------------------------------------------------------------------------------

# my $sc = build_meta_info_for_module('ShoppingCart');
my $sc = build_meta_info_for_module
    ('ShoppingCart', sub { return ShoppingCart->new(-ID => "4711"); });

$sc->put_in();
# $sc->get_content();

# ------------------------------------------------------------------------------
my $template = build_meta_info_for_module('ClassTemplate');

# $sc->put_in(); # do validation again!

ClassTemplate::no_args();
$template->add_date_positional();
$template->get_content();
$template->current_position_positional();
$template->current_position_named();
$template->current_position_at_date();
$template->special_rule_test();
$template->write();

# ------------------------------------------------------------------------------
end_meta_info_gen();

print "\n# ==== End of meta generation, fallback to validation mode ==========\n\n";

# ------------------------------------------------------------------------------
# print Dumper($sc);
# $sc->put_in();

# print Dumper($template);
# $template->current_position_positional(1, 2);

# ------------------------------------------------------------------------------
my $my_class = build_meta_info_for_module('MyClass',
					  sub { return MyClass->new(-name => 'AnyPerson') });

# call without paramters, they are not needed for meta information mode
$my_class->my_sub();
$my_class->my_next_sub();

# ------------------------------------------------------------------------------

my $meta_info = get_meta_info();
# print "\n# === Meta Class Information Dump ============================\n".Dumper($meta_info);

my $meta_info_list = list_meta_info();

sub configure_report {
    my $report_format = par report_format => -Enum => [html => csv => text => 0] => shift;

    use Report::Porf::Framework;

    my $framework = Report::Porf::Framework::get();
    my $report    = $framework->create_report($report_format);

    $report->cc(  -a => 'l',  -h => 'Module Name',     -vn => 'module',  -w => 20, );
    $report->cc(  -a => 'l',  -h => 'Sub Name',        -vn => 'sub',     -w => 30, );
    $report->cc(  -a => 'l',  -h => 'Pos./Named',      -vn => 'kind',    -w => 10, );
    $report->cc(  -a => 'l',  -h => 'Parameter Name',  -vn => 'name',    -w => 20, );
    $report->cc(  -a => 'l',  -h => 'Rule(s)',         -vn => 'rule',    -w => 30, );

    $report->set_row_group_changes_action(
        sub {
	    if ($_[0]
		&&  ($_[0]->{'module'} ne $_[1]->{'module'}
		     || $_[0]->{'sub'} ne $_[1]->{'sub'})
		) {
		return $report->get_separator_line();
	    }
	    return '';
        }); 
    $report->configure_complete();
    
    return $report;
}

# print join ("\n", @{Report::Porf::Framework::report_configuration_as_string($meta_info_list)});

auto_report($meta_info_list);

my $report = configure_report('html');
$report->write_all($meta_info_list, "meta_infos.html");

$report = configure_report('text');
# $report->write_all($meta_info_list);

