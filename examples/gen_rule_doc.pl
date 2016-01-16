# perl
#
# Safer Perl: Generate Rule Documentation
#
# Ralf Peine, Mon Sep 29 12:08:09 2014

use strict;
use warnings;

use v5.10;

$| = 1;

use lib '../../AndroidPerl/spartanic/lib';

use Report::Porf qw(:all);
use Scalar::Validation qw(:all);
use MyValidation;

my $rules_ref = get_rules();

my @rule_info = map { $rules_ref->{$_} } sort keys %$rules_ref;
my @my_rules = grep { $_->{-owner} eq "MyValidation" } @rule_info;

my $rule_output_file     = "rule_info.html";
my $my_rules_output_file = "my_rules_info.html";

say "Write rule doc into $rule_output_file";

# just use simple to get an overview
# auto_report(\@rule_info, $rule_output_file);
# auto_report(\@rule_info);

# or for pretty table

my $report_framework = Report::Porf::Framework::get();
my $report           = $report_framework->create_report("HTML");

$report->cc(-h => "Rule Name",    -vn => "-name");
$report->cc(-h => "Parent Rule",  -vn => "-as");
$report->cc(-h => "Quelle",       -vn => "-owner");
$report->cc(-h => "Beschreibung", -vn => "-description");
$report->cc(-h => "Enum",         -v  => '$_->{-enum} ? $_->{-enum}: ""');

$report->configure_complete();

$report->write_all(\@rule_info, $rule_output_file);
$report->write_all(\@my_rules,  $my_rules_output_file);
say "Done.";