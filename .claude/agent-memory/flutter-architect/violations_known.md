---
name: Violações arquiteturais conhecidas — estado atual
description: Violações confirmadas via leitura dos arquivos em 2026-04-15, organizadas por arquivo e regra violada
type: project
---

Violações confirmadas em 2026-04-15:

## 1. app_state.dart — nome da subclasse de erro
- Arquivo: `lib/core/state/app_state.dart` linha 10
- Classe nomeada `Error<T>` mas CLAUDE.md especifica `ErrorState<T>`
- Risco: `Error` é nome do tipo base de erros em Dart (não é palavra reservada, mas causa shadowing do tipo nativo `Error` dentro de qualquer arquivo que importe app_state.dart sem prefixo)

## 2. product_viewmodel.dart — captura genérica de Exception sem mensagem em português
- Arquivo: `lib/presentation/viewmodels/product_viewmodel.dart` linha 22
- `products.value = Error(e.toString())` — e.toString() pode retornar texto em inglês, violando a convenção de mensagens de erro em português
- Risco menor: depende do que a Exception contém; Failure já usa português, mas Exception genérica não garante

## 3. pubspec.yaml — ausência do pacote provider
- CLAUDE.md especifica Provider como gerenciamento de estado
- pubspec.yaml não declara a dependência `provider`
- Impacto atual: baixo (ProductViewModel usa ValueNotifier diretamente), mas bloqueante para expansão

**Why:** Registro para evitar reintrodução das violações em futuras implementações.
**How to apply:** Sempre verificar esses pontos ao revisar PRs ou novas implementações neste projeto.
