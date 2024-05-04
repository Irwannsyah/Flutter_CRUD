import 'package:cru/halamanProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class UbahProduk extends StatefulWidget {
  final Map ListData;
  const UbahProduk({super.key, required this.ListData});

  @override
  State<UbahProduk> createState() => _UbahProdukState();
}

class _UbahProdukState extends State<UbahProduk> {
  final formKey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();

  Future<void> _ubah() async {
    final respon = await http.post(
      Uri.parse('http://192.168.68.81/api_produk/update.php'),
      body: {
        'id': id.text,
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
    id.text = widget.ListData['id'];
    nama_produk.text = widget.ListData['item_name'];
    harga_produk.text = widget.ListData['price'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update produk"),
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
                  hintText: "Update Nama produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "update nama produk tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: harga_produk,
                decoration: InputDecoration(
                  hintText: "Update Harga produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Update Harga tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _ubah().then((_) {
                      final snackBar = SnackBar(
                        content: const Text("Data berhasil diubah"),
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
                        content: const Text("Data gagal diubah"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
