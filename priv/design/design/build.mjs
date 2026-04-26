import StyleDictionary from 'style-dictionary';
import { register } from '@tokens-studio/sd-transforms';

import path from 'node:path';
import fs from 'node:fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const tokensBasePath = path.resolve(__dirname, "./");
const outputBasePath = path.resolve(tokensBasePath, '..', 'tokens');
const buildPath = outputBasePath + path.sep;

const semanticReferenceTheme = "neo";

function themeSources(theme, mode) {
  const base = `${tokensBasePath}/tokens/themes/${theme}`;
  return [
    `${base}/border.json`,
    `${base}/dimension.json`,
    `${base}/text.json`,
    `${base}/font.json`,
    `${base}/color/${mode}.json`
  ];
}

function themeStaticJsonPaths(theme) {
  const base = `${tokensBasePath}/tokens/themes/${theme}`;
  return [
    `${base}/border.json`,
    `${base}/dimension.json`,
    `${base}/text.json`,
    `${base}/font.json`
  ];
}

function themeStaticSuffixes(theme) {
  return [
    `themes/${theme}/border.json`,
    `themes/${theme}/dimension.json`,
    `themes/${theme}/text.json`,
    `themes/${theme}/font.json`
  ];
}

function rmCssRecursive(dir) {
  if (!fs.existsSync(dir)) return;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) rmCssRecursive(full);
    else if (entry.name.endsWith('.css')) fs.rmSync(full, { force: true });
  }
}

function cleanBuildPath() {
  fs.mkdirSync(buildPath, { recursive: true });

  const themesDir = path.resolve(buildPath, 'themes');
  rmCssRecursive(themesDir);

  const semanticDir = path.resolve(buildPath, 'semantic');
  if (fs.existsSync(semanticDir)) {
    for (const entry of fs.readdirSync(semanticDir)) {
      if (!entry.endsWith('.css')) continue;
      fs.rmSync(path.resolve(semanticDir, entry), { force: true });
    }
  }
}

function getTokenSets() {
  const metadataPath = path.resolve(tokensBasePath, 'tokens/$metadata.json');
  return JSON.parse(fs.readFileSync(metadataPath, 'utf-8')).tokenSetOrder;
}

function registerTransforms() {
  register(StyleDictionary, {
    excludeParentKeys: false,
    platform: "css",
    'ts/color/modifiers': { format: 'hex' }
  });
  
  StyleDictionary.registerTransform({
    type: 'name',
    transitive: true,
    name: 'name/kebab-no-default',
    transform: (token, config) => {
      const transformedName = token.path
        .map(part => part.replace(/([a-z0-9])([A-Z])/g, '$1-$2')
          .replace(/([A-Z])([A-Z][a-z])/g, '$1-$2').toLowerCase())
        .join('-')
        .replace(/-default$/, '');
      return config.prefix ? `${config.prefix}--${transformedName}` : transformedName;
    }
  });
}

async function semantic() {
  const sets = getTokenSets().filter(set => set.startsWith("semantic/"));
  const promises = sets.map(set => {
    const colorFilter = token => token.filePath.endsWith(`${set}.json`)
    const baseFile = {
      destination: `${set}.css`,
      format: 'css/variables',
      options: {
        selector: `@theme inline`,
        outputReferences: true
      },
      filter: colorFilter
    }
    const files =
      set === "semantic/color"
        ? [
            baseFile,
            {
              destination: `${set}-scope.css`,
              format: 'css/variables',
              options: {
                selector: `[data-theme][data-mode]`,
                outputReferences: true
              },
              filter: colorFilter
            }
          ]
        : [baseFile]
    const sd = new StyleDictionary({
      source: [
        `${tokensBasePath}/tokens/semantic/*.json`,
        ...themeSources(semanticReferenceTheme, "light")
      ],
      preprocessors: ['tokens-studio'],
      platforms: {
        css: {
          transforms: [
            'attribute/cti',
            'name/kebab-no-default',
            'fontFamily/css',
            'shadow/css/shorthand',
            'cubicBezier/css',
            'ts/descriptionToComment',
            'ts/resolveMath',
            'ts/opacity',
            'ts/size/lineheight',
            'ts/typography/fontWeight',
            'ts/color/modifiers',
            'ts/size/css/letterspacing',
            'ts/shadow/innerShadow'
          ],
          buildPath,
          files
        }
      },
      log: { verbosity: 'verbose' }
    });
    return sd.buildPlatform('css');
  });
  return Promise.all(promises);
}

const themeTransforms = [
  'attribute/cti',
  'name/kebab-no-default',
  'fontFamily/css',
  'shadow/css/shorthand',
  'cubicBezier/css',
  'ts/descriptionToComment',
  'ts/resolveMath',
  'ts/opacity',
  'ts/size/lineheight',
  'ts/typography/fontWeight',
  'ts/color/modifiers',
  'ts/size/css/letterspacing',
  'ts/shadow/innerShadow'
];

async function themeStatic(theme) {
  const suffixes = themeStaticSuffixes(theme);
  const sd = new StyleDictionary({
    source: themeStaticJsonPaths(theme),
    preprocessors: ['tokens-studio'],
    platforms: {
      css: {
        transforms: themeTransforms,
        buildPath,
        files: suffixes.map(suffix => {
          const name = path.basename(suffix, '.json');
          return {
            destination: `themes/${theme}/${name}.css`,
            format: 'css/variables',
            options: {
              selector: `[data-theme="${theme}"]`,
              outputReferences: true
            },
            filter: token => token.filePath.endsWith(suffix)
          };
        })
      }
    },
    log: { verbosity: 'verbose' }
  });
  return sd.buildPlatform('css');
}

async function themeColor(theme, mode) {
  const base = `${tokensBasePath}/tokens/themes/${theme}`;
  const colorPath = `${base}/color/${mode}.json`;
  const suffix = `themes/${theme}/color/${mode}.json`;
  const sd = new StyleDictionary({
    source: [colorPath],
    preprocessors: ['tokens-studio'],
    platforms: {
      css: {
        transforms: themeTransforms,
        buildPath,
        files: [{
          destination: `themes/${theme}/color/${mode}.css`,
          format: 'css/variables',
          options: {
            selector: `[data-theme="${theme}"][data-mode="${mode}"]`,
            outputReferences: true
          },
          filter: token => token.filePath.endsWith(suffix)
        }]
      }
    },
    log: { verbosity: 'verbose' }
  });
  return sd.buildPlatform('css');
}

async function theme() {
  const themes = ["neo", "uno", "duo", "leo"];
  const modes = ["light", "dark"];
  const staticBuilds = themes.map(theme => themeStatic(theme));
  const colorBuilds = themes.flatMap(theme =>
    modes.map(mode => themeColor(theme, mode))
  );
  return Promise.all([...staticBuilds, ...colorBuilds]);
}

async function build() {
  try {    
    cleanBuildPath();
    registerTransforms();
    
    const promises = [
      semantic(),
      theme(),
    ];
    
    await Promise.all(promises);
  } catch (error) {
    console.error('\n❌ Build failed:', error);
    process.exit(1);
  }
}

build();