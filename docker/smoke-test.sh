#!/usr/bin/env bash
# Sobe a imagem do site e confere o que ela promete: páginas, saúde, 404, cabeçalhos,
# cache, gzip, usuário sem root e só os arquivos do site dentro dela.
# Uso: docker/smoke-test.sh <imagem>
set -euo pipefail

image="${1:?uso: docker/smoke-test.sh <imagem>}"
name="katua-site-smoke-$$"
port="${SMOKE_PORT:-18080}"
base="http://127.0.0.1:${port}"
failures=0

cleanup() { docker rm -f "$name" >/dev/null 2>&1 || true; }
trap cleanup EXIT

ok()   { printf '  ok    %s\n' "$1"; }
fail() { printf '  FALHA %s\n' "$1"; failures=$((failures + 1)); }
check() { if eval "$2"; then ok "$1"; else fail "$1"; fi; }

echo "Imagem: $image"
docker run -d --name "$name" -p "127.0.0.1:${port}:8080" --read-only \
  --tmpfs /tmp --tmpfs /var/cache/nginx "$image" >/dev/null

# Espera o HEALTHCHECK da imagem ficar saudável (até 60 s).
for _ in $(seq 1 60); do
  health="$(docker inspect -f '{{.State.Health.Status}}' "$name" 2>/dev/null || echo starting)"
  [ "$health" = "healthy" ] && break
  if [ "$(docker inspect -f '{{.State.Running}}' "$name")" != "true" ]; then
    docker logs "$name"; echo "O container parou."; exit 1
  fi
  sleep 1
done
check "HEALTHCHECK saudável" '[ "$health" = "healthy" ]'

status() { curl -s -o /dev/null -w '%{http_code}' "$base$1"; }
headers() { curl -s -D - -o /dev/null "$@"; }

check "/ responde 200"                '[ "$(status /)" = 200 ]'
check "/ traz o site"                 'curl -s "$base/" | grep -q "Software rápido"'
check "/healthz responde 200"         '[ "$(status /healthz)" = 200 ]'
check "caminho inexistente dá 404"    '[ "$(status /nao-existe)" = 404 ]'
check "404 usa a página própria"      'curl -s "$base/nao-existe" | grep -q "Esta página não existe"'
check "arquivo oculto dá 404"         '[ "$(status /.git/config)" = 404 ]'
check "CSS e JS servidos"             '[ "$(status /assets/css/site.css)" = 200 ] && [ "$(status /assets/js/site.js)" = 200 ]'

h_root="$(headers "$base/")"
h_css="$(headers -H "Accept-Encoding: gzip" "$base/assets/css/site.css")"
h_404="$(headers "$base/nao-existe")"
has() { printf '%s' "$1" | tr -d '\r' | grep -qi "$2"; }

check "nosniff"                       'has "$h_root" "^x-content-type-options: nosniff"'
check "X-Frame-Options DENY"          'has "$h_root" "^x-frame-options: DENY"'
check "Referrer-Policy"               'has "$h_root" "^referrer-policy: strict-origin-when-cross-origin"'
check "CSP presente"                  'has "$h_root" "^content-security-policy: default-src"'
check "cabeçalhos também no 404"      'has "$h_404" "^x-content-type-options: nosniff"'
check "versão do nginx oculta"        '! has "$h_root" "^server: nginx/"'
check "HTML sem cache longo"          'has "$h_root" "^cache-control: no-cache"'
check "assets com cache"              'has "$h_css" "^cache-control: public, max-age=86400"'
check "gzip no CSS"                   'has "$h_css" "^content-encoding: gzip"'

# O hash da CSP tem de ser o do script inline atual de index.html.
inline_hash="$(curl -s "$base/" | python3 -c '
import base64, hashlib, re, sys
html = sys.stdin.read()
for script in re.findall(r"<script>(.*?)</script>", html, re.S):
    print("sha256-" + base64.b64encode(hashlib.sha256(script.encode("utf-8")).digest()).decode())
')"
check "CSP autoriza o script inline"  'has "$h_root" "$inline_hash"'

uid="$(docker exec "$name" id -u)"
check "nginx roda sem root (uid $uid)" '[ "$uid" != 0 ]'

files="$(docker exec "$name" find /usr/share/nginx/html -mindepth 1 -maxdepth 1 | sort | tr '\n' ' ')"
echo "  conteúdo: $files"
check "só o site dentro da imagem" \
  '[ "$files" = "/usr/share/nginx/html/404.html /usr/share/nginx/html/assets /usr/share/nginx/html/index.html " ]'

if [ "$failures" -gt 0 ]; then
  echo "$failures verificação(ões) falharam."
  docker logs "$name" | tail -20
  exit 1
fi
echo "Todas as verificações passaram."
