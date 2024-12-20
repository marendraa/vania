
import 'package:vania_app/app/models/orders.dart';
import 'package:vania/vania.dart';

class OrdersController extends Controller {

     Future<Response> index() async {

      final listorder = await Orders().query().get();

      return Response.json({
        'message' : 'order ditemukan',
        'data' :listorder,
        });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {

      try {
        request.validate({
          'cust_id' : 'required',
        });

        final ordersData = request.only([
          'cust_id',
        ]);

        ordersData['cust_id'] = int.parse(ordersData['cust_id']);
        ordersData['date'] = DateTime.now().toIso8601String();
        ordersData['created_at'] = DateTime.now().toIso8601String();

        await Orders().query().insert(ordersData);

        return Response.json({
          'message' : 'data order berhasil ditambahkan',
          'data' : ordersData,
      }, 201);

      } catch (e) {
        
        return Response.json({
          'message' : 'terjadi kesalahan',
          'error' : e.toString(),
        });
      }
     }

     Future<Response> show(Request request, int id) async {
      final orders = await Orders().query().where('order_num', '=', id).first();

      return Response.json({
        'data' : orders,
      });
      }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          return Response.json({});
     }

     Future<Response> destroy(int id) async {
      try {
        
        final order = await Orders().query().where('order_num', '=', id).first();

        if (order == null) {
          return Response.json({
            'message' : 'order number $id tidak ditemukan',
          });
        }

        await Orders().query().where('cust_id', '=', id).delete();

        return Response.json({
          'message' : 'order number $id berhasil dihapus',
        }, 200);

      } catch (e) {
        return Response.json({
          'message': 'terjadi kesalahan saat menghapus',
          'error' : e.toString(),
        });
      }
    }
}

final OrdersController ordersController = OrdersController();

