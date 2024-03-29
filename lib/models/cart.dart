import 'dart:collection';
import 'dart:math';
import 'package:fastshop/models/cartItem.dart';
import 'package:fastshop/models/producto.dart';

class Cart {
  final List<CartItem> _items = <CartItem>[];

  /// Creates an empty cart.
  Cart();

  /// Creates a Cart from an old Cart
  Cart.clone(Cart cart) {
    _items.addAll(cart._items);
  }

  /// Fills the cart with a sampling from the given products.
  Cart.sample(Iterable<Producto> products) {
    _items.addAll(products.take(3).map((product) => CartItem(1, product)));
  }

  /// The total count of items in cart, including duplicates of the same item.
  ///
  /// This is in contrast of just doing [items.length], which only counts
  /// each product once, regardless of how many are being bought.
  int get itemCount => _items.fold(0, (sum, el) => sum + el.count);


  /// The total price of items in the cart
  double get itemTotalPrice => _items.fold(0, (sum, el) => sum + el.totalPrice);

  /// This is the current state of the cart.
  ///
  /// This is a list because users expect their cart items to be in the same
  /// order they bought them.
  ///
  /// It is an unmodifiable view because we don't want a random widget to
  /// put the cart into a bad state. Use [add] and [remove] to modify the state.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  /// Adds [product] to cart. This will either update an existing [CartItem]
  /// in [items] or add a one at the end of the list.
  void add(Producto product, [int count = 1]) {
    _updateCount(product, count);
  }

  /// Removes [product] from cart. This will either update the count of
  /// an existing [CartItem] in [items] or remove it entirely (if count reaches
  /// `0`.
  void remove(Producto product, [int count = 1]) {
    _updateCount(product, -count);
  }

  /// Updates the [count] of a [product] from the cart.
  void update(Producto product, [int count = 1]) {
    _setNewCount(product, count);
  }

  @override
  String toString() => "$items";

  void _updateCount(Producto product, int difference) {
    if (difference == 0) return;
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = item.count + difference;
        if (newCount <= 0) {
          _items.removeAt(i);
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        return;
      }
    }
    if (difference < 0) return;
    _items.add(CartItem(max(difference, 0), product));
  }

  void _setNewCount(Producto product, int count) {
    if (count == 0) return;
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (product == item.product) {
        final newCount = count;
        if (newCount <= 0) {
          items.removeAt(i);
          return;
        }
        _items[i] = CartItem(newCount, item.product);
        return;
      }
    }
  }
}