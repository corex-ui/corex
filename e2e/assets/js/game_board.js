import {animate, stagger} from "motion"
import * as Tetrex from "./tetrex_engine.js"

const KEY_COMMANDS = {
  ArrowLeft: "left",
  ArrowRight: "right",
  ArrowDown: "down",
  " ": "rotate"
}

const TILE_CLASS =
  "checkbox w-full h-full min-h-0"
const PREVIEW_TILE =
  "checkbox w-full aspect-square min-w-0 pointer-events-none"
const DEFAULT_REPLAY_STEP_MS = 280
const REPLAY_SPEEDS = [2, 5, 10, 1]
const CLEAR_ANIM_MS = 420

const reducedMotion = () =>
  window.matchMedia("(prefers-reduced-motion: reduce)").matches

function resetTileMotion(el) {
  if (!el) return
  for (const prop of ["transform", "opacity", "rotate", "filter"]) {
    el.style.removeProperty(prop)
  }
}

const GameBoard = {
  mounted() {
    this.tickTimer = null
    this.replayTimer = null
    this.paused = true
    this.clearing = false
    this.mode = this.el.dataset.mode || "play"
    this.play = this.mode === "play"
    this.replay = this.mode === "replay"
    this.watch = this.mode === "watch"
    this.tickMs = parseInt(this.el.dataset.tickMs || "700", 10)
    this.boardEl = document.getElementById("tetrex-board")
    this.replayFrames = []
    this.replayIndex = 0
    this.replayBaseStepMs = DEFAULT_REPLAY_STEP_MS
    this.replaySpeedIdx = 0
    this.replayPlaying = false
    this.serverPaintedBoard = false
    this.boardRevealed = false

    this.handleEvent("game_apply", ({cells}) => {
      this.applyCells(cells)
    })

    this.handleEvent("game_start", () => {
      if (!this.play || !this.engine) return
      this.paused = false
      this.syncTickInterval()
      this.startTick()
    })

    this.handleEvent("replay_init", ({frames, step_ms}) => {
      if (!this.replay || !frames?.length) return
      this.replayFrames = frames
      this.replayBaseStepMs = step_ms || DEFAULT_REPLAY_STEP_MS
      this.replaySpeedIdx = 0
      this.replayIndex = 0
      this.syncReplayHudFromFrame(0)
      this.wireReplayControls()
      this.wireReplayEndOverlay()
      this.updateReplaySpeedLabel()
      requestAnimationFrame(() => this.replayPlay())
    })

    if (this.play) {
      this.onKeyDown = (event) => this.handleKeyDown(event)
      window.addEventListener("keydown", this.onKeyDown)
      this.initPlayEngineIfReady()
    }

    if (this.replay) {
      this.wireReplayControls()
      this.wireReplayEndOverlay()
    }

    this.prepareInitialBoardReveal()
  },

  updated() {
    if (this.play) this.initPlayEngineIfReady()
  },

  prepareInitialBoardReveal() {
    const board = document.getElementById("tetrex-board")
    if (!board || this.boardRevealed) return

    if (this.replay || (this.play && this.el.dataset.boardReady === "true")) {
      this.serverPaintedBoard = true
    }

    board.classList.add("opacity-0")

    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        board.classList.remove("opacity-0")
        this.boardRevealed = true
      })
    })
  },

  initPlayEngineIfReady() {
    if (this.engine || this.el.dataset.boardReady === "false") return

    const raw = this.el.dataset.client
    if (!raw) return

    try {
      this.engine = Tetrex.fromClient(JSON.parse(raw))
      this.paused = true
      this.syncTickInterval()
      this.updatePreview(this.engine.next_type)
      this.updateHud()
    } catch (_e) {
      this.engine = null
    }
  },

  destroyed() {
    if (this.tickTimer) clearInterval(this.tickTimer)
    if (this.replayTimer) clearInterval(this.replayTimer)
    if (this.onKeyDown) window.removeEventListener("keydown", this.onKeyDown)
    this.teardownReplayControls()
    this.teardownReplayEndOverlay()
  },

  wireReplayControls() {
    const root = document.getElementById("tetrex-replay-controls")
    if (!root || root.dataset.wired === "true") return
    root.dataset.wired = "true"

    const playToggle = document.getElementById("tetrex-replay-play")

    this.onReplayPlayChanged = (event) => {
      const pressed = event.detail?.pressed === true || event.detail?.pressed === "true"
      if (pressed) this.replayPlay()
      else this.replayPause()
    }

    if (playToggle) {
      playToggle.addEventListener("tetrex-replay-play-changed", this.onReplayPlayChanged)
      this.replayPlayToggle = playToggle
    }

    this.onReplayControl = (event) => {
      const action = event.target.closest("[data-replay-action]")?.dataset?.replayAction
      if (!action) return
      event.preventDefault()

      if (action === "restart") {
        this.hideReplayEndOverlay()
        this.replayRestart()
      } else if (action === "speed") {
        this.replayCycleSpeed()
      }
    }

    root.addEventListener("click", this.onReplayControl)
    this.replayControlsRoot = root
  },

  wireReplayEndOverlay() {
    const overlay = document.getElementById("tetrex-replay-end-overlay")
    if (!overlay || overlay.dataset.wired === "true") return
    overlay.dataset.wired = "true"

    this.onReplayEndControl = (event) => {
      const action = event.target.closest("[data-replay-action]")?.dataset?.replayAction
      if (action !== "watch-again") return
      event.preventDefault()
      this.hideReplayEndOverlay()
      this.replayRestart()
      this.replayPlay()
    }

    overlay.addEventListener("click", this.onReplayEndControl)
    this.replayEndOverlay = overlay
  },

  teardownReplayEndOverlay() {
    if (this.replayEndOverlay && this.onReplayEndControl) {
      this.replayEndOverlay.removeEventListener("click", this.onReplayEndControl)
    }
  },

  showReplayEndOverlay() {
    const overlay =
      this.replayEndOverlay || document.getElementById("tetrex-replay-end-overlay")
    if (!overlay) return
    overlay.classList.remove("hidden")
    overlay.setAttribute("aria-hidden", "false")
  },

  hideReplayEndOverlay() {
    const overlay =
      this.replayEndOverlay || document.getElementById("tetrex-replay-end-overlay")
    if (!overlay) return
    overlay.classList.add("hidden")
    overlay.setAttribute("aria-hidden", "true")
  },

  teardownReplayControls() {
    if (this.replayPlayToggle && this.onReplayPlayChanged) {
      this.replayPlayToggle.removeEventListener(
        "tetrex-replay-play-changed",
        this.onReplayPlayChanged
      )
    }

    if (this.replayControlsRoot && this.onReplayControl) {
      this.replayControlsRoot.removeEventListener("click", this.onReplayControl)
    }
  },

  syncReplayPlayToggle(playing) {
    const toggle = this.replayPlayToggle || document.getElementById("tetrex-replay-play")
    if (!toggle) return

    toggle.dispatchEvent(
      new CustomEvent("corex:toggle:set-pressed", {
        detail: { pressed: !!playing },
        bubbles: true
      })
    )
  },

  replayIntervalMs() {
    const speed = REPLAY_SPEEDS[this.replaySpeedIdx] || 1
    return Math.max(16, Math.round(this.replayBaseStepMs / speed))
  },

  startReplayTimer() {
    if (this.replayTimer) clearInterval(this.replayTimer)

    this.replayTimer = setInterval(() => {
      if (this.clearing) return

      if (this.replayIndex >= this.replayFrames.length - 1) {
        this.replayPause()
        this.showReplayEndOverlay()
        return
      }

      void this.advanceReplayToFrame(this.replayIndex + 1).then((shown) => {
        if (typeof shown === "number") this.replayIndex = shown
      })
    }, this.replayIntervalMs())
  },

  replayPlay() {
    if (!this.replayFrames.length) return
    if (this.replayPlaying && this.replayTimer) return

    this.hideReplayEndOverlay()
    this.replayPlaying = true
    this.syncReplayPlayToggle(true)

    if (this.replayIndex >= this.replayFrames.length - 1) {
      this.replayIndex = 0
      this.advanceReplayToFrame(0)
    }

    this.startReplayTimer()
  },

  replayCycleSpeed() {
    this.replaySpeedIdx = (this.replaySpeedIdx + 1) % REPLAY_SPEEDS.length
    this.updateReplaySpeedLabel()

    if (this.replayPlaying) {
      this.startReplayTimer()
    }
  },

  updateReplaySpeedLabel() {
    const btn = document.getElementById("tetrex-replay-speed")
    if (!btn) return
    const speed = REPLAY_SPEEDS[this.replaySpeedIdx] || 1
    btn.textContent = `×${speed}`
  },

  replayPause() {
    this.replayPlaying = false
    this.syncReplayPlayToggle(false)

    if (this.replayTimer) {
      clearInterval(this.replayTimer)
      this.replayTimer = null
    }
  },

  replayRestart() {
    this.replayPause()
    this.replayIndex = 0
    this.serverPaintedBoard = false
    this.advanceReplayToFrame(0)
  },

  syncReplayHudFromFrame(index) {
    const frame = this.replayFrames[index]
    if (!frame) return

    const engine = Tetrex.fromClient(frame)
    this.updateHudFromEngine(engine)
    this.updatePreview(engine.next_type)
  },

  showReplayFrameImmediate(index, engine) {
    const frame = this.replayFrames[index]
    if (!frame && !engine) return

    const state = engine || Tetrex.fromClient(frame)

    if (index === 0 && this.serverPaintedBoard) {
      this.serverPaintedBoard = false
      this.updateHudFromEngine(state)
      this.updatePreview(state.next_type)
      return
    }

    this.applyCells(Tetrex.cellsForRender(state))
    this.updateHudFromEngine(state)
    this.updatePreview(state.next_type)
  },

  async advanceReplayToFrame(index) {
    if (this.clearing) return this.replayIndex

    const frame = this.replayFrames[index]
    if (!frame) return this.replayIndex

    let engine = Tetrex.fromClient(frame)

    if (Tetrex.isClearLocked(engine)) {
      this.clearing = true

      try {
        this.showReplayFrameImmediate(index, engine)
        await this.animateLineClear(engine.pending_clear)
        const nextFrame = this.replayFrames[index + 1]

        if (nextFrame) {
          this.showReplayFrameImmediate(index + 1)
          return index + 1
        }

        this.showReplayFrameImmediate(index, Tetrex.commitClear(engine))
        return index
      } finally {
        this.clearing = false
      }
    }

    if (index > 0) {
      const rows = Tetrex.linesClearedBetween(
        this.replayFrames[index - 1],
        frame
      )

      if (rows.length) {
        this.clearing = true

        try {
          this.showReplayFrameImmediate(index - 1)
          await this.animateLineClear(rows)
        } finally {
          this.clearing = false
        }
      }
    }

    this.showReplayFrameImmediate(index, engine)
    return index
  },

  updatePreview(nextType) {
    const root = document.getElementById("tetrex-next")
    if (!root) return

    const cells = Tetrex.previewCells(nextType)

    for (const cell of cells) {
      const tile = root.querySelector(`[data-preview="${cell.col}-${cell.row}"]`)
      if (!tile) continue

      const mod = cell.theme ? ` checkbox--${cell.theme}` : ""
      tile.className = PREVIEW_TILE + mod

      const control = tile.querySelector('[data-part="control"]')
      if (control) {
        control.setAttribute("data-state", cell.filled ? "checked" : "unchecked")
      }
    }
  },

  updateHudFromEngine(engine) {
    if (!engine) return
    this.updateScoreDisplay(engine.score)
    this.updateLevelDisplay(engine.level || Tetrex.levelForLines(engine.lines || 0))
    this.updateLinesDisplay(engine.lines || 0)
  },

  updateHud() {
    this.updateHudFromEngine(this.engine)
  },

  updateScoreDisplay(score) {
    const el = document.getElementById("tetrex-score")
    if (!el) return
    el.textContent = String(score).padStart(6, "0")
  },

  updateLevelDisplay(level) {
    const el = document.getElementById("tetrex-level")
    if (!el) return
    el.textContent = String(level)
  },

  updateLinesDisplay(lines) {
    const el = document.getElementById("tetrex-lines")
    if (!el) return
    el.textContent = String(lines)
  },

  syncTickInterval() {
    if (!this.engine) return
    const level = this.engine.level || Tetrex.levelForLines(this.engine.lines || 0)
    this.tickMs = Tetrex.tickMsForLevel(level)
  },

  restartTick() {
    if (!this.play || this.paused || this.engine?.status !== "playing") return
    if (this.clearing || Tetrex.isClearLocked(this.engine)) return

    this.syncTickInterval()
    this.startTick()
  },

  startTick() {
    if (this.tickTimer) clearInterval(this.tickTimer)

    this.tickTimer = setInterval(() => {
      if (!this.engine || this.paused || this.clearing || this.engine.status !== "playing") return
      if (Tetrex.isClearLocked(this.engine)) return

      const prevLevel = this.engine.level
      this.engine = Tetrex.tick(this.engine)
      this.afterChange(prevLevel)
    }, this.tickMs)
  },

  handleKeyDown(event) {
    if (!this.engine || this.paused || this.clearing || this.engine.status !== "playing") return
    if (Tetrex.isClearLocked(this.engine)) return

    const cmd = KEY_COMMANDS[event.key]
    if (!cmd) return

    event.preventDefault()
    this.runCommand(cmd)
  },

  runCommand(cmd) {
    const prevLevel = this.engine?.level
    this.engine = Tetrex.command(this.engine, cmd)
    this.afterChange(prevLevel)
  },

  afterChange(prevLevel) {
    if (!this.engine) return

    if (Tetrex.isClearLocked(this.engine)) {
      this.applyCells(Tetrex.cellsForRender(this.engine))
      this.updateHud()
      this.pushSync()
      this.runLineClearEffect()
      return
    }

    const level = this.engine.level || Tetrex.levelForLines(this.engine.lines || 0)

    if (prevLevel != null && level > prevLevel) {
      this.syncTickInterval()
      this.restartTick()
    }

    this.applyCells(Tetrex.cellsForRender(this.engine))
    this.updatePreview(this.engine.next_type)
    this.updateHud()
    this.pushSync()

    if (this.engine?.status === "game_over" && this.tickTimer) {
      clearInterval(this.tickTimer)
      this.tickTimer = null
      return
    }

    if (
      this.play &&
      !this.paused &&
      !this.clearing &&
      !Tetrex.isClearLocked(this.engine) &&
      !this.tickTimer
    ) {
      this.restartTick()
    }
  },

  async animateLineClear(rows) {
    if (!rows?.length) return

    const tiles = []

    for (const row of rows) {
      for (let col = 0; col < Tetrex.cols(); col++) {
        const root = document.getElementById(Tetrex.cellId(col, row))
        if (root) tiles.push(root)
      }
    }

    if (!reducedMotion() && tiles.length > 0) {
      try {
        await animate(
          tiles,
          {scale: [1, 1.12, 0], opacity: [1, 1, 0]},
          {
            duration: CLEAR_ANIM_MS / 1000,
            delay: stagger(0.022),
            easing: [0.4, 0, 0.85, 0.5]
          }
        )
      } finally {
        tiles.forEach(resetTileMotion)
      }
    } else {
      await new Promise((resolve) => setTimeout(resolve, CLEAR_ANIM_MS))
    }
  },

  async runLineClearEffect() {
    if (this.clearing || !Tetrex.isClearLocked(this.engine)) return

    this.clearing = true
    if (this.tickTimer) {
      clearInterval(this.tickTimer)
      this.tickTimer = null
    }

    await this.animateLineClear(this.engine.pending_clear || [])

    const prevLevel = this.engine.level
    this.engine = Tetrex.commitClear(this.engine)
    this.clearing = false
    this.afterChange(prevLevel)
    this.restartTick()
  },

  pushSync() {
    if (!this.engine) return
    this.pushEvent("sync", {game: Tetrex.toClient(this.engine)})
  },

  applyCells(cells) {
    if (!cells || cells.length === 0) return
    this.serverPaintedBoard = false

    for (const cell of cells) {
      this.applyCell(cell)
    }
  },

  applyCell({id, checked, theme}) {
    const root = document.getElementById(id)
    if (!root) return

    const mod = theme ? ` checkbox--${theme}` : ""
    const nextClass = TILE_CLASS + mod
    const control = document.getElementById(`checkbox:${id}:control`)
    const wasChecked = control?.getAttribute("data-state") === "checked"
    const nextChecked = !!checked

    if (wasChecked === nextChecked && root.className === nextClass) return

    resetTileMotion(root)
    root.className = nextClass

    root.dispatchEvent(
      new CustomEvent("corex:checkbox:set-checked", {
        bubbles: false,
        detail: {checked: nextChecked}
      })
    )

    if (control) {
      control.setAttribute("data-state", nextChecked ? "checked" : "unchecked")
    }
  }
}

export default GameBoard
