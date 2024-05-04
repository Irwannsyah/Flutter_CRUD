import 'dart:convert';

import 'package:cru/detailProduk.dart';
import 'package:cru/tambahProduk.dart';
import 'package:cru/ubahproduk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HalamanProduk extends StatefulWidget {
  const HalamanProduk({super.key});

  @override
  State<HalamanProduk> createState() => _HalamanProdukState();
}

class _HalamanProdukState extends State<HalamanProduk> {
  List _listdata = [];
  bool _loading = true;

  Future _getdata() async {
    try {
      final respon =
          await http.get(Uri.parse('http://192.168.68.81/api_produk/read.php'));
      if (respon.statusCode == 200) {
        final data = jsonDecode(respon.body);
        setState(() {
          _listdata = data;
          _loading = !_loading;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    try {
      final respon = await http.post(
          Uri.parse('http://192.168.68.81/api_produk/delete.php'),
          body: {"id": id});
      if (respon.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    _getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman product"),
        backgroundColor: Colors.grey,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailProduk(
                                    Listdata: {
                                      'id': _listdata[index]['id'],
                                      'item_name': _listdata[index]
                                          ['item_name'],
                                      'price': _listdata[index]['price'],
                                    },
                                  )));
                    },
                    child: ListTile(
                      title: Text(_listdata[index]['item_name']),
                      subtitle: Text(_listdata[index]['price']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UbahProduk(
                                              ListData: {
                                                'id': _listdata[index]['id'],
                                                'item_name': _listdata[index]
                                                    ['item_name'],
                                                'price': _listdata[index]
                                                    ['price'],
                                              },
                                            )));
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(
                                            "anda yakin ingin menghapus data?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                _hapus(_listdata[index]['id'])
                                                    .then((value) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context)=> HalamanProduk())),
                                                      (route) => false);
                                                });
                                              },
                                              child: Text("hapus")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("tidak"))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          child: const Text(
            "+",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TambahProduk()));
          }),
    );
  }
}
