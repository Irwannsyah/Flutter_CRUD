import 'package:cru/halamanProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class TambahProduk extends StatefulWidget {
  const TambahProduk({Key? key}) : super(key: key);

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<void> _simpan() async {
    final respon = await http.post(
      Uri.parse('http://192.168.68.81/api_produk/create.php'),
      body: {
        'item_name': nama_produk.text,
        'price': harga_produk.text,
      },
    );
    if (respon.statusCode == 200) {
      setState(() {
        // Membersihkan teks setelah pengiriman data
        nama_produk.clear();
        harga_produk.clear();
      });
      return;
    } else {
      throw Exception('Gagal menyimpan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah produk"),
      ),
      body: Form(
        key: formKey, // Menggunakan kunci formulir
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: nama_produk,
                decoration: InputDecoration(
                  hintText: "Nama produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama produk tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: harga_produk,
                decoration: InputDecoration(
                  hintText: "Harga produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _simpan().then((_) {
                      final snackBar = SnackBar(
                        content: const Text("Data berhasil disimpan"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HalamanProduk()),
                        (route) => false,
                      );
                    }).catchError((error) {
                      final snackBar = SnackBar(
                        content: const Text("Data gagal disimpan"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
