# Projeto mobile_arquitetura_01

App Flutter que consome FakeStore API (https://fakestoreapi.com/products) organizado em arquitetura em camadas.

## Camadas
- presentation/ — UI, páginas, viewmodels, providers
- domain/ — entidades e contratos de repositório
- data/ — models, datasources, implementação de repositórios
- core/ — utilitários (http, errors, state)

## Regras invioláveis
- presentation/ NÃO importa data/ nem core/network/
- ViewModel NÃO importa material.dart, Widget ou BuildContext (apenas foundation.dart)
- domain/ não importa nada de data/, presentation/ ou core/
- Repository decide a fonte dos dados (remote, local, cache)
- DataSources fazem APENAS operações de IO
- Fluxo: UI → ViewModel → Repository → DataSource

## Convenções
- Mensagens de erro em português
- Estados da UI via sealed class AppState<T>: Loading | Success | ErrorState
- Gerenciamento de estado: Provider (para favoritos) + ValueNotifier (para estado de produtos)
- Dart 3.7+, null-safety estrito