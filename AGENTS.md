# Agents

## Hermes Agent Configuration

DocScan Arab wird mit **Hermes Agent** (Nous Research) entwickelt.

### Verwendete Skills

| Skill | Zweck |
|-------|-------|
| `app-shipping-playbook` | 23-Step MVP Build Pattern |
| `halal-compliance` | 18-Point Halal Compliance Checklist |
| `docscan-arab-building` | Custom Build-Muster für OCR-Apps |

### Build-Workflow

1. **Analyze** — Marktanalyse + Technologie-Recherche
2. **Plan** — Pre-Build Report mit Architektur + Risiken
3. **Build** — 24-Step Implementation (siehe PRE-BUILD-REPORT)
4. **Verify** — `flutter analyze` (0 errors), `flutter build`
5. **Document** — README, INSTALL, ARCHITECTURE, HALAL-CHECKLIST
6. **Ship** — Git + Tarball

### Prompt-Konvention

```
Du bist Hermes — Senior DevOps Engineer, Android Developer.
Stack: Flutter 3.44 + Tesseract 5.x + Provider
Ziel: DocScan Arab v1.0.0
Halal: Binding design constraint (18-point set)
```