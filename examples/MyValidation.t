# perl
#
# MyValidation.t
#
# Test validation rules of MyValidation.pm
#
# Sat Aug 30 13:07:24 2014

use Test::More;
use Test::Exception;

use Scalar::Validation qw(:all);
use MyValidation;                # add own rules

diag ("--- Rule IsoDate ------------------------------------------------------------");

lives_ok {validate date => IsoDate => '0000-01-01'} " IsoDate 0000-01-01";
lives_ok {validate date => IsoDate => '1000-01-31'} " IsoDate 1000-01-31";
lives_ok {validate date => IsoDate => '1000-02-28'} " IsoDate 1000-02-28";
lives_ok {validate date => IsoDate => '1000-03-31'} " IsoDate 1000-03-31";
lives_ok {validate date => IsoDate => '1000-04-30'} " IsoDate 1000-04-30";
lives_ok {validate date => IsoDate => '1000-05-31'} " IsoDate 1000-05-31";
lives_ok {validate date => IsoDate => '1000-06-30'} " IsoDate 1000-06-30";
lives_ok {validate date => IsoDate => '1000-07-31'} " IsoDate 1000-07-31";
lives_ok {validate date => IsoDate => '1000-08-31'} " IsoDate 1000-08-31";
lives_ok {validate date => IsoDate => '1000-09-30'} " IsoDate 1000-09-30";
lives_ok {validate date => IsoDate => '1000-10-31'} " IsoDate 1000-10-31";
lives_ok {validate date => IsoDate => '1000-11-30'} " IsoDate 1000-11-30";
lives_ok {validate date => IsoDate => '1000-12-31'} " IsoDate 1000-12-31";
lives_ok {validate date => IsoDate => '2017-01-17'} " IsoDate 2017-01-17";

lives_ok {validate date => IsoDate            => '1965-12-29'} " IsoDate 1965-12-29";

throws_ok { validate date       => IsoDate      => undef; }
    qr/value <undef> is not an ISO 8601 date/io,
    "!IsoDate undef";

throws_ok { validate date       => IsoDate      => '1234a-12-10'; }
    qr/value '1234a-12-10' is not an ISO 8601 date/io,
    "!IsoDate 1234a-12-10";

throws_ok { validate date       => IsoDate      => 'date'; }
    qr/value 'date' is not an ISO 8601 date/io,
    "!IsoDate date";

throws_ok { validate date       => IsoDate      => '1234-12b-10'; }
    qr/value '1234-12b-10' is not an ISO 8601 date/io,
    "!IsoDate 1234-12b-10";

throws_ok { validate date       => IsoDate      => '1234-12-10c'; }
    qr/value '1234-12-10c' is not an ISO 8601 date/io,
    "!IsoDate 1234-12-10c";

throws_ok { validate date       => IsoDate      => '0000-00-00'; }
    qr/value '0000-00-00' is not an ISO 8601 date/io,
    "!IsoDate 0000-00-00";

throws_ok { validate date       => IsoDate      => '0000-01-00'; }
    qr/value '0000-01-00' is not an ISO 8601 date/io,
    "!IsoDate 0000-01-00";

throws_ok { validate date       => IsoDate      => '0000-00-01'; }
    qr/value '0000-00-01' is not an ISO 8601 date/io,
    "!IsoDate 0000-00-01";

throws_ok { validate date       => IsoDate      => '2000-02-30'; }
    qr/value '2000-02-30' is not an ISO 8601 date/io,
    "!IsoDate 2000-02-30";

foreach my $month (qw(02 04 06 09 11)) {
    throws_ok { validate date       => IsoDate      => "2000-$month-31"; }
    qr/value '2000-..-31' is not an ISO 8601 date/io,
    "!IsoDate 2000-$month-31";
}

foreach my $month (qw(01 02 03 04 05 06 07 08 09 10 11 12)) {
    throws_ok { validate date       => IsoDate      => "2000-$month-32"; }
    qr/value '2000-..-32' is not an ISO 8601 date/io,
    "!IsoDate 2000-$month-32";
}

throws_ok { validate date       => IsoDate      => '2000-13-01'; }
    qr/value '2000-13-01' is not an ISO 8601 date/io,
    "!IsoDate 2000-13-01";


