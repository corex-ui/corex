import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'url';

export const SingleToMulti = async () => {
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const tokensBasePath = path.resolve(__dirname, "./");
  const single_token = path.resolve(tokensBasePath, 'tokens/tokens.json');
  const multi_token_path = path.resolve(tokensBasePath, 'tokens/multi');
  
  try {
    const tokens = JSON.parse(await fs.promises.readFile(single_token, 'utf8'));
    const metadata = tokens.$metadata || {};
    const themes = tokens.$themes || {};
    delete tokens.$metadata;
    delete tokens.$themes;
    
    const writeTokensToFile = async (filePath, tokenData) => {
      const dirName = path.dirname(filePath);
      await fs.promises.mkdir(dirName, { recursive: true });
      await fs.promises.writeFile(filePath, JSON.stringify(tokenData, null, 2), 'utf8');
      console.log(`✔︎ ${path.relative(process.cwd(), filePath)}`);
    };
    
    await writeTokensToFile(path.join(multi_token_path, '$metadata.json'), metadata);
    await writeTokensToFile(path.join(multi_token_path, '$themes.json'), themes);
    
    if (metadata.tokenSetOrder) {
      for (const tokenSet of metadata.tokenSetOrder) {
        if (tokens[tokenSet]) {
          const targetPath = path.join(multi_token_path, ...tokenSet.split('/')) + '.json';
          await writeTokensToFile(targetPath, tokens[tokenSet]);
        }
      }
    }
    
    console.log('✅ Tokens transformed successfully');
    return { success: true };
  } catch (error) {
    console.error('❌ Token transformation failed:', error.message);
    return { success: false, error };
  }
};

