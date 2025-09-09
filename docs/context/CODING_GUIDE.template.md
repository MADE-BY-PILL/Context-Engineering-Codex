#parse("CE_vars.vm")
---
context_role: engineer
phase: coding
visibility: public
weight: 0.7
related: ["ARCHITECTURE.md","TECHNICAL_PLAN.md","TESTING_PLAN.md"]
owner: ${USER}
project: ${PROJECT_NAME}
date: ${DATE}
---

$h Conventions

- **Linguagem/Framework**: (ex.: C# 12, ASP.NET Core, EF Core)
- **Naming**: PascalCase (tipos), camelCase (métodos/variáveis), SNAKE_CASE (constantes)
- **Pastas**: `Domain/`, `Application/`, `Infrastructure/`, `Api/`
- **Nullability**: enabled; evitar `!` a não ser em Builders e Mappers
- **Logs**: structured logging; nunca logar dados pessoais

$h Patterns & Structure

- **Arquitetura**: Clean/Hexagonal (não referenciar `Infrastructure` a partir de `Domain`)
- **Injeção de Dependências**: construtor; evitar service locator
- **Erro/Exceções**: exceptions para fluxo anómalo; `Result<T>` para domínio

$h Example Snippets

```csharp
namespace ${PROJECT_NAME}.Domain.Orders;

public sealed class Order
{
    public Guid Id { get; init; }
    public decimal Total { get; private set; }

    public void AddLine(decimal price, int qty)
    {
        Total += price * qty;
    }
}
```


$h Testing Guidance
- Unit: 1 assert por comportamento, nome claro, AAA (Arrange/Act/Assert)
- Integration: testcontainers; DB real, sem mocks
- Contract: gerar stubs do OpenAPI
- Coverage: foco em domínio crítico (linhas/branches alvo no TESTING_PLAN)

$h Tooling
- Formatador: dotnet format no CI
- Analyzers: Roslyn/StyleCop com regras do repositório
- Security: dotnet list package --vulnerable no CI
