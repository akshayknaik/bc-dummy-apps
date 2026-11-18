# Contoso BC Dummy Apps

Dummy Business Central (BC 25 / runtime 14) multi-app repo with inter-dependent extensions — built as a sandbox for GitHub Actions CI/CD.

## Dependency graph

```
                Contoso.Core  (50100-50149)
                /           \
   Contoso.Customer       Contoso.Item
     (50150-50199)        (50200-50249)
                \           /
                Contoso.Sales  (50250-50299)
                      |
              Contoso.Reporting (50300-50349)

Tests:
  Contoso.Core.Test  (50400-50449) -> Core + Library Assert
  Contoso.Sales.Test (50450-50499) -> Core, Customer, Item, Sales + Library Assert
```

## Build order

| # | Folder | Depends on |
|---|--------|-----------|
| 1 | Contoso.Core | — |
| 2 | Contoso.Customer | Core |
| 3 | Contoso.Item | Core |
| 4 | Contoso.Sales | Core, Customer, Item |
| 5 | Contoso.Reporting | Core, Customer, Sales |
| 6 | Contoso.Core.Test | Core, Library Assert |
| 7 | Contoso.Sales.Test | Core, Customer, Item, Sales, Library Assert |

Generate it from the app.json files:

```powershell
./scripts/Get-AppBuildOrder.ps1          # table
./scripts/Get-AppBuildOrder.ps1 -AsJson  # for an Actions matrix
```

## What each app does

| App | Objects |
|-----|---------|
| Core | Enums `CTS Region`, `CTS Loyalty Tier`; tables `CTS Core Setup`, `CTS Log Entry`; setup + log pages; `CTS Core Mgt` (logging, tier discount, `OnAfterLog` event) |
| Customer | Customer table/page ext (region, tier, points); `CTS Customer Loyalty Mgt` (AddPoints, CalcTier) |
| Item | `CTS Item Category` table + page; Item table/page ext; `CTS Item Category Mgt` |
| Sales | Sales Header/Line ext; Sales Order + subform page ext; discount codeunit; event subscribers (copy tier, apply discount, award points on post) |
| Reporting | Query `CTS Sales by Loyalty Tier`; API page `contoso/loyalty/v1.0/customerLoyalties` |

## Local setup

1. Open `Contoso.code-workspace` in VS Code (AL Language extension).
2. Add a `.vscode/launch.json` per app pointing at your sandbox/container (git-ignored).
3. Download symbols, then publish in build order.

## CI (`.github/workflows/ci.yml`)

Runs on push/PR to `main` and manually (pick BC version).

| Job | Runner | What it does |
|-----|--------|--------------|
| validate | ubuntu-latest | `Get-AppBuildOrder.ps1` — fails on circular deps |
| build | windows-latest | `Invoke-CIBuild.ps1` — BcContainerHelper `Run-AlPipeline` with compiler folder (no container), CodeCop + UICop, uploads `.app` artifacts |

App version = `1.0.<run_number>.0`. Run locally: `./scripts/Invoke-CIBuild.ps1 -BcVersion 25`.

## Next step: CD

Repo is laid out so either option works:
- **AL-Go for GitHub** — add `.AL-Go/settings.json` with `appFolders` / `testFolders`; AL-Go resolves the order itself.
- **Custom workflow** — use `Get-AppBuildOrder.ps1 -AsJson` + BcContainerHelper `Run-AlPipeline`.
