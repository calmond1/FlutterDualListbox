import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Dual Listbox Demo'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo> todos = <ToDo>[];

  _HomePageState() {
    int i = 1;
    while (i <= 50) {
      // Alternate between true and false
      todos.add(ToDo((i % 2 == 1), "Task ${i}"));
      i++;
    }
  }

  void _updateTask(bool val, int index) {
    if (todos[index].val != val) {
      todos[index].val = val;
    }
    setState(() {});
  }

  buildListview(Widget w, bool flag) {
    List<Widget> items = <Widget>[];

    items.add(w);
    todos.asMap().forEach((index, todo) {
      if (flag == todo.val) {
        items.add(
          Align(
            alignment: flag ? Alignment.topLeft : Alignment.topRight,
            child: GestureDetector(
              onTap: (() {
                _updateTask(!todos[index].val, index);
              }),
              child: Text('${todos[index].name}'),
            ),
          ),
        );
      }
    });

    return Expanded(
        child: buildBox(ListView(
      shrinkWrap: false,
      children: items,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: (() {
                debugPrint("Tapped Save");
              }),
              child: buildCard(Text('Save')),
            ),
            Text(
                'Scroll a list until you find the todo item you are looking for.'),
            Text('Tap on the name and it will move to the other list.'),
            Text('Once you\'ve made all your changes, click Save'),
            // Making this work correctly https://www.youtube.com/watch?v=9kZ0RiYYR2E
            Expanded(
              child: Row(
                children: [
                  buildListview(
                      buildBox(
                        Align(
                            alignment: Alignment.topRight,
                            child: Text('To Do')),
                      ),
                      false),
                  buildListview(
                      buildBox(
                        Align(
                            alignment: Alignment.topLeft, child: Text('Done')),
                      ),
                      true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToDo extends ChangeNotifier {
  bool val = false;
  String name = "";

  ToDo(this.val, this.name) {}
}

buildCard(Widget w) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: w,
    ),
  );
}

buildBox(Widget w) {
  return Container(
    margin: const EdgeInsets.all(5.0),
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    child: w,
  );
}
