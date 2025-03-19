import 'package:flutter/material.dart';

class TagPopulerItem extends StatelessWidget {
  final VoidCallback onTap;
  const TagPopulerItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: onTap, // Memicu aksi klik
        splashColor: Colors.blue.withAlpha(50), // Warna efek klik
        highlightColor: Colors.blue.withAlpha(100), // Warna saat ditekan
        child: Row(
          children: [
            const Text(
              "#",
              style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "Kategori",
                style: TextStyle(
                    color: Colors.black.withAlpha(150),
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Text(
              "3232",
              style: TextStyle(
                color: Colors.black.withAlpha(100),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
