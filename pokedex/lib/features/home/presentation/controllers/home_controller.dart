import 'package:flutter/foundation.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/features/home/domain/usecases/get_pokemon_list.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._getPokemonList);

  final GetPokemonList _getPokemonList;

  bool _isLoading = false;
  String? _errorMessage;
  List<Pokemon> _allPokemon = <Pokemon>[];
  List<Pokemon> _visiblePokemon = <Pokemon>[];
  String _query = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Pokemon> get visiblePokemon => _visiblePokemon;

  Future<void> load({required int limit, required int offset}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cached = await _getPokemonList.cached(limit: limit, offset: offset);
      if (cached.isNotEmpty) {
        _allPokemon = cached;
        _applyQuery();
        _isLoading = false;
        notifyListeners();
      }

      final fresh = await _getPokemonList.refresh(limit: limit, offset: offset);
      _allPokemon = fresh;
      _applyQuery();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to load Pokemon. ${error.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateQuery(String value) {
    _query = value.trim().toLowerCase();
    _applyQuery();
    notifyListeners();
  }

  void _applyQuery() {
    if (_query.isEmpty) {
      _visiblePokemon = List<Pokemon>.from(_allPokemon);
      return;
    }

    _visiblePokemon = _allPokemon.where((pokemon) {
      final nameMatch = pokemon.name.toLowerCase().contains(_query);
      final idMatch = pokemon.id.toString() == _query;
      return nameMatch || idMatch;
    }).toList();
  }
}
