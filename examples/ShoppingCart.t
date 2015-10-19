# perl
#
# ShoppingCart.t
#
# Test validation rules of MyValidation.pm
#
# Sat Aug 30 13:07:24 2014

use Test::More;
use Test::Exception;

# in real projects I prefer Test::Class

use Scalar::Validation qw(:all);
use MyValidation;                # add own rules

use ShoppingCart;

# ------------------------------------------------------------------------------

my $shoppingCart = new ShoppingCart;

ok(defined $shoppingCart, "new ShoppingCart()");

# ------------------------------------------------------------------------------

my $content = $shoppingCart->content;

is($content, "", "Empty shopping cart after creation");

lives_ok { $shoppingCart->put_in("ID004711"); } "Add article into shopping cart";

is($shoppingCart->count_articles,
   1,
   "1 Article in shopping cart"
);

is($shoppingCart->content,
   "1 * ID004711\n",
   "List of 1 article in shopping cart"
);

lives_ok { $shoppingCart->put_in("ID000032"); }
"Add another article into shopping cart";

is($shoppingCart->count_articles,
   2,
   "2 articles in shopping cart"
);

is($shoppingCart->content,
   "1 * ID000032\n".
   "1 * ID004711\n",
   "List of 2 articles in shopping cart"
);

# ------------------------------------------------------------------------------

throws_ok { ShoppingCart::put_in('ID42'); }
    qr/Error: ShoppingCart::put_in\(parameter self\): 'ID42' is not of class ShoppingCart or derived from it./io,
    "Wrong call of put_in('ID42') without instance";

done_testing();
