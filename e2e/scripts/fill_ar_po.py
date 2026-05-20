#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

PO_PATH = Path(__file__).resolve().parents[1] / "priv/gettext/ar/LC_MESSAGES/default.po"

COMPONENTS = {
    "Accordion": "الأكورديون",
    "Action": "الإجراء",
    "Angle Slider": "منزلق الزاوية",
    "Angle slider": "منزلق الزاوية",
    "Avatar": "الصورة الرمزية",
    "Carousel": "العرض الدوار",
    "Checkbox": "مربع الاختيار",
    "Clipboard": "الحافظة",
    "Collapsible": "القسم القابل للطي",
    "Code": "الكود",
    "Color picker": "منتقي الألوان",
    "Color Picker": "منتقي الألوان",
    "Combobox": "صندوق التحرير والسرد",
    "Data list": "قائمة البيانات",
    "Data List": "قائمة البيانات",
    "Data table": "جدول البيانات",
    "Data Table": "جدول البيانات",
    "Date picker": "منتقي التاريخ",
    "Date Picker": "منتقي التاريخ",
    "Dialog": "مربع الحوار",
    "Editable": "الحقل القابل للتحرير",
    "File upload": "رفع الملفات",
    "File Upload": "رفع الملفات",
    "File upload live": "رفع الملفات (مباشر)",
    "Floating panel": "اللوحة العائمة",
    "Floating Panel": "اللوحة العائمة",
    "Layout heading": "عنوان التخطيط",
    "Layout Heading": "عنوان التخطيط",
    "Listbox": "صندوق القائمة",
    "Marquee": "الشريط المتحرك",
    "Menu": "القائمة",
    "Native input": "إدخال HTML أصلي",
    "Native Input": "إدخال HTML أصلي",
    "Navigate": "التنقل",
    "Number input": "إدخال الأرقام",
    "Number Input": "إدخال الأرقام",
    "Password input": "إدخال كلمة المرور",
    "Password Input": "إدخال كلمة المرور",
    "Pin input": "إدخال الرمز",
    "Pin Input": "إدخال الرمز",
    "Radio group": "مجموعة أزرار الاختيار",
    "Radio Group": "مجموعة أزرار الاختيار",
    "Select": "القائمة المنسدلة",
    "Signature pad": "لوحة التوقيع",
    "Signature Pad": "لوحة التوقيع",
    "Switch": "المفتاح",
    "Tabs": "علامات التبويب",
    "Tags input": "إدخال الوسوم",
    "Tags Input": "إدخال الوسوم",
    "Timer": "المؤقت",
    "Toast": "الإشعار المنبثق",
    "Pagination": "ترقيم الصفحات",
    "Toggle": "التبديل",
    "Toggle group": "مجموعة التبديل",
    "Toggle Group": "مجموعة التبديل",
    "Tooltip": "تلميح الأداة",
    "Tree view": "عرض الشجرة",
    "Tree View": "عرض الشجرة",
}

SUFFIX = {
    "Anatomy": "البنية",
    "Playground": "ساحة التجربة",
    "API": "API",
    "Event": "الحدث",
    "Pattern": "النمط",
    "Animation": "الحركة",
    "Style": "النمط البصري",
    "Styling": "التنسيق",
    "Form": "النموذج",
    "form": "النموذج",
}

