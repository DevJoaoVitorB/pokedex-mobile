import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pokedex/features/home/domain/entities/pokemon.dart';
import 'package:pokedex/features/home/domain/usecases/get_pokemon_list.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._getPokemonList);

  final GetPokemonList _getPokemonList;

  bool _isLoading = false;
  String? _errorMessage;
  List<Pokemon> _allPokemon = <Pokemon>[];
  List<Pokemon> _filteredPokemon = <Pokemon>[];
  List<Pokemon> _visiblePokemon = <Pokemon>[];
  String _query = '';
  int _currentPage = 1;
  final int _pageSize = 20;
  final int _allLimit = 1025;
  final int _batchSize = 200;
  String _selectedType = 'All';
  String _selectedGeneration = 'All';
  String _selectedWeight = 'All';
  String _selectedHeight = 'All';
  List<String> _availableTypes = <String>['All'];
  List<String> _availableGenerations = <String>['All'];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Pokemon> get visiblePokemon => _visiblePokemon;
  int get currentPage => _currentPage;
  int get pageSize => _pageSize;
  bool get canGoBack => _currentPage > 1;
  String get selectedType => _selectedType;
  String get selectedGeneration => _selectedGeneration;
  String get selectedWeight => _selectedWeight;
  String get selectedHeight => _selectedHeight;
  List<String> get typeOptions => _availableTypes;
  List<String> get generationOptions => _availableGenerations;
  List<String> get weightOptions => const <String>[
    'All',
    'Light 0.1kg - 10kg',
    'Medium 10kg - 50kg',
    'Heavy 50kg - 200kg',
    'Massive 200kg+',
  ];
  List<String> get heightOptions => const <String>[
    'All',
    'Short 0.1m - 0.7m',
    'Medium 0.7m - 1.5m',
    'Tall 1.5m - 2.5m',
    'Giant 2.5m+',
  ];
  int get totalPages => max(1, (_filteredPokemon.length / _pageSize).ceil());

  Future<void> load({required int limit, required int offset}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cached = await _getPokemonList.cached(limit: limit, offset: offset);
      if (cached.isNotEmpty) {
        _allPokemon = cached;
        _updateAvailableFilters();
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      }

      final fresh = await _getPokemonList.refresh(limit: limit, offset: offset);
      _allPokemon = fresh;
      _updateAvailableFilters();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to load Pokemon. ${error.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPage(int page) async {
    if (page < 1) {
      return;
    }
    _currentPage = page;
    _applyFilters();
    notifyListeners();
  }

  Future<void> nextPage() async {
    await loadPage(_currentPage + 1);
  }

  Future<void> previousPage() async {
    if (!canGoBack) {
      return;
    }
    await loadPage(_currentPage - 1);
  }

  void updateQuery(String value) {
    _query = value.trim().toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void updateTypeFilter(String value) {
    _selectedType = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void updateGenerationFilter(String value) {
    _selectedGeneration = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void updateWeightFilter(String value) {
    _selectedWeight = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  void updateHeightFilter(String value) {
    _selectedHeight = value;
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  Future<void> loadAllPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cached = await _getPokemonList.cached(limit: _allLimit, offset: 0);
      if (cached.isNotEmpty) {
        _allPokemon = cached;
        _updateAvailableFilters();
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      }

      final all = <Pokemon>[];
      for (var offset = 0; offset < _allLimit; offset += _batchSize) {
        final limit = (offset + _batchSize > _allLimit)
            ? _allLimit - offset
            : _batchSize;
        final batch = await _getPokemonList.refresh(
          limit: limit,
          offset: offset,
        );
        if (batch.isEmpty) {
          break;
        }
        all.addAll(batch);
        _allPokemon = List<Pokemon>.from(all);
        _updateAvailableFilters();
        _applyFilters();
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to load Pokemon. ${error.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateAvailableFilters() {
    final typeSet = <String>{};
    final generationSet = <String>{};

    for (final pokemon in _allPokemon) {
      for (final type in pokemon.types) {
        typeSet.add(_titleCase(type.name));
      }
      generationSet.add(_titleCase(pokemon.generation));
    }

    _availableTypes = <String>['All', ...typeSet.toList()..sort()];
    _availableGenerations = <String>['All', ...generationSet.toList()..sort()];
  }

  void _applyFilters() {
    Iterable<Pokemon> filtered = _allPokemon;

    if (_query.isNotEmpty) {
      filtered = filtered.where((pokemon) {
        final nameMatch = pokemon.name.toLowerCase().contains(_query);
        final idMatch = pokemon.id.toString() == _query;
        return nameMatch || idMatch;
      });
    }

    if (_selectedType != 'All') {
      final typeValue = _selectedType.toLowerCase();
      filtered = filtered.where(
        (pokemon) =>
            pokemon.types.any((type) => type.name.toLowerCase() == typeValue),
      );
    }

    if (_selectedGeneration != 'All') {
      final generationValue = _selectedGeneration.toLowerCase();
      filtered = filtered.where(
        (pokemon) => pokemon.generation.toLowerCase() == generationValue,
      );
    }

    if (_selectedWeight != 'All') {
      filtered = filtered.where((pokemon) => _matchesWeight(pokemon.weight));
    }

    if (_selectedHeight != 'All') {
      filtered = filtered.where((pokemon) => _matchesHeight(pokemon.height));
    }

    _filteredPokemon = filtered.toList();
    if (_filteredPokemon.isEmpty) {
      _visiblePokemon = <Pokemon>[];
      return;
    }

    final maxPage = totalPages;
    if (_currentPage > maxPage) {
      _currentPage = 1;
    }

    final start = (_currentPage - 1) * _pageSize;
    final end = min(start + _pageSize, _filteredPokemon.length);
    _visiblePokemon = _filteredPokemon.sublist(start, end);
  }

  bool _matchesWeight(int weightHg) {
    switch (_selectedWeight) {
      case 'Light 0.1kg - 10kg':
        return weightHg >= 1 && weightHg <= 100;
      case 'Medium 10kg - 50kg':
        return weightHg > 100 && weightHg <= 500;
      case 'Heavy 50kg - 200kg':
        return weightHg > 500 && weightHg <= 2000;
      case 'Massive 200kg+':
        return weightHg > 2000;
      default:
        return true;
    }
  }

  bool _matchesHeight(int heightDm) {
    switch (_selectedHeight) {
      case 'Short 0.1m - 0.7m':
        return heightDm >= 1 && heightDm <= 7;
      case 'Medium 0.7m - 1.5m':
        return heightDm > 7 && heightDm <= 15;
      case 'Tall 1.5m - 2.5m':
        return heightDm > 15 && heightDm <= 25;
      case 'Giant 2.5m+':
        return heightDm > 25;
      default:
        return true;
    }
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }
}
