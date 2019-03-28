import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(TutApp());

//Remember: everything is a widget
class TutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair2 =WordPair.random();

    return MaterialApp(
      title: 'Startup name gen',
      theme: new ThemeData(
        primaryColor: Colors.white
      ),
      home: RandomWords(),
    );
  }
}

//requirment 1: class extends State (has logic)
class RandomWordsState extends State<RandomWords> {
  //underscore = private
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = new Set<WordPair>();

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
         if (alreadySaved) {
          _saved.remove(pair);
         } else {
           _saved.add(pair);
         }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Gen'),

        
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],

      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles =_saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style:_biggerFont
                ),
              );
            }
          );
          final List<Widget> divided =ListTile
          .divideTiles(
            context: context,
            tiles: tiles
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }


}

//req2: class extends StatefulWidget
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() {
    return new RandomWordsState();
  }
}
