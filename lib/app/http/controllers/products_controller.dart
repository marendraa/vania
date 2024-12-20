
import 'package:vania/vania.dart';
import 'package:vania_app/app/models/products.dart';


class ProductsController extends Controller {

     Future<Response> index() async {

      final listProduct = await Products().query().get();

      return Response.json({
        'message' : 'data list products',
        'data'    : listProduct,
      });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {
            
            request.validate({
              'vend_id'    : 'required',
              'prod_name'  : 'required',
              'prod_price' : 'required',
              'prod_desc'  : 'required',
            });

            final productData = request.only([
              'vend_id',
              'prod_name',
              'prod_price',
              'prod_desc',
            ]);

            productData['created_at'] = DateTime.now().toIso8601String();

            await Products().query().insert(productData);

            return Response.json({
              'message': 'Customer berhasil ditambahkan',
              'data': productData,
            }, 201);

          } catch (e) {
            return Response.json({
              'message': 'Terjadi kesalahan',
              'error': e.toString(),
            });
          }
     }

     Future<Response> show(int id) async {
          final products = await Products().query().where('prod_id', '=', id).first();

          return Response.json({
            'data' : products,
          });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          try {
            request.validate({
              'vend_id'    : 'required',
              'prod_name'  : 'required',
              'prod_price' : 'required',
              'prod_desc'  : 'required',
            });

            final productData = request.only([
              'vend_id',
              'prod_name',
              'prod_price',
              'prod_desc',
            ]);

            productData['updated_at'] = DateTime.now().toIso8601String();

            final products = await Products().query().where('prod_id', '=', id).first();

            if (products == null) {
              return Response.json({
                'message' : 'products dengan ID $id tidak ditemukan',
              }, 400);
            }

            await Products().query().where('prod_id', '=', id).update(productData);

            return Response.json({
              'message' : 'products berhasil diperbarui',
              'date'   : productData,
            });

          } catch (e) {
            
            return Response.json({
              'message' : 'terjadi kesalahan',
              'error'   : e.toString(), 
            }, 500);
          }
     }

     Future<Response> destroy(int id) async {
      try {
        final product = await Products().query().where('prod_id', '=', id).first();
        if (product == null) {
          return Response.json({
            'messaage' : 'data product ID $id tidak ditemukan',
          }, 404);
        }

        await Products().query().where('cust_id', '=', id).delete();

        return Response.json({
          'message' : 'data product ID $id berhasil dihapus',
        }, 200);

      } catch (e) {
        
        return Response.json({
          'message' : 'terjadi kesalahan',
          'error' : e.toString(),
        }, 500);
      }
     }
}

final ProductsController productController = ProductsController();

