#!/usr/bin/env bash

set -euo pipefail

repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

mock_dir="$test_dir/bin"
log_file="$test_dir/commands"
mkdir -p "$mock_dir"

mock_command() {
  local name=$1
  cat >"$mock_dir/$name" <<'EOF'
#!/usr/bin/env bash
printf '%s %s\n' "$(basename "$0")" "$*" >>"$BOOTSTRAP_LOG"
EOF
  chmod +x "$mock_dir/$name"
}

for command in apt-get curl tar ln stow rm; do
  mock_command "$command"
done

cat >"$mock_dir/id" <<'EOF'
#!/usr/bin/env bash
printf '0\n'
EOF
chmod +x "$mock_dir/id"

cat >"$mock_dir/uname" <<'EOF'
#!/usr/bin/env bash
printf 'x86_64\n'
EOF
chmod +x "$mock_dir/uname"

export BOOTSTRAP_LOG="$log_file"
PATH="$mock_dir:$PATH" HOME="$test_dir/home" "$repo_dir/bootstrap.sh"

grep -Fx 'apt-get update' "$log_file"
grep -Fx 'apt-get install -y git stow tmux unzip ripgrep' "$log_file"
grep -F 'curl -fsSL https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz -o ' "$log_file"
grep -F 'tar -C /opt -xzf ' "$log_file"
grep -Fx 'ln -sfn /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim' "$log_file"
grep -Fx "stow -R -d $repo_dir -t $test_dir/home git tmux nvim" "$log_file"
