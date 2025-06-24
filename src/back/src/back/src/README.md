# taku

<!-- Shields -->
<p align="center">
  <a href="https://github.com/imgnx/taku/blob/main/LICENSE">
    <img alt="GitHub" src="https://img.shields.io/github/license/imgnx/taku?style=flat-square">
  </a>
  <a href="https://github.com/imgnx/taku/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/imgnx/taku?style=flat-square">
  </a>
  <a href="https://github.com/imgnx/taku/stargazers">
    <img alt="GitHub stars" src="https://img.shields.io/github/stars/imgnx/taku?style=social">
  </a>
  <a href="https://github.com/imgnx/taku/network/members">
    <img alt="GitHub forks" src="https://img.shields.io/github/forks/imgnx/taku?style=social">
  </a>
  <a href="https://github.com/imgnx/taku/commits/main">
    <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/imgnx/taku?style=flat-square">
  </a>
</p>

<p align="center">
  <b>Script for initializing a new project with <code>taku init</code></b>
</p>

<p align="center">
  <b>Powered</b> w/ 🥄 by [<a href="https://github.com/imgnx">@imgnx</a>]
</p>

<!-- OG:image for https://github.com/imgnx/taku -->

<img src="https://opengraph.githubassets.com/1/imgnx/taku" alt="taku CLI Open Graph Image" style="max-width: 420px; width: 100%; display: block; margin: 0 auto;" />

<!-- cli parser formula -->

$$
\begin{aligned}
\text{Runtime}_{\text{CLI}} &= \mathcal{O}(n + m \cdot \log k) + \sum_{i=1}^{f} \Bigg[\frac{d_i^2}{\sqrt{p_i + 1}} + \ln\left(\frac{v_i!}{(v_i - u_i)!}\right)\Bigg] \\\\
\text{where:} \quad
n &= \text{number of arguments}, \\
m &= \text{number of key-value pairs}, \\
k &= \text{distinct normalized keys}, \\
f &= \text{number of flags}, \\
d_i &= \text{depth of nesting in flag } i, \\
p_i &= \text{number of positional args before flag } i, \\
v_i &= \text{length of value assigned to flag } i, \\
u_i &= \text{number of underscores in that value}
\end{aligned}
$$

```
 Usage: `taku init <path> <name>`
 Initializes a new project with the specified path and name, setting up the necessary directory structure and
 files.
     <path> - The path where the project will be initialized (defaults to current directory).
     <name> - The name of the project (defaults to the name of the current directory).
```

```shellscript

mkdir ${project_name} && cd ${project_name} && touch main.sh && echo "#\!/bin/bash\n./cli/main.sh" > main.sh

mkdir -p frontend/src frontend/dist backend/src backend/dist cli/src cli/dist
```

Pseudocode

```markdown
### Steps to initialize a new project with `taku init`:
```

Initialize `git`

```
brew install git-lfs

git lfs track "*.jpg"
git lfs track "*.jpeg"
git lfs track "*.png"
git lfs track "*.tiff"
git lfs track "*.ogg"
git lfs track "*.zip"
git lfs track "*.mid"
git lfs track "*.pdf"
```

- Prompt user for name of project (defaults to name of directory — like `U.P.D.A.T.E.`)

- Other prompts...

  - `frontend` framework (ie. react)

    \+ ts/js?

    \+ dependencies (npm, yarn, etc.)

  - `backend` framework (ie. rust)

    \+ dependencies (cargo, etc.)

  - `cli` framework (ie. shellscript, javascript, etc.)

    \+ dependencies (brew, apt, apt-get, etc.)

- Initialize frontend into `frontend/` (ie. use yarn, webpack, tailwindcss, react, etc.)

- Initialize backend into `backend/` (ie. use cargo)

- Initialize CLI into `cli/` (ie. use zsh/bash for now and place shebang at the top of `cli/main.[sh/js/rs]`)

- Create `main.sh` in root and add `source src/main.[sh/js/rs]` and also the attached script, which should
  pass the JSON object `result` to cli/main.[sh/js/rs].

- Install `husky`

- Install and/or test `ggshield`

- Create `.gitignore`

- Create `README.md` with KaTeX Big O notation (defaults to CLI Parser formula)

- Create `LICENSE` file (defaults to MIT)

