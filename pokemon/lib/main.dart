import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemon/pokemon.dart';
import 'package:pokemon/pokemondetail.dart';

void main() {
  runApp(new MaterialApp(
    title: "Pokemon",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;
  PokeHub findPoke;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);

    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
    findPoke = PokeHub.fromJson(decodedJson);
    print(findPoke.toJson());
  }

  void findPokemon(value) {
    setState(() {
      var tempListData = pokeHub.pokemon
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      if (tempListData.length > 0) {
        findPoke.pokemon = tempListData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: !isSearching
            ? new Text("Pokemon")
            : TextField(
                onChanged: (value) {
                  findPokemon(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Aja Shay",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      findPoke = pokeHub;
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: findPoke == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: findPoke.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeDetail(
                                          pokemon: poke,
                                        )));
                          },
                          child: Hero(
                            tag: poke.img,
                            child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(poke.img))),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Icon(Icons.star,
                                            color: Colors.yellow),
                                        new Icon(Icons.star,
                                            color: Colors.yellow),
                                        new Icon(Icons.star,
                                            color: Colors.yellow),
                                        new Icon(Icons.star,
                                            color: Colors.yellow),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Rica Matsumoto"),
            accountEmail: new Text("AshKetchum@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  "https://i.pinimg.com/originals/f8/29/be/f829bed61f75627eea111dfde089fe2c.png"),
            ),
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(
                        "https://rog.asus.com/media/1554200908315.jpg"),
                    fit: BoxFit.cover)),
          ),
          new ListTile()
        ]),
      ),
      backgroundColor: Colors.cyan[200],
    );
  }

  void get newMethod => Icons;
  
}
