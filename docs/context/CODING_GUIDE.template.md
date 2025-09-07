---
context_role: engineer
phase: coding
visibility: public
weight: 0.7
related: ["ARCHITECTURE.md","TECHNICAL_PLAN.md","TESTING_PLAN.md"]
owner: <owner>
project: <project>
date: 2025-09-07
tags: []
---

# Conventions
- Language/Framework: (e.g., C# 12, ASP.NET Core, EF Core)
- Naming: PascalCase (types), camelCase (members/locals), SNAKE_CASE (consts)
- Folders: Domain/, Application/, Infrastructure/, Api/
- Nullability: enabled; avoid postfix `!` except in builders/mappers
- Logging: structured; never log secrets or personal data

# Patterns & Structure
- Clean/Hexagonal; Domain must not reference Infrastructure
- Dependency Injection: constructor; avoid service locator
- Errors/Exceptions: exceptions for abnormal flow; `Result<T>` for domain decisions

# Example Snippets
```csharp
namespace <root_namespace>.Domain.Orders;

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

# Testing Guidance
- Unit: 1 assertion per behavior, clear names, AAA (Arrange/Act/Assert)
- Integration: Testcontainers; real DB, minimal mocks
- Contract: generate OpenAPI stubs
- Coverage: focus on critical domain logic

# Tooling
- Formatter: `dotnet format` in CI
- Analyzers: Roslyn/StyleCop (repo rules)
- Security: `dotnet list package --vulnerable` in CI
