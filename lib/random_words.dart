import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:random_wordpairs/database.dart';

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
  final _randomPairs = <Pair>[];
  final _savedPairs = <Pair>{};
  final int _maxPairsConst = 50;
  final ScrollController _scrollController = ScrollController();
  bool _buttonEnabled = false;
  int _maxPairs = 50;

  @override
  void initState() {
    super.initState();
    _loadSavedPairs();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  void _scrollListener() {
    // Check if the scroll position is at the bottom
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _buttonEnabled = true; // Enable the button
      });
    }
  }

  Future<void> _loadSavedPairs() async {
    final savedPairs = await DatabaseHelper.instance.loadPairs();
    setState(() {
      _savedPairs.addAll(savedPairs);
    });
  }

  Widget _buildList() {
    return Scrollbar(
        thickness: 0.6,
        thumbVisibility: true,
        controller: _scrollController,
        radius: const Radius.circular(10.0),
        child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, item) {
          if (item.isOdd) return const Divider();

          final index = item ~/ 2;

          if (index >= _randomPairs.length && _randomPairs.length < _maxPairs) {
            _randomPairs.addAll(generateWordPairs()
                .take(10)
                .map((wordPair) => Pair(wordPair.first, wordPair.second)));
          }

          if (index < _maxPairs) {
            return _buildRow(_randomPairs[index]);
          }

          return null;
        }));
  }

  Widget _buildRow(Pair pair) {
    final alreadySaved = _savedPairs.contains(pair);

    return ListTile(
      title: Text(pair.asPascalCase, style: const TextStyle(fontSize: 18.0)),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _savedPairs.remove(pair);
            DatabaseHelper.instance.deletePair(pair);
          } else {
            _savedPairs.add(pair);
            DatabaseHelper.instance.insertPair(pair);
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
                children: _savedPairs.map((Pair pair) {
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
                      _savedPairs.remove(pair);
                      DatabaseHelper.instance.deletePair(pair);
                    });
                    this.setState(() {
                      _savedPairs.remove(pair);
                    });
                  });
            }).toList()));
      });
    }));
  }

  void _generateWordPairs() {
    setState(() {
      _maxPairs = _maxPairs + _maxPairsConst;
      _buttonEnabled = false;
      _randomPairs.addAll(generateWordPairs()
          .take(_maxPairsConst)
          .map((wordPair) => Pair(wordPair.first, wordPair.second)));
    });
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _buttonEnabled ? _generateWordPairs : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _buttonEnabled ? Theme.of(context).primaryColor : Colors.grey, // Adjust the background color
          ),
          child: const Text('Generate Word Pairs'),
        ),
      ),
    );
  }
}
