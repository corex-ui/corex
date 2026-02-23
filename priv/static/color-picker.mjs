import {
  getPlacement,
  getPlacementStyles
} from "./chunk-QYWY7F3J.mjs";
import {
  trackDismissableElement
} from "./chunk-CHUGBG5L.mjs";
import "./chunk-DTH4G7GO.mjs";
import {
  Component,
  VanillaMachine,
  clampValue,
  createAnatomy,
  createGuards,
  createMachine,
  createProps,
  createSplitProps,
  dataAttr,
  disableTextSelection,
  dispatchInputValueEvent,
  getBoolean,
  getDir,
  getEventKey,
  getEventPoint,
  getEventStep,
  getInitialFocus,
  getPercentValue,
  getRelativePoint,
  getString,
  getValuePercent,
  isLeftClick,
  isModifierKey,
  mod,
  normalizeProps,
  query,
  queryAll,
  raf,
  setElementValue,
  snapValueToStep,
  toFixedNumber,
  trackFormControl,
  trackPointerMove,
  tryCatch,
  visuallyHiddenStyle
} from "./chunk-PLUM2DEK.mjs";

// ../node_modules/.pnpm/@zag-js+color-utils@1.34.1/node_modules/@zag-js/color-utils/dist/index.mjs
var __defProp = Object.defineProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __publicField = (obj, key, value) => __defNormalProp(obj, key + "", value);
var generateRGB_R = (orientation, dir, zValue) => {
  const maskImage = `linear-gradient(to ${orientation[Number(!dir)]}, transparent, #000)`;
  const result = {
    areaStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(${zValue},0,0),rgb(${zValue},255,0))`
    },
    areaGradientStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(${zValue},0,255),rgb(${zValue},255,255))`,
      WebkitMaskImage: maskImage,
      maskImage
    }
  };
  return result;
};
var generateRGB_G = (orientation, dir, zValue) => {
  const maskImage = `linear-gradient(to ${orientation[Number(!dir)]}, transparent, #000)`;
  const result = {
    areaStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(0,${zValue},0),rgb(255,${zValue},0))`
    },
    areaGradientStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(0,${zValue},255),rgb(255,${zValue},255))`,
      WebkitMaskImage: maskImage,
      maskImage
    }
  };
  return result;
};
var generateRGB_B = (orientation, dir, zValue) => {
  const maskImage = `linear-gradient(to ${orientation[Number(!dir)]}, transparent, #000)`;
  const result = {
    areaStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(0,0,${zValue}),rgb(255,0,${zValue}))`
    },
    areaGradientStyles: {
      backgroundImage: `linear-gradient(to ${orientation[Number(dir)]},rgb(0,255,${zValue}),rgb(255,255,${zValue}))`,
      WebkitMaskImage: maskImage,
      maskImage
    }
  };
  return result;
};
var generateHSL_H = (orientation, dir, zValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      background: [
        `linear-gradient(to ${orientation[Number(dir)]}, hsla(0,0%,0%,1) 0%, hsla(0,0%,0%,0) 50%, hsla(0,0%,100%,0) 50%, hsla(0,0%,100%,1) 100%)`,
        `linear-gradient(to ${orientation[Number(!dir)]},hsl(0,0%,50%),hsla(0,0%,50%,0))`,
        `hsl(${zValue}, 100%, 50%)`
      ].join(",")
    }
  };
  return result;
};
var generateHSL_S = (orientation, dir, alphaValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      background: [
        `linear-gradient(to ${orientation[Number(!dir)]}, hsla(0,0%,0%,${alphaValue}) 0%, hsla(0,0%,0%,0) 50%, hsla(0,0%,100%,0) 50%, hsla(0,0%,100%,${alphaValue}) 100%)`,
        `linear-gradient(to ${orientation[Number(dir)]},hsla(0,100%,50%,${alphaValue}),hsla(60,100%,50%,${alphaValue}),hsla(120,100%,50%,${alphaValue}),hsla(180,100%,50%,${alphaValue}),hsla(240,100%,50%,${alphaValue}),hsla(300,100%,50%,${alphaValue}),hsla(359,100%,50%,${alphaValue}))`,
        "hsl(0, 0%, 50%)"
      ].join(",")
    }
  };
  return result;
};
var generateHSL_L = (orientation, dir, zValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      backgroundImage: [
        `linear-gradient(to ${orientation[Number(!dir)]},hsl(0,0%,${zValue}%),hsla(0,0%,${zValue}%,0))`,
        `linear-gradient(to ${orientation[Number(dir)]},hsl(0,100%,${zValue}%),hsl(60,100%,${zValue}%),hsl(120,100%,${zValue}%),hsl(180,100%,${zValue}%),hsl(240,100%,${zValue}%),hsl(300,100%,${zValue}%),hsl(360,100%,${zValue}%))`
      ].join(",")
    }
  };
  return result;
};
var generateHSB_H = (orientation, dir, zValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      background: [
        `linear-gradient(to ${orientation[Number(dir)]},hsl(0,0%,0%),hsla(0,0%,0%,0))`,
        `linear-gradient(to ${orientation[Number(!dir)]},hsl(0,0%,100%),hsla(0,0%,100%,0))`,
        `hsl(${zValue}, 100%, 50%)`
      ].join(",")
    }
  };
  return result;
};
var generateHSB_S = (orientation, dir, alphaValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      background: [
        `linear-gradient(to ${orientation[Number(!dir)]},hsla(0,0%,0%,${alphaValue}),hsla(0,0%,0%,0))`,
        `linear-gradient(to ${orientation[Number(dir)]},hsla(0,100%,50%,${alphaValue}),hsla(60,100%,50%,${alphaValue}),hsla(120,100%,50%,${alphaValue}),hsla(180,100%,50%,${alphaValue}),hsla(240,100%,50%,${alphaValue}),hsla(300,100%,50%,${alphaValue}),hsla(359,100%,50%,${alphaValue}))`,
        `linear-gradient(to ${orientation[Number(!dir)]},hsl(0,0%,0%),hsl(0,0%,100%))`
      ].join(",")
    }
  };
  return result;
};
var generateHSB_B = (orientation, dir, alphaValue) => {
  const result = {
    areaStyles: {},
    areaGradientStyles: {
      background: [
        `linear-gradient(to ${orientation[Number(!dir)]},hsla(0,0%,100%,${alphaValue}),hsla(0,0%,100%,0))`,
        `linear-gradient(to ${orientation[Number(dir)]},hsla(0,100%,50%,${alphaValue}),hsla(60,100%,50%,${alphaValue}),hsla(120,100%,50%,${alphaValue}),hsla(180,100%,50%,${alphaValue}),hsla(240,100%,50%,${alphaValue}),hsla(300,100%,50%,${alphaValue}),hsla(359,100%,50%,${alphaValue}))`,
        "#000"
      ].join(",")
    }
  };
  return result;
};
function getColorAreaGradient(color, options) {
  const { xChannel, yChannel, dir: dirProp = "ltr" } = options;
  const { zChannel } = color.getColorAxes({ xChannel, yChannel });
  const zValue = color.getChannelValue(zChannel);
  const { minValue: zMin, maxValue: zMax } = color.getChannelRange(zChannel);
  const orientation = ["top", dirProp === "rtl" ? "left" : "right"];
  let dir = false;
  let background = { areaStyles: {}, areaGradientStyles: {} };
  let alphaValue = (zValue - zMin) / (zMax - zMin);
  let isHSL = color.getFormat() === "hsla";
  switch (zChannel) {
    case "red": {
      dir = xChannel === "green";
      background = generateRGB_R(orientation, dir, zValue);
      break;
    }
    case "green": {
      dir = xChannel === "red";
      background = generateRGB_G(orientation, dir, zValue);
      break;
    }
    case "blue": {
      dir = xChannel === "red";
      background = generateRGB_B(orientation, dir, zValue);
      break;
    }
    case "hue": {
      dir = xChannel !== "saturation";
      if (isHSL) {
        background = generateHSL_H(orientation, dir, zValue);
      } else {
        background = generateHSB_H(orientation, dir, zValue);
      }
      break;
    }
    case "saturation": {
      dir = xChannel === "hue";
      if (isHSL) {
        background = generateHSL_S(orientation, dir, alphaValue);
      } else {
        background = generateHSB_S(orientation, dir, alphaValue);
      }
      break;
    }
    case "brightness": {
      dir = xChannel === "hue";
      background = generateHSB_B(orientation, dir, alphaValue);
      break;
    }
    case "lightness": {
      dir = xChannel === "hue";
      background = generateHSL_L(orientation, dir, zValue);
      break;
    }
  }
  return background;
}
var isEqualObject = (a, b) => {
  if (Object.keys(a).length !== Object.keys(b).length) return false;
  for (let key in a) if (a[key] !== b[key]) return false;
  return true;
};
var Color = class {
  toHexInt() {
    return this.toFormat("rgba").toHexInt();
  }
  getChannelValue(channel) {
    if (channel in this) return this[channel];
    throw new Error("Unsupported color channel: " + channel);
  }
  getChannelValuePercent(channel, valueToCheck) {
    const value = valueToCheck ?? this.getChannelValue(channel);
    const { minValue, maxValue } = this.getChannelRange(channel);
    return getValuePercent(value, minValue, maxValue);
  }
  getChannelPercentValue(channel, percentToCheck) {
    const { minValue, maxValue, step } = this.getChannelRange(channel);
    const percentValue = getPercentValue(percentToCheck, minValue, maxValue, step);
    return snapValueToStep(percentValue, minValue, maxValue, step);
  }
  withChannelValue(channel, value) {
    const { minValue, maxValue } = this.getChannelRange(channel);
    if (channel in this) {
      let clone = this.clone();
      clone[channel] = clampValue(value, minValue, maxValue);
      return clone;
    }
    throw new Error("Unsupported color channel: " + channel);
  }
  getColorAxes(xyChannels) {
    let { xChannel, yChannel } = xyChannels;
    let xCh = xChannel || this.getChannels().find((c) => c !== yChannel);
    let yCh = yChannel || this.getChannels().find((c) => c !== xCh);
    let zCh = this.getChannels().find((c) => c !== xCh && c !== yCh);
    return { xChannel: xCh, yChannel: yCh, zChannel: zCh };
  }
  incrementChannel(channel, stepSize) {
    const { minValue, maxValue, step } = this.getChannelRange(channel);
    const value = snapValueToStep(
      clampValue(this.getChannelValue(channel) + stepSize, minValue, maxValue),
      minValue,
      maxValue,
      step
    );
    return this.withChannelValue(channel, value);
  }
  decrementChannel(channel, stepSize) {
    return this.incrementChannel(channel, -stepSize);
  }
  isEqual(color) {
    const isSame = isEqualObject(this.toJSON(), color.toJSON());
    return isSame && this.getChannelValue("alpha") === color.getChannelValue("alpha");
  }
};
var HEX_COLOR_REGEX = /^#[\da-f]+$/i;
var RGB_COLOR_REGEX = /^rgba?\((.*)\)$/;
var HEX_STARTING_REGEX = /[^#]/gi;
var _RGBColor = class _RGBColor2 extends Color {
  constructor(red, green, blue, alpha) {
    super();
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.alpha = alpha;
  }
  static parse(value) {
    let colors = [];
    if (HEX_COLOR_REGEX.test(value) && [4, 5, 7, 9].includes(value.length)) {
      const values = (value.length < 6 ? value.replace(HEX_STARTING_REGEX, "$&$&") : value).slice(1).split("");
      while (values.length > 0) {
        colors.push(parseInt(values.splice(0, 2).join(""), 16));
      }
      colors[3] = colors[3] !== void 0 ? colors[3] / 255 : void 0;
    }
    const match = value.match(RGB_COLOR_REGEX);
    if (match?.[1]) {
      colors = match[1].split(",").map((value2) => Number(value2.trim())).map((num, i) => clampValue(num, 0, i < 3 ? 255 : 1));
    }
    return colors.length < 3 ? void 0 : new _RGBColor2(colors[0], colors[1], colors[2], colors[3] ?? 1);
  }
  toString(format = "css") {
    switch (format) {
      case "hex":
        return "#" + (this.red.toString(16).padStart(2, "0") + this.green.toString(16).padStart(2, "0") + this.blue.toString(16).padStart(2, "0")).toUpperCase();
      case "hexa":
        return "#" + (this.red.toString(16).padStart(2, "0") + this.green.toString(16).padStart(2, "0") + this.blue.toString(16).padStart(2, "0") + Math.round(this.alpha * 255).toString(16).padStart(2, "0")).toUpperCase();
      case "rgb":
        return `rgb(${this.red}, ${this.green}, ${this.blue})`;
      case "css":
      case "rgba":
        return `rgba(${this.red}, ${this.green}, ${this.blue}, ${this.alpha})`;
      case "hsl":
        return this.toHSL().toString("hsl");
      case "hsb":
        return this.toHSB().toString("hsb");
      default:
        return this.toFormat(format).toString(format);
    }
  }
  toFormat(format) {
    switch (format) {
      case "rgba":
        return this;
      case "hsba":
        return this.toHSB();
      case "hsla":
        return this.toHSL();
      default:
        throw new Error("Unsupported color conversion: rgb -> " + format);
    }
  }
  toHexInt() {
    return this.red << 16 | this.green << 8 | this.blue;
  }
  /**
   * Converts an RGB color value to HSB.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB.
   * @returns An HSBColor object.
   */
  toHSB() {
    const red = this.red / 255;
    const green = this.green / 255;
    const blue = this.blue / 255;
    const min = Math.min(red, green, blue);
    const brightness = Math.max(red, green, blue);
    const chroma = brightness - min;
    const saturation = brightness === 0 ? 0 : chroma / brightness;
    let hue = 0;
    if (chroma !== 0) {
      switch (brightness) {
        case red:
          hue = (green - blue) / chroma + (green < blue ? 6 : 0);
          break;
        case green:
          hue = (blue - red) / chroma + 2;
          break;
        case blue:
          hue = (red - green) / chroma + 4;
          break;
      }
      hue /= 6;
    }
    return new HSBColor(
      toFixedNumber(hue * 360, 2),
      toFixedNumber(saturation * 100, 2),
      toFixedNumber(brightness * 100, 2),
      toFixedNumber(this.alpha, 2)
    );
  }
  /**
   * Converts an RGB color value to HSL.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#From_RGB.
   * @returns An HSLColor object.
   */
  toHSL() {
    const red = this.red / 255;
    const green = this.green / 255;
    const blue = this.blue / 255;
    const min = Math.min(red, green, blue);
    const max = Math.max(red, green, blue);
    const lightness = (max + min) / 2;
    const chroma = max - min;
    let hue = -1;
    let saturation = -1;
    if (chroma === 0) {
      hue = saturation = 0;
    } else {
      saturation = chroma / (lightness < 0.5 ? max + min : 2 - max - min);
      switch (max) {
        case red:
          hue = (green - blue) / chroma + (green < blue ? 6 : 0);
          break;
        case green:
          hue = (blue - red) / chroma + 2;
          break;
        case blue:
          hue = (red - green) / chroma + 4;
          break;
      }
      hue /= 6;
    }
    return new HSLColor(
      toFixedNumber(hue * 360, 2),
      toFixedNumber(saturation * 100, 2),
      toFixedNumber(lightness * 100, 2),
      toFixedNumber(this.alpha, 2)
    );
  }
  clone() {
    return new _RGBColor2(this.red, this.green, this.blue, this.alpha);
  }
  getChannelFormatOptions(channel) {
    switch (channel) {
      case "red":
      case "green":
      case "blue":
        return { style: "decimal" };
      case "alpha":
        return { style: "percent" };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  formatChannelValue(channel, locale) {
    let options = this.getChannelFormatOptions(channel);
    let value = this.getChannelValue(channel);
    return new Intl.NumberFormat(locale, options).format(value);
  }
  getChannelRange(channel) {
    switch (channel) {
      case "red":
      case "green":
      case "blue":
        return { minValue: 0, maxValue: 255, step: 1, pageSize: 17 };
      case "alpha":
        return { minValue: 0, maxValue: 1, step: 0.01, pageSize: 0.1 };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  toJSON() {
    return { r: this.red, g: this.green, b: this.blue, a: this.alpha };
  }
  getFormat() {
    return "rgba";
  }
  getChannels() {
    return _RGBColor2.colorChannels;
  }
};
__publicField(_RGBColor, "colorChannels", ["red", "green", "blue"]);
var RGBColor = _RGBColor;
var HSL_REGEX = /hsl\(([-+]?\d+(?:.\d+)?\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d+(?:.\d+)?%)\)|hsla\(([-+]?\d+(?:.\d+)?\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d(.\d+)?)\)/;
var _HSLColor = class _HSLColor2 extends Color {
  constructor(hue, saturation, lightness, alpha) {
    super();
    this.hue = hue;
    this.saturation = saturation;
    this.lightness = lightness;
    this.alpha = alpha;
  }
  static parse(value) {
    let m;
    if (m = value.match(HSL_REGEX)) {
      const [h, s, l, a] = (m[1] ?? m[2]).split(",").map((n) => Number(n.trim().replace("%", "")));
      return new _HSLColor2(mod(h, 360), clampValue(s, 0, 100), clampValue(l, 0, 100), clampValue(a ?? 1, 0, 1));
    }
  }
  toString(format = "css") {
    switch (format) {
      case "hex":
        return this.toRGB().toString("hex");
      case "hexa":
        return this.toRGB().toString("hexa");
      case "hsl":
        return `hsl(${this.hue}, ${toFixedNumber(this.saturation, 2)}%, ${toFixedNumber(this.lightness, 2)}%)`;
      case "css":
      case "hsla":
        return `hsla(${this.hue}, ${toFixedNumber(this.saturation, 2)}%, ${toFixedNumber(this.lightness, 2)}%, ${this.alpha})`;
      case "hsb":
        return this.toHSB().toString("hsb");
      case "rgb":
        return this.toRGB().toString("rgb");
      default:
        return this.toFormat(format).toString(format);
    }
  }
  toFormat(format) {
    switch (format) {
      case "hsla":
        return this;
      case "hsba":
        return this.toHSB();
      case "rgba":
        return this.toRGB();
      default:
        throw new Error("Unsupported color conversion: hsl -> " + format);
    }
  }
  /**
   * Converts a HSL color to HSB.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#HSL_to_HSV.
   * @returns An HSBColor object.
   */
  toHSB() {
    let saturation = this.saturation / 100;
    let lightness = this.lightness / 100;
    let brightness = lightness + saturation * Math.min(lightness, 1 - lightness);
    saturation = brightness === 0 ? 0 : 2 * (1 - lightness / brightness);
    return new HSBColor(
      toFixedNumber(this.hue, 2),
      toFixedNumber(saturation * 100, 2),
      toFixedNumber(brightness * 100, 2),
      toFixedNumber(this.alpha, 2)
    );
  }
  /**
   * Converts a HSL color to RGB.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#HSL_to_RGB_alternative.
   * @returns An RGBColor object.
   */
  toRGB() {
    let hue = this.hue;
    let saturation = this.saturation / 100;
    let lightness = this.lightness / 100;
    let a = saturation * Math.min(lightness, 1 - lightness);
    let fn = (n, k = (n + hue / 30) % 12) => lightness - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
    return new RGBColor(
      Math.round(fn(0) * 255),
      Math.round(fn(8) * 255),
      Math.round(fn(4) * 255),
      toFixedNumber(this.alpha, 2)
    );
  }
  clone() {
    return new _HSLColor2(this.hue, this.saturation, this.lightness, this.alpha);
  }
  getChannelFormatOptions(channel) {
    switch (channel) {
      case "hue":
        return { style: "unit", unit: "degree", unitDisplay: "narrow" };
      case "saturation":
      case "lightness":
      case "alpha":
        return { style: "percent" };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  formatChannelValue(channel, locale) {
    let options = this.getChannelFormatOptions(channel);
    let value = this.getChannelValue(channel);
    if (channel === "saturation" || channel === "lightness") {
      value /= 100;
    }
    return new Intl.NumberFormat(locale, options).format(value);
  }
  getChannelRange(channel) {
    switch (channel) {
      case "hue":
        return { minValue: 0, maxValue: 360, step: 1, pageSize: 15 };
      case "saturation":
      case "lightness":
        return { minValue: 0, maxValue: 100, step: 1, pageSize: 10 };
      case "alpha":
        return { minValue: 0, maxValue: 1, step: 0.01, pageSize: 0.1 };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  toJSON() {
    return { h: this.hue, s: this.saturation, l: this.lightness, a: this.alpha };
  }
  getFormat() {
    return "hsla";
  }
  getChannels() {
    return _HSLColor2.colorChannels;
  }
};
__publicField(_HSLColor, "colorChannels", ["hue", "saturation", "lightness"]);
var HSLColor = _HSLColor;
var HSB_REGEX = /hsb\(([-+]?\d+(?:.\d+)?\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d+(?:.\d+)?%)\)|hsba\(([-+]?\d+(?:.\d+)?\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d+(?:.\d+)?%\s*,\s*[-+]?\d(.\d+)?)\)/;
var _HSBColor = class _HSBColor2 extends Color {
  constructor(hue, saturation, brightness, alpha) {
    super();
    this.hue = hue;
    this.saturation = saturation;
    this.brightness = brightness;
    this.alpha = alpha;
  }
  static parse(value) {
    let m;
    if (m = value.match(HSB_REGEX)) {
      const [h, s, b, a] = (m[1] ?? m[2]).split(",").map((n) => Number(n.trim().replace("%", "")));
      return new _HSBColor2(mod(h, 360), clampValue(s, 0, 100), clampValue(b, 0, 100), clampValue(a ?? 1, 0, 1));
    }
  }
  toString(format = "css") {
    switch (format) {
      case "css":
        return this.toHSL().toString("css");
      case "hex":
        return this.toRGB().toString("hex");
      case "hexa":
        return this.toRGB().toString("hexa");
      case "hsb":
        return `hsb(${this.hue}, ${toFixedNumber(this.saturation, 2)}%, ${toFixedNumber(this.brightness, 2)}%)`;
      case "hsba":
        return `hsba(${this.hue}, ${toFixedNumber(this.saturation, 2)}%, ${toFixedNumber(this.brightness, 2)}%, ${this.alpha})`;
      case "hsl":
        return this.toHSL().toString("hsl");
      case "rgb":
        return this.toRGB().toString("rgb");
      default:
        return this.toFormat(format).toString(format);
    }
  }
  toFormat(format) {
    switch (format) {
      case "hsba":
        return this;
      case "hsla":
        return this.toHSL();
      case "rgba":
        return this.toRGB();
      default:
        throw new Error("Unsupported color conversion: hsb -> " + format);
    }
  }
  /**
   * Converts a HSB color to HSL.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_HSL.
   * @returns An HSLColor object.
   */
  toHSL() {
    let saturation = this.saturation / 100;
    let brightness = this.brightness / 100;
    let lightness = brightness * (1 - saturation / 2);
    saturation = lightness === 0 || lightness === 1 ? 0 : (brightness - lightness) / Math.min(lightness, 1 - lightness);
    return new HSLColor(
      toFixedNumber(this.hue, 2),
      toFixedNumber(saturation * 100, 2),
      toFixedNumber(lightness * 100, 2),
      toFixedNumber(this.alpha, 2)
    );
  }
  /**
   * Converts a HSV color value to RGB.
   * Conversion formula adapted from https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB_alternative.
   * @returns An RGBColor object.
   */
  toRGB() {
    let hue = this.hue;
    let saturation = this.saturation / 100;
    let brightness = this.brightness / 100;
    let fn = (n, k = (n + hue / 60) % 6) => brightness - saturation * brightness * Math.max(Math.min(k, 4 - k, 1), 0);
    return new RGBColor(
      Math.round(fn(5) * 255),
      Math.round(fn(3) * 255),
      Math.round(fn(1) * 255),
      toFixedNumber(this.alpha, 2)
    );
  }
  clone() {
    return new _HSBColor2(this.hue, this.saturation, this.brightness, this.alpha);
  }
  getChannelFormatOptions(channel) {
    switch (channel) {
      case "hue":
        return { style: "unit", unit: "degree", unitDisplay: "narrow" };
      case "saturation":
      case "brightness":
      case "alpha":
        return { style: "percent" };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  formatChannelValue(channel, locale) {
    let options = this.getChannelFormatOptions(channel);
    let value = this.getChannelValue(channel);
    if (channel === "saturation" || channel === "brightness") {
      value /= 100;
    }
    return new Intl.NumberFormat(locale, options).format(value);
  }
  getChannelRange(channel) {
    switch (channel) {
      case "hue":
        return { minValue: 0, maxValue: 360, step: 1, pageSize: 15 };
      case "saturation":
      case "brightness":
        return { minValue: 0, maxValue: 100, step: 1, pageSize: 10 };
      case "alpha":
        return { minValue: 0, maxValue: 1, step: 0.01, pageSize: 0.1 };
      default:
        throw new Error("Unknown color channel: " + channel);
    }
  }
  toJSON() {
    return { h: this.hue, s: this.saturation, b: this.brightness, a: this.alpha };
  }
  getFormat() {
    return "hsba";
  }
  getChannels() {
    return _HSBColor2.colorChannels;
  }
};
__publicField(_HSBColor, "colorChannels", ["hue", "saturation", "brightness"]);
var HSBColor = _HSBColor;
var nativeColors = "aliceblue:f0f8ff,antiquewhite:faebd7,aqua:00ffff,aquamarine:7fffd4,azure:f0ffff,beige:f5f5dc,bisque:ffe4c4,black:000000,blanchedalmond:ffebcd,blue:0000ff,blueviolet:8a2be2,brown:a52a2a,burlywood:deb887,cadetblue:5f9ea0,chartreuse:7fff00,chocolate:d2691e,coral:ff7f50,cornflowerblue:6495ed,cornsilk:fff8dc,crimson:dc143c,cyan:00ffff,darkblue:00008b,darkcyan:008b8b,darkgoldenrod:b8860b,darkgray:a9a9a9,darkgreen:006400,darkkhaki:bdb76b,darkmagenta:8b008b,darkolivegreen:556b2f,darkorange:ff8c00,darkorchid:9932cc,darkred:8b0000,darksalmon:e9967a,darkseagreen:8fbc8f,darkslateblue:483d8b,darkslategray:2f4f4f,darkturquoise:00ced1,darkviolet:9400d3,deeppink:ff1493,deepskyblue:00bfff,dimgray:696969,dodgerblue:1e90ff,firebrick:b22222,floralwhite:fffaf0,forestgreen:228b22,fuchsia:ff00ff,gainsboro:dcdcdc,ghostwhite:f8f8ff,gold:ffd700,goldenrod:daa520,gray:808080,green:008000,greenyellow:adff2f,honeydew:f0fff0,hotpink:ff69b4,indianred:cd5c5c,indigo:4b0082,ivory:fffff0,khaki:f0e68c,lavender:e6e6fa,lavenderblush:fff0f5,lawngreen:7cfc00,lemonchiffon:fffacd,lightblue:add8e6,lightcoral:f08080,lightcyan:e0ffff,lightgoldenrodyellow:fafad2,lightgrey:d3d3d3,lightgreen:90ee90,lightpink:ffb6c1,lightsalmon:ffa07a,lightseagreen:20b2aa,lightskyblue:87cefa,lightslategray:778899,lightsteelblue:b0c4de,lightyellow:ffffe0,lime:00ff00,limegreen:32cd32,linen:faf0e6,magenta:ff00ff,maroon:800000,mediumaquamarine:66cdaa,mediumblue:0000cd,mediumorchid:ba55d3,mediumpurple:9370d8,mediumseagreen:3cb371,mediumslateblue:7b68ee,mediumspringgreen:00fa9a,mediumturquoise:48d1cc,mediumvioletred:c71585,midnightblue:191970,mintcream:f5fffa,mistyrose:ffe4e1,moccasin:ffe4b5,navajowhite:ffdead,navy:000080,oldlace:fdf5e6,olive:808000,olivedrab:6b8e23,orange:ffa500,orangered:ff4500,orchid:da70d6,palegoldenrod:eee8aa,palegreen:98fb98,paleturquoise:afeeee,palevioletred:d87093,papayawhip:ffefd5,peachpuff:ffdab9,peru:cd853f,pink:ffc0cb,plum:dda0dd,powderblue:b0e0e6,purple:800080,rebeccapurple:663399,red:ff0000,rosybrown:bc8f8f,royalblue:4169e1,saddlebrown:8b4513,salmon:fa8072,sandybrown:f4a460,seagreen:2e8b57,seashell:fff5ee,sienna:a0522d,silver:c0c0c0,skyblue:87ceeb,slateblue:6a5acd,slategray:708090,snow:fffafa,springgreen:00ff7f,steelblue:4682b4,tan:d2b48c,teal:008080,thistle:d8bfd8,tomato:ff6347,turquoise:40e0d0,violet:ee82ee,wheat:f5deb3,white:ffffff,whitesmoke:f5f5f5,yellow:ffff00,yellowgreen:9acd32";
var makeMap = (str) => {
  const map = /* @__PURE__ */ new Map();
  const list = str.split(",");
  for (let i = 0; i < list.length; i++) {
    const [key, val] = list[i].split(":");
    map.set(key, `#${val}`);
    if (key.includes("gray")) map.set(key.replace("gray", "grey"), `#${val}`);
  }
  return map;
};
var nativeColorMap = makeMap(nativeColors);
var parseColor = (value) => {
  if (nativeColorMap.has(value)) {
    return parseColor(nativeColorMap.get(value));
  }
  const result = RGBColor.parse(value) || HSBColor.parse(value) || HSLColor.parse(value);
  if (!result) {
    const error = new Error("Invalid color value: " + value);
    Error.captureStackTrace?.(error, parseColor);
    throw error;
  }
  return result;
};
var normalizeColor = (v) => {
  return typeof v === "string" ? parseColor(v) : v;
};

