import StyleDictionary from 'style-dictionary';
import { register } from '@tokens-studio/sd-transforms';

import path from 'node:path';
import fs from 'node:fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const tokensBasePath = path.resolve(__dirname, "./");
const buildPath = 'tokens/';

function cleanBuildPath() {
  if (fs.existsSync(buildPath)) {
    fs.rmSync(buildPath, { recursive: true, force: true });
  }
  fs.mkdirSync(buildPath, { recursive: true });
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
    const sd = new StyleDictionary({
      source: [
        `${tokensBasePath}/tokens/semantic/*.json`,
        `${tokensBasePath}/tokens/themes/neo/light.json`
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
          files: [{
            destination: `${set}.css`,
            format: 'css/variables',
            options: {
              selector: `@theme inline`,
              outputReferences: true
            },
            filter: token => token.filePath.endsWith(`${set}.json`)
          }]
        }
      },
      log: { verbosity: 'default' }
    });
    return sd.buildPlatform('css');
  });
  return Promise.all(promises);
}

async function theme() {
  const themes = ["neo", "uno", "duo", "leo"];
  const modes = ["light", "dark"];
  
  const promises = themes.flatMap(theme =>
    modes.map(mode => {
      const sd = new StyleDictionary({
        source: [`${tokensBasePath}/tokens/themes/${theme}/${mode}.json`],
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
            files: [{
              destination: `themes/${theme}/${mode}.css`,
              format: 'css/variables',
              options: {
                selector: `[data-theme="${theme}"][data-mode="${mode}"]`,
                outputReferences: true
              },
              filter: token => token.filePath.endsWith(`themes/${theme}/${mode}.json`)
            }]
          }
        },
        log: { verbosity: 'default' }
      });
      return sd.buildPlatform('css');
    })
  );
  
  return Promise.all(promises);
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