import {
  isEqual
} from "./chunk-EWT2BP2N.mjs";

// ../node_modules/.pnpm/@zag-js+core@1.40.0/node_modules/@zag-js/core/dist/memo.mjs
function memo(getDeps, fn, opts) {
  let deps = [];
  let result;
  return (depArgs) => {
    const newDeps = getDeps(depArgs);
    const depsChanged = newDeps.length !== deps.length || newDeps.some((dep, index) => !isEqual(deps[index], dep));
    if (!depsChanged) return result;
    deps = newDeps;
    result = fn(newDeps, depArgs);
    opts?.onChange?.(result);
    return result;
  };
}

export {
  memo
};
