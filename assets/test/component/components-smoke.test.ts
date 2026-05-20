import { describe, expect, it } from "vitest";
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
import { Switch } from "../../components/switch";
import { Tabs } from "../../components/tabs";
import { TagsInput } from "../../components/tags-input";
import { Timer } from "../../components/timer";
import { createStore } from "@zag-js/toast";
import { ToastGroup } from "../../components/toast";
import { ToggleGroup } from "../../components/toggle-group";
import { Toggle } from "../../components/toggle";
import { Tooltip } from "../../components/tooltip";
import type { Props as ToggleProps } from "@zag-js/toggle";
import { TreeView } from "../../components/tree-view";
import { collection } from "@zag-js/listbox";
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
  editableTree,
  fileUploadTree,
  floatingPanelTree,
  listboxTree,
  marqueeTree,
  menuTree,
  numberInputTree,
  paginationTree,
  passwordInputTree,
  pinInputTree,
  radioGroupTree,
  sampleTreeRoot,
  selectTree,
  signaturePadTree,
  smokeId,
  tabsTree,
  tagsInputTree,
  timerTree,
  toggleGroupTree,
  toggleInputTree,
  toggleTree,
  tooltipTree,
  treeViewTree,
  withId,
} from "../helpers/component-smoke";

function smoke(
  name: string,
  run: () => { render: () => void; init?: () => void; destroy?: () => void }
) {
  it(`${name} render() does not throw`, () => {
    const inst = run();
    expect(() => inst.render()).not.toThrow();
    inst.destroy?.();
  });
}

function smokeInit(name: string, run: () => { init: () => void; destroy?: () => void }) {
  it(`${name} init() does not throw`, () => {
    const inst = run();
    expect(() => inst.init()).not.toThrow();
    inst.destroy?.();
  });
}

describe("component render smoke", () => {
  smoke("Accordion", () => {
    const el = accordionTree();
    const c = new Accordion(el, { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("AngleSlider", () => {
    const c = new AngleSlider(angleSliderTree(), { id: smokeId, defaultValue: 0 });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Avatar", () => {
    const c = new Avatar(avatarTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Carousel", () => {
    const c = new Carousel(carouselTree(2), { id: smokeId, slideCount: 2, defaultPage: 0 });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Checkbox", () => {
    const c = new Checkbox(toggleInputTree("checkbox"), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Clipboard", () => {
    const c = new Clipboard(clipboardTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Collapsible", () => {
    const c = new Collapsible(collapsibleTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("ColorPicker", () => {
    const c = new ColorPicker(colorPickerTree(), {
      id: smokeId,
      defaultValue: parseColor("#ff0000"),
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Combobox", () => {
    const c = new Combobox(
      comboboxTree(),
      { id: smokeId },
      [{ label: "One", value: "one" }],
      false
    );
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("DatePicker", () => {
    const c = new DatePicker(withId(document.createElement("div")), {
      id: smokeId,
      selectionMode: "single",
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Dialog", () => {
    const c = new Dialog(dialogTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Editable", () => {
    const c = new Editable(editableTree(), { id: smokeId, defaultValue: "text" });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("FileUpload", () => {
    const c = new FileUpload(fileUploadTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("FloatingPanel", () => {
    const c = new FloatingPanel(floatingPanelTree(), { id: smokeId, defaultOpen: false });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Listbox", () => {
    const items: ValueLabelItem[] = [{ label: "A", value: "a" }];
    const c = new Listbox(listboxTree(), {
      id: smokeId,
      collection: collection(zagListCollectionConfig(items, false)),
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Marquee", () => {
    const c = new Marquee(marqueeTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Menu", () => {
    const c = new Menu(menuTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("NumberInput", () => {
    const c = new NumberInput(numberInputTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Pagination", () => {
    const c = new Pagination(paginationTree(), {
      id: smokeId,
      count: 20,
      page: 1,
      pageSize: 10,
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("PasswordInput", () => {
    const c = new PasswordInput(passwordInputTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("PinInput", () => {
    const c = new PinInput(pinInputTree(), { id: smokeId, count: 4 });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("RadioGroup", () => {
    const c = new RadioGroup(radioGroupTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Select", () => {
    const items: ValueLabelItem[] = [{ label: "A", value: "a" }];
    const c = new Select(selectTree(), {
      id: smokeId,
      collection: collection(zagListCollectionConfig(items, false)),
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("SignaturePad", () => {
    const c = new SignaturePad(signaturePadTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Switch", () => {
    const c = new Switch(toggleInputTree("switch"), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Tabs", () => {
    const c = new Tabs(tabsTree(), { id: smokeId, defaultValue: "home" });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("TagsInput", () => {
    const c = new TagsInput(tagsInputTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Timer", () => {
    const c = new Timer(timerTree(), {
      id: smokeId,
      countdown: true,
      startMs: 60_000,
      autoStart: false,
    });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("ToastGroup", () => {
    const container = withId(document.createElement("div"));
    const store = createStore({ placement: "bottom" });
    const c = new ToastGroup(container, { id: smokeId, store });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Toggle", () => {
    const c = new Toggle(toggleTree(), { id: smokeId } as unknown as ToggleProps);
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("ToggleGroup", () => {
    const c = new ToggleGroup(toggleGroupTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("Tooltip", () => {
    const c = new Tooltip(tooltipTree(), { id: smokeId });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });

  smoke("TreeView", () => {
    const c = new TreeView(treeViewTree(), { id: smokeId, rootNode: sampleTreeRoot });
    return { render: () => c.render(), destroy: () => c.destroy() };
  });
});

describe("component init smoke", () => {
  smokeInit("Checkbox", () => {
    const c = new Checkbox(toggleInputTree("checkbox"), { id: smokeId });
    return { init: () => c.init(), destroy: () => c.destroy() };
  });

  smokeInit("Tabs", () => {
    const c = new Tabs(tabsTree(), { id: smokeId, defaultValue: "home" });
    return { init: () => c.init(), destroy: () => c.destroy() };
  });

  smokeInit("Dialog", () => {
    const c = new Dialog(dialogTree(), { id: smokeId });
    return { init: () => c.init(), destroy: () => c.destroy() };
  });

  smokeInit("Carousel", () => {
    const c = new Carousel(carouselTree(2), { id: smokeId, slideCount: 2, defaultPage: 0 });
    return { init: () => c.init(), destroy: () => c.destroy() };
  });
});
