# Blog32

Personal calculator website at https://jacober-calc.github.io/, built with Zensical.

## Local tools and storage

Run commands from this repository using `site.sh`. The launcher sets local cache,
configuration, data, state, Python bytecode, and temporary directories before
running the tools. No shell startup files or global Python packages are changed.
Package download caching is disabled.

- `.venv/`: Zensical, pip, and Python dependencies.
- `.local/`: tool caches, configuration, state, and temporary downloads.
- `.cache/`: Zensical's project build cache, if generated.
- `site/`: generated website output.
- `docs/`: Markdown pages, articles, and images.
- `zensical.toml`: site settings and navigation.
- `requirements.txt`: pinned versions of website tools and dependencies.

Generated files and installed tools are ignored by Git. The environment uses the
existing system Python 3.14 and its standard library; Python itself is not bundled
or modified. This is a local installation, not a portable Python distribution.
Use the launcher instead of invoking pip or Zensical directly to preserve these
storage settings.

## Setup

The tools are already installed in this checkout. To recreate them after cloning
on a machine with Python 3.14, run:

```sh
./site.sh setup
```

Setup downloads pip from the Python Packaging Authority only if needed, installs
it inside `.venv/`, and removes its temporary installer. It then installs the pinned
requirements from PyPI. All downloaded files are stored inside this repository.

## Preview and build

```sh
./site.sh serve
```

Open the local address printed in the terminal, normally http://127.0.0.1:8000/.
Press Ctrl+C to stop the server.

```sh
./site.sh build --strict
```

The generated website is written to `site/`.

## Writing articles

Add Markdown files beneath `docs/articles/`. Link them from `docs/index.md`, and
add entries to `nav` in `zensical.toml` when they should appear in site navigation.
Edit an existing Markdown file whenever an article needs updating. No blog plugin,
post metadata, or publication dates are required.

## Article formatting

The site follows the visual conventions of the
[SwissMicros DM32 User Manual](https://technical.swissmicros.com/dm32/doc/dm32_user_manual.html):
white pages, warm brown headings, dark grey body text, flat black physical-key
labels, orange and blue shifted functions, and grey calculator-display text.
The stylesheet is `docs/stylesheets/manual.css`. It uses system sans-serif fonts;
the manual's domain-licensed Theinhardt font files are not bundled or requested.

Use ordinary Markdown headings (`#`, `##`, `###`). Add section numbers to the
heading text yourself only when an article needs them. For inline notation:

| Meaning | Markdown / HTML |
| --- | --- |
| Physical key | `**XEQ**{.button}` |
| Key with a special character | `**√x**{.button}` or `**Σ+**{.button}` |
| Orange shifted function | `**GTO**{.or}` |
| Blue shifted function | `**EQN**{.bl}` |
| Calculator display / soft-menu text | `<kbd>RAD</kbd>` |
| Letter selection | `[Q]` |
| File path or program source | ordinary backticks / fenced code blocks |

For example, `2 **ENTER**{.button} 3 **+**{.button}` uses plain digits and black key
labels. This syntax accepts literal plus signs without escaping. Function labels
can use normal Unicode: √x, eˣ, yˣ, Σ+, π, ×, ÷, ▲, ▼, ≤, ≥, and ≠. For compound
labels, inline HTML such as `<sup>` and `<sub>` is also available.

When a shift key itself needs to appear as a blank coloured rectangle, use:

```html
<span class="ors" role="img" aria-label="Orange shift">&nbsp;</span>
<span class="bls" role="img" aria-label="Blue shift">&nbsp;</span>
```

The attribute syntax uses Zensical's existing `attr_list` support. No additional
packages, fonts, scripts, or remote stylesheet services are needed.

## GitHub Pages

In the repository's **Settings > Pages**, set **Source** to **GitHub Actions**.
Once the workflow has been pushed to GitHub, pushes to `main` will build and
publish the website. Setup alone does not publish anything.

## Drafts and publishing

Use `backstage` for ongoing changes. Commit and push there to save work on GitHub;
those pushes do not update the public website. Preview locally with `./site.sh serve`.
When ready, open a pull request from `backstage` into `main` and merge it. That merge
triggers the website deployment. Manual deployments also run only from `main`.

To require pull requests for `main`, go to **Settings > Rules > Rulesets**, use the
**New ruleset** menu to **Import a ruleset**, and select
`.github/main-ruleset.json` from this checkout. Confirm **Active** enforcement and
save it. The file requires pull requests, blocks force pushes and deletion, and
has no bypass actors. It requires zero review approvals so a solo maintainer can
merge their own pull requests. Committing the JSON file does not activate it;
it must be imported in GitHub.

## License

MIT; see [LICENSE](LICENSE).
