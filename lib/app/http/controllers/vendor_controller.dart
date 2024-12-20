import 'package:vania/vania.dart';
import 'package:vania_app/app/models/vendors.dart';

class VendorController extends Controller {

     Future<Response> index() async {
      final listVendors = await Vendors().query().get();
      return Response.json({
        'message' : 'data list vendors',
        'data'    : listVendors,
      });
     }

     Future<Response> create() async {
          return Response.json({});
     }

     Future<Response> store(Request request) async {

      try {
        
        request.validate({
          'vend_name'    : 'required',
          'vend_address' : 'required',
          'vend_kota'    : 'required',
          'vend_state'   : 'required',
          'vend_zip'     : 'required',
          'vend_country' : 'required',
        });

        final vendorsData = request.only([
          'vend_name',
          'vend_address',
          'vend_kota',
          'vend_state',
          'vend_zip',
          'vend_country',
        ]);

        vendorsData['created_at'] = DateTime.now().toIso8601String();

        await Vendors().query().insert(vendorsData);

        return Response.json({
          'message' : 'data vendors berhasil ditambahkan',
          'data ' : vendorsData,
        }, 201);

      } catch (e) {
        
        return Response.json({
          'message' : 'terjadi kesalahan',
          'error'   : e.toString(),
        });
      }

     }

     Future<Response> show(Request request, int id) async {

      final vendors = await Vendors().query().where('vend_id', '=', id).first();

      return Response.json({
        'data' : vendors,
      });
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
      try {
        request.validate({
          'vend_name'    : 'required',
          'vend_address' : 'required',
          'vend_kota'    : 'required',
          'vend_state'   : 'required',
          'vend_zip'     : 'required',
          'vend_country' : 'required',
        });

        final vendorsData = request.only([
          'vend_name',
          'vend_address',
          'vend_kota',
          'vend_state',
          'vend_zip',
          'vend_country',
        ]);

        vendorsData['updated_at'] = DateTime.now().toIso8601String();

        final vendors = await Vendors().query().where('vend_id', '=', id).first();

        if (vendors == null) {
          return Response.json({
            'message' : 'vendors dengan ID $id tidak ditemukan',
          }, 404);
        }

        await Vendors().query().where('cust_id', '=', id).update(vendorsData);

        return Response.json({
          'message' : 'vendors berhasil diupdate',
          'data'    : vendorsData,
        });

      } catch (e) {

        return Response.json({
          'message': 'Terjadi kesalahan',
          'error': e.toString(),
        }, 500);
      }
     }

     Future<Response> destroy(int id) async {

      try {
        final vendors = await Vendors().query().where('vend_id', '=', id).first();

        if (vendors == null) {
          
          return Response.json({
            'message' : 'data vendor ID $id tidak ditemukan',
          }, 404);
        }

        await Vendors().query().where('vend_id', '=', id).delete();

        return Response.json({
          'message' : 'data vendor ID $id berhasil dihapus',
        }, 200);

      } catch (e) {

        return Response.json({
          'message' : 'terjadi kesalahan',
          'error' : e.toString(),
        }, 500);
      }
     }
}

final VendorController vendorsController = VendorController();

