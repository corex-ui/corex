#!/usr/bin/env node
import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..", "..");
const PACKAGE_JSON = resolve(ROOT, "package.json");
const LOCKFILE = resolve(ROOT, "pnpm-lock.yaml");
const SCOPE = "@zag-js/";
const DEP_FIELDS = ["dependencies", "devDependencies"];

function loadPackage() {
  return JSON.parse(readFileSync(PACKAGE_JSON, "utf8"));
}

function zagEntries(pkg) {
  const entries = [];
  for (const field of DEP_FIELDS) {
    const deps = pkg[field];
    if (!deps) continue;
    for (const [name, version] of Object.entries(deps)) {
      if (name.startsWith(SCOPE)) entries.push({ field, name, version });
    }
  }
  return entries;
}

function uniqueVersions(values) {
  return [...new Set(values)];
}

function lockfileZagVersions() {
  const source = readFileSync(LOCKFILE, "utf8");
  const versions = [];
  const re = /^ {2}'@zag-js\/[^@']+@([^'(]+)/gm;
  let match;
  while ((match = re.exec(source)) !== null) {
    versions.push(match[1]);
  }
  return versions;
}

function fail(message) {
  console.error(message);
  process.exit(1);
}

function check() {
  const entries = zagEntries(loadPackage());
  if (entries.length === 0) {
    fail(`No ${SCOPE}* packages found in package.json`);
  }

  const manifestVersions = uniqueVersions(entries.map((entry) => entry.version));
  if (manifestVersions.length !== 1) {
    const listed = entries.map((entry) => `  ${entry.name}: ${entry.version}`).join("\n");
    fail(
      `${SCOPE}* packages must share one version (mixed copies break VanillaMachine typing).\n${listed}`
    );
  }

  const locked = uniqueVersions(lockfileZagVersions());
  if (locked.length === 0) {
    fail(`No ${SCOPE}* packages found in pnpm-lock.yaml`);
  }
  if (locked.length !== 1) {
    fail(
      `pnpm-lock.yaml has mixed ${SCOPE}* versions: ${locked.join(", ")}. ` +
        `Update every @zag-js package together (pnpm run update:zag).`
    );
  }

  const manifestVersion = manifestVersions[0].replace(/^[~^]/, "");
  if (locked[0] !== manifestVersion) {
    fail(
      `package.json pins ${SCOPE}* at ${manifestVersions[0]} but pnpm-lock.yaml resolved ${locked[0]}.`
    );
  }

  console.log(`All ${entries.length} ${SCOPE}* packages are at ${manifestVersions[0]}`);
}

function latestZagVersion() {
  const version = execFileSync("npm", ["view", "@zag-js/core", "version"], {
    encoding: "utf8",
    cwd: ROOT,
  }).trim();
  if (!/^\d+\.\d+\.\d+$/.test(version)) {
    fail(`Unexpected @zag-js/core version from npm: ${version}`);
  }
  return version;
}

function update() {
  const pkg = loadPackage();
  const entries = zagEntries(pkg);
  if (entries.length === 0) {
    fail(`No ${SCOPE}* packages found in package.json`);
  }

  const version = latestZagVersion();
  const specifier = `^${version}`;
  for (const entry of entries) {
    pkg[entry.field][entry.name] = specifier;
  }
  writeFileSync(PACKAGE_JSON, `${JSON.stringify(pkg, null, 2)}\n`);
  console.log(`Set ${entries.length} ${SCOPE}* packages to ${specifier}`);

  execFileSync("pnpm", ["install"], { stdio: "inherit", cwd: ROOT });
  check();
  console.log("Run `mix assets.build` to refresh priv/static bundles.");
}

function main() {
  const mode = process.argv[2] ?? "--check";
  if (mode === "--check") {
    check();
    return;
  }
  if (mode === "--update") {
    update();
    return;
  }
  fail(`Unknown mode ${mode}. Use --check or --update.`);
}

main();
