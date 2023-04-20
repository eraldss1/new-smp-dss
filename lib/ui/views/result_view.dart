import 'package:flutter/material.dart';
import 'package:new_smp_dss/models/alternatif.dart';

class MyResultPage extends StatelessWidget {
  final List<Alternatif> result;

  const MyResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil WASPAS'),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(result[index].name),
            subtitle: Text(result[index].result.toString()),
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
                        Text(result[index].criteriaValue[0].toString()),
                        const Text('Jarak'),
                        Text(result[index].distance.toString()),
                        const Text('SPP'),
                        Text(result[index].criteriaValue[2].toString()),
                        const Text('Jumlah Murid yang Diterima'),
                        Text(result[index].criteriaValue[3].toString()),
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
    );
  }
}
