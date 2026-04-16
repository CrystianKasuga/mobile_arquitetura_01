---
name: Convenções de nomenclatura e decisões arquiteturais confirmadas
description: Padrões de nomenclatura, decisões de implementação e dependências relevantes confirmadas no projeto
type: project
---

Confirmado em 2026-04-15:

## Sufixos de nomenclatura
- Entidades de domínio: sem sufixo (ex: `Product`)
- Models de dados: sufixo `Model` (ex: `ProductModel`)
- DataSources: sufixo `Datasource` (ex: `ProductRemoteDatasource`, `ProductLocalDatasource`)
- Repositórios (interface): sem sufixo (ex: `ProductRepository`)
- Repositórios (implementação): sufixo `Impl` (ex: `ProductRepositoryImpl`)
- ViewModels: sufixo `ViewModel` (ex: `ProductViewModel`)
- Pages: sufixo `Page` (ex: `ProductPage`)

## Dependências relevantes no pubspec.yaml
- `http: ^1.2.1` — cliente HTTP usado em AppHttpClient
- `shared_preferences: ^2.2.2` — cache local usado em ProductLocalDatasource
- `provider`: AUSENTE (previsto em CLAUDE.md para favoritos futuros)
- SDK: `^3.7.0` — Dart 3.7+, null-safety estrito, suporte a sealed classes e switch expressions

## Wiring de dependências
- Feito manualmente em `main.dart`, sem DI framework
- main.dart tem permissão implícita para importar todas as camadas (ponto de composição)

## Estado da UI
- Sealed class `AppState<T>` com 3 subclasses: `Loading`, `Success`, `Error`
- CLAUDE.md especifica a terceira subclasse como `ErrorState` — há divergência no código atual
- ViewModel usa `ValueNotifier<AppState<T>>` (não ChangeNotifier)

## Conversão Model → Entity
- Feita no Repository (`_toEntity`), não nos DataSources — correto arquiteturalmente
