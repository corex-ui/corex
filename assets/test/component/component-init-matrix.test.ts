import { describe, expect, it } from "vitest";
import { collection } from "@zag-js/listbox";
import { createStore } from "@zag-js/toast";
import { Accordion } from "../../components/accordion";
import { AngleSlider } from "../../components/angle-slider";
import { Avatar } from "../../components/avatar";
import { Carousel } from "../../components/carousel";
import { Checkbox } from "../../components/checkbox";
import { Clipboard } from "../../components/clipboard";
import { Collapsible } from "../../components/collapsible";
import { ColorPicker, parse as parseColor } from "../../components/color-picker";
import { Combobox } from "../../components/combobox";
import { DatePicker } from "../../components/date-picker";
import { Dialog } from "../../components/dialog";
import { Drawer } from "../../components/drawer";
import { HoverCard } from "../../components/hover-card";
import { Popover } from "../../components/popover";
import { Editable } from "../../components/editable";
import { FileUpload } from "../../components/file-upload";
import { FloatingPanel } from "../../components/floating-panel";
import { Listbox } from "../../components/listbox";
import { Marquee } from "../../components/marquee";
import { Menu } from "../../components/menu";
import { NumberInput } from "../../components/number-input";
import { Pagination } from "../../components/pagination";
import { PasswordInput } from "../../components/password-input";
import { PinInput } from "../../components/pin-input";
import { RadioGroup } from "../../components/radio-group";
import { Select } from "../../components/select";
import { SignaturePad } from "../../components/signature-pad";
import { Slider } from "../../components/slider";
import { Switch } from "../../components/switch";
import { Tabs } from "../../components/tabs";
import { TagsInput } from "../../components/tags-input";
import { Timer } from "../../components/timer";
import { ToastGroup } from "../../components/toast";
import { ToggleGroup } from "../../components/toggle-group";
import { Toggle } from "../../components/toggle";
import { Tooltip } from "../../components/tooltip";
import type { Props as ToggleProps } from "@zag-js/toggle";
import { TreeView } from "../../components/tree-view";
import { Progress } from "../../components/progress";
import { RatingGroup } from "../../components/rating-group";
import { Steps } from "../../components/steps";
import { QrCode } from "../../components/qr-code";
import { Presence } from "../../components/presence";
import { Splitter } from "../../components/splitter";
import { ScrollArea } from "../../components/scroll-area";
import { Toc } from "../../components/toc";
import { DateInput } from "../../components/date-input";
import { ImageCropper } from "../../components/image-cropper";
import { NavigationMenu } from "../../components/navigation-menu";
import { CascadeSelect } from "../../components/cascade-select";
import { Tour } from "../../components/tour";
import { zagListCollectionConfig, type ValueLabelItem } from "../../lib/list-collection";
import {
  accordionTree,
  angleSliderTree,
  avatarTree,
  carouselTree,
  clipboardTree,
  collapsibleTree,
  colorPickerTree,
  comboboxTree,
  dialogTree,
  drawerTree,
  editableTree,
  hoverCardTree,
  fileUploadTree,
  floatingPanelTree,
  listboxTree,
  menuTree,
  numberInputTree,
  paginationTree,
  passwordInputTree,
  pinInputTree,
  popoverTree,
  radioGroupTree,
  sampleTreeRoot,
  selectTree,
  signaturePadTree,
  sliderTree,
  tabsTree,
  tagsInputTree,
  timerTree,
  toggleGroupTree,
  toggleInputTree,
  toggleTree,
  tooltipTree,
  treeViewTree,
  progressTree,
  ratinggroupTree,
  stepsTree,
  qrcodeTree,
  presenceTree,
  splitterTree,
  scrollareaTree,
  tocTree,
  dateinputTree,
  imagecropperTree,
  navigationmenuTree,
  cascadeselectTree,
  tourTree,
} from "../helpers/component-smoke";
import { runInitDestroy } from "../helpers/component-runner";

