const COLS = 10
const ROWS = 18
const PIECE_TYPES = ["i", "o", "t", "l"]
const MAX_LEVEL = 29
const BASE_TICK_MS = 700
const MIN_TICK_MS = 90

const SHAPES = {
  i: (rot) =>
    rot % 2 === 0
      ? [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0]
        ]
      : [
          [0, 0],
          [0, 1],
          [0, 2],
          [0, 3]
        ],
  o: () => [
    [0, 0],
    [1, 0],
    [0, 1],
    [1, 1]
  ],
  t: (rot) =>
    [
      [
        [0, 0],
        [1, 0],
        [2, 0],
        [1, 1]
      ],
      [
        [1, 0],
        [0, 1],
        [1, 1],
        [1, 2]
      ],
      [
        [0, 1],
        [1, 1],
        [2, 1],
        [1, 0]
      ],
      [
        [1, 0],
        [1, 1],
        [2, 1],
        [1, 2]
      ]
    ][rot],
  l: (rot) =>
    [
      [
        [0, 0],
        [0, 1],
        [0, 2],
        [1, 2]
      ],
      [
        [0, 0],
        [1, 0],
        [2, 0],
        [0, 1]
      ],
      [
        [1, 0],
        [1, 1],
        [1, 2],
        [0, 0]
      ],
      [
        [2, 0],
        [0, 1],
        [1, 1],
        [2, 1]
      ]
    ][rot]
}

const LINE_SCORE = {1: 40, 2: 100, 3: 300, 4: 1200}

export function cols() {
  return COLS
}

export function rows() {
  return ROWS
}

export function cellId(col, row) {
  return `game-${col}-${row}`
}

export function themeForType(type) {
  return {i: "accent", o: "brand", t: "alert", l: "success"}[type]
}

export function levelForLines(lines) {
  return Math.min(MAX_LEVEL, Math.floor((lines || 0) / 10) + 1)
}

export function tickMsForLevel(level) {
  const lv = Math.max(1, level || 1)
  return Math.max(MIN_TICK_MS, Math.round(BASE_TICK_MS * Math.pow(0.88, lv - 1)))
}

export function scoreForClears(count, level) {
  const base = LINE_SCORE[count] || count * 40
  return base * Math.max(1, level || 1)
}

export function isClearLocked(game) {
  return Array.isArray(game?.pending_clear) && game.pending_clear.length > 0
}

function mergedBoard(game) {
  if (!game.piece) return game.board
  return mergePiece(game.board, game.piece)
}

export function fullRowsInGame(game) {
  return findFullRows(mergedBoard(game))
}

export function linesClearedBetween(prevFrame, nextFrame) {
  const prev = fromClient(prevFrame)
  const next = fromClient(nextFrame)

  if (isClearLocked(prev)) return []

  const delta = (next.lines || 0) - (prev.lines || 0)
  if (delta <= 0) return []

  const rows = findFullRows(mergedBoard(prev))
  if (rows.length <= delta) return rows

  return rows.slice(-delta)
}

const PREVIEW_COLS = 4
const PREVIEW_ROWS = 4

export function previewCells(type) {
  if (!type || !SHAPES[type]) {
    return Array.from({length: PREVIEW_ROWS * PREVIEW_COLS}, (_, i) => ({
      col: i % PREVIEW_COLS,
      row: Math.floor(i / PREVIEW_COLS),
      filled: false,
      theme: null
    }))
  }

  const coords = SHAPES[type](0)
  const xs = coords.map(([x]) => x)
  const ys = coords.map(([, y]) => y)
  const minX = Math.min(...xs)
  const maxX = Math.max(...xs)
  const minY = Math.min(...ys)
  const maxY = Math.max(...ys)
  const w = maxX - minX + 1
  const h = maxY - minY + 1
  const padX = Math.floor((PREVIEW_COLS - w) / 2) - minX
  const padY = Math.floor((PREVIEW_ROWS - h) / 2) - minY
  const theme = themeForType(type)
  const set = new Set(coords.map(([x, y]) => `${x},${y}`))
  const cells = []

  for (let row = 0; row < PREVIEW_ROWS; row++) {
    for (let col = 0; col < PREVIEW_COLS; col++) {
      const filled = set.has(`${col - padX},${row - padY}`)
      cells.push({col, row, filled, theme: filled ? theme : null})
    }
  }

  return cells
}

function emptyBoard() {
  return Array.from({length: ROWS}, () => Array(COLS).fill(null))
}

function randomType() {
  return PIECE_TYPES[Math.floor(Math.random() * PIECE_TYPES.length)]
}

function at(board, x, y) {
  return board[y][x]
}

function putAt(board, x, y, value) {
  const next = board.map((row) => row.slice())
  next[y][x] = value
  return next
}

function inBounds(x, y) {
  return x >= 0 && x < COLS && y >= 0 && y < ROWS
}

function blockCoords(piece) {
  return SHAPES[piece.type](piece.rotation).map(([x, y]) => [piece.x + x, piece.y + y])
}

function valid(board, piece) {
  return blockCoords(piece).every(([x, y]) => inBounds(x, y) && at(board, x, y) === null)
}

