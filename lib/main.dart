import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();
  late ListModel<int>
      _list; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _gridKey,
      initialItems: <int>[0, 1, 2, 3, 4, 5],
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade200,
          title: const Text(
            'Dean\'s Quiz App',
            // style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedGrid(
            key: _gridKey,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: double.infinity,
              // mainAxisExtent: 200, height
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            initialItemCount: _list.length,
            itemBuilder: _buildItem,
          ),
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    required this.listKey,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedGridState> listKey;
  final List<E> _items;

  AnimatedGridState? get _animatedGrid => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedGrid!.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.animation,
    required this.item,
  }) : assert(item >= 0);

  final Animation<double> animation;
  final int item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.bounceOut),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 20.0,
            child: Card(
              color: Colors.blue.shade300,
              child: Center(
                child: Text('${item + 1}'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Question {
  String question;
  String imageURL;
  String category;
  List<String> answers;
  String correctAnswer;

  Question(
      {required this.question,
      required this.imageURL,
      required this.category,
      required this.answers,
      required this.correctAnswer});
}
