import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlClientProvider {
  GraphqlClientProvider._();

  static final GraphqlClientProvider instance = GraphqlClientProvider._();

  static const String endpoint = 'https://beta.pokeapi.co/graphql/v1beta';

  late final GraphQLClient _client;

  GraphQLClient get client => _client;

  Future<void> initialize() async {
    await initHiveForFlutter();
    final box = await HiveStore.openBox('graphql');
    final store = HiveStore(box);
    final cache = GraphQLCache(store: store);

    _client = GraphQLClient(link: HttpLink(endpoint), cache: cache);
  }
}
