import 'package:flutter/material.dart';
import 'package:pokedex/core/network/graphql_client.dart';
import 'package:pokedex/core/theme/app_colors.dart';
import 'package:pokedex/features/home/data/datasources/pokemon_graphql_datasource.dart';
import 'package:pokedex/features/home/data/repositories/pokemon_repository_impl.dart';
import 'package:pokedex/features/home/domain/usecases/get_pokemon_list.dart';
import 'package:pokedex/features/home/presentation/controllers/home_controller.dart';
import 'package:pokedex/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:pokedex/features/home/presentation/widgets/home_card.dart';
import 'package:pokedex/features/home/presentation/widgets/home_filters.dart';
import 'package:pokedex/features/home/presentation/widgets/home_header.dart';
import 'package:pokedex/features/home/presentation/widgets/home_pagination.dart';
import 'package:pokedex/features/home/presentation/widgets/home_search_bar.dart';
import 'package:pokedex/features/home/presentation/widgets/home_title_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    final client = GraphqlClientProvider.instance.client;
    final datasource = PokemonGraphqlDatasource(client);
    final repository = PokemonRepositoryImpl(datasource);
    final usecase = GetPokemonList(repository);
    _controller = HomeController(usecase);
    _controller.loadAllPokemon();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const HomeBottomNav(currentIndex: 0),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomScrollView(
              slivers: <Widget>[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: HomeHeader(),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: HomeTitleSection(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: HomeSearchBar(onChanged: _controller.updateQuery),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: HomeFilters(
                      selectedType: _controller.selectedType,
                      selectedGeneration: _controller.selectedGeneration,
                      selectedWeight: _controller.selectedWeight,
                      selectedHeight: _controller.selectedHeight,
                      typeOptions: _controller.typeOptions,
                      generationOptions: _controller.generationOptions,
                      weightOptions: _controller.weightOptions,
                      heightOptions: _controller.heightOptions,
                      onTypeSelected: _controller.updateTypeFilter,
                      onGenerationSelected: _controller.updateGenerationFilter,
                      onWeightSelected: _controller.updateWeightFilter,
                      onHeightSelected: _controller.updateHeightFilter,
                    ),
                  ),
                ),
                if (_controller.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                else if (_controller.errorMessage != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          _controller.errorMessage ?? 'Error',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pokemon = _controller.visiblePokemon[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: HomeCard(pokemon: pokemon),
                        );
                      }, childCount: _controller.visiblePokemon.length),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: HomePagination(
                      currentPage: _controller.currentPage,
                      totalPages: _controller.totalPages,
                      onNext: _controller.nextPage,
                      onPrevious: _controller.previousPage,
                      onSelect: _controller.loadPage,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
              ],
            );
          },
        ),
      ),
    );
  }
}
