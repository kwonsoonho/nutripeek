import 'package:flutter/material.dart';

import '../../domain/entities/supplement.dart';

class ReviewPage extends StatefulWidget {
  final Supplement supplement;

  const ReviewPage({super.key, required this.supplement});
  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('ReviewPage'),));  }
}