- Create `CHANGELOG.md` with initial version (defaults to 0.1.0)

- Create `CONTRIBUTING.md` with guidelines for contributing to the project

- Create `CODE_OF_CONDUCT.md` with a standard code of conduct

- Create `SECURITY.md` with guidelines for reporting security issues

- Create `UPGRADE.md` with instructions for upgrading the project

- Create `CONTRIBUTORS.md` to acknowledge contributors to the project

- Create `Makefile` with common tasks (e.g., build, test, lint, format)

- Create `Dockerfile` for containerization (if applicable)

- Create `docker-compose.yml` for local development (if applicable)

- Create `tsconfig.json` for TypeScript projects (if applicable)

- Create `eslint.config.js` for JavaScript/TypeScript linting

- Create `prettier.config.js` for code formatting

- Create `babel.config.js` for JavaScript transpilation (if applicable)

- Create `webpack.config.js` for bundling (if applicable)

- Create `rollup.config.js` for bundling (if applicable)

- Create `pnpm-lock.yaml` or `yarn.lock` for package management

- Create package.json with name, version, deps, etc.

- Configure husky

- Configure `git` hooks

  - `commit`

    \+ assertion: semantic commits

    - fallback: failure

    \+ assertion: ggshield — no secrets

    - fallback: failure

```

```

cargo build --release && mv target out

````

---

<!-- prettier-ignore -->
\* This script is a Node.js CLI parser designed to handle command-line arguments with special handling for sub-commands and escape sequences. It allows for flexible argument parsing, including flags, commands, and paths.

```javascript
#!/usr/bin/env node
// parser.js

// List of escape sequences/sub-commands that should collect args until a terminator (e.g., ";")
const escapeSequences = ["exec"];
const escapeTerminator = [";", "\\;"];

const rawArgs = process.argv.slice(2);

function printHelp() {
  console.log(`Usage: main.sh <command> <path> [options]\n
Options:
  -key value         Set a key to a value
  -key=value         Set a key to a value
  -flag              Boolean flag
  -exec ... ;        Special escape sequence, collects args until ';' or '\\;'
  -h, --help         Show this help message
`);
}

function normalizeKey(flag) {
  return flag.replace(/^-+/, "").replace(/-([a-z])/g, (_, c) => c.toUpperCase());
}

function parseValue(val) {
  if (val === "true") return true;
  if (val === "false") return false;
  const num = Number(val);
  return isNaN(num) ? val : num;
}

function parseArgs(args) {
  const result = {};
  let i = 0;
  while (i < args.length) {
    const arg = args[i];

    // Help flag
    if (arg === "-h" || arg === "--help") {
      printHelp();
      process.exit(0);
    }

    // First is the command
    if (!result.command) {
      result.command = arg;
      i++;
      continue;
    }

    // First non-flag after command is path
    if (!result.path && !arg.startsWith("-")) {
      result.path = arg;
      i++;
      continue;
    }

    // Normalize -key=value or --key=value
    if (arg.startsWith("-") && arg.includes("=")) {
      const [rawKey, value] = arg.split(/=(.+)/);
      const key = normalizeKey(rawKey);
      result[key] = parseValue(value);
      i++;
      continue;
    }

    // -key <value> pattern or escape sequence
    if (arg.startsWith("-")) {
      const key = normalizeKey(arg);
      const next = args[i + 1];

      // Handle escape sequences (e.g., exec)
      if (escapeSequences.includes(key)) {
        let parts = [];
        i++;
        while (i < args.length && !escapeTerminator.includes(args[i])) {
          parts.push(args[i]);
          i++;
        }
        result[key] = parts.join(" ");
        i++; // skip the terminating ; or \\;
        continue;
      }

      // -key <value>
      if (next && !next.startsWith("-")) {
        result[key] = parseValue(next);
        i += 2;
      } else {
        result[key] = true; // treat as boolean flag
        i++;
      }
      continue;
    }

    // fallback positional (not path, not a flag)
    i++;
  }
  return result;
}

// Main execution
if (rawArgs.length === 0) {
  printHelp();
  process.exit(1);
}

const result = parseArgs(rawArgs);

if (!result.command) {
  console.error("Error: No command provided.");
  printHelp();
  process.exit(1);
}

console.log(JSON.stringify(result, null, 2));
````
