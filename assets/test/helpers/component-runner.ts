export function runInitDestroy(run: () => { init: () => void; destroy: () => void }): void {
  const inst = run();
  inst.init();
  inst.destroy();
}

export function runRenderDestroy(run: () => { render: () => void; destroy: () => void }): void {
  const inst = run();
  inst.render();
  inst.destroy();
}
