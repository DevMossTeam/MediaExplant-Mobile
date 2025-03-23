import 'package:flutter/material.dart';

class TagPopulerItem extends StatelessWidget {
  final VoidCallback onTap;
  const TagPopulerItem({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: InkWell(
        onTap: onTap, // Memicu aksi klik
        splashColor: Colors.black.withAlpha(50),
        highlightColor: Colors.white.withAlpha(100),
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
                "Xiao yan",
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
