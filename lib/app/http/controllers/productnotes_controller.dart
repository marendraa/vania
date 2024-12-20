import 'package:vania/vania.dart';
import 'package:vania_app/app/models/productnotes.dart';

class ProductnotesController extends Controller {

     Future<Response> index() async {
      final listProductsnote = await Productnotes().query().get();

      return Response.json({
        'message' : 'list data product notes ditemukan',
        'data'    : listProductsnote,
      });

     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {
          try {

            request.validate({
              'prod_id'   : 'required',
              'note_text' : 'required'
            });

            final productnotesData = request.only([
              'prod_id',
              'note_text',
            ]);

            productnotesData['prod_id'] = int.parse(productnotesData['prod_id']);
            productnotesData['note_date'] = DateTime.now().toIso8601String();
            productnotesData['created_at'] = DateTime.now().toIso8601String();

            await Productnotes().query().insert(productnotesData);

            return Response.json({
              'message' : 'data product note berhasil ditambahkan',
              'data'    : productnotesData,
            }, 201);

          } catch (e) {
            return Response.json({
              'message' : 'terjadi kesalahan',
              'error'   : e.toString(),
            });
          }
     }

     Future<Response> show(int id) async {
          final productsnotes = await Productnotes().query().where('note_id', '=', id).first();

          return Response.json({
            'message' : 'data ditemukan',
            'data'    : productsnotes
          });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          try {
            request.validate({
              'prod_id'   : 'required',
              'note_text' : 'required'
            });

            final productnotesData = request.only([
              'prod_id',
              'note_text'
            ]);

            final productnotes = await Productnotes().query().where('note_id', 'id', id).first();

            if (productnotes == null) {
              return Response.json({
                'message' : 'productnote ID $id tidak ditemukan',
              }, 404);
            }

            await Productnotes().query().update(productnotesData);

            return Response.json({
              'message' : 'productnotes ID $id berhasil diupdate',
              'data' : productnotes,
            }, 200);

          } catch (e) {
            return Response.json({
              'message' : 'terjadi kesalahan',
              'error'   : e.toString(),
            }, 500);
          }
     }

     Future<Response> destroy(int id) async {
          try {
            final productnotes = await Productnotes().query().where('note_id', '=', id).first();

            if (productnotes == null) {
              return Response.json({
                'message' : 'product dengan id $id tidak ditemukan',

              }, 404);
            }

            await Productnotes().query().where('note_id', '=', id).delete();

            return Response.json({
              'message' : 'product dengan ID $id berhasil dihapus',
            }, 200);

          } catch (e) {

            return Response.json({
              'message' : 'terjadi kesalahan saat menghapus',
              'error'   : e.toString(),
            });
          }
     }
}

final ProductnotesController productnotesController = ProductnotesController();

