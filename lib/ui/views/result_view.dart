import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../enums/enum_alternatif.dart';
import '../../models/alternatif.dart';

class MyResultPage extends StatelessWidget {
  final List<Alternatif> result;
  final bool noResult;

  const MyResultPage({super.key, required this.result, required this.noResult});

  String getAkreditasi(int akreditasiNumber) {
    if (akreditasiNumber == 5) {
      return 'A';
    } else if (akreditasiNumber == 4) {
      return 'B';
    } else if (akreditasiNumber == 3) {
      return 'C';
    } else if (akreditasiNumber == 2) {
      return 'D';
    }
    return '';
  }

  String getSPP(String namaSekolah) {
    List<Alternatif> la = [...alternatives];
    la.retainWhere((element) => element.name == namaSekolah);
    return la[0].criteriaValue[3].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hasil Rekomendasi WASPAS'),
        ),
        body: Column(
          children: [
            noResult ? myMessage() : Container(),
            Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(result[index].name),
                    subtitle: Text("Nilai WASPAS : ${result[index].result}"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(result[index].name),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Akreditasi'),
                                Text(result[index].criteriaValue[0]),
                                const Padding(padding: EdgeInsets.all(5)),
                                //
                                const Text('Jarak'),
                                Text(
                                    "${result[index].jarak.toStringAsFixed(2)} Km"),
                                const Padding(padding: EdgeInsets.all(5)),
                                //
                                const Text('SPP'),
                                Text("Rp. ${result[index].criteriaValue[2]}"),
                                const Padding(padding: EdgeInsets.all(5)),
                                //
                                const Text('Jumlah Murid yang Diterima'),
                                Text("${result[index].criteriaValue[3]} Orang"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
        // ignore: avoid_unnecessary_containers
        );
  }

  Widget myMessage() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          height: 70,
          color: const Color.fromARGB(255, 220, 53, 69),
          child: const Text(
            'Sekolah dengan kriteria tersebut tidak ditemukan!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(13),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Beberapa rekomendasi sekolah :',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