EXACT = {
    "Components": "المكوّنات",
    "Display settings": "إعدادات العرض",
    "Documentation": "التوثيق",
    "Interactive preview": "معاينة تفاعلية",
    "Main": "الرئيسية",
    "Previous page": "الصفحة السابقة",
    "Select a country": "اختر دولة",
    "We lost the connection": "فُقد الاتصال",
    "We're trying to reconnect you...": "نحاول إعادة الاتصال بك...",
    "MCP": "MCP",
    "Browse components": "تصفّح المكوّنات",
    "Visit Hexdocs": "زيارة Hexdocs",
    "Blog": "المدونة",
    "No posts yet.": "لا توجد مقالات بعد.",
    "Post not found": "المقالة غير موجودة",
    "Home": "الرئيسية",
    "Articles about Corex, Phoenix LiveView, accessibility, and UI development.": "مقالات حول Corex وPhoenix LiveView وإمكانية الوصول وتطوير واجهات المستخدم.",
    "Dark Mode": "الوضع الداكن",
    "Installation": "التثبيت",
    "Localize": "التوطين",
    "Theming": "السمات",
    "Corex by the numbers": "Corex بالأرقام",
    "Star on GitHub": "تألّق على GitHub",
    "Templates": "القوالب",
    "Templates · Corex": "القوالب · Corex",
    "Corex Links": "روابط Corex",
    "GitHub": "GitHub",
    "Live demo": "عرض مباشر",
    "Soonex preview slides": "شرائح معاينة Soonex",
    "Hero section": "قسم البطل",
    "Highlights section": "قسم أبرز النقاط",
    "Locales & RTL": "اللغات واتجاه RTL",
    "Soonex": "Soonex",
    "Soonex i18n": "Soonex i18n",
    "Soonex i18n preview slides": "شرائح معاينة Soonex i18n",
    "Starter kit": "مجموعة البداية",
    "Static Tableau starters with Corex": "بدايات Tableau ثابتة مع Corex",
    "Waitlist section": "قسم قائمة الانتظار",
    "Search currency": "ابحث عن العملة",
    "%{a_name} (%{a_iata_code})": "%{a_name} (%{a_iata_code})",
    "API": "API",
    "API & Events": "API والأحداث",
    "Accent": "بارز",
    "Accessible by default.": "يمكن الوصول إليه افتراضيًا.",
    "Actions": "الإجراءات",
    "Alert": "تنبيه",
    "Anatomy": "البنية",
    "Anatomy & slots": "البنية والفتحات",
    "Animation": "الحركة",
    "Apple": "Apple",
    "Async": "غير متزامن",
    "Australian Dollar": "دولار أسترالي",
    "Playground": "ساحة التجربة",
    "Pattern": "النمط",
    "Event": "الحدث",
    "Style": "النمط البصري",
    "Form": "النموذج",
    "Disabled": "معطّل",
    "Enabled": "مفعّل",
    "Invalid": "غير صالح",
    "Read only": "للقراءة فقط",
    "Read-only": "للقراءة فقط",
    "Multiple": "متعدد",
    "Single": "مفرد",
    "Clear": "مسح",
    "Reset": "إعادة تعيين",
    "Submit": "إرسال",
    "Cancel": "إلغاء",
    "Close": "إغلاق",
    "Open": "فتح",
    "Save": "حفظ",
    "Delete": "حذف",
    "Edit": "تحرير",
    "Copy": "نسخ",
    "Copied": "تم النسخ",
    "Loading": "جارٍ التحميل",
    "Loading...": "جارٍ التحميل...",
    "Error": "خطأ",
    "Success": "نجاح",
    "Warning": "تحذير",
    "Info": "معلومات",
    "Default": "افتراضي",
    "Primary": "أساسي",
    "Secondary": "ثانوي",
    "Muted": "باهت",
    "Neutral": "محايد",
    "Danger": "خطر",
    "Small": "صغير",
    "Medium": "متوسط",
    "Large": "كبير",
    "XL": "كبير جدًا",
    "SM": "ص",
    "MD": "م",
    "LG": "ك",
    "LTR": "من اليسار لليمين",
    "RTL": "من اليمين لليسار",
    "Left": "يسار",
    "Right": "يمين",
    "Top": "أعلى",
    "Bottom": "أسفل",
    "Center": "وسط",
    "Horizontal": "أفقي",
    "Vertical": "عمودي",
    "Inline": "مضمّن",
    "Block": "كتلة",
    "Controlled": "مُتحكَّم به",
    "Uncontrolled": "غير مُتحكَّم به",
    "Controlled value": "قيمة مُتحكَّم بها",
    "Event log": "سجل الأحداث",
    "Events": "الأحداث",
    "Patterns": "الأنماط",
    "Styling": "التنسيق",
    "Zag.js": "Zag.js",
    "Phoenix": "Phoenix",
    "Corex": "Corex",
    "LiveView": "LiveView",
    "JavaScript": "JavaScript",
    "Controller": "المتحكّم",
    "CustomEvent": "CustomEvent",
    "Page not found": "الصفحة غير موجودة",
    "The page you were looking for doesn't exist.": "الصفحة التي تبحث عنها غير موجودة.",
    "Something went wrong": "حدث خطأ ما",
    "Try again": "أعد المحاولة",
    "Skip to content": "تخطي إلى المحتوى",
    "Color mode": "وضع الألوان",
    "Toggle color mode": "تبديل وضع الألوان",
    "Language": "اللغة",
    "Theme": "المظهر",
    "Mode": "الوضع",
    "English": "الإنجليزية",
    "Arabic": "العربية",
    "French": "الفرنسية",
    "in one command.": "في أمر واحد.",
    "Zag.js powers accessibility, keyboard, and focus.": "Zag.js يدير إمكانية الوصول ولوحة المفاتيح والتركيز.",
    "Works in Controller and Live View": "يعمل في المتحكّم وLiveView",
    "Production-ready coming-soon sites: Tableau export, shared tokens, Markdown posts, and Corex components. Choose English-first Soonex or Soonex i18n with locales and RTL.": "مواقع «قريبًا» جاهزة للإنتاج: تصدير Tableau، رموز مشتركة، مقالات Markdown، ومكوّنات Corex. اختر Soonex بالإنجليزية أو Soonex i18n مع اللغات واتجاه RTL.",
    "Same Soonex surface with Gettext and Localize: Arabic, English, and French out of the box, RTL-aware controls, and the same static build pipeline.": "نفس واجهة Soonex مع Gettext وLocalize: العربية والإنجليزية والفرنسية جاهزة، عناصر تحكم تدعم RTL، ونفس خط أنابيب البناء الثابت.",
    "Single-locale coming-soon layout with Neo through Leo themes, Markdown journal, waitlist, and static assets sized for GitHub Pages or any CDN.": "تخطيط «قريبًا» بلغة واحدة مع سمات Neo إلى Leo، يوميات Markdown، قائمة انتظار، وأصول ثابتة مناسبة لـ GitHub Pages أو أي CDN.",
    "Bring your own CSS or opt into Corex Design tokens, themes and modes.": "استخدم CSS الخاص بك أو فعّل رموز Corex Design والسمات والأوضاع.",
    "Built-in JS animation, instant mode, and custom Motion-driven transitions.": "حركة JS مدمجة، وضع فوري، وانتقالات مخصّصة عبر Motion.",
    "Corex generator wires up the dependency, the design tokens and the assets pipeline for you.": "مولّد Corex يربط الاعتمادية ورموز التصميم وخط أصول المشروع.",
    "Declarative LiveView attrs, server pushEvent logs, and client CustomEvent listeners.": "سمات LiveView تصريحية، سجلات pushEvent من الخادم، ومستمعو CustomEvent على العميل.",
    "Drive every component from LiveView or JavaScript and listen back from either side.": "تحكّم بكل مكوّن من LiveView أو JavaScript واستمع من أي جانب.",
    "Async loading, controlled state, and redirect navigation.": "تحميل غير متزامن، حالة مُتحكَّم بها، وتنقل بإعادة التوجيه.",
    "Async loading, controlled state, and streaming items.": "تحميل غير متزامن، حالة مُتحكَّم بها، وعناصر متدفقة.",
    "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.": "نص تجريبي لعرض التخطيط.",
    "Column slots, an optional action column, and the empty state.": "فتحات الأعمدة، عمود إجراء اختياري، والحالة الفارغة.",
    "Control and interact with the accordion from LiveView or the client.": "تحكّم وتفاعل مع الأكورديون من LiveView أو العميل.",
    "Controller-rendered form; the hidden input submits the pin string.": "نموذج يعرضه المتحكّم؛ الإدخال المخفي يرسل سلسلة الرمز.",
    "Default structure, indicator, error slot, and indeterminate state.": "البنية الافتراضية، المؤشر، فتحة الخطأ، والحالة غير المحددة.",
    "Density and trigger colors via modifier classes on the collapsible root.": "الكثافة وألوان المشغّل عبر فئات المعدّل على جذر القسم القابل للطي.",
    "Density and width via modifier classes on the clipboard root.": "الكثافة والعرض عبر فئات المعدّل على جذر الحافظة.",
    "Explore the default structure, slot customization, and compound mode for the angle slider.": "استكشف البنية الافتراضية وتخصيص الفتحات والوضع المركّب لمنزلق الزاوية.",
    "Explore the structure, custom slots, manual slots and compound mode": "استكشف البنية والفتحات المخصّصة والفتحات اليدوية والوضع المركّب",
    "Explore the structure, indicator, custom slots and compound mode": "استكشف البنية والمؤشر والفتحات المخصّصة والوضع المركّب",
    "Image slides, custom content with links, and compound layout.": "شرائح صور، محتوى مخصّص بروابط، وتخطيط مركّب.",
    "Minimal items list, manual label/content slots, custom slots, and empty state.": "قائمة عناصر بسيطة، فتحات تسمية/محتوى يدوية، فتحات مخصّصة، وحالة فارغة.",
    "Minimal list, grouped sections, flat nested and grouped nested panels, and more.": "قائمة بسيطة، أقسام مجمّعة، لوحات متداخلة مسطّحة ومجمّعة، والمزيد.",
    "Minimal pin input and an initial value via the value assign.": "إدخال رمز بسيط وقيمة ابتدائية عبر assign القيمة.",
    "Minimal uses aria_label only; add <:label> for visible text (errors on the Form page).": "الاستخدام البسيط يعتمد aria_label فقط؛ أضف <:label> للنص الظاهر (الأخطاء في صفحة النموذج).",
    "Native HTML inputs with shared layout, optional icons, and grouped types.": "مدخلات HTML أصلية بتخطيط مشترك، أيقونات اختيارية، وأنواع مجمّعة.",
    "Navigate paged data with prev/next triggers and dynamic page items.": "تنقّل بين بيانات مقسّمة بمشغّلات السابق/التالي وعناصر صفحات ديناميكية.",
    "Phoenix to_form/2, stricter validation, and Corex select inside a plain HTML form": "Phoenix to_form/2، تحقق أشد، وselect من Corex داخل نموذج HTML عادي",
    "Phoenix to_form/2, stricter validation, and plain HTML  -  grouped like anatomy.": "Phoenix to_form/2، تحقق أشد، وHTML عادي — مجمّع كالبنية.",
    "Programmatic selection and reading the current value from LiveView or the client.": "اختيار برمجي وقراءة القيمة الحالية من LiveView أو العميل.",
    "Programmatically set the checked state from the server or client bindings.": "تعيين حالة التحديد برمجيًا من الخادم أو ربطات العميل.",
    "Semantic colors and density (sm–xl) via modifier classes on the root.": "ألوان دلالية وكثافة (ص–كبير جدًا) عبر فئات المعدّل على الجذر.",
    "Semantic colors and density via modifier classes on the checkbox root.": "ألوان دلالية وكثافة عبر فئات المعدّل على جذر مربع الاختيار.",
    "Semantic colors on page controls, density steps, type scale, radii, and host max-width utilities—same modifier pattern as accordion.": "ألوان دلالية على عناصر الصفحة، درجات الكثافة، مقياس النوع، أنصاف القطر، وحدود العرض — نفس نمط المعدّل كالأكورديون.",
    "Semantic colors on title and subtitle, width utilities on the root; use typography utilities on the heading slots for scale.": "ألوان دلالية على العنوان والعنوان الفرعي، أدوات العرض على الجذر؛ استخدم أدوات الطباعة على فتحات العناوين للمقياس.",
    "Semantic colors, density steps, and width utilities via modifier classes on the accordion.": "ألوان دلالية، درجات كثافة، وأدوات عرض عبر فئات المعدّل على الأكورديون.",
    "Semantic colors, density steps, and width utilities via modifier classes on the radio group.": "ألوان دلالية، درجات كثافة، وأدوات عرض عبر فئات المعدّل على مجموعة الاختيار.",
    "Semantic colors, density steps, radius, and text utilities via modifier classes on the tree view.": "ألوان دلالية، كثافة، نصف قطر، وأدوات نص عبر فئات المعدّل على عرض الشجرة.",
    "Semantic colors, density, and width utilities on the combobox root.": "ألوان دلالية وكثافة وأدوات عرض على جذر صندوق التحرير والسرد.",
    "Semantic colors, density, typography, radius, and width utilities via modifier classes on the select root.": "ألوان دلالية وكثافة وطباعة ونصف قطر وعرض عبر فئات المعدّل على جذر القائمة المنسدلة.",
    "Semantic colors, layout density, corner radius, and width utilities via modifier classes on the carousel.": "ألوان دلالية وكثافة تخطيط ونصف قطر وزوايا وعرض عبر فئات المعدّل على العرض الدوار.",
    "Semantic colors, root gap, typography, radius, and max-width utilities on the tabs root.": "ألوان دلالية وفجوة الجذر وطباعة ونصف قطر وحد أقصى للعرض على جذر علامات التبويب.",
    "open_file_picker (CustomEvent from JavaScript)": "open_file_picker (CustomEvent من JavaScript)",
    "open_file_picker (push_event from LiveView)": "open_file_picker (push_event من LiveView)",
    "set_value (CustomEvent from JavaScript)": "set_value (CustomEvent من JavaScript)",
    "set_value (Phoenix binding)": "set_value (ربط Phoenix)",
    "set_value (push_event from LiveView)": "set_value (push_event من LiveView)",
    "value (Phoenix binding)": "value (ربط Phoenix)",
    "value (push_event from LiveView)": "value (push_event من LiveView)",
    "name-%{system_unique_integer}": "name-%{system_unique_integer}",
    "lorem, duis, donec: pressed control, optional indicator, and trigger label swap.": "lorem, duis, donec: عنصر تحكم مضغوط، مؤشر اختياري، وتبديل تسمية المشغّل.",
}

