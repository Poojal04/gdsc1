import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 22, 125, 185)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
    var favorites = <WordPair>[];

 void toggleFavorite(WordPair pair) {
  if (favorites.contains(pair)) {
    favorites.remove(pair);
  } else {
    favorites.add(pair);
  }
  notifyListeners();
}


}
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 150, // Adjust the size as needed
              backgroundImage: NetworkImage('https://images.news18.com/ibnlive/uploads/2022/05/iit-kanpur.jpg'),
            ),
          ),
          SizedBox(height: 100),
          Row(
            children: [
              Text(
                'Poojal Katiyar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          
          Row(
            children: [
              Text(
                'poojalk22@iitk.ac.in',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 7, 1, 1),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.location_city), // Icon for city
              SizedBox(width: 10),
              Text('City: Kanpur'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.format_list_numbered), // Icon for roll number
              SizedBox(width: 10),
              Text('Roll No: 220770'),
            ],
          ),
        ],
      ),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        var pair = appState.favorites[index];
        return Dismissible(
          key: Key(pair.asPascalCase),
          onDismissed: (_) {
            appState.toggleFavorite(pair);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Row(
              children: [
                Expanded(
                  child: Text(pair.asLowerCase),
                ),
                MouseRegion(
                  onEnter: (_) {
                    // Handle hover entering event
                    // For example, change icon color or add effect
                  },
                  onExit: (_) {
                    // Handle hover exiting event
                    // For example, revert icon color or effect
                  },
                  child: GestureDetector(
                    onTap: () {
                      appState.toggleFavorite(pair);
                    },
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var showNames = false;

  void toggleMenu() {
    setState(() {
      showNames = !showNames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  showNames = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorite'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  showNames = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                  showNames = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: showNames ? Text('Home') : Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: showNames ? Text('Favorite') : Text(''),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: showNames ? Text('Profile') : Text(''),
              )
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: _getPage(selectedIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleMenu,
        child: Icon(
          showNames ? Icons.close : Icons.menu,
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return GeneratorPage();
      case 1:
        return FavoritesPage();
      case 2:
        return ProfilePage();
      default:
        return Container(); // Empty container or handle error case
    }
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
           ElevatedButton.icon(
  onPressed: () {
    appState.toggleFavorite(pair); // Pass the pair argument
  },
  icon: Icon(icon),
  label: Text('Like'),
),

              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),

        // ↓ Make the following change.
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
