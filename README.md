# katua-site

Site institucional da **Katuá Tech**: uma página que apresenta a empresa e os dois produtos, o **Skeleton** (open source) e o **Medvita**.

## Abrir localmente

É HTML e CSS estáticos, sem etapa de build. Sirva a pasta e abra no navegador:

```sh
py -3 -m http.server 8765
```

Depois, <http://localhost:8765>. Qualquer hospedagem estática serve o site como está.

## Estrutura

| Caminho | O que é |
| --- | --- |
| `index.html` | A página, com as ilustrações dos produtos em SVG embutido |
| `assets/css/tokens.css` | Tokens do design system KATUÁ. (cores claro/escuro, tipografia, espaçamento, raios) |
| `assets/css/components.css` | Classes `kt-*` do design system (botão, badge, título de seção, cartão, navbar) |
| `assets/css/site.css` | Layout das seções e cores das ilustrações |
| `assets/js/theme.js` | Botão de tema claro/escuro; sem escolha, segue o sistema |
| `assets/img/` | Favicon e logotipos oficiais (positivo e negativo) |

## Marca

O site segue o design system **KATUÁ.**: tokens semânticos em vez de HEX, títulos com o ponto azul, Archivo nos títulos, Inter no texto e JetBrains Mono no código, ícones Lucide. As imagens dos produtos são ilustrações desenhadas a partir das telas reais, não capturas. Nas ilustrações do Medvita entram as cores da marca Medvita (azul, verde e petróleo), só como acento.

## Pendências antes de publicar

- Confirmar o e-mail de contato (`contato@katua.tech` é provisório) em `index.html`.
- Imagem de compartilhamento (`og:image`) e domínio definitivo.

## Fluxo de trabalho

Issues, branches, commits, PRs e versões seguem o skill `dev-workflow` (`.claude/skills/dev-workflow/`), configurado em `.github/dev-workflow.toml`. Veja o [AGENTS.md](AGENTS.md).

Depois de clonar, instale o hook de commit uma vez:

```sh
py -3 .claude/skills/dev-workflow/scripts/bootstrap.py install-hook
```
