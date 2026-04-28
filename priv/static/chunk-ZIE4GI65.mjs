// lib/event-details.ts
function diffStringValues(next, previous) {
  const added = next.filter((v) => !previous.includes(v));
  const removed = previous.filter((v) => !next.includes(v));
  return { added, removed };
}

export {
  diffStringValues
};
