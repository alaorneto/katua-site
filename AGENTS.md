# AGENTS.md — katua-site

Site institucional da Katuá Tech: HTML e CSS estáticos, sem etapa de build.

## Fluxo de desenvolvimento

O fluxo deste repositório é o skill `dev-workflow` (`.claude/skills/dev-workflow/`, configurado em
`.github/dev-workflow.toml`). Carregue o skill e siga-o (no Claude Code, pela ferramenta Skill; em
outro agente ou à mão, lendo `.claude/skills/dev-workflow/SKILL.md`) sempre que:

- entrar no modo de planejamento ou escrever um plano: ele termina com a seção "Itens do GitHub";
- um plano for aceito: as issues e o epic são criados antes de qualquer edição;
- for começar, sem plano, qualquer mudança em arquivo versionado (código, testes, documentação, CI,
  dependências);
- for criar ou atualizar uma issue ou um epic, criar branch, commitar ou abrir PR;
- for decidir se um PR publica versão e com que nível, ou mexer em release, changelog ou tag;
- for fechar uma issue.

Perguntas e investigações sem mudança de arquivo não precisam do skill. Valem sempre, mesmo sem ele:
nenhuma mudança versionada sem issue; nunca `--no-verify`; ninguém edita a versão nem o changelog à mão.

## Marca e design

O site segue o design system **KATUÁ.** (guardado como artifact no Claude): tokens em
`assets/css/tokens.css`, classes `kt-*` em `assets/css/components.css`.

- Use sempre os tokens semânticos (`--surface`, `--ink`, `--azul`…), nunca o HEX direto.
- Títulos são afirmações curtas e terminam com o ponto azul (`<span class="kt-period">.</span>`).
- Sem emoji, sem exclamação, sem gradiente roxo-azul. Ícones Lucide, traço de 2 px.
- O logotipo é o SVG oficial (`assets/img/`), nunca texto digitado.
- Imagens de produto são ilustrações, não capturas de tela.
