import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//Função principal do programa
void main() 
{
	runApp(new LuckyList()); //Inicia o Widget LuckyList, que engloba o APP
}

//Widget que controla os estados da lista e retorna a lista como widget
class RandomWordsState extends State<RandomWords> 
{
	final _suggestions = <WordPair>[]; //Array de palavras a serem listadas
	final _saved = new Set<WordPair>(); //Array que guarda as palavras selecionadas
	final _biggerFont = const TextStyle(fontSize: 18.0); //Estilo do texto

	@override
	Widget build(BuildContext context) //O build é a função construtora do widget
	{
		//O Scaffold implementa o layout básico de um material design
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Words List'),
				actions: <Widget>[
          			new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        		],
			),
			body: _buildSuggestions(),
		);
	}

	void _pushSaved()
	{
		Navigator.of(context).push( //Realiza o push conforme a rota que será dada
			new MaterialPageRoute( //Instancia uma rota
    			builder: (context) { //Cria o construtor da nova página
        			final tiles = _saved.map( //Mapeia as palavras para a nova lista
          				(pair) {
            				return new ListTile(
              					title: new Text(
                					pair.asPascalCase,
                					style: _biggerFont,
              					),
            				);
          				},
        			);
        			
					final divided = ListTile.divideTiles( //Adiciona uma borda entre as palavras da lista
            			context: context,
            			tiles: tiles,
          			).toList();
					
					return new Scaffold(
          				appBar: new AppBar(
            				title: new Text('Saved Suggestions'),
          				),
          				body: new ListView(children: divided),
        			);
      			},
    		),
		);
	}

	Widget _buildSuggestions() //Função que preenche o array de sugestões e a lista
	{
		//Retorna uma ListView, criando através do builder dela
		return new ListView.builder(
			padding: const EdgeInsets.all(16.0),
			itemBuilder: (context, i) {
				if (i.isOdd) return new Divider(); //Se o indice for impar, retornar o item divisar

				final index = i ~/ 2;

				if (index >= _suggestions.length) //Se o indice ultrapassar o numero de palavras
				{
					_suggestions.addAll(generateWordPairs().take(10)); //Gera novas palavras no array
				}

				return _buildRow(_suggestions[index]);
			}
		);
	}

	Widget _buildRow(WordPair pair) //Função que recebe uma palavra e retorna um bloco da lista
	{
		final alreadySaved = _saved.contains(pair); //Guarda se a palavra já foi salva

		return new ListTile(
			title: new Text( //Cria um widget texto (TextView) com a string e estilo dados
				pair.asPascalCase,
				style: _biggerFont,
			),
			trailing: new Icon( //Criação de um icone interativo de acordo com alreadySaved
      			alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
      			color: alreadySaved ? Colors.teal : null,
    		),
			onTap: () {
				setState(() { //Muda o ícone e seu preenchimento na tela
					if(alreadySaved)
					{
						_saved.remove(pair); //Se estiver selecionado, quebra a seleção
					}			  
					else
					{
						_saved.add(pair); //Se não estiver selecionado, seleciona
					}
				});
			}
		);
	}
}

//Widget que possui um estado, o qual muda de valor durante a execução
class RandomWords extends StatefulWidget 
{
	@override
	createState() => new RandomWordsState(); //Instancia o estado criado
}

//Widget principal da aplicação
class LuckyList extends StatelessWidget 
{
	@override
	Widget build(BuildContext context) {
		return new MaterialApp( //É o top-level da aplicação o root de todas as atividades
			title: 'List',
			theme: new ThemeData(
				primaryColor: Colors.teal,
			),
			home: new RandomWords()
		);
	}
}
