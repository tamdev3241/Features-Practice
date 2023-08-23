import 'package:flutter/material.dart';

class DataChat extends StatelessWidget {
  final Map<String, dynamic>? data;
  const DataChat({
    super.key,
    this.data = const {},
  });

  @override
  Widget build(BuildContext context) {
    return data != null
        ? Column(
            children: data!.keys.map((key) {
              if (key == "image") {
                return Image.network(data![key]);
              }
              return Row(
                children: [
                  Text(key),
                  Text(data![key]),
                ],
              );
            }).toList(),
          )
        : const Center(child: Text("Not data"));
  }
}