// ../node_modules/.pnpm/@zag-js+color-picker@1.34.1/node_modules/@zag-js/color-picker/dist/index.mjs
var anatomy = createAnatomy("color-picker", [
  "root",
  "label",
  "control",
  "trigger",
  "positioner",
  "content",
  "area",
  "areaThumb",
  "valueText",
  "areaBackground",
  "channelSlider",
  "channelSliderLabel",
  "channelSliderTrack",
  "channelSliderThumb",
  "channelSliderValueText",
  "channelInput",
  "transparencyGrid",
  "swatchGroup",
  "swatchTrigger",
  "swatchIndicator",
  "swatch",
  "eyeDropperTrigger",
  "formatTrigger",
  "formatSelect"
]);
var parts = anatomy.build();
var getRootId = (ctx) => ctx.ids?.root ?? `color-picker:${ctx.id}`;
var getLabelId = (ctx) => ctx.ids?.label ?? `color-picker:${ctx.id}:label`;
var getHiddenInputId = (ctx) => ctx.ids?.hiddenInput ?? `color-picker:${ctx.id}:hidden-input`;
var getControlId = (ctx) => ctx.ids?.control ?? `color-picker:${ctx.id}:control`;
var getTriggerId = (ctx) => ctx.ids?.trigger ?? `color-picker:${ctx.id}:trigger`;
var getContentId = (ctx) => ctx.ids?.content ?? `color-picker:${ctx.id}:content`;
var getPositionerId = (ctx) => ctx.ids?.positioner ?? `color-picker:${ctx.id}:positioner`;
var getFormatSelectId = (ctx) => ctx.ids?.formatSelect ?? `color-picker:${ctx.id}:format-select`;
var getAreaId = (ctx) => ctx.ids?.area ?? `color-picker:${ctx.id}:area`;
var getAreaGradientId = (ctx) => ctx.ids?.areaGradient ?? `color-picker:${ctx.id}:area-gradient`;
var getAreaThumbId = (ctx) => ctx.ids?.areaThumb ?? `color-picker:${ctx.id}:area-thumb`;
var getChannelSliderTrackId = (ctx, channel) => ctx.ids?.channelSliderTrack?.(channel) ?? `color-picker:${ctx.id}:slider-track:${channel}`;
var getChannelSliderThumbId = (ctx, channel) => ctx.ids?.channelSliderThumb?.(channel) ?? `color-picker:${ctx.id}:slider-thumb:${channel}`;
var getContentEl = (ctx) => ctx.getById(getContentId(ctx));
var getAreaThumbEl = (ctx) => ctx.getById(getAreaThumbId(ctx));
var getChannelSliderThumbEl = (ctx, channel) => ctx.getById(getChannelSliderThumbId(ctx, channel));
var getFormatSelectEl = (ctx) => ctx.getById(getFormatSelectId(ctx));
var getHiddenInputEl = (ctx) => ctx.getById(getHiddenInputId(ctx));
var getAreaEl = (ctx) => ctx.getById(getAreaId(ctx));
var getAreaValueFromPoint = (ctx, point, dir) => {
  const areaEl = getAreaEl(ctx);
  if (!areaEl) return;
  const { getPercentValue: getPercentValue2 } = getRelativePoint(point, areaEl);
  return {
    x: getPercentValue2({ dir, orientation: "horizontal" }),
    y: getPercentValue2({ orientation: "vertical" })
  };
};
var getControlEl = (ctx) => ctx.getById(getControlId(ctx));
var getTriggerEl = (ctx) => ctx.getById(getTriggerId(ctx));
var getPositionerEl = (ctx) => ctx.getById(getPositionerId(ctx));
var getChannelSliderTrackEl = (ctx, channel) => ctx.getById(getChannelSliderTrackId(ctx, channel));
var getChannelSliderValueFromPoint = (ctx, point, channel, dir) => {
  const trackEl = getChannelSliderTrackEl(ctx, channel);
  if (!trackEl) return;
  const { getPercentValue: getPercentValue2 } = getRelativePoint(point, trackEl);
  return {
    x: getPercentValue2({ dir, orientation: "horizontal" }),
    y: getPercentValue2({ orientation: "vertical" })
  };
};
var getChannelInputEls = (ctx) => {
  return [
    ...queryAll(getContentEl(ctx), "input[data-channel]"),
    ...queryAll(getControlEl(ctx), "input[data-channel]")
  ];
};
function getChannelDisplayColor(color, channel) {
  switch (channel) {
    case "hue":
      return parseColor(`hsl(${color.getChannelValue("hue")}, 100%, 50%)`);
    case "lightness":
    case "brightness":
    case "saturation":
    case "red":
    case "green":
    case "blue":
      return color.withChannelValue("alpha", 1);
    case "alpha": {
      return color;
    }
    default:
      throw new Error("Unknown color channel: " + channel);
  }
}
function getChannelValue(color, channel) {
  if (channel == null) return "";
  if (channel === "hex") {
    return color.toString("hex");
  }
  if (channel === "css") {
    return color.toString("css");
  }
  if (channel in color) {
    return color.getChannelValue(channel).toString();
  }
  const isHSL = color.getFormat() === "hsla";
  switch (channel) {
    case "hue":
      return isHSL ? color.toFormat("hsla").getChannelValue("hue").toString() : color.toFormat("hsba").getChannelValue("hue").toString();
    case "saturation":
      return isHSL ? color.toFormat("hsla").getChannelValue("saturation").toString() : color.toFormat("hsba").getChannelValue("saturation").toString();
    case "lightness":
      return color.toFormat("hsla").getChannelValue("lightness").toString();
    case "brightness":
      return color.toFormat("hsba").getChannelValue("brightness").toString();
    case "red":
    case "green":
    case "blue":
      return color.toFormat("rgba").getChannelValue(channel).toString();
    default:
      return color.getChannelValue(channel).toString();
  }
}
function getChannelRange(color, channel) {
  switch (channel) {
    case "hex":
      const minColor = parseColor("#000000");
      const maxColor = parseColor("#FFFFFF");
      return {
        minValue: minColor.toHexInt(),
        maxValue: maxColor.toHexInt(),
        pageSize: 10,
        step: 1
      };
    case "css":
      return void 0;
    case "hue":
    case "saturation":
    case "lightness":
      return color.toFormat("hsla").getChannelRange(channel);
    case "brightness":
      return color.toFormat("hsba").getChannelRange(channel);
    case "red":
    case "green":
    case "blue":
      return color.toFormat("rgba").getChannelRange(channel);
    default:
      return color.getChannelRange(channel);
  }
}
function getSliderBackgroundDirection(orientation, dir) {
  if (orientation === "vertical") {
    return "top";
  } else if (dir === "ltr") {
    return "right";
  } else {
    return "left";
  }
}
var getSliderBackground = (props2) => {
  const { channel, value, dir, orientation } = props2;
  const bgDirection = getSliderBackgroundDirection(orientation, dir);
  const { minValue, maxValue } = value.getChannelRange(channel);
  switch (channel) {
    case "hue":
      return `linear-gradient(to ${bgDirection}, rgb(255, 0, 0) 0%, rgb(255, 255, 0) 17%, rgb(0, 255, 0) 33%, rgb(0, 255, 255) 50%, rgb(0, 0, 255) 67%, rgb(255, 0, 255) 83%, rgb(255, 0, 0) 100%)`;
    case "lightness": {
      let start = value.withChannelValue(channel, minValue).toString("css");
      let middle = value.withChannelValue(channel, (maxValue - minValue) / 2).toString("css");
      let end = value.withChannelValue(channel, maxValue).toString("css");
      return `linear-gradient(to ${bgDirection}, ${start}, ${middle}, ${end})`;
    }
    case "saturation":
    case "brightness":
    case "red":
    case "green":
    case "blue":
    case "alpha": {
      let start = value.withChannelValue(channel, minValue).toString("css");
      let end = value.withChannelValue(channel, maxValue).toString("css");
      return `linear-gradient(to ${bgDirection}, ${start}, ${end})`;
    }
    default:
      throw new Error("Unknown color channel: " + channel);
  }
};
function connect(service, normalize) {
  const { context, send, prop, computed, state, scope } = service;
  const value = context.get("value");
  const format = context.get("format");
  const areaValue = computed("areaValue");
  const valueAsString = computed("valueAsString");
  const disabled = computed("disabled");
  const readOnly = !!prop("readOnly");
  const invalid = !!prop("invalid");
  const required = !!prop("required");
  const interactive = computed("interactive");
  const dragging = state.hasTag("dragging");
  const open = state.hasTag("open");
  const focused = state.hasTag("focused");
  const getAreaChannels = (props2) => {
    const channels = areaValue.getChannels();
    return {
      xChannel: props2.xChannel ?? channels[1],
      yChannel: props2.yChannel ?? channels[2]
    };
  };
  const currentPlacement = context.get("currentPlacement");
  const popperStyles = getPlacementStyles({
    ...prop("positioning"),
    placement: currentPlacement
  });
  function getSwatchTriggerState(props2) {
    const color = normalizeColor(props2.value).toFormat(context.get("format"));
    return {
      value: color,
      valueAsString: color.toString("hex"),
      checked: color.isEqual(value),
      disabled: props2.disabled || !interactive
    };
  }
  return {
    dragging,
    open,
    valueAsString,
    value,
    inline: !!prop("inline"),
    setOpen(nextOpen) {
      if (prop("inline")) return;
      const open2 = state.hasTag("open");
      if (open2 === nextOpen) return;
      send({ type: nextOpen ? "OPEN" : "CLOSE" });
    },
    setValue(value2) {
      send({ type: "VALUE.SET", value: normalizeColor(value2), src: "set-color" });
    },
    getChannelValue(channel) {
      return getChannelValue(value, channel);
    },
    getChannelValueText(channel, locale) {
      return value.formatChannelValue(channel, locale);
    },
    setChannelValue(channel, channelValue) {
      const color = value.withChannelValue(channel, channelValue);
      send({ type: "VALUE.SET", value: color, src: "set-channel" });
    },
    format: context.get("format"),
    setFormat(format2) {
      const formatValue = value.toFormat(format2);
      send({ type: "VALUE.SET", value: formatValue, src: "set-format" });
    },
    alpha: value.getChannelValue("alpha"),
    setAlpha(alphaValue) {
      const color = value.withChannelValue("alpha", alphaValue);
      send({ type: "VALUE.SET", value: color, src: "set-alpha" });
    },
    getRootProps() {
      return normalize.element({
        ...parts.root.attrs,
        dir: prop("dir"),
        id: getRootId(scope),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        style: {
          "--value": value.toString("css")
        }
      });
    },
    getLabelProps() {
      return normalize.element({
        ...parts.label.attrs,
        dir: prop("dir"),
        id: getLabelId(scope),
        htmlFor: getHiddenInputId(scope),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-required": dataAttr(required),
        "data-focus": dataAttr(focused),
        onClick(event) {
          event.preventDefault();
          const inputEl = query(getControlEl(scope), "[data-channel=hex]");
          inputEl?.focus({ preventScroll: true });
        }
      });
    },
    getControlProps() {
      return normalize.element({
        ...parts.control.attrs,
        id: getControlId(scope),
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-state": open ? "open" : "closed",
        "data-focus": dataAttr(focused)
      });
    },
    getTriggerProps() {
      return normalize.button({
        ...parts.trigger.attrs,
        id: getTriggerId(scope),
        dir: prop("dir"),
        disabled,
        "aria-label": `select color. current color is ${valueAsString}`,
        "aria-controls": getContentId(scope),
        "aria-labelledby": getLabelId(scope),
        "aria-haspopup": prop("inline") ? void 0 : "dialog",
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        "data-invalid": dataAttr(invalid),
        "data-placement": currentPlacement,
        "aria-expanded": open,
        "data-state": open ? "open" : "closed",
        "data-focus": dataAttr(focused),
        type: "button",
        onClick() {
          if (!interactive) return;
          send({ type: "TRIGGER.CLICK" });
        },
        onBlur() {
          if (!interactive) return;
          send({ type: "TRIGGER.BLUR" });
        },
        style: {
          position: "relative"
        }
      });
    },
    getPositionerProps() {
      return normalize.element({
        ...parts.positioner.attrs,
        id: getPositionerId(scope),
        dir: prop("dir"),
        style: popperStyles.floating
      });
    },
    getContentProps() {
      return normalize.element({
        ...parts.content.attrs,
        id: getContentId(scope),
        dir: prop("dir"),
        role: prop("inline") ? void 0 : "dialog",
        tabIndex: -1,
        "data-placement": currentPlacement,
        "data-state": open ? "open" : "closed",
        hidden: !open
      });
    },
    getValueTextProps() {
      return normalize.element({
        ...parts.valueText.attrs,
        dir: prop("dir"),
        "data-disabled": dataAttr(disabled),
        "data-focus": dataAttr(focused)
      });
    },
    getAreaProps(props2 = {}) {
      const { xChannel, yChannel } = getAreaChannels(props2);
      const { areaStyles } = getColorAreaGradient(areaValue, {
        xChannel,
        yChannel,
        dir: prop("dir")
      });
      return normalize.element({
        ...parts.area.attrs,
        id: getAreaId(scope),
        role: "group",
        "data-invalid": dataAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          if (isModifierKey(event)) return;
          const point = getEventPoint(event);
          const channel = { xChannel, yChannel };
          send({ type: "AREA.POINTER_DOWN", point, channel, id: "area" });
          event.preventDefault();
        },
        style: {
          position: "relative",
          touchAction: "none",
          forcedColorAdjust: "none",
          ...areaStyles
        }
      });
    },
    getAreaBackgroundProps(props2 = {}) {
      const { xChannel, yChannel } = getAreaChannels(props2);
      const { areaGradientStyles } = getColorAreaGradient(areaValue, {
        xChannel,
        yChannel,
        dir: prop("dir")
      });
      return normalize.element({
        ...parts.areaBackground.attrs,
        id: getAreaGradientId(scope),
        "data-invalid": dataAttr(invalid),
        "data-disabled": dataAttr(disabled),
        "data-readonly": dataAttr(readOnly),
        style: {
          position: "relative",
          touchAction: "none",
          forcedColorAdjust: "none",
          ...areaGradientStyles
        }
      });
    },
    getAreaThumbProps(props2 = {}) {
      const { xChannel, yChannel } = getAreaChannels(props2);
      const channel = { xChannel, yChannel };
      const xPercent = areaValue.getChannelValuePercent(xChannel);
      const yPercent = 1 - areaValue.getChannelValuePercent(yChannel);
      const isRtl = prop("dir") === "rtl";
      const finalXPercent = isRtl ? 1 - xPercent : xPercent;
      const xValue = areaValue.getChannelValue(xChannel);
      const yValue = areaValue.getChannelValue(yChannel);
      const color = areaValue.withChannelValue("alpha", 1).toString("css");
      return normalize.element({
        ...parts.areaThumb.attrs,
        id: getAreaThumbId(scope),
        dir: prop("dir"),
        tabIndex: disabled ? void 0 : 0,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        role: "slider",
        "aria-valuemin": 0,
        "aria-valuemax": 100,
        "aria-valuenow": xValue,
        "aria-label": `${xChannel} and ${yChannel}`,
        "aria-roledescription": "2d slider",
        "aria-valuetext": `${xChannel} ${xValue}, ${yChannel} ${yValue}`,
        style: {
          position: "absolute",
          left: `${finalXPercent * 100}%`,
          top: `${yPercent * 100}%`,
          transform: "translate(-50%, -50%)",
          touchAction: "none",
          forcedColorAdjust: "none",
          "--color": color,
          background: color
        },
        onFocus() {
          if (!interactive) return;
          send({ type: "AREA.FOCUS", id: "area", channel });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const step = getEventStep(event);
          const keyMap = {
            ArrowUp() {
              send({ type: "AREA.ARROW_UP", channel, step });
            },
            ArrowDown() {
              send({ type: "AREA.ARROW_DOWN", channel, step });
            },
            ArrowLeft() {
              send({ type: "AREA.ARROW_LEFT", channel, step });
            },
            ArrowRight() {
              send({ type: "AREA.ARROW_RIGHT", channel, step });
            },
            PageUp() {
              send({ type: "AREA.PAGE_UP", channel, step });
            },
            PageDown() {
              send({ type: "AREA.PAGE_DOWN", channel, step });
            },
            Escape(event2) {
              event2.stopPropagation();
            }
          };
          const exec = keyMap[getEventKey(event, {
            dir: prop("dir")
          })];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        }
      });
    },
    getTransparencyGridProps(props2 = {}) {
      const { size = "12px" } = props2;
      return normalize.element({
        ...parts.transparencyGrid.attrs,
        style: {
          "--size": size,
          width: "100%",
          height: "100%",
          position: "absolute",
          backgroundColor: "#fff",
          backgroundImage: "conic-gradient(#eeeeee 0 25%, transparent 0 50%, #eeeeee 0 75%, transparent 0)",
          backgroundSize: "var(--size) var(--size)",
          inset: "0px",
          zIndex: "auto",
          pointerEvents: "none"
        }
      });
    },
    getChannelSliderProps(props2) {
      const { orientation = "horizontal", channel, format: format2 } = props2;
      return normalize.element({
        ...parts.channelSlider.attrs,
        "data-channel": channel,
        "data-orientation": orientation,
        role: "presentation",
        onPointerDown(event) {
          if (!interactive) return;
          if (!isLeftClick(event)) return;
          if (isModifierKey(event)) return;
          const point = getEventPoint(event);
          send({ type: "CHANNEL_SLIDER.POINTER_DOWN", channel, format: format2, point, id: channel, orientation });
          event.preventDefault();
        },
        style: {
          position: "relative",
          touchAction: "none"
        }
      });
    },
    getChannelSliderTrackProps(props2) {
      const { orientation = "horizontal", channel, format: format2 } = props2;
      const normalizedValue = format2 ? value.toFormat(format2) : areaValue;
      return normalize.element({
        ...parts.channelSliderTrack.attrs,
        id: getChannelSliderTrackId(scope, channel),
        role: "group",
        "data-channel": channel,
        "data-orientation": orientation,
        style: {
          position: "relative",
          forcedColorAdjust: "none",
          backgroundImage: getSliderBackground({
            orientation,
            channel,
            dir: prop("dir"),
            value: normalizedValue
          })
        }
      });
    },
    getChannelSliderLabelProps(props2) {
      const { channel } = props2;
      return normalize.element({
        ...parts.channelSliderLabel.attrs,
        "data-channel": channel,
        onClick(event) {
          if (!interactive) return;
          event.preventDefault();
          const thumbId = getChannelSliderThumbId(scope, channel);
          scope.getById(thumbId)?.focus({ preventScroll: true });
        },
        style: {
          userSelect: "none",
          WebkitUserSelect: "none"
        }
      });
    },
    getChannelSliderValueTextProps(props2) {
      return normalize.element({
        ...parts.channelSliderValueText.attrs,
        "data-channel": props2.channel
      });
    },
    getChannelSliderThumbProps(props2) {
      const { orientation = "horizontal", channel, format: format2 } = props2;
      const normalizedValue = format2 ? value.toFormat(format2) : areaValue;
      const channelRange = normalizedValue.getChannelRange(channel);
      const channelValue = normalizedValue.getChannelValue(channel);
      const offset = (channelValue - channelRange.minValue) / (channelRange.maxValue - channelRange.minValue);
      const isRtl = prop("dir") === "rtl";
      const finalOffset = orientation === "horizontal" && isRtl ? 1 - offset : offset;
      const placementStyles = orientation === "horizontal" ? { left: `${finalOffset * 100}%`, top: "50%" } : { top: `${offset * 100}%`, left: "50%" };
      return normalize.element({
        ...parts.channelSliderThumb.attrs,
        id: getChannelSliderThumbId(scope, channel),
        role: "slider",
        "aria-label": channel,
        tabIndex: disabled ? void 0 : 0,
        "data-channel": channel,
        "data-disabled": dataAttr(disabled),
        "data-orientation": orientation,
        "aria-disabled": dataAttr(disabled),
        "aria-orientation": orientation,
        "aria-valuemax": channelRange.maxValue,
        "aria-valuemin": channelRange.minValue,
        "aria-valuenow": channelValue,
        "aria-valuetext": `${channel} ${channelValue}`,
        style: {
          forcedColorAdjust: "none",
          position: "absolute",
          background: getChannelDisplayColor(areaValue, channel).toString("css"),
          ...placementStyles
        },
        onFocus() {
          if (!interactive) return;
          send({ type: "CHANNEL_SLIDER.FOCUS", channel });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          const step = getEventStep(event) * channelRange.step;
          const keyMap = {
            ArrowUp() {
              send({ type: "CHANNEL_SLIDER.ARROW_UP", channel, step });
            },
            ArrowDown() {
              send({ type: "CHANNEL_SLIDER.ARROW_DOWN", channel, step });
            },
            ArrowLeft() {
              send({ type: "CHANNEL_SLIDER.ARROW_LEFT", channel, step });
            },
            ArrowRight() {
              send({ type: "CHANNEL_SLIDER.ARROW_RIGHT", channel, step });
            },
            PageUp() {
              send({ type: "CHANNEL_SLIDER.PAGE_UP", channel });
            },
            PageDown() {
              send({ type: "CHANNEL_SLIDER.PAGE_DOWN", channel });
            },
            Home() {
              send({ type: "CHANNEL_SLIDER.HOME", channel });
            },
            End() {
              send({ type: "CHANNEL_SLIDER.END", channel });
            },
            Escape(event2) {
              event2.stopPropagation();
            }
          };
          const exec = keyMap[getEventKey(event, {
            dir: prop("dir")
          })];
          if (exec) {
            exec(event);
            event.preventDefault();
          }
        }
      });
    },
    getChannelInputProps(props2) {
      const { channel } = props2;
      const isTextField = channel === "hex" || channel === "css";
      const channelRange = getChannelRange(value, channel);
      return normalize.input({
        ...parts.channelInput.attrs,
        dir: prop("dir"),
        type: isTextField ? "text" : "number",
        "data-channel": channel,
        "aria-label": channel,
        spellCheck: false,
        autoComplete: "off",
        disabled,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        readOnly,
        defaultValue: getChannelValue(value, channel),
        min: channelRange?.minValue,
        max: channelRange?.maxValue,
        step: channelRange?.step,
        onBeforeInput(event) {
          if (isTextField || !interactive) return;
          const value2 = event.currentTarget.value;
          if (value2.match(/[^0-9.]/g)) {
            event.preventDefault();
          }
        },
        onFocus(event) {
          if (!interactive) return;
          send({ type: "CHANNEL_INPUT.FOCUS", channel });
          event.currentTarget.select();
        },
        onBlur(event) {
          if (!interactive) return;
          const value2 = isTextField ? event.currentTarget.value : event.currentTarget.valueAsNumber;
          send({ type: "CHANNEL_INPUT.BLUR", channel, value: value2, isTextField });
        },
        onKeyDown(event) {
          if (event.defaultPrevented) return;
          if (!interactive) return;
          if (event.key === "Enter") {
            const value2 = isTextField ? event.currentTarget.value : event.currentTarget.valueAsNumber;
            send({ type: "CHANNEL_INPUT.CHANGE", channel, value: value2, isTextField });
            event.preventDefault();
          }
        },
        style: {
          appearance: "none",
          WebkitAppearance: "none",
          MozAppearance: "textfield"
        }
      });
    },
    getHiddenInputProps() {
      return normalize.input({
        type: "text",
        disabled,
        name: prop("name"),
        tabIndex: -1,
        readOnly,
        required,
        id: getHiddenInputId(scope),
        style: visuallyHiddenStyle,
        defaultValue: valueAsString
      });
    },
    getEyeDropperTriggerProps() {
      return normalize.button({
        ...parts.eyeDropperTrigger.attrs,
        type: "button",
        dir: prop("dir"),
        disabled,
        "data-disabled": dataAttr(disabled),
        "data-invalid": dataAttr(invalid),
        "data-readonly": dataAttr(readOnly),
        "aria-label": "Pick a color from the screen",
        onClick() {
          if (!interactive) return;
          send({ type: "EYEDROPPER.CLICK" });
        }
      });
    },
    getSwatchGroupProps() {
      return normalize.element({
        ...parts.swatchGroup.attrs,
        role: "group"
      });
    },
    getSwatchTriggerState,
    getSwatchTriggerProps(props2) {
      const swatchState = getSwatchTriggerState(props2);
      return normalize.button({
        ...parts.swatchTrigger.attrs,
        disabled: swatchState.disabled,
        dir: prop("dir"),
        type: "button",
        "aria-label": `select ${swatchState.valueAsString} as the color`,
        "data-state": swatchState.checked ? "checked" : "unchecked",
        "data-value": swatchState.valueAsString,
        "data-disabled": dataAttr(swatchState.disabled),
        onClick() {
          if (swatchState.disabled) return;
          send({ type: "SWATCH_TRIGGER.CLICK", value: swatchState.value });
        },
        style: {
          "--color": swatchState.valueAsString,
          position: "relative"
        }
      });
    },
    getSwatchIndicatorProps(props2) {
      const swatchState = getSwatchTriggerState(props2);
      return normalize.element({
        ...parts.swatchIndicator.attrs,
        dir: prop("dir"),
        hidden: !swatchState.checked
      });
    },
    getSwatchProps(props2) {
      const { respectAlpha = true } = props2;
      const swatchState = getSwatchTriggerState(props2);
      const color = swatchState.value.toString(respectAlpha ? "css" : "hex");
      return normalize.element({
        ...parts.swatch.attrs,
        dir: prop("dir"),
        "data-state": swatchState.checked ? "checked" : "unchecked",
        "data-value": swatchState.valueAsString,
        style: {
          "--color": color,
          position: "relative",
          background: color
        }
      });
    },
    getFormatTriggerProps() {
      return normalize.button({
        ...parts.formatTrigger.attrs,
        dir: prop("dir"),
        type: "button",
        "aria-label": `change color format to ${getNextFormat(format)}`,
        onClick(event) {
          if (event.currentTarget.disabled) return;
          const nextFormat = getNextFormat(format);
          send({ type: "FORMAT.SET", format: nextFormat, src: "format-trigger" });
        }
      });
    },
    getFormatSelectProps() {
      return normalize.select({
        ...parts.formatSelect.attrs,
        "aria-label": "change color format",
        dir: prop("dir"),
        defaultValue: prop("format"),
        disabled,
        onChange(event) {
          const format2 = assertFormat(event.currentTarget.value);
          send({ type: "FORMAT.SET", format: format2, src: "format-select" });
        }
      });
    }
  };
}
var formats = ["hsba", "hsla", "rgba"];
var formatRegex = new RegExp(`^(${formats.join("|")})$`);
function getNextFormat(format) {
  const index = formats.indexOf(format);
  return formats[index + 1] ?? formats[0];
}
function assertFormat(format) {
  if (formatRegex.test(format)) return format;
  throw new Error(`Unsupported color format: ${format}`);
}
var parse = (colorString) => {
  return parseColor(colorString);
};
var HEX_REGEX = /^[0-9a-fA-F]{3,8}$/;
function isValidHex(value) {
  return HEX_REGEX.test(value);
}
function prefixHex(value) {
  if (value.startsWith("#")) return value;
  if (isValidHex(value)) return `#${value}`;
  return value;
}
var { and } = createGuards();
var hashObject = (obj) => {
  let hash = "";
  for (const key in obj) hash += `${key}:${obj[key] ?? ""};`;
  return hash;
};
var DEFAULT_COLOR = parse("#000000");
var machine = createMachine({
  props({ props: props2 }) {
    const color = props2.value ?? props2.defaultValue ?? DEFAULT_COLOR;
    return {
      dir: "ltr",
      defaultValue: DEFAULT_COLOR,
      defaultFormat: color.getFormat(),
      openAutoFocus: true,
      ...props2,
      positioning: {
        placement: "bottom",
        ...props2.positioning
      }
    };
  },
  initialState({ prop }) {
    const open = prop("open") || prop("defaultOpen") || prop("inline");
    return open ? "open" : "idle";
  },
  context({ prop, bindable, getContext }) {
    return {
      value: bindable(() => ({
        defaultValue: prop("defaultValue"),
        value: prop("value"),
        isEqual(a, b) {
          return b != null && a.isEqual(b);
        },
        hash(a) {
          return hashObject(a.toJSON());
        },
        onChange(value) {
          const ctx = getContext();
          const format = ctx.get("format");
          prop("onValueChange")?.({ value, valueAsString: value.toString(format) });
        }
      })),
      format: bindable(() => ({
        defaultValue: prop("defaultFormat"),
        value: prop("format"),
        onChange(format) {
          prop("onFormatChange")?.({ format });
        }
      })),
      activeId: bindable(() => ({ defaultValue: null })),
      activeChannel: bindable(() => ({ defaultValue: null })),
      activeOrientation: bindable(() => ({ defaultValue: null })),
      fieldsetDisabled: bindable(() => ({ defaultValue: false })),
      restoreFocus: bindable(() => ({ defaultValue: true })),
      currentPlacement: bindable(() => ({
        defaultValue: void 0
      }))
    };
  },
  computed: {
    rtl: ({ prop }) => prop("dir") === "rtl",
    disabled: ({ prop, context }) => !!prop("disabled") || context.get("fieldsetDisabled"),
    interactive: ({ prop }) => !(prop("disabled") || prop("readOnly")),
    valueAsString: ({ context }) => context.get("value").toString(context.get("format")),
    areaValue: ({ context }) => {
      const format = context.get("format").startsWith("hsl") ? "hsla" : "hsba";
      return context.get("value").toFormat(format);
    }
  },
  effects: ["trackFormControl"],
  watch({ prop, context, action, track }) {
    track([() => context.hash("value")], () => {
      action(["syncInputElements", "dispatchChangeEvent"]);
    });
    track([() => context.get("format")], () => {
      action(["syncFormatSelectElement", "syncValueWithFormat"]);
    });
    track([() => prop("open")], () => {
      action(["toggleVisibility"]);
    });
  },
  on: {
    "VALUE.SET": {
      actions: ["setValue"]
    },
    "FORMAT.SET": {
      actions: ["setFormat"]
    },
    "CHANNEL_INPUT.CHANGE": {
      actions: ["setChannelColorFromInput"]
    },
    "EYEDROPPER.CLICK": {
      actions: ["openEyeDropper"]
    },
    "SWATCH_TRIGGER.CLICK": {
      actions: ["setValue"]
    }
  },
  states: {
    idle: {
      tags: ["closed"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["setInitialFocus"]
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setInitialFocus"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setInitialFocus"]
          }
        ],
        "CHANNEL_INPUT.FOCUS": {
          target: "focused",
          actions: ["setActiveChannel"]
        }
      }
    },
    focused: {
      tags: ["closed", "focused"],
      on: {
        "CONTROLLED.OPEN": {
          target: "open",
          actions: ["setInitialFocus"]
        },
        OPEN: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setInitialFocus"]
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnOpen"]
          },
          {
            target: "open",
            actions: ["invokeOnOpen", "setInitialFocus"]
          }
        ],
        "CHANNEL_INPUT.FOCUS": {
          actions: ["setActiveChannel"]
        },
        "CHANNEL_INPUT.BLUR": {
          target: "idle",
          actions: ["setChannelColorFromInput"]
        },
        "TRIGGER.BLUR": {
          target: "idle"
        }
      }
    },
    open: {
      tags: ["open"],
      effects: ["trackPositioning", "trackDismissableElement"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["setReturnFocus"]
          },
          {
            target: "idle"
          }
        ],
        "TRIGGER.CLICK": [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose"]
          }
        ],
        "AREA.POINTER_DOWN": {
          target: "open:dragging",
          actions: ["setActiveChannel", "setAreaColorFromPoint", "focusAreaThumb"]
        },
        "AREA.FOCUS": {
          actions: ["setActiveChannel"]
        },
        "CHANNEL_SLIDER.POINTER_DOWN": {
          target: "open:dragging",
          actions: ["setActiveChannel", "setChannelColorFromPoint", "focusChannelThumb"]
        },
        "CHANNEL_SLIDER.FOCUS": {
          actions: ["setActiveChannel"]
        },
        "AREA.ARROW_LEFT": {
          actions: ["decrementAreaXChannel"]
        },
        "AREA.ARROW_RIGHT": {
          actions: ["incrementAreaXChannel"]
        },
        "AREA.ARROW_UP": {
          actions: ["incrementAreaYChannel"]
        },
        "AREA.ARROW_DOWN": {
          actions: ["decrementAreaYChannel"]
        },
        "AREA.PAGE_UP": {
          actions: ["incrementAreaXChannel"]
        },
        "AREA.PAGE_DOWN": {
          actions: ["decrementAreaXChannel"]
        },
        "CHANNEL_SLIDER.ARROW_LEFT": {
          actions: ["decrementChannel"]
        },
        "CHANNEL_SLIDER.ARROW_RIGHT": {
          actions: ["incrementChannel"]
        },
        "CHANNEL_SLIDER.ARROW_UP": {
          actions: ["incrementChannel"]
        },
        "CHANNEL_SLIDER.ARROW_DOWN": {
          actions: ["decrementChannel"]
        },
        "CHANNEL_SLIDER.PAGE_UP": {
          actions: ["incrementChannel"]
        },
        "CHANNEL_SLIDER.PAGE_DOWN": {
          actions: ["decrementChannel"]
        },
        "CHANNEL_SLIDER.HOME": {
          actions: ["setChannelToMin"]
        },
        "CHANNEL_SLIDER.END": {
          actions: ["setChannelToMax"]
        },
        "CHANNEL_INPUT.BLUR": {
          actions: ["setChannelColorFromInput"]
        },
        INTERACT_OUTSIDE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["invokeOnClose", "setReturnFocus"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose"]
          }
        ],
        "SWATCH_TRIGGER.CLICK": [
          {
            guard: and("isOpenControlled", "closeOnSelect"),
            actions: ["setValue", "invokeOnClose"]
          },
          {
            guard: "closeOnSelect",
            target: "focused",
            actions: ["setValue", "invokeOnClose", "setReturnFocus"]
          },
          {
            actions: ["setValue"]
          }
        ]
      }
    },
    "open:dragging": {
      tags: ["open"],
      exit: ["clearActiveChannel"],
      effects: ["trackPointerMove", "disableTextSelection", "trackPositioning", "trackDismissableElement"],
      on: {
        "CONTROLLED.CLOSE": [
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["setReturnFocus"]
          },
          {
            target: "idle"
          }
        ],
        "AREA.POINTER_MOVE": {
          actions: ["setAreaColorFromPoint", "focusAreaThumb"]
        },
        "AREA.POINTER_UP": {
          target: "open",
          actions: ["invokeOnChangeEnd"]
        },
        "CHANNEL_SLIDER.POINTER_MOVE": {
          actions: ["setChannelColorFromPoint", "focusChannelThumb"]
        },
        "CHANNEL_SLIDER.POINTER_UP": {
          target: "open",
          actions: ["invokeOnChangeEnd"]
        },
        INTERACT_OUTSIDE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            guard: "shouldRestoreFocus",
            target: "focused",
            actions: ["invokeOnClose", "setReturnFocus"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose"]
          }
        ],
        CLOSE: [
          {
            guard: "isOpenControlled",
            actions: ["invokeOnClose"]
          },
          {
            target: "idle",
            actions: ["invokeOnClose"]
          }
        ]
      }
    }
  },
  implementations: {
    guards: {
      closeOnSelect: ({ prop }) => !!prop("closeOnSelect"),
      isOpenControlled: ({ prop }) => prop("open") != null || !!prop("inline"),
      shouldRestoreFocus: ({ context }) => !!context.get("restoreFocus")
    },
    effects: {
      trackPositioning({ context, prop, scope }) {
        if (prop("inline")) return;
        if (!context.get("currentPlacement")) {
          context.set("currentPlacement", prop("positioning")?.placement);
        }
        const anchorEl = getTriggerEl(scope);
        const getPositionerEl2 = () => getPositionerEl(scope);
        return getPlacement(anchorEl, getPositionerEl2, {
          ...prop("positioning"),
          defer: true,
          onComplete(data) {
            context.set("currentPlacement", data.placement);
          }
        });
      },
      trackDismissableElement({ context, scope, prop, send }) {
        if (prop("inline")) return;
        const getContentEl2 = () => getContentEl(scope);
        return trackDismissableElement(getContentEl2, {
          type: "popover",
          exclude: getTriggerEl(scope),
          defer: true,
          onInteractOutside(event) {
            prop("onInteractOutside")?.(event);
            if (event.defaultPrevented) return;
            context.set("restoreFocus", !(event.detail.focusable || event.detail.contextmenu));
          },
          onPointerDownOutside: prop("onPointerDownOutside"),
          onFocusOutside: prop("onFocusOutside"),
          onDismiss() {
            send({ type: "INTERACT_OUTSIDE" });
          }
        });
      },
      trackFormControl({ context, scope, send }) {
        const inputEl = getHiddenInputEl(scope);
        return trackFormControl(inputEl, {
          onFieldsetDisabledChange(disabled) {
            context.set("fieldsetDisabled", disabled);
          },
          onFormReset() {
            send({ type: "VALUE.SET", value: context.initial("value"), src: "form.reset" });
          }
        });
      },
      trackPointerMove({ context, scope, event, send }) {
        return trackPointerMove(scope.getDoc(), {
          onPointerMove({ point }) {
            const type = context.get("activeId") === "area" ? "AREA.POINTER_MOVE" : "CHANNEL_SLIDER.POINTER_MOVE";
            send({ type, point, format: event.format });
          },
          onPointerUp() {
            const type = context.get("activeId") === "area" ? "AREA.POINTER_UP" : "CHANNEL_SLIDER.POINTER_UP";
            send({ type });
          }
        });
      },
      disableTextSelection({ scope }) {
        return disableTextSelection({
          doc: scope.getDoc(),
          target: getContentEl(scope)
        });
      }
    },
    actions: {
      openEyeDropper({ scope, context }) {
        const win = scope.getWin();
        const isSupported = "EyeDropper" in win;
        if (!isSupported) return;
        const picker = new win.EyeDropper();
        picker.open().then(({ sRGBHex }) => {
          const format = context.get("value").getFormat();
          const color = parseColor(sRGBHex).toFormat(format);
          context.set("value", color);
        }).catch(() => void 0);
      },
      setActiveChannel({ context, event }) {
        context.set("activeId", event.id);
        if (event.channel) context.set("activeChannel", event.channel);
        if (event.orientation) context.set("activeOrientation", event.orientation);
      },
      clearActiveChannel({ context }) {
        context.set("activeChannel", null);
        context.set("activeId", null);
        context.set("activeOrientation", null);
      },
      setAreaColorFromPoint({ context, event, computed, scope, prop }) {
        const v = event.format ? context.get("value").toFormat(event.format) : computed("areaValue");
        const { xChannel, yChannel } = event.channel || context.get("activeChannel");
        const percent = getAreaValueFromPoint(scope, event.point, prop("dir"));
        if (!percent) return;
        const xValue = v.getChannelPercentValue(xChannel, percent.x);
        const yValue = v.getChannelPercentValue(yChannel, 1 - percent.y);
        const color = v.withChannelValue(xChannel, xValue).withChannelValue(yChannel, yValue);
        context.set("value", color);
      },
      setChannelColorFromPoint({ context, event, computed, scope, prop }) {
        const channel = event.channel || context.get("activeId");
        const normalizedValue = event.format ? context.get("value").toFormat(event.format) : computed("areaValue");
        const percent = getChannelSliderValueFromPoint(scope, event.point, channel, prop("dir"));
        if (!percent) return;
        const orientation = context.get("activeOrientation") || "horizontal";
        const channelPercent = orientation === "horizontal" ? percent.x : percent.y;
        const value = normalizedValue.getChannelPercentValue(channel, channelPercent);
        const color = normalizedValue.withChannelValue(channel, value);
        context.set("value", color);
      },
      setValue({ context, event }) {
        context.set("value", event.value);
      },
      setFormat({ context, event }) {
        context.set("format", event.format);
      },
      dispatchChangeEvent({ scope, computed }) {
        dispatchInputValueEvent(getHiddenInputEl(scope), { value: computed("valueAsString") });
      },
      syncInputElements({ context, scope }) {
        syncChannelInputs(scope, context.get("value"));
      },
      invokeOnChangeEnd({ context, prop, computed }) {
        prop("onValueChangeEnd")?.({
          value: context.get("value"),
          valueAsString: computed("valueAsString")
        });
      },
      setChannelColorFromInput({ context, event, scope, prop }) {
        const { channel, isTextField, value } = event;
        const currentAlpha = context.get("value").getChannelValue("alpha");
        let color;
        if (channel === "alpha") {
          let valueAsNumber = parseFloat(value);
          valueAsNumber = Number.isNaN(valueAsNumber) ? currentAlpha : valueAsNumber;
          color = context.get("value").withChannelValue("alpha", valueAsNumber);
        } else if (isTextField) {
          color = tryCatch(
            () => {
              const parseValue = channel === "hex" ? prefixHex(value) : value;
              return parse(parseValue).withChannelValue("alpha", currentAlpha);
            },
            () => context.get("value")
          );
        } else {
          const current = context.get("value").toFormat(context.get("format"));
          const valueAsNumber = Number.isNaN(value) ? current.getChannelValue(channel) : value;
          color = current.withChannelValue(channel, valueAsNumber);
        }
        syncChannelInputs(scope, context.get("value"), color);
        context.set("value", color);
        prop("onValueChangeEnd")?.({
          value: color,
          valueAsString: color.toString(context.get("format"))
        });
      },
      incrementChannel({ context, event }) {
        const color = context.get("value").incrementChannel(event.channel, event.step);
        context.set("value", color);
      },
      decrementChannel({ context, event }) {
        const color = context.get("value").decrementChannel(event.channel, event.step);
        context.set("value", color);
      },
      incrementAreaXChannel({ context, event, computed }) {
        const { xChannel } = event.channel;
        const color = computed("areaValue").incrementChannel(xChannel, event.step);
        context.set("value", color);
      },
      decrementAreaXChannel({ context, event, computed }) {
        const { xChannel } = event.channel;
        const color = computed("areaValue").decrementChannel(xChannel, event.step);
        context.set("value", color);
      },
      incrementAreaYChannel({ context, event, computed }) {
        const { yChannel } = event.channel;
        const color = computed("areaValue").incrementChannel(yChannel, event.step);
        context.set("value", color);
      },
      decrementAreaYChannel({ context, event, computed }) {
        const { yChannel } = event.channel;
        const color = computed("areaValue").decrementChannel(yChannel, event.step);
        context.set("value", color);
      },
      setChannelToMax({ context, event }) {
        const value = context.get("value");
        const range = value.getChannelRange(event.channel);
        const color = value.withChannelValue(event.channel, range.maxValue);
        context.set("value", color);
      },
      setChannelToMin({ context, event }) {
        const value = context.get("value");
        const range = value.getChannelRange(event.channel);
        const color = value.withChannelValue(event.channel, range.minValue);
        context.set("value", color);
      },
      focusAreaThumb({ scope }) {
        raf(() => {
          getAreaThumbEl(scope)?.focus({ preventScroll: true });
        });
      },
      focusChannelThumb({ event, scope }) {
        raf(() => {
          getChannelSliderThumbEl(scope, event.channel)?.focus({ preventScroll: true });
        });
      },
      setInitialFocus({ prop, scope }) {
        if (!prop("openAutoFocus")) return;
        raf(() => {
          const element = getInitialFocus({
            root: getContentEl(scope),
            getInitialEl: prop("initialFocusEl")
          });
          element?.focus({ preventScroll: true });
        });
      },
      setReturnFocus({ scope }) {
        raf(() => {
          getTriggerEl(scope)?.focus({ preventScroll: true });
        });
      },
      syncFormatSelectElement({ context, scope }) {
        syncFormatSelect(scope, context.get("format"));
      },
      syncValueWithFormat({ context }) {
        const value = context.get("value");
        const newValue = value.toFormat(context.get("format"));
        if (newValue.isEqual(value)) return;
        context.set("value", newValue);
      },
      invokeOnOpen({ prop, context }) {
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: true, value: context.get("value") });
      },
      invokeOnClose({ prop, context }) {
        if (prop("inline")) return;
        prop("onOpenChange")?.({ open: false, value: context.get("value") });
      },
      toggleVisibility({ prop, event, send }) {
        send({ type: prop("open") ? "CONTROLLED.OPEN" : "CONTROLLED.CLOSE", previousEvent: event });
      }
    }
  }
});
function syncChannelInputs(scope, currentValue, nextValue) {
  const channelInputEls = getChannelInputEls(scope);
  raf(() => {
    channelInputEls.forEach((inputEl) => {
      const channel = inputEl.dataset.channel;
      setElementValue(inputEl, getChannelValue(nextValue || currentValue, channel));
    });
  });
}
function syncFormatSelect(scope, format) {
  const selectEl = getFormatSelectEl(scope);
  if (!selectEl) return;
  raf(() => setElementValue(selectEl, format));
}
var props = createProps()([
  "closeOnSelect",
  "dir",
  "disabled",
  "format",
  "defaultFormat",
  "getRootNode",
  "id",
  "ids",
  "initialFocusEl",
  "inline",
  "name",
  "positioning",
  "onFocusOutside",
  "onFormatChange",
  "onInteractOutside",
  "onOpenChange",
  "onPointerDownOutside",
  "onValueChange",
  "onValueChangeEnd",
  "defaultOpen",
  "open",
  "positioning",
  "required",
  "readOnly",
  "value",
  "defaultValue",
  "invalid",
  "openAutoFocus"
]);
var splitProps = createSplitProps(props);
var areaProps = createProps()(["xChannel", "yChannel"]);
var splitAreaProps = createSplitProps(areaProps);
var channelProps = createProps()(["channel", "orientation"]);
var splitChannelProps = createSplitProps(channelProps);
var swatchTriggerProps = createProps()(["value", "disabled"]);
var splitSwatchTriggerProps = createSplitProps(swatchTriggerProps);
var swatchProps = createProps()(["value", "respectAlpha"]);
var splitSwatchProps = createSplitProps(swatchProps);
var transparencyGridProps = createProps()(["size"]);
var splitTransparencyGridProps = createSplitProps(transparencyGridProps);

