import 'package:flutter/material.dart';

class DetailProduk extends StatefulWidget {
  final Map Listdata;
  DetailProduk({Key? key, required this.Listdata}) : super(key: key);
  //const DetailProduk({super.key});

  @override
  State<DetailProduk> createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  final formkey = GlobalKey<FormState>();
  TextEditingController id = TextEditingController();
  TextEditingController nama_produk = TextEditingController();
  TextEditingController harga_produk = TextEditingController();
  @override
  Widget build(BuildContext context) {
    id.text = widget.Listdata['id'];
    nama_produk.text = widget.Listdata['item_name'];
    harga_produk.text = widget.Listdata['price'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail produk"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text(
                    "ID Produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.Listdata['id'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "nama Produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.Listdata['item_name'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  title: const Text(
                    "harga produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    widget.Listdata['price'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
