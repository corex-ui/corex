import {
  Component,
  VanillaMachine,
  createAnatomy,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  getBoolean,
  getDataUrl,
  getEventTarget,
  getNumber,
  getRelativePoint,
  getString,
  isLeftClick,
  isModifierKey,
  normalizeProps,
  query,
  trackPointerMove
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/perfect-freehand@1.2.3/node_modules/perfect-freehand/dist/esm/index.mjs
var { PI: e } = Math;
var t = e + 1e-4;
var n = 0.5;
var r = [1, 1];
function i(e2, t2, n2, r2 = (e3) => e3) {
  return e2 * r2(0.5 - t2 * (0.5 - n2));
}
var { min: a } = Math;
function o(e2, t2, n2) {
  let r2 = a(1, t2 / n2);
  return a(1, e2 + (a(1, 1 - r2) - e2) * (r2 * 0.275));
}
function s(e2) {
  return [-e2[0], -e2[1]];
}
function c(e2, t2) {
  return [e2[0] + t2[0], e2[1] + t2[1]];
}
function l(e2, t2, n2) {
  return e2[0] = t2[0] + n2[0], e2[1] = t2[1] + n2[1], e2;
}
function u(e2, t2) {
  return [e2[0] - t2[0], e2[1] - t2[1]];
}
function d(e2, t2, n2) {
  return e2[0] = t2[0] - n2[0], e2[1] = t2[1] - n2[1], e2;
}
function f(e2, t2) {
  return [e2[0] * t2, e2[1] * t2];
}
function p(e2, t2, n2) {
  return e2[0] = t2[0] * n2, e2[1] = t2[1] * n2, e2;
}
function m(e2, t2) {
  return [e2[0] / t2, e2[1] / t2];
}
function h(e2) {
  return [e2[1], -e2[0]];
}
function g(e2, t2) {
  let n2 = t2[0];
  return e2[0] = t2[1], e2[1] = -n2, e2;
}
function ee(e2, t2) {
  return e2[0] * t2[0] + e2[1] * t2[1];
}
function _(e2, t2) {
  return e2[0] === t2[0] && e2[1] === t2[1];
}
function v(e2) {
  return Math.hypot(e2[0], e2[1]);
}
function y(e2, t2) {
  let n2 = e2[0] - t2[0], r2 = e2[1] - t2[1];
  return n2 * n2 + r2 * r2;
}
function b(e2) {
  return m(e2, v(e2));
}
function x(e2, t2) {
  return Math.hypot(e2[1] - t2[1], e2[0] - t2[0]);
}
function S(e2, t2, n2) {
  let r2 = Math.sin(n2), i2 = Math.cos(n2), a2 = e2[0] - t2[0], o2 = e2[1] - t2[1], s2 = a2 * i2 - o2 * r2, c2 = a2 * r2 + o2 * i2;
  return [s2 + t2[0], c2 + t2[1]];
}
function C(e2, t2, n2, r2) {
  let i2 = Math.sin(r2), a2 = Math.cos(r2), o2 = t2[0] - n2[0], s2 = t2[1] - n2[1], c2 = o2 * a2 - s2 * i2, l2 = o2 * i2 + s2 * a2;
  return e2[0] = c2 + n2[0], e2[1] = l2 + n2[1], e2;
}
function w(e2, t2, n2) {
  return c(e2, f(u(t2, e2), n2));
}
function te(e2, t2, n2, r2) {
  let i2 = n2[0] - t2[0], a2 = n2[1] - t2[1];
  return e2[0] = t2[0] + i2 * r2, e2[1] = t2[1] + a2 * r2, e2;
}
function T(e2, t2, n2) {
  return c(e2, f(t2, n2));
}
var E = [0, 0];
var D = [0, 0];
var O = [0, 0];
function k(e2, n2) {
  let r2 = T(e2, b(h(u(e2, c(e2, [1, 1])))), -n2), i2 = [], a2 = 1 / 13;
  for (let n3 = a2; n3 <= 1; n3 += a2) i2.push(S(r2, e2, t * 2 * n3));
  return i2;
}
function A(e2, n2, r2) {
  let i2 = [], a2 = 1 / r2;
  for (let r3 = a2; r3 <= 1; r3 += a2) i2.push(S(n2, e2, t * r3));
  return i2;
}
function j(e2, t2, n2) {
  let r2 = u(t2, n2), i2 = f(r2, 0.5), a2 = f(r2, 0.51);
  return [u(e2, i2), u(e2, a2), c(e2, a2), c(e2, i2)];
}
function M(e2, n2, r2, i2) {
  let a2 = [], o2 = T(e2, n2, r2), s2 = 1 / i2;
  for (let n3 = s2; n3 < 1; n3 += s2) a2.push(S(o2, e2, t * 3 * n3));
  return a2;
}
function ne(e2, t2, n2) {
  return [c(e2, f(t2, n2)), c(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2))];
}
function N(e2, t2, n2) {
  return e2 === false || e2 === void 0 ? 0 : e2 === true ? Math.max(t2, n2) : e2;
}
function re(e2, t2, n2) {
  return e2.slice(0, 10).reduce((e3, r2) => {
    let i2 = r2.pressure;
    return t2 && (i2 = o(e3, r2.distance, n2)), (e3 + i2) / 2;
  }, e2[0].pressure);
}
function P(e2, n2 = {}) {
  let { size: r2 = 16, smoothing: a2 = 0.5, thinning: f2 = 0.5, simulatePressure: m2 = true, easing: _2 = (e3) => e3, start: v2 = {}, end: b2 = {}, last: x2 = false } = n2, { cap: S2 = true, easing: w2 = (e3) => e3 * (2 - e3) } = v2, { cap: T2 = true, easing: P2 = (e3) => --e3 * e3 * e3 + 1 } = b2;
  if (e2.length === 0 || r2 <= 0) return [];
  let F2 = e2[e2.length - 1].runningLength, I2 = N(v2.taper, r2, F2), L2 = N(b2.taper, r2, F2), R2 = (r2 * a2) ** 2, z2 = [], B = [], V = re(e2, m2, r2), H = i(r2, f2, e2[e2.length - 1].pressure, _2), U, W = e2[0].vector, G = e2[0].point, K = G, q = G, J = K, Y = false;
  for (let n3 = 0; n3 < e2.length; n3++) {
    let { pressure: a3 } = e2[n3], { point: s2, vector: h2, distance: v3, runningLength: b3 } = e2[n3], x3 = n3 === e2.length - 1;
    if (!x3 && F2 - b3 < 3) continue;
    f2 ? (m2 && (a3 = o(V, v3, r2)), H = i(r2, f2, a3, _2)) : H = r2 / 2, U === void 0 && (U = H);
    let S3 = b3 < I2 ? w2(b3 / I2) : 1, T3 = F2 - b3 < L2 ? P2((F2 - b3) / L2) : 1;
    H = Math.max(0.01, H * Math.min(S3, T3));
    let k2 = (x3 ? e2[n3] : e2[n3 + 1]).vector, A2 = x3 ? 1 : ee(h2, k2), j2 = ee(h2, W) < 0 && !Y, M2 = A2 !== null && A2 < 0;
    if (j2 || M2) {
      g(E, W), p(E, E, H);
      for (let e3 = 0; e3 <= 1; e3 += 0.07692307692307693) d(D, s2, E), C(D, D, s2, t * e3), q = [D[0], D[1]], z2.push(q), l(O, s2, E), C(O, O, s2, t * -e3), J = [O[0], O[1]], B.push(J);
      G = q, K = J, M2 && (Y = true);
      continue;
    }
    if (Y = false, x3) {
      g(E, h2), p(E, E, H), z2.push(u(s2, E)), B.push(c(s2, E));
      continue;
    }
    te(E, k2, h2, A2), g(E, E), p(E, E, H), d(D, s2, E), q = [D[0], D[1]], (n3 <= 1 || y(G, q) > R2) && (z2.push(q), G = q), l(O, s2, E), J = [O[0], O[1]], (n3 <= 1 || y(K, J) > R2) && (B.push(J), K = J), V = a3, W = h2;
  }
  let X = [e2[0].point[0], e2[0].point[1]], Z = e2.length > 1 ? [e2[e2.length - 1].point[0], e2[e2.length - 1].point[1]] : c(e2[0].point, [1, 1]), Q = [], $ = [];
  if (e2.length === 1) {
    if (!(I2 || L2) || x2) return k(X, U || H);
  } else {
    I2 || L2 && e2.length === 1 || (S2 ? Q.push(...A(X, B[0], 13)) : Q.push(...j(X, z2[0], B[0])));
    let t2 = h(s(e2[e2.length - 1].vector));
    L2 || I2 && e2.length === 1 ? $.push(Z) : T2 ? $.push(...M(Z, t2, H, 29)) : $.push(...ne(Z, t2, H));
  }
  return z2.concat($, B.reverse(), Q);
}
var F = [0, 0];
function I(e2) {
  return e2 != null && e2 >= 0;
}
function L(e2, t2 = {}) {
  let { streamline: i2 = 0.5, size: a2 = 16, last: o2 = false } = t2;
  if (e2.length === 0) return [];
  let s2 = 0.15 + (1 - i2) * 0.85, l2 = Array.isArray(e2[0]) ? e2 : e2.map(({ x: e3, y: t3, pressure: r2 = n }) => [e3, t3, r2]);
  if (l2.length === 2) {
    let e3 = l2[1];
    l2 = l2.slice(0, -1);
    for (let t3 = 1; t3 < 5; t3++) l2.push(w(l2[0], e3, t3 / 4));
  }
  l2.length === 1 && (l2 = [...l2, [...c(l2[0], r), ...l2[0].slice(2)]]);
  let u2 = [{ point: [l2[0][0], l2[0][1]], pressure: I(l2[0][2]) ? l2[0][2] : 0.25, vector: [...r], distance: 0, runningLength: 0 }], f2 = false, p2 = 0, m2 = u2[0], h2 = l2.length - 1;
  for (let e3 = 1; e3 < l2.length; e3++) {
    let t3 = o2 && e3 === h2 ? [l2[e3][0], l2[e3][1]] : w(m2.point, l2[e3], s2);
    if (_(m2.point, t3)) continue;
    let r2 = x(t3, m2.point);
    if (p2 += r2, e3 < h2 && !f2) {
      if (p2 < a2) continue;
      f2 = true;
    }
    d(F, m2.point, t3), m2 = { point: t3, pressure: I(l2[e3][2]) ? l2[e3][2] : n, vector: b(F), distance: r2, runningLength: p2 }, u2.push(m2);
  }
  return u2[0].vector = u2[1]?.vector || [0, 0], u2;
}
function R(e2, t2 = {}) {
  return P(L(e2, t2), t2);
}
var z = R;