WITH_PREFIX = {
    "With ": "مع ",
    "Without ": "بدون ",
    "With controlled ": "مع تحكم ",
    "With custom ": "مع مخصّص ",
    "With manual ": "مع يدوي ",
    "With compound ": "مع مركّب ",
    "With grouped ": "مع مجمّع ",
    "With nested ": "مع متداخل ",
    "With async ": "مع غير متزامن ",
    "With value": "مع قيمة",
    "With triggers": "مع مشغّلات",
    "With translation": "مع ترجمة",
    "With visibility icons": "مع أيقونات الظهور",
    "With switching trigger": "مع مشغّل التبديل",
    "With title and description": "مع عنوان ووصف",
    "With label": "مع تسمية",
    "With icons": "مع أيقونات",
    "With indicator": "مع مؤشر",
    "With error": "مع خطأ",
    "With slots": "مع فتحات",
    "With empty state": "مع حالة فارغة",
    "With disabled": "معطّل",
    "With read only": "للقراءة فقط",
    "With invalid": "غير صالح",
    "With multiple": "متعدد",
    "With single": "مفرد",
    "With accent": "بارز",
    "With neutral": "محايد",
    "With danger": "خطر",
    "With primary": "أساسي",
    "With secondary": "ثانوي",
    "With muted": "باهت",
    "With sm": "صغير",
    "With md": "متوسط",
    "With lg": "كبير",
    "With xl": "كبير جدًا",
}