// components/color-picker.ts
var ColorPicker = class extends Component {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  initMachine(props2) {
    return new VanillaMachine(machine, props2);
  }
  initApi() {
    return connect(this.machine.service, normalizeProps);
  }
  render() {
    const rootEl = this.el.querySelector('[data-part="root"]');
    if (rootEl) this.spreadProps(rootEl, this.api.getRootProps());
    const labelEl = this.el.querySelector('[data-part="label"]');
    if (labelEl) this.spreadProps(labelEl, this.api.getLabelProps());
    const hiddenInputEl = this.el.querySelector('[data-part="hidden-input"]');
    if (hiddenInputEl) this.spreadProps(hiddenInputEl, this.api.getHiddenInputProps());
    const controlEl = this.el.querySelector('[data-part="control"]');
    if (controlEl) this.spreadProps(controlEl, this.api.getControlProps());
    const triggerEl = this.el.querySelector('[data-part="trigger"]');
    if (triggerEl) this.spreadProps(triggerEl, this.api.getTriggerProps());
    const triggerGrids = this.el.querySelectorAll(
      '[data-part="transparency-grid"][data-size="10px"]'
    );
    triggerGrids.forEach(
      (el) => this.spreadProps(el, this.api.getTransparencyGridProps({ size: "10px" }))
    );
    const triggerSwatch = triggerEl?.querySelector('[data-part="swatch"]');
    if (triggerSwatch)
      this.spreadProps(triggerSwatch, this.api.getSwatchProps({ value: this.api.value }));
    const hexInputs = this.el.querySelectorAll(
      '[data-part="channel-input"][data-channel="hex"]'
    );
    hexInputs.forEach(
      (el) => this.spreadProps(el, this.api.getChannelInputProps({ channel: "hex" }))
    );
    const alphaInputs = this.el.querySelectorAll(
      '[data-part="channel-input"][data-channel="alpha"]'
    );
    alphaInputs.forEach(
      (el) => this.spreadProps(el, this.api.getChannelInputProps({ channel: "alpha" }))
    );
    const positionerEl = this.el.querySelector('[data-part="positioner"]');
    if (positionerEl) this.spreadProps(positionerEl, this.api.getPositionerProps());
    const contentEl = this.el.querySelector('[data-part="content"]');
    if (contentEl) this.spreadProps(contentEl, this.api.getContentProps());
    const areaEl = this.el.querySelector('[data-part="area"]');
    if (areaEl) this.spreadProps(areaEl, this.api.getAreaProps());
    const areaBgEl = this.el.querySelector('[data-part="area-background"]');
    if (areaBgEl) this.spreadProps(areaBgEl, this.api.getAreaBackgroundProps());
    const areaThumbEl = this.el.querySelector('[data-part="area-thumb"]');
    if (areaThumbEl) this.spreadProps(areaThumbEl, this.api.getAreaThumbProps());
    const hueSliderEl = this.el.querySelector(
      '[data-part="channel-slider"][data-channel="hue"]'
    );
    if (hueSliderEl)
      this.spreadProps(hueSliderEl, this.api.getChannelSliderProps({ channel: "hue" }));
    const hueTrackEl = this.el.querySelector(
      '[data-part="channel-slider-track"][data-channel="hue"]'
    );
    if (hueTrackEl)
      this.spreadProps(hueTrackEl, this.api.getChannelSliderTrackProps({ channel: "hue" }));
    const hueThumbEl = this.el.querySelector(
      '[data-part="channel-slider-thumb"][data-channel="hue"]'
    );
    if (hueThumbEl)
      this.spreadProps(hueThumbEl, this.api.getChannelSliderThumbProps({ channel: "hue" }));
    const alphaSliderEl = this.el.querySelector(
      '[data-part="channel-slider"][data-channel="alpha"]'
    );
    if (alphaSliderEl)
      this.spreadProps(alphaSliderEl, this.api.getChannelSliderProps({ channel: "alpha" }));
    const alphaGrids = this.el.querySelectorAll(
      '[data-part="transparency-grid"][data-size="12px"]'
    );
    alphaGrids.forEach(
      (el) => this.spreadProps(el, this.api.getTransparencyGridProps({ size: "12px" }))
    );
    const alphaTrackEl = this.el.querySelector(
      '[data-part="channel-slider-track"][data-channel="alpha"]'
    );
    if (alphaTrackEl)
      this.spreadProps(alphaTrackEl, this.api.getChannelSliderTrackProps({ channel: "alpha" }));
    const alphaThumbEl = this.el.querySelector(
      '[data-part="channel-slider-thumb"][data-channel="alpha"]'
    );
    if (alphaThumbEl)
      this.spreadProps(alphaThumbEl, this.api.getChannelSliderThumbProps({ channel: "alpha" }));
    const redInputs = this.el.querySelectorAll(
      '[data-part="channel-input"][data-channel="red"]'
    );
    redInputs.forEach(
      (el) => this.spreadProps(el, this.api.getChannelInputProps({ channel: "red" }))
    );
    const greenInputs = this.el.querySelectorAll(
      '[data-part="channel-input"][data-channel="green"]'
    );
    greenInputs.forEach(
      (el) => this.spreadProps(el, this.api.getChannelInputProps({ channel: "green" }))
    );
    const blueInputs = this.el.querySelectorAll(
      '[data-part="channel-input"][data-channel="blue"]'
    );
    blueInputs.forEach(
      (el) => this.spreadProps(el, this.api.getChannelInputProps({ channel: "blue" }))
    );
    const swatchGroupEl = this.el.querySelector('[data-part="swatch-group"]');
    if (swatchGroupEl) this.spreadProps(swatchGroupEl, this.api.getSwatchGroupProps());
    const swatchTriggers = this.el.querySelectorAll(
      '[data-part="swatch-trigger"][data-value]'
    );
    swatchTriggers.forEach((trigger) => {
      const value = trigger.getAttribute("data-value");
      if (value) this.spreadProps(trigger, this.api.getSwatchTriggerProps({ value }));
      const swatchEl = trigger.querySelector('[data-part="swatch"][data-value]');
      if (swatchEl) {
        const swatchValue = swatchEl.getAttribute("data-value");
        if (swatchValue)
          this.spreadProps(swatchEl, this.api.getSwatchProps({ value: swatchValue }));
      }
    });
    const swatchGrids = this.el.querySelectorAll(
      '[data-part="transparency-grid"][data-size="var(--spacing-mini)"]'
    );
    swatchGrids.forEach(
      (el) => this.spreadProps(el, this.api.getTransparencyGridProps({ size: "var(--spacing-mini)" }))
    );
  }
};