diag ("--- Test of leap years ------------------------------------------------------");
lives_ok  {validate date => IsoDate => '1004-02-29'} " IsoDate 1004-02-29";
lives_ok  {validate date => IsoDate => '1200-02-29'} " IsoDate 1200-02-29";
lives_ok  {validate date => IsoDate => '1204-02-29'} " IsoDate 1204-02-29";
lives_ok  {validate date => IsoDate => '2000-02-29'} " IsoDate 2000-02-29";
lives_ok  {validate date => IsoDate => '9200-02-29'} " IsoDate 9200-02-29";
throws_ok {validate date => IsoDate => '1001-02-29'}
    qr/value '1001-02-29' is not an ISO 8601 date/,
    "!IsoDate 1001-02-29";
throws_ok {validate date => IsoDate => '1002-02-29'}
    qr/value '1002-02-29' is not an ISO 8601 date/,
    "!IsoDate 1002-02-29";
throws_ok {validate date => IsoDate => '1003-02-29'}
    qr/value '1003-02-29' is not an ISO 8601 date/,
    "!IsoDate 1003-02-29";
throws_ok {validate date => IsoDate => '1900-02-29'}
    qr/value '1900-02-29' is not an ISO 8601 date/,
    "!IsoDate 1900-02-29";

diag ("--- Rule BirthDate ------------------------------------------------------------");

# ------- Prepare --- instead of using current date -----
MyValidation::create_birth_date_rule("1410618214"); # 2014-09-13T16:23:34 MESZ

# ------- Test -----------

lives_ok {validate date => BirthDate       => '1965-12-29'} " BirthDate 1965-12-29";
lives_ok {validate date => BirthDate       => '2014-09-12'} " BirthDate 2014-09-12";
lives_ok {validate date => BirthDate       => '2014-09-13'} " BirthDate 2014-09-13";

throws_ok { validate birth_date => BirthDate => '0-0-0'; }
    qr/value '0-0-0' is not an ISO birth date/io,
    "!BirthDate 0-0-0";

throws_ok {validate date => BirthDate       => '2014-09-14'}
    qr/value '2014-09-14' is not an ISO birth date, or it is in the future!/io,
     "!BirthDate 2014-09-14";

throws_ok {validate date => BirthDate       => '2014-10-13'}
    qr/value '2014-10-13' is not an ISO birth date, or it is in the future!/io,
     "!BirthDate 2014-10-13";

throws_ok {validate date => BirthDate       => '2015-09-13'}
    qr/value '2015-09-13' is not an ISO birth date, or it is in the future!/io,
    "!BirthDate 2015-09-13";

throws_ok { validate birth_date => BirthDate => '2117-01-17'; }
    qr/value '2117-01-17' is not an ISO birth date, or it is in the future!/io,
    "!BirthDate 2117-01-17";

diag ("--- Rule LivingBirthDate ------------------------------------------------------------");

lives_ok  { validate date => LivingBirthDate => '1965-12-29'} " LivingBirthDate 1965-12-29";
throws_ok { validate date => LivingBirthDate => '1777-12-29'; }
    qr/value '1777-12-29' is not an ISO birth date or its more than 150 years ago!/io,
    "!LivingBirthDate 1777-12-29";

diag ("--- Rule ArticleId ------------------------------------------------------------");

lives_ok {validate article_id => ArticleId => 'ID0'}
    " ArticleId => ID0";
lives_ok {validate article_id => ArticleId => 'ID1'}
    " ArticleId => ID1";
lives_ok {validate article_id => ArticleId => 'ID1234567890'}
    " ArticleId => ID1234567890";

throws_ok {validate article_id => ArticleId => undef }
    qr/<undef> is not an article ID like/,
    "!ArticleId => undef";
throws_ok {validate article_id => ArticleId => bla; }
    qr/'bla' is not an article ID like/,
    "!ArticleId => bla";
throws_ok {validate article_id => ArticleId => id123; }
    qr/'id123' is not an article ID like/,
    "!ArticleId => id123";
throws_ok {validate article_id => ArticleId => ['ID123', 'ID456']; }
    qr/'ARRAY\(0x\w+\)' is not an article ID like/,
    "!ArticleId => [ ID123 ID456 ]";

done_testing();