// ../node_modules/.pnpm/@zag-js+signature-pad@1.34.1/node_modules/@zag-js/signature-pad/dist/index.mjs
var anatomy = createAnatomy("signature-pad").parts(
  "root",
  "control",
  "segment",
  "segmentPath",
  "guide",
  "clearTrigger",
  "label"
);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `signature-${ctx.id}`;
var getControlId = (ctx) => ctx.ids?.control ?? `signature-control-${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `signature-label-${ctx.id}`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `signature-input-${ctx.id}`;
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getSegmentEl = (ctx) => query(getControlEl(ctx), "[data-part=segment]");
var getDataUrl2 = (ctx, options) => {
  return getDataUrl(getSegmentEl(ctx), options);
};
function connect(service, normalize) {
  const { state, send, prop, computed, context, scope } = service;
  const drawing = state.matches("drawing");
  const empty = computed("isEmpty");
  const interactive = computed("isInteractive");
  const disabled = !!prop("disabled");
  const required = !!prop("required");
  const translations = prop("translations");
  return {
    empty,
    drawing,
    currentPath: context.get("currentPath"),
    paths: context.get("paths"),
    clear() {
      send({ type: "CLEAR" });
    },
    getDataUrl(type, quality) {
      if (computed("isEmpty")) return Promise.resolve("");
      return getDataUrl2(scope, { type, quality });
    },
    getLabelProps() {
      return normalize.label({
        ...parts.label.attrs,
        id: getLabelId(scope),
        "data-disabled": dataAttr(disabled),
        "data-required": dataAttr(required),
        htmlFor: getHiddenInputId(scope),
        onClick(event) {
          if (!interactive) return;
          if (event.defaultPrevented) return;
          const controlEl = getControlEl(scope);
          controlEl?.focus({ preventScroll: true });
        }
      });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        "data-disabled": dataAttr(disabled),
        id: getRootId(scope)
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        tabIndex: disabled ? void 0 : 0,
        id: getControlId(scope),
        role: "application",
        "aria-roledescription": "signature pad",
        "aria-label": translations.control,
        "aria-disabled": disabled,
        "data-disabled": dataAttr(disabled),
        onPointerDown(event) {
          if (!isLeftClick(event)) return;
          if (isModifierKey(event)) return;
          if (!interactive) return;
          const target = getEventTarget(event);
          if (target?.closest("[data-part=clear-trigger]")) return;
          event.currentTarget.setPointerCapture(event.pointerId);
          const point = { x: event.clientX, y: event.clientY };
          const controlEl = getControlEl(scope);
          if (!controlEl) return;
          const { offset } = getRelativePoint(point, controlEl);
          send({ type: "POINTER_DOWN", point: offset, pressure: event.pressure });
        },
        onPointerUp(event) {
          if (!interactive) return;
          if (event.currentTarget.hasPointerCapture(event.pointerId)) {
            event.currentTarget.releasePointerCapture(event.pointerId);
          }
        },
        style: {
          position: "relative",
          touchAction: "none",
          userSelect: "none",
          WebkitUserSelect: "none"
        }
      });
    },
    getSegmentProps() {
      return normalize.svg({
        ...parts.segment.attrs,
        style: {
          position: "absolute",
          top: 0,
          left: 0,
          width: "100%",
          height: "100%",
          pointerEvents: "none",
          fill: prop("drawing").fill
        }
      });
    },
    getSegmentPathProps(props2) {
      return normalize.path({
        ...parts.segmentPath.attrs,
        d: props2.path
      });
    },
    getGuideProps() {
      return normalize.element({
        ...parts.guide.attrs,
        "data-disabled": dataAttr(disabled)
      });
    },
    getClearTriggerProps() {
      return normalize.button({
        ...parts.clearTrigger.attrs,
        type: "button",
        "aria-label": translations.clearTrigger,
        hidden: !context.get("paths").length || drawing,
        disabled,
        onClick() {
          send({ type: "CLEAR" });
        }
      });
    },
    getHiddenInputProps(props2) {
      return normalize.input({
        id: getHiddenInputId(scope),
        type: "text",
        hidden: true,
        disabled,
        required: prop("required"),
        readOnly: true,
        name: prop("name"),
        value: props2.value
      });
    }
  };
}
var average = (a2, b2) => (a2 + b2) / 2;
function getSvgPathFromStroke(points, closed = true) {
  const len = points.length;
  if (len < 4) {
    return "";
  }
  let a2 = points[0];
  let b2 = points[1];
  const c2 = points[2];
  let result = `M${a2[0].toFixed(2)},${a2[1].toFixed(2)} Q${b2[0].toFixed(2)},${b2[1].toFixed(2)} ${average(b2[0], c2[0]).toFixed(2)},${average(
    b2[1],
    c2[1]
  ).toFixed(2)} T`;
  for (let i2 = 2, max = len - 1; i2 < max; i2++) {
    a2 = points[i2];
    b2 = points[i2 + 1];
    result += `${average(a2[0], b2[0]).toFixed(2)},${average(a2[1], b2[1]).toFixed(2)} `;
  }
  if (closed) {
    result += "Z";
  }
  return result;
}
var machine = createMachine({
  props({ props: props2 }) {
    return {
      defaultPaths: [],
      ...props2,
      drawing: {
        size: 2,
        simulatePressure: false,
        thinning: 0.7,
        smoothing: 0.4,
        streamline: 0.6,
        ...props2.drawing
      },
      translations: {
        control: "signature pad",
        clearTrigger: "clear signature",
        ...props2.translations
      }
    };
  },
  initialState() {
    return "idle";
  },
  context({ prop, bindable }) {
    return {
      paths: bindable(() => ({
        defaultValue: prop("defaultPaths"),
        value: prop("paths"),
        sync: true,
        onChange(value) {
          prop("onDraw")?.({ paths: value });
        }
      })),
      currentPoints: bindable(() => ({
        defaultValue: []
      })),
      currentPath: bindable(() => ({
        defaultValue: null
      }))
    };
  },
  computed: {
    isInteractive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
    isEmpty: ({ context }) => context.get("paths").length === 0
  },
  on: {
    CLEAR: {
      actions: ["clearPoints", "invokeOnDrawEnd", "focusCanvasEl"]
    }
  },
  states: {
    idle: {
      on: {
        POINTER_DOWN: {
          target: "drawing",
          actions: ["addPoint"]
        }
      }
    },
    drawing: {
      effects: ["trackPointerMove"],
      on: {
        POINTER_MOVE: {
          actions: ["addPoint", "invokeOnDraw"]
        },
        POINTER_UP: {
          target: "idle",
          actions: ["endStroke", "invokeOnDrawEnd"]
        }
      }
    }
  },
  implementations: {
    effects: {
      trackPointerMove({ scope, send }) {
        const doc = scope.getDoc();
        return trackPointerMove(doc, {
          onPointerMove({ event, point }) {
            const controlEl = getControlEl(scope);
            if (!controlEl) return;
            const { offset } = getRelativePoint(point, controlEl);
            send({ type: "POINTER_MOVE", point: offset, pressure: event.pressure });
          },
          onPointerUp() {
            send({ type: "POINTER_UP" });
          }
        });
      }
    },
    actions: {
      addPoint({ context, event, prop }) {
        const nextPoints = [...context.get("currentPoints"), event.point];
        context.set("currentPoints", nextPoints);
        const stroke = z(nextPoints, prop("drawing"));
        context.set("currentPath", getSvgPathFromStroke(stroke));
      },
      endStroke({ context }) {
        const nextPaths = [...context.get("paths"), context.get("currentPath")];
        context.set("paths", nextPaths);
        context.set("currentPoints", []);
        context.set("currentPath", null);
      },
      clearPoints({ context }) {
        context.set("currentPoints", []);
        context.set("paths", []);
        context.set("currentPath", null);
      },
      focusCanvasEl({ scope }) {
        queueMicrotask(() => {
          scope.getActiveElement()?.focus({ preventScroll: true });
        });
      },
      invokeOnDraw({ context, prop }) {
        prop("onDraw")?.({
          paths: [...context.get("paths"), context.get("currentPath")]
        });
      },
      invokeOnDrawEnd({ context, prop, scope, computed }) {
        prop("onDrawEnd")?.({
          paths: [...context.get("paths")],
          getDataUrl(type, quality = 0.92) {
            if (computed("isEmpty")) return Promise.resolve("");
            return getDataUrl2(scope, { type, quality });
          }
        });
      }
    }
  }
});
var props = createProps()([
  "defaultPaths",
  "dir",
  "disabled",
  "drawing",
  "getRootNode",
  "id",
  "ids",
  "name",
  "onDraw",
  "onDrawEnd",
  "paths",
  "readOnly",
  "required",
  "translations"
]);
var splitProps = createSplitProps(props);

// components/signature-pad.ts
var SignaturePad = class extends Component {
  imageURL = "";
  paths = [];
  name;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    this.name = props2.name;
    return new VanillaMachine(machine, props2);
  }
  setName(name) {
    this.name = name;
  }
  setPaths(paths) {
    this.paths = paths;
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  syncPaths = () => {
    const segment = this.el.querySelector(
      '[data-scope="signature-pad"][data-part="segment"]'
    );
    if (!segment) return;
    const totalPaths = this.api.paths.length + (this.api.currentPath ? 1 : 0);
    if (totalPaths === 0) {
      segment.innerHTML = "";
      this.imageURL = "";
      this.paths = [];
      const hiddenInput = this.el.querySelector(
        '[data-scope="signature-pad"][data-part="hidden-input"]'
      );
      if (hiddenInput) hiddenInput.value = "";
      return;
    }
    segment.innerHTML = "";
    this.api.paths.forEach((pathData) => {
      const pathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
      pathEl.setAttribute("data-scope", "signature-pad");
      pathEl.setAttribute("data-part", "path");
      this.spreadProps(pathEl, this.api.getSegmentPathProps({ path: pathData }));
      segment.appendChild(pathEl);
    });
    if (this.api.currentPath) {
      const currentPathEl = document.createElementNS("http://www.w3.org/2000/svg", "path");
      currentPathEl.setAttribute("data-scope", "signature-pad");
      currentPathEl.setAttribute("data-part", "current-path");
      this.spreadProps(currentPathEl, this.api.getSegmentPathProps({ path: this.api.currentPath }));
      segment.appendChild(currentPathEl);
    }
  };
  render() {
    const rootEl = this.el.querySelector(
      '[data-scope="signature-pad"][data-part="root"]'
    );
    if (!rootEl) return;
    this.spreadProps(rootEl, this.api.getRootProps());
    const label = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="label"]'
    );
    if (label) this.spreadProps(label, this.api.getLabelProps());
    const control = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="control"]'
    );
    if (control) this.spreadProps(control, this.api.getControlProps());
    const segment = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="segment"]'
    );
    if (segment) this.spreadProps(segment, this.api.getSegmentProps());
    const guide = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="guide"]'
    );
    if (guide) this.spreadProps(guide, this.api.getGuideProps());
    const clearBtn = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="clear-trigger"]'
    );
    if (clearBtn) {
      this.spreadProps(clearBtn, this.api.getClearTriggerProps());
    }
    const hiddenInput = rootEl.querySelector(
      '[data-scope="signature-pad"][data-part="hidden-input"]'
    );
    if (hiddenInput) {
      this.spreadProps(
        hiddenInput,
        this.api.getHiddenInputProps({
          value: this.api.paths.length > 0 ? JSON.stringify(this.api.paths) : ""
        })
      );
    }
    this.syncPaths();
  }
};

// hooks/signature-pad.ts
function getPaths(el, attr) {
  const value = el.dataset[attr];
  if (!value) return [];
  try {
    return JSON.parse(value);
  } catch {
    return [];
  }
}
function buildDrawingOptions(el) {
  return {
    fill: getString(el, "drawingFill") || "black",
    size: getNumber(el, "drawingSize") ?? 2,
    simulatePressure: getBoolean(el, "drawingSimulatePressure"),
    smoothing: getNumber(el, "drawingSmoothing") ?? 0.5,
    thinning: getNumber(el, "drawingThinning") ?? 0.7,
    streamline: getNumber(el, "drawingStreamline") ?? 0.65
  };
}
var SignaturePadHook = {
  mounted() {
    const el = this.el;
    const pushEvent = this.pushEvent.bind(this);
    const controlled = getBoolean(el, "controlled");
    const paths = getPaths(el, "paths");
    const defaultPaths = getPaths(el, "defaultPaths");
    const signaturePad = new SignaturePad(el, {
      id: el.id,
      name: getString(el, "name"),
      ...controlled && paths.length > 0 ? { paths } : void 0,
      ...!controlled && defaultPaths.length > 0 ? { defaultPaths } : void 0,
      drawing: buildDrawingOptions(el),
      onDrawEnd: (details) => {
        signaturePad.setPaths(details.paths);
        const hiddenInput = el.querySelector(
          '[data-scope="signature-pad"][data-part="hidden-input"]'
        );
        if (hiddenInput) {
          hiddenInput.value = details.paths.length > 0 ? JSON.stringify(details.paths) : "";
          hiddenInput.dispatchEvent(new Event("input", { bubbles: true }));
          hiddenInput.dispatchEvent(new Event("change", { bubbles: true }));
        }
        details.getDataUrl("image/png").then((url) => {
          signaturePad.imageURL = url;
          const eventName = getString(el, "onDrawEnd");
          if (eventName && this.liveSocket.main.isConnected()) {
            pushEvent(eventName, {
              id: el.id,
              paths: details.paths,
              url
            });
          }
          const eventNameClient = getString(el, "onDrawEndClient");
          if (eventNameClient) {
            el.dispatchEvent(
              new CustomEvent(eventNameClient, {
                bubbles: true,
                detail: {
                  id: el.id,
                  paths: details.paths,
                  url
                }
              })
            );
          }
        });
      }
    });
    signaturePad.init();
    this.signaturePad = signaturePad;
    this.onClear = (event) => {
      const { id: targetId } = event.detail;
      if (targetId && targetId !== el.id) return;
      signaturePad.api.clear();
    };
    el.addEventListener("phx:signature-pad:clear", this.onClear);
    this.handlers = [];
    this.handlers.push(
      this.handleEvent("signature_pad_clear", (payload) => {
        const targetId = payload.signature_pad_id;
        if (targetId && targetId !== el.id) return;
        signaturePad.api.clear();
      })
    );
  },
  updated() {
    const controlled = getBoolean(this.el, "controlled");
    const paths = getPaths(this.el, "paths");
    const defaultPaths = getPaths(this.el, "defaultPaths");
    const name = getString(this.el, "name");
    if (name) {
      this.signaturePad?.setName(name);
    }
    this.signaturePad?.updateProps({
      id: this.el.id,
      name,
      ...controlled && paths.length > 0 ? { paths } : {},
      ...!controlled && defaultPaths.length > 0 ? { defaultPaths } : {},
      drawing: buildDrawingOptions(this.el)
    });
  },
  destroyed() {
    if (this.onClear) {
      this.el.removeEventListener("phx:signature-pad:clear", this.onClear);
    }
    if (this.handlers) {
      for (const handler of this.handlers) {
        this.removeHandleEvent(handler);
      }
    }
    this.signaturePad?.destroy();
  }
};
export {
  SignaturePadHook as SignaturePad
};