// hooks/color-picker.ts
function parsePositioning(val) {
  if (!val) return void 0;
  try {
    return JSON.parse(val);
  } catch {
    return void 0;
  }
}
var ColorPickerHook = {
  mounted() {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const defaultVal = getString(el, "defaultValue");
    const valueVal = getString(el, "value");
    const zag = new ColorPicker(el, {
      id: el.id,
      ...controlled ? { value: valueVal ? parse(valueVal) : void 0 } : { defaultValue: defaultVal ? parse(defaultVal) : void 0 },
      name: getString(el, "name") ?? el.id,
      format: getString(el, "format", [
        "rgba",
        "hsla",
        "hsba",
        "hex"
      ]) ?? "rgba",
      defaultFormat: getString(el, "defaultFormat", [
        "rgba",
        "hsla",
        "hsba",
        "hex"
      ]),
      closeOnSelect: getBoolean(el, "closeOnSelect") !== false,
      ...controlled ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") },
      openAutoFocus: getBoolean(el, "openAutoFocus") !== false,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: parsePositioning(el.dataset.positioning),
      onValueChange: (details) => {
        const eventName = getString(el, "onValueChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            valueAsString: details.valueAsString,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      },
      onValueChangeEnd: (details) => {
        const eventName = getString(el, "onValueChangeEnd");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, {
            valueAsString: details.valueAsString,
            id: el.id
          });
        }
        const eventNameClient = getString(el, "onValueChangeEndClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { value: details, id: el.id }
            })
          );
        }
      },
      onOpenChange: (details) => {
        const eventName = getString(el, "onOpenChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { open: details.open, id: el.id });
        }
        const eventNameClient = getString(el, "onOpenChangeClient");
        if (eventNameClient) {
          el.dispatchEvent(
            new CustomEvent(eventNameClient, {
              bubbles: true,
              detail: { open: details.open, id: el.id }
            })
          );
        }
      },
      onFormatChange: (details) => {
        const eventName = getString(el, "onFormatChange");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { format: details.format, id: el.id });
        }
      },
      onPointerDownOutside: () => {
        const eventName = getString(el, "onPointerDownOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      },
      onFocusOutside: () => {
        const eventName = getString(el, "onFocusOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      },
      onInteractOutside: () => {
        const eventName = getString(el, "onInteractOutside");
        if (eventName && !this.liveSocket.main.isDead && this.liveSocket.main.isConnected()) {
          this.pushEvent(eventName, { id: el.id });
        }
      }
    });
    zag.init();
    this.colorPicker = zag;
    this.handlers = [];
    this.onSetOpen = (event) => {
      const { open } = event.detail;
      zag.api.setOpen(open);
    };
    el.addEventListener("phx:color-picker:set-open", this.onSetOpen);
    this.onSetValue = (event) => {
      const { value } = event.detail;
      zag.api.setValue(value);
    };
    el.addEventListener("phx:color-picker:set-value", this.onSetValue);
    this.onSetFormat = (event) => {
      const { format } = event.detail;
      zag.api.setFormat(format);
    };
    el.addEventListener("phx:color-picker:set-format", this.onSetFormat);
    this.handlers.push(
      this.handleEvent(
        "color_picker_set_open",
        (payload) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setOpen(payload.open);
        }
      )
    );
    this.handlers.push(
      this.handleEvent(
        "color_picker_set_value",
        (payload) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setValue(payload.value);
        }
      )
    );
    this.handlers.push(
      this.handleEvent(
        "color_picker_set_format",
        (payload) => {
          const targetId = payload.color_picker_id;
          if (targetId) {
            const matches = el.id === targetId || el.id === `color-picker:${targetId}`;
            if (!matches) return;
          }
          zag.api.setFormat(payload.format);
        }
      )
    );
  },
  updated() {
    const el = this.el;
    const controlled = getBoolean(el, "controlled");
    const defaultVal = getString(el, "defaultValue");
    const valueVal = getString(el, "value");
    this.colorPicker?.updateProps({
      ...controlled ? { value: valueVal ? parse(valueVal) : void 0 } : { defaultValue: defaultVal ? parse(defaultVal) : void 0 },
      name: getString(el, "name") ?? el.id,
      format: getString(el, "format", [
        "rgba",
        "hsla",
        "hsba",
        "hex"
      ]) ?? "rgba",
      defaultFormat: getString(el, "defaultFormat", [
        "rgba",
        "hsla",
        "hsba",
        "hex"
      ]),
      closeOnSelect: getBoolean(el, "closeOnSelect") !== false,
      ...controlled ? { open: getBoolean(el, "open") } : { defaultOpen: getBoolean(el, "defaultOpen") },
      openAutoFocus: getBoolean(el, "openAutoFocus") !== false,
      disabled: getBoolean(el, "disabled"),
      invalid: getBoolean(el, "invalid"),
      readOnly: getBoolean(el, "readOnly"),
      required: getBoolean(el, "required"),
      dir: getDir(el),
      positioning: parsePositioning(el.dataset.positioning)
    });
  },
  destroyed() {
    if (this.onSetOpen) {
      this.el.removeEventListener("phx:color-picker:set-open", this.onSetOpen);
    }
    if (this.onSetValue) {
      this.el.removeEventListener("phx:color-picker:set-value", this.onSetValue);
    }
    if (this.onSetFormat) {
      this.el.removeEventListener("phx:color-picker:set-format", this.onSetFormat);
    }
    if (this.handlers) {
      for (const h of this.handlers) {
        this.removeHandleEvent(h);
      }
    }
    this.colorPicker?.destroy();
  }
};
export {
  ColorPickerHook as ColorPicker
};
