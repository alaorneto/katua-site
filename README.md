# katua-site

Site institucional da **Katuá Tech**: uma página que apresenta a empresa e os dois produtos, o **Skeleton** (open source) e o **Medvita**.

## Abrir localmente

É HTML e CSS estáticos, sem etapa de build. Sirva a pasta e abra no navegador:

```sh
py -3 -m http.server 8765
```

Depois, <http://localhost:8765>.

## Container Docker

O site é publicado como imagem Docker: nginx sem root (`nginxinc/nginx-unprivileged`, versão estável fixada por digest) servindo os arquivos na porta **8080**.

```sh
docker run -d --name katua-site -p 8080:8080 ghcr.io/alaorneto/katua-site:latest
```

Depois, <http://localhost:8080>. A rota `/healthz` responde `ok` para o orquestrador, e a imagem tem `HEALTHCHECK`. Ela roda também com o sistema de arquivos somente leitura, desde que `/tmp` e `/var/cache/nginx` sejam graváveis:

```sh
docker run -d -p 8080:8080 --read-only --tmpfs /tmp --tmpfs /var/cache/nginx ghcr.io/alaorneto/katua-site:latest
```

### Tags

| Tag | Aponta para |
| --- | --- |
| `X.Y.Z` | Uma versão exata (use esta em produção) |
| `X.Y` | A última correção da versão X.Y |
| `latest` | A última versão final |
| `beta`, `rc`… | A última pré-release do canal |

Imagens para `linux/amd64` e `linux/arm64`.

### Construir e testar localmente

```sh
docker build -t katua-site:dev .
bash docker/smoke-test.sh katua-site:dev
```

O teste sobe o container e confere páginas, `/healthz`, 404, cabeçalhos de segurança, cache, gzip, usuário sem root e que só os arquivos do site estão na imagem. O workflow **Imagem Docker** roda o mesmo teste em cada PR.

### Publicação

Não há passo manual: quando um PR com o label `release` é mesclado, o workflow **Versão e release** publica a versão e dispara **Publicar imagem Docker** (`release.dispatch_workflow` em `.github/dev-workflow.toml`), que constrói a imagem na tag da versão, publica no GitHub Container Registry e testa a imagem publicada. Para republicar uma versão, rode esse workflow à mão com `version` e `tag`.

### Arquivos

| Caminho | O que é |
| --- | --- |
| `Dockerfile` | A imagem |
| `.dockerignore` | Lista de permissão: só o site e a configuração do nginx entram no build |
| `docker/nginx.conf` | Servidor: cache, gzip, 404, `/healthz` |
| `docker/security-headers.conf` | Cabeçalhos de segurança e CSP. O hash do script inline de `index.html` está aqui; se ele mudar, troque o hash (o teste avisa) |
| `docker/smoke-test.sh` | Teste da imagem |

## Estrutura

| Caminho | O que é |
| --- | --- |
| `index.html` | A página, com as ilustrações dos produtos em SVG embutido |
| `404.html` | Página de endereço não encontrado |
| `assets/css/tokens.css` | Tokens do design system KATUÁ. (cores claro/escuro, tipografia, espaçamento, raios) |
| `assets/css/components.css` | Classes `kt-*` do design system (botão, badge, título de seção, cartão, navbar) |
| `assets/css/site.css` | Layout das seções e cores das ilustrações |
| `assets/js/site.js` | Tema claro/escuro (sem escolha, segue o sistema), menu no celular e link da seção atual no cabeçalho |
| `assets/img/` | Favicon e logotipos oficiais (positivo e negativo) |

## Marca

O site segue o design system **KATUÁ.**: tokens semânticos em vez de HEX, títulos com o ponto azul, Archivo nos títulos, Inter no texto e JetBrains Mono no código, ícones Lucide. As imagens dos produtos são ilustrações desenhadas a partir das telas reais, não capturas. Nas ilustrações do Medvita entram as cores da marca Medvita (azul, verde e petróleo), só como acento.

## Pendências antes de publicar

- Confirmar o e-mail de contato (`contato@katua.tech` é provisório) em `index.html`.
- Imagem de compartilhamento (`og:image`) e domínio definitivo.
- Conferir o que o texto do Medvita promete: a secretária virtual e o aplicativo para Windows (hoje descrito como "a caminho").
- O repositório do Skeleton não tem arquivo de licença; o site o chama de open source.

## Fluxo de trabalho

Issues, branches, commits, PRs e versões seguem o skill `dev-workflow` (`.claude/skills/dev-workflow/`), configurado em `.github/dev-workflow.toml`. Veja o [AGENTS.md](AGENTS.md).

Depois de clonar, instale o hook de commit uma vez:

```sh
py -3 .claude/skills/dev-workflow/scripts/bootstrap.py install-hook
```
