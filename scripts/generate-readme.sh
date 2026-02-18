#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

{
  echo "# Gabriel Koerich's Homebrew Tap"
  echo
  echo "Homebrew tap for Gabriel Koerich tools."
  echo
  echo "## Install"
  echo
  echo "\`\`\`bash"
  echo "brew tap gabrielkoerich/tap"
  echo "\`\`\`"
  echo
  echo "## Packages"
  echo
  echo "### Formulae"
  echo
  find Formula -maxdepth 1 -type f -name '*.rb' | sort | while IFS= read -r file; do
    formula_name="$(basename "$file" .rb)"
    homepage="$(awk -F'"' '/^[[:space:]]*homepage[[:space:]]+"/ { print $2; exit }' "$file")"
    description="$(awk -F'"' '/^[[:space:]]*desc[[:space:]]+"/ { print $2; exit }' "$file")"

    url="$(awk -F'"' '/^[[:space:]]*url[[:space:]]+"/ { print $2; exit }' "$file")"
    version="unknown"
    if [[ -n "$url" ]]; then
      archive_name="${url##*/}"
      if [[ "$archive_name" == *.tar.gz ]]; then
        version="${archive_name%.tar.gz}"
        version="${version#v}"
      fi
    fi

    if [[ "$version" == "unknown" ]]; then
      explicit_version="$(awk -F'"' '/^[[:space:]]*version[[:space:]]+"/ { print $2; exit }' "$file")"
      if [[ -n "$explicit_version" ]]; then
        version="$explicit_version"
      fi
    fi

    formula_cell="\`$formula_name\`"
    if [[ -n "$homepage" ]]; then
      formula_cell="[\`$formula_name\`]($homepage)"
    fi

    has_service="false"
    if awk '/^[[:space:]]*service[[:space:]]+do/ { found=1 } END { exit(found ? 0 : 1) }' "$file"; then
      has_service="true"
    fi

    printf -- '- %s (`%s`): %s\n' "$formula_cell" "$version" "$description"
    printf -- '  - Install: `brew install %s`\n' "$formula_name"
    if [[ "$has_service" == "true" ]]; then
      printf -- '  - Start service: `brew services start %s`\n' "$formula_name"
      printf -- '  - Stop service: `brew services stop %s`\n' "$formula_name"
    fi
  done

  echo
  echo "## Update"
  echo
  echo "\`\`\`bash"
  echo "brew update"
  echo "brew upgrade"
  echo "\`\`\`"
  echo
  echo "## Uninstall"
  echo
  echo "\`\`\`bash"
  echo "brew uninstall <formula>"
  echo "brew untap gabrielkoerich/tap"
  echo "\`\`\`"
} > README.md