def comp_ar(name: str) -> str:
    return COMPONENTS.get(name, name)


def translate(msgid: str) -> str:
    if msgid in EXACT:
        return EXACT[msgid]

    for en, ar in COMPONENTS.items():
        if msgid == en:
            return ar

    if msgid.endswith(" Anatomy"):
        return f"بنية {comp_ar(msgid[: -len(' Anatomy')])}"

    if msgid.endswith(" Styling"):
        return f"تنسيق {comp_ar(msgid[: -len(' Styling')])}"

    if " · " in msgid:
        left, right = msgid.split(" · ", 1)
        return f"{comp_ar(left)} · {SUFFIX.get(right, right)}"

    if msgid.endswith(" form"):
        return f"نموذج {comp_ar(msgid[:-5])}"

    for prefix, ar_prefix in WITH_PREFIX.items():
        if msgid.startswith(prefix):
            rest = msgid[len(prefix) :]
            if rest in EXACT:
                return ar_prefix + EXACT[rest]
            if rest in COMPONENTS:
                return ar_prefix + COMPONENTS[rest]
            return ar_prefix + rest.lower() if len(rest) < 40 else ar_prefix + rest

    return msgid


def escape_po(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def unescape(s: str) -> str:
    s = s.strip()
    if s.startswith("msgid "):
        s = s[6:]
    elif s.startswith("msgstr "):
        s = s[7:]
    if s.startswith('"') and s.endswith('"'):
        s = s[1:-1]
    return s.replace("\\n", "\n").replace('\\"', '"').replace("\\\\", "\\")


def format_msgstr(s: str) -> list[str]:
    if "\n" not in s:
        return [f'msgstr "{escape_po(s)}"\n']
    parts = s.split("\n")
    lines = [f'msgstr "{escape_po(parts[0])}"\n']
    for part in parts[1:]:
        lines.append(f'"{escape_po(part)}"\n')
    return lines


def fill_po(path: Path) -> tuple[int, int, int]:
    raw = path.read_text()
    blocks = re.split(r"\n\n(?=#:|\nmsgid )", raw)
    header = blocks[0]
    out = [header.rstrip() + "\n\n"]
    filled = unchanged = total = 0

    for block in blocks[1:]:
        if not block.strip():
            continue
        meta = []
        msgid_lines = []
        msgstr_lines = []
        for line in block.splitlines():
            if line.startswith("#") or line.startswith(","):
                meta.append(line)
            elif line.startswith("msgid "):
                msgid_lines = [unescape(line)]
            elif line.startswith("msgstr "):
                msgstr_lines = [unescape(line)]
            elif line.startswith('"') and msgstr_lines and not msgid_lines:
                msgstr_lines.append(unescape(line))
            elif line.startswith('"') and msgid_lines and not msgstr_lines:
                msgid_lines.append(unescape(line))
            elif line.startswith('"') and len(msgid_lines) > len(msgstr_lines):
                msgid_lines.append(unescape(line))
            elif line.startswith('"'):
                msgstr_lines.append(unescape(line))

        mid = "".join(msgid_lines)
        mst = "".join(msgstr_lines)
        if mid:
            total += 1
            if not mst:
                mst = translate(mid)
                filled += 1
            else:
                unchanged += 1

        chunk = []
        for line in meta:
            chunk.append(line + "\n")
        if mid != "" or "msgid" in block:
            chunk.append(f'msgid "{escape_po(mid)}"\n')
            chunk.extend(format_msgstr(mst))
        out.append("".join(chunk).rstrip() + "\n\n")

    path.write_text("".join(out).rstrip() + "\n")
    return filled, unchanged, total


if __name__ == "__main__":
    filled, unchanged, total = fill_po(PO_PATH)
    still_empty = 0
    text = PO_PATH.read_text()
    for block in re.split(r"\n\n(?=#:)", text)[1:]:
        mid_m = re.search(r'msgid "((?:[^"\\]|\\.)*)"', block)
        mst_m = re.search(r'msgstr "((?:[^"\\]|\\.)*)"', block)
        if mid_m and mid_m.group(1) and mst_m and mst_m.group(1) == "":
            still_empty += 1
    print(f"filled {filled}, unchanged {unchanged}, total {total}, still_empty {still_empty}")
