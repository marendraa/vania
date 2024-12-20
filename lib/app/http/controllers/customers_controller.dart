import 'package:vania_app/app/models/customers.dart';
import 'package:vania/vania.dart';

class CustomersController extends Controller {
  Future<Response> index() async {
    final listcustomer = await Customers().query().get();
    return Response.json({
      'message': 'data list customers',
      'data': listcustomer,
    });
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
      try {
    // Validasi input
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    });

    // Filter hanya kolom yang sesuai
    final customerData = request.only([
      'cust_name',
      'cust_address',
      'cust_city',
      'cust_state',
      'cust_zip',
      'cust_country',
      'cust_telp',
    ]);

    

    // Simpan ke database
    await Customers().query().insert(customerData);

    // Kembalikan respons sukses
    return Response.json({
      'message': 'Customer berhasil ditambahkan',
      'data': customerData,
    }, 201);

  } catch (e) {
    // Tangani error
    return Response.json({
      'message': 'Terjadi kesalahan',
      'error': e.toString(),
    });
  }

  }

  Future<Response> show(Request request, int id) async {
    final customer =
        await Customers().query().where('cust_id', '=', id).first();

    return Response.json({
      'data': customer,
    });
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

Future<Response> update(Request request, int id) async {
  try {
    // Validasi input
    request.validate({
      'cust_name': 'required',
      'cust_address': 'required',
      'cust_city': 'required',
      'cust_state': 'required',
      'cust_zip': 'required',
      'cust_country': 'required',
      'cust_telp': 'required',
    });

    // Ambil hanya data yang relevan untuk diupdate
    final customerData = request.only([
      'cust_name',
      'cust_address',
      'cust_city',
      'cust_state',
      'cust_zip',
      'cust_country',
      'cust_telp',
    ]);

    // Tambahkan updated_at ke data
    customerData['updated_at'] = DateTime.now().toIso8601String();

    // Periksa apakah customer dengan ID yang diberikan ada
    final customer = await Customers().query().where('cust_id', '=', id).first(); // Ganti 'id' ke 'cust_id' jika perlu
    if (customer == null) {
      return Response.json({
        'message': 'Customer dengan ID $id tidak ditemukan',
      }, 404);
    }

    // Lakukan update
    await Customers().query().where('cust_id', '=', id).update(customerData);

    // Kembalikan respons sukses
    return Response.json({
      'message': 'Customer berhasil diperbarui',
      'data': customerData,
    }, 200);
  } catch (e) {
    // Tangani error
    return Response.json({
      'message': 'Terjadi kesalahan',
      'error': e.toString(),
    }, 500);
  }
}

  Future<Response> destroy(int id) async {
      try {
    // Periksa apakah pelanggan dengan ID yang diberikan ada
    final customer = await Customers().query().where('cust_id', '=', id).first();

    if (customer == null) {
      return Response.json({
        'message': 'Customer dengan ID $id tidak ditemukan',
      }, 404);
    }

    // Hapus pelanggan
    await Customers().query().where('cust_id', '=', id).delete();

    // Respons sukses
    return Response.json({
      'message': 'Customer dengan ID $id berhasil dihapus',
    }, 200);
  } catch (e) {
    // Tangani error
    return Response.json({
      'message': 'Terjadi kesalahan saat menghapus customer',
      'error': e.toString(),
    }, 500);
  }
  }
}

final CustomersController customersController = CustomersController();