function mergePiece(board, piece) {
  return blockCoords(piece).reduce((acc, [x, y]) => {
    if (!inBounds(x, y)) return acc
    return putAt(acc, x, y, {theme: themeForType(piece.type)})
  }, board)
}

function findFullRows(board) {
  const rows = []

  for (let y = 0; y < ROWS; y++) {
    if (board[y].every((cell) => cell !== null)) rows.push(y)
  }

  return rows
}

function clearLinesForRows(board, rows) {
  if (!rows.length) return {board, cleared: 0}

  const rowSet = new Set(rows)
  const incomplete = board.filter((_, y) => !rowSet.has(y))
  const cleared = rows.length
  const emptyRows = Array.from({length: cleared}, () => Array(COLS).fill(null))

  return {board: [...emptyRows, ...incomplete], cleared}
}

function spawnPiece(game, type) {
  const piece = {type, rotation: 0, x: 3, y: 0}

  if (valid(game.board, piece)) {
    return {...game, piece, next_type: randomType()}
  }

  return {...game, piece: null, status: "game_over"}
}

function lockPiece(game) {
  const board = mergePiece(game.board, game.piece)
  const fullRows = findFullRows(board)

  if (fullRows.length > 0) {
    return {
      ...game,
      board,
      piece: null,
      pending_clear: [...fullRows].sort((a, b) => a - b)
    }
  }

  return spawnPiece({...game, board, piece: null}, game.next_type)
}

export function commitClear(game) {
  if (!isClearLocked(game)) return game

  const {board, cleared} = clearLinesForRows(game.board, game.pending_clear)
  const lines = (game.lines || 0) + cleared
  const level = levelForLines(lines)
  const score = game.score + scoreForClears(cleared, level)

  return spawnPiece(
    {
      ...game,
      board,
      pending_clear: null,
      lines,
      level,
      score
    },
    game.next_type
  )
}

function tryMove(game, dx, dy) {
  if (!game.piece) return {ok: true, game}

  const moved = {...game.piece, x: game.piece.x + dx, y: game.piece.y + dy}

  if (valid(game.board, moved)) {
    return {ok: true, game: {...game, piece: moved}}
  }

  return {ok: false, game}
}

export function newGame() {
  const next = randomType()

  return spawnPiece(
    {
      board: emptyBoard(),
      piece: null,
      next_type: randomType(),
      status: "playing",
      score: 0,
      lines: 0,
      level: 1,
      pending_clear: null
    },
    next
  )
}

export function command(game, cmd) {
  if (game.status !== "playing" || isClearLocked(game)) return game

  switch (cmd) {
    case "left":
      return tryMove(game, -1, 0).game
    case "right":
      return tryMove(game, 1, 0).game
    case "down": {
      const result = tryMove(game, 0, 1)
      return result.ok ? result.game : lockPiece(game)
    }
    case "rotate": {
      const nextRot = (game.piece.rotation + 1) % 4
      for (const [dx, dy] of [
        [0, 0],
        [-1, 0],
        [1, 0],
        [-2, 0],
        [2, 0],
        [0, -1],
        [0, 1]
      ]) {
        const rotated = {
          ...game.piece,
          rotation: nextRot,
          x: game.piece.x + dx,
          y: game.piece.y + dy
        }
        if (valid(game.board, rotated)) return {...game, piece: rotated}
      }
      return game
    }
    case "hard_drop": {
      let next = game
      while (true) {
        const result = tryMove(next, 0, 1)
        if (result.ok) next = result.game
        else return lockPiece(next)
      }
    }
    default:
      return game
  }
}

export function tick(game) {
  if (game.status !== "playing" || isClearLocked(game)) return game

  const result = tryMove(game, 0, 1)
  return result.ok ? result.game : lockPiece(game)
}

export function cellsForRender(game) {
  const board = mergedBoard(game)
  const clearingRows = new Set(game.pending_clear || [])
  const cells = []

  for (let row = 0; row < ROWS; row++) {
    for (let col = 0; col < COLS; col++) {
      const cell = board[row][col]
      cells.push({
        id: cellId(col, row),
        col,
        row,
        checked: cell !== null,
        theme: cell ? cell.theme : null,
        clearing: clearingRows.has(row)
      })
    }
  }

  return cells
}

export function toClient(game) {
  return {
    board: game.board.map((row) => row.map((cell) => (cell ? {theme: cell.theme} : null))),
    piece: game.piece,
    next_type: game.next_type,
    status: game.status,
    score: game.score,
    lines: game.lines || 0,
    level: game.level || levelForLines(game.lines || 0),
    pending_clear: game.pending_clear || null
  }
}

export function fromClient(data) {
  const lines = data.lines ?? 0

  return {
    board: data.board.map((row) => row.map((cell) => (cell ? {theme: cell.theme} : null))),
    piece: data.piece,
    next_type: data.next_type,
    status: data.status,
    score: data.score,
    lines,
    level: data.level ?? levelForLines(lines),
    pending_clear: data.pending_clear ?? null
  }
}