const items: ValueLabelItem[] = [{ label: "A", value: "a" }];
const listCollection = () => collection(zagListCollectionConfig(items, false));

type Factory = () => { init: () => void; destroy: () => void };

const cases: [string, Factory][] = [
  [
    "Accordion",
    () => {
      const el = accordionTree();
      const c = new Accordion(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Accordion multiple",
    () => {
      const el = accordionTree();
      const c = new Accordion(el, { id: el.id, multiple: true });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "AngleSlider",
    () => {
      const el = angleSliderTree();
      const c = new AngleSlider(el, { id: el.id, defaultValue: 0 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "AngleSlider 90",
    () => {
      const el = angleSliderTree();
      const c = new AngleSlider(el, { id: el.id, defaultValue: 90 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Avatar",
    () => {
      const el = avatarTree();
      const c = new Avatar(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Carousel",
    () => {
      const el = carouselTree(2);
      const c = new Carousel(el, { id: el.id, slideCount: 2, defaultPage: 0 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Carousel loop",
    () => {
      const el = carouselTree(3);
      const c = new Carousel(el, { id: el.id, slideCount: 3, loop: true, defaultPage: 1 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Checkbox",
    () => {
      const el = toggleInputTree("checkbox");
      const c = new Checkbox(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Checkbox checked",
    () => {
      const el = toggleInputTree("checkbox");
      const c = new Checkbox(el, { id: el.id, defaultChecked: true });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Clipboard",
    () => {
      const el = clipboardTree();
      const c = new Clipboard(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Collapsible",
    () => {
      const el = collapsibleTree();
      const c = new Collapsible(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Collapsible open",
    () => {
      const el = collapsibleTree();
      const c = new Collapsible(el, { id: el.id, defaultOpen: true });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "ColorPicker",
    () => {
      const el = colorPickerTree();
      const c = new ColorPicker(el, { id: el.id, defaultValue: parseColor("#000") });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Combobox",
    () => {
      const el = comboboxTree();
      const c = new Combobox(el, { id: el.id }, items, false);
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "DatePicker",
    () => {
      const el = document.createElement("div");
      el.id = "dp";
      const c = new DatePicker(el, { id: el.id, selectionMode: "single" });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Dialog",
    () => {
      const el = dialogTree();
      const c = new Dialog(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Drawer",
    () => {
      const el = drawerTree();
      const c = new Drawer(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "HoverCard",
    () => {
      const el = hoverCardTree();
      const c = new HoverCard(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Popover",
    () => {
      const el = popoverTree();
      const c = new Popover(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Editable",
    () => {
      const el = editableTree();
      const c = new Editable(el, { id: el.id, defaultValue: "x" });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "FileUpload",
    () => {
      const el = fileUploadTree();
      const c = new FileUpload(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "FloatingPanel",
    () => {
      const el = floatingPanelTree();
      const c = new FloatingPanel(el, { id: el.id, defaultOpen: false });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Listbox",
    () => {
      const el = listboxTree();
      const c = new Listbox(el, { id: el.id, collection: listCollection() });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Marquee",
    () => {
      const el = document.createElement("div");
      el.id = "mq";
      el.innerHTML = `<div data-scope="marquee" data-part="root"><div data-part="viewport"><div data-part="content"></div></div></div>`;
      const c = new Marquee(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Menu",
    () => {
      const el = menuTree();
      const c = new Menu(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "NumberInput",
    () => {
      const el = numberInputTree();
      const c = new NumberInput(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Pagination",
    () => {
      const el = paginationTree();
      const c = new Pagination(el, { id: el.id, count: 50, page: 1, pageSize: 10 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "PasswordInput",
    () => {
      const el = passwordInputTree();
      const c = new PasswordInput(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "PinInput",
    () => {
      const el = pinInputTree(4);
      const c = new PinInput(el, { id: el.id, count: 4 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "RadioGroup",
    () => {
      const el = radioGroupTree();
      const c = new RadioGroup(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Select",
    () => {
      const el = selectTree();
      const c = new Select(el, { id: el.id, collection: listCollection() });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "SignaturePad",
    () => {
      const el = signaturePadTree();
      const c = new SignaturePad(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Slider",
    () => {
      const el = sliderTree();
      const c = new Slider(el, { id: el.id, defaultValue: [0] });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Slider range",
    () => {
      const el = sliderTree(2);
      const c = new Slider(el, { id: el.id, defaultValue: [20, 80] });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Switch",
    () => {
      const el = toggleInputTree("switch");
      const c = new Switch(el, { id: el.id, defaultChecked: true });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Tabs",
    () => {
      const el = tabsTree();
      const c = new Tabs(el, { id: el.id, defaultValue: "home" });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "TagsInput",
    () => {
      const el = tagsInputTree();
      const c = new TagsInput(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Timer countdown",
    () => {
      const el = timerTree();
      const c = new Timer(el, { id: el.id, countdown: true, startMs: 30_000, autoStart: false });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "ToastGroup",
    () => {
      const el = document.createElement("div");
      el.id = "tg";
      const store = createStore({ placement: "bottom" });
      const c = new ToastGroup(el, { id: el.id, store });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Toggle",
    () => {
      const el = toggleTree();
      const c = new Toggle(el, { id: el.id } as unknown as ToggleProps);
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "ToggleGroup",
    () => {
      const el = toggleGroupTree();
      const c = new ToggleGroup(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Tooltip",
    () => {
      const el = tooltipTree();
      const c = new Tooltip(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "TreeView",
    () => {
      const el = treeViewTree();
      const c = new TreeView(el, { id: el.id, rootNode: sampleTreeRoot });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Progress",
    () => {
      const el = progressTree();
      const c = new Progress(el, { id: el.id, defaultValue: 40 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "RatingGroup",
    () => {
      const el = ratinggroupTree();
      const c = new RatingGroup(el, { id: el.id, count: 5 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Steps",
    () => {
      const el = stepsTree();
      const c = new Steps(el, { id: el.id, count: 3 });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "QrCode",
    () => {
      const el = qrcodeTree();
      const c = new QrCode(el, { id: el.id, defaultValue: "https://zagjs.com" });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Presence",
    () => {
      const el = presenceTree();
      const c = new Presence(el, { present: true });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Splitter",
    () => {
      const el = splitterTree();
      const c = new Splitter(el, {
        id: el.id,
        panels: [{ id: "a" }, { id: "b" }],
        defaultSize: [50, 50],
      });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "ScrollArea",
    () => {
      const el = scrollareaTree();
      const c = new ScrollArea(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Toc",
    () => {
      const el = tocTree();
      const c = new Toc(el, { id: el.id, items: [{ value: "intro", depth: 2 }] });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "DateInput",
    () => {
      const el = dateinputTree();
      const c = new DateInput(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "ImageCropper",
    () => {
      const el = imagecropperTree();
      const c = new ImageCropper(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "NavigationMenu",
    () => {
      const el = navigationmenuTree();
      const c = new NavigationMenu(el, { id: el.id });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "CascadeSelect",
    () => {
      const el = cascadeselectTree();
      const c = new CascadeSelect(el, {
        id: el.id,
        rootNode: { value: "root", label: "root", children: [{ value: "a", label: "A" }] },
      });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
  [
    "Tour",
    () => {
      Object.defineProperty(window, "visualViewport", {
        configurable: true,
        value: {
          width: 1024,
          height: 768,
          offsetLeft: 0,
          offsetTop: 0,
          addEventListener() {},
          removeEventListener() {},
        },
      });
      const el = tourTree();
      const c = new Tour(el, {
        id: el.id,
        steps: [{ id: "start", type: "dialog", title: "Hi", description: "There" }],
      });
      return { init: () => c.init(), destroy: () => c.destroy() };
    },
  ],
];

describe.each(cases)("%s init", (_name, factory) => {
  it("does not throw", () => {
    expect(() => runInitDestroy(factory)).not.toThrow();
  });
});
