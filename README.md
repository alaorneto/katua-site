# katua-site

Site institucional da **Katuá Tech**.

## Fluxo de trabalho

Issues, branches, commits, PRs e versões seguem o skill `dev-workflow` (`.claude/skills/dev-workflow/`), configurado em `.github/dev-workflow.toml`. Veja o [AGENTS.md](AGENTS.md).

Depois de clonar, instale o hook de commit uma vez:

```sh
py -3 .claude/skills/dev-workflow/scripts/bootstrap.py install-hook
```
