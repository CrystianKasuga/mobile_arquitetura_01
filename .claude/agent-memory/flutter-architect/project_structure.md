---
name: Estrutura real de diretórios — mobile_arquitetura_01
description: Mapa completo dos arquivos Dart existentes no projeto, suas camadas e dependências confirmadas via leitura direta dos arquivos
type: project
---

Estrutura confirmada em 2026-04-15:

```
lib/
  core/
    errors/failure.dart          — class Failure implements Exception
    network/http_client.dart     — AppHttpClient (usa package:http)
    state/app_state.dart         — sealed class AppState<T>; subclasses: Loading, Success, Error
  domain/
    entities/product.dart        — entidade Product (id, title, price, image), sem imports externos
    repositories/product_repository.dart — abstract class, importa apenas domain/entities/product.dart
  data/
    models/product_model.dart    — ProductModel com fromJson/toJson, sem imports externos
    datasources/product_remote_datasource.dart — usa AppHttpClient + ProductModel
    datasources/product_local_datasource.dart  — usa SharedPreferences + ProductModel + dart:convert
    repositories/product_repository_impl.dart  — implementa ProductRepository; lógica: remote → cache → local fallback
  presentation/
    viewmodels/product_viewmodel.dart — ValueNotifier<AppState<List<Product>>>; importa foundation.dart + AppState + Product + ProductRepository
    pages/product_page.dart           — StatelessWidget; importa material.dart, AppState, Product, ProductViewModel
  main.dart — wiring manual (sem DI framework); importa tudo inclusive core/network e data/
```

**Why:** Mapa de referência para validações arquiteturais futuras.
**How to apply:** Consultar antes de sugerir paths de novos arquivos ou avaliar violações de import.
