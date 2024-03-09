import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';


class Pair extends WordPair {
  Pair(super.first, super.second);

  Map<String, Object?> toMap() {
    return {
      'firstWord': first,
      'secondWord': second,
    };
  }
}


class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = <WordPair>{};
  final int _maxWordPairs = 50;
  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          if (item.isOdd) return const Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPairs.length &&
              _randomWordPairs.length < _maxWordPairs) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          if (index < _maxWordPairs) {
            return _buildRow(_randomWordPairs[index]);
          }

          return null;
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
      title: Text(pair.asPascalCase, style: const TextStyle(fontSize: 18.0)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedWordPairs.remove(pair);
          } else {
            _savedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext builder, StateSetter setState) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('Saved WordPairs'),
            ),
            body: ListView(
                children: _savedWordPairs.map((WordPair pair) {
              return ListTile(
                  title: Text(pair.asPascalCase,
                      style: const TextStyle(
                        fontSize: 16.0,
                      )),
                  trailing: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      _savedWordPairs.remove(pair);
                    });
                    this.setState(() {
                      _savedWordPairs.remove(pair);
                    });
                  });
            }).toList()));
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WordPair generator'),
        actions: <Widget>[
          IconButton(onPressed: _pushSaved, icon: const Icon(Icons.list))
        ],
      ),
      body: _buildList(),
    );
  }
}