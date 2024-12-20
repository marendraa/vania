import 'package:vania_app/app/http/controllers/customers_controller.dart';
import 'package:vania_app/app/http/controllers/ordersitem_controller.dart';
import 'package:vania_app/app/http/controllers/orders_controller.dart';
import 'package:vania_app/app/http/controllers/products_controller.dart';
import 'package:vania_app/app/http/controllers/productnotes_controller.dart';
import 'package:vania_app/app/http/controllers/vendor_controller.dart';
import 'package:vania/vania.dart';
import 'package:vania_app/app/http/controllers/auth_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // Base Prefix
    Router.basePrefix('api');

    Router.post('login', authController.login);
    Router.post('sign-up', authController.signUp);

    // Group for customers
    Router.group(() {
      Router.get('/', customersController.index);
      Router.get('/{id}', customersController.show);
      Router.post('/', customersController.store);
      Router.put('/{id}', customersController.update);
      Router.delete('/{id}', customersController.destroy);
    }, prefix: 'customers');

    // Group for order items
    Router.group(() {
      Router.get('/', orderitemsController.index);
      Router.get('/{id}', orderitemsController.show);
      Router.post('/', orderitemsController.create);
      Router.put('/{id}', orderitemsController.update);
      Router.delete('/{id}', orderitemsController.destroy);
    }, prefix: 'orderitems');

    // Group for products
    Router.group(() {
      Router.get('/', productController.index);
      Router.get('/{id}', productController.show);
      Router.post('/', productController.create);
      Router.put('/{id}', productController.update);
      Router.delete('/{id}', productController.destroy);
    }, prefix: 'products');

    // Group for orders
    Router.group(() {
      Router.get('/', ordersController.index);
      Router.get('/{id}', ordersController.show);
      Router.post('/', ordersController.store);
      Router.delete('/{id}', ordersController.destroy);
    }, prefix: 'orders');

    // Group for vendors
    Router.group(() {
      Router.get('/', vendorsController.index);
      Router.get('/{id}', vendorsController.show);
      Router.post('/', vendorsController.create);
      Router.put('/{id}', vendorsController.update);
      Router.delete('/{id}', vendorsController.destroy);
    }, prefix: 'vendors');

    // Group for product notes
    Router.group(() {
      Router.get('/', productnotesController.index);
      Router.get('/{id}', productnotesController.show);
      Router.post('/', productnotesController.create);
      Router.put('/{id}', productnotesController.update);
      Router.delete('/{id}', productnotesController.destroy);
    }, prefix: 'productnotes');
  }
}
