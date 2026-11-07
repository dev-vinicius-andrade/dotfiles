# secrets

`env.sops.env` is a dotenv file encrypted with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age).
Only the values are encrypted; it is safe to commit. `zsh/secrets.zsh` decrypts it once,
caches the plaintext in `$XDG_RUNTIME_DIR` (mode 600, tmpfs) and exports the variables.

| Task | Command |
|---|---|
| Edit / add / rotate a value | `secrets_edit` (same as `sops edit secrets/env.sops.env`) |
| List variable names | `secrets_list` |
| Reload after editing elsewhere | `secrets_reload` |

## New machine

Copy the age private key to `~/.config/sops/age/keys.txt` (macOS: `~/Library/Application Support/sops/age/keys.txt`),
or point `SOPS_AGE_KEY_FILE` at it. Without the key the shell still starts; secrets are just skipped.

## Another key / person

Add the age public key (`age-keygen -y keys.txt`) to `.sops.yaml`, then run `sops updatekeys secrets/env.sops.env`.

## Guardrails

- `.githooks/pre-commit` runs gitleaks on staged changes (`git config core.hooksPath .githooks`, done by `init.sh`).
- `.github/workflows/gitleaks.yml` scans every push / PR, with custom rules in `.gitleaks.toml`.
- atuin's `history_filter` keeps `export *_TOKEN=...` lines out of synced shell history.
