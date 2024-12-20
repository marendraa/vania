import 'package:vania_app/app/models/ordersitem.dart';
import 'package:vania/vania.dart';

class OrdersitemController extends Controller {

     Future<Response> index() async {

      final listOrderitems = await Ordersitem().query().get();
        return Response.json({
          'message' : 'data order items',
          'data' : listOrderitems,
        });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {
            request.validate({
              'order_num' : 'required',
              'prod_id'   : 'required',
              'quantity'  : 'required',
              'size'      : 'required'
            });

            final orderitemData = request.only([
              'order_num',
              'prod_id',
              'quantity',
              'size',
            ]);

            orderitemData['created'] = DateTime.now().toIso8601String();

            await Ordersitem().query().insert(orderitemData);

            return Response.json({
              'message' : 'data order item berhasil ditambahkan',
              'data'    : orderitemData,
            });
          } catch (e) {
            
            return Response.json({
              'message' : 'terjadi kesalahan',
              'error'   : e.toString(),
            });
          }
     }

     Future<Response> show(Request req, int id) async {
      final orderitems = await Ordersitem().query().where('order_item', '=', id).first();
      
      return Response.json({
        'data' : orderitems,
      });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          try {
            request.validate({
              'order_num' : 'required',
              'prod_id'   : 'required',
              'quantity'  : 'required',
              'size'      : 'required'
            });

            final orderitemData = request.only([
              'order_num',
              'prod_id',
              'quantity',
              'size',
            ]);

            final orderitems = await Ordersitem().query().where('order_num', '=', id).first();

            if (orderitems == null) {
              
              return Response.json({
                'message' : 'customer dengan ID $id tidak ditemukan'
              }, 404);
            }

            await Ordersitem().query().where('order_num', '=', id).update(orderitemData);

            return Response.json({
              'message' : 'data order item berhasil diperbarui',
              'data'    : orderitemData,
            });

          } catch (e) {
            return Response.json({
              'message' : 'terjadi kesalahan',
              'error'   : e.toString(),
            });
          }
     }

     Future<Response> destroy(int id) async {
          try {

            final orderitems = await Ordersitem().query().where('order_num', '=', id).first();
            
            if (orderitems == null) {
              return Response.json({
                'message' : 'data order item ID $id tidak ditemukan',
              }, 404);
            }
            await Ordersitem().query().where('order_num', '=', id).delete();

            return Response.json({
              'message' : 'data order item ID $id berhasil dihapus'
            }, 200);
          } catch (e) {
            return Response.json({
              'message' : 'terjadi kesalahan',
            });
            
          }
     }
}

final OrdersitemController orderitemsController = OrdersitemController();

