---
title: "تصميم Corex: نظام تصميم يضع إمكانية الوصول في المقدمة"
description: "أهداف تباين Leonardo، خطوط أنابيب الرموز، ومعدّلات BEM بحيث يُدمَج AA وAAA منذ البداية وليس كترقيع لاحق."
date: "2026-05-22 12:00:00 +0000"
permalink: /ar/blog/corex-design-a11y/
tags:
  - Corex
  - رموز التصميم
  - إمكانية الوصول
sitemap:
  priority: 0.8
  changefreq: monthly
---

تعمل مكونات Corex بدون CSS مضمّن. يظل الـ hook يشغّل الآلة؛ ويظل الشجرة تحصل على `data-state` و`data-part`. التصميم هو كيف يبدو هذا **الجسد**.

الآلة لا تقرأ `site.css`. يستهدف CSS المكوّن العُقد **`[data-scope][data-part]`** التي يصونها الـ hook. المرافق المشتركة (`ui-input`، `ui-trigger`) تُركّز مظهر الحقول والأزرار؛ والمعدّلات على الجذر (`combobox--accent`، `button--lg`) تضبط نسخة واحدة.

**Corex Design** ينسخ الرموز وCSS المكوّنات إلى `assets/corex/`. تستورد ما تستخدمه. غيّر `ui-input` مرة واحدة ويتحرك كل عنصر تحكم يبني عليه معًا. هذا منفصل عن التشريح (HEEx) ومنفصل عن الحالة (الآلة مقابل assigns)، لكنه يجلس على نفس DOM الذي يحدّثه العقل.

عندما [يُرقّع LiveView DOM](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching)، يعيد الـ hook تطبيق حالة الآلة على عُقد **`[data-part]`**. يستهدف CSS التصميم تلك الأجزاء، لا وحدة LiveView. تغيير الرمز لا يتطلب إعادة تعلّم bindings أو assigns؛ يتطلب إعادة استيراد أو إعادة توليد `assets/corex/` بعد `mix corex.design`.

## لماذا المركزية

بدون Design، تميل كل صفحة نموذج إلى تراكم قواعدها الخاصة. حلقات تركيز combobox في `site.css`. حشوة حقل كلمة المرور في ورقة أنماط خاصة بـ LiveView. حدود pin input معدّلة لحملة واحدة. إصلاح تباين على `native-input` لم يصل أبدًا إلى مدخل combobox لأنهما كانا محدّدين مختلفين كُتبا قبل أشهر.

يعكس Corex Design ذلك. **الرموز** تعرّف الحبر والحدود والتباعد ونصف القطر مرة واحدة. **المرافق المشتركة** تُركّب تلك الرموز في أنماط (`ui-input`، `ui-trigger`، `ui-item`). **CSS المكوّن** يطبّق المرافق على `data-part` المناسب. **المعدّلات** على الجذر تغيّر اللون الدلالي والحجم لتلك النسخة. غيّر الطبقة المشتركة ويتحرك كل مكوّن يستخدم `@apply ui-input` معًا.

## نمط إدخال واحد، وكل عنصر تحكم يكتب

عناصر التحكم الشبيهة بالنص لا تملك كلٌّ منها نسخة من الحدود والتركيز والنص البديل والتعطيل. تسحب من `ui-input` في `assets/corex/utilities.css` (يُستورد عبر `main.css`).

`native-input` يطبّقه على جزء الحقل:

```css
.native-input [data-scope="native-input"][data-part="input"] {
  @apply ui-input;
}
```

يظهر نفس المرفق في مدخلات combobox وpassword-input وeditable وpin-input وclipboard في ملفات مكوّناتها. لتغيير معالجة التركيز أو ارتفاع اللمس لكل الحقول، عدّل الرموز و`ui-input`، ثم `mix corex.design --force` بعد ترقية Corex إن لزم. يتحدّث كل مكوّن يستخدم `@apply ui-input` معًا.

**ركّز البدائي، وتخصّص فقط حيث يختلف DOM.** المحفّزات تستخدم `ui-trigger` بنفس الطريقة (أزرار، محفّزات select، أزرار إغلاق dialog، أسهم carousel). صفوف القوائم تستخدم `ui-item`. الأسطح العائمة تستخدم `ui-content`. نادرًا ما تضيف تلك الفئات في HEEx؛ CSS المكوّن يُركّبها لك.

طريقة مفيدة لقراءة المستودع: افتح `assets/corex/utilities.css` للبدائيات، ثم `assets/corex/components/<name>.css` لكيفية ربط ذلك البدائي بالأجزاء. إن بدا مكوّنان غير متناسقين، الإصلاح ليس أبدًا «أضف CSS على LiveView». بل «تحقق هل كلا الجزأين يستخدمان `@apply` لنفس المرفق» أو «وائم معدّلاتهما على نفس المحور الدلالي (`--accent`، `--lg`).»

| المرفق | الدور | أمثلة في CSS المكوّن |
|---------|------|---------------------------|
| `ui-input` | حقول نصية وأجزاء على شكل مدخل | `native-input`، `combobox`، `password-input`، `pin-input`، `editable`، `clipboard` |
| `ui-trigger` | عناصر قابلة للنقر وأزرار أيقونة | `button`، `select`، `dialog`، `carousel`، `file-upload` |
| `ui-item` | خيارات في القوائم والقوائم المنسدلة | `select`، `combobox`، `menu` |
| `ui-content` | لوحات وأسطح popover | `dialog`، `combobox`، `select` |
| `ui-label` | تسميات الحقول | `native-input`، تخطيطات مجاورة للنماذج |

CSS الخاص بالمكوّن يضيف فقط ما تحتاجه شجرة Zag: حشو إضافي لخلية pin، تخطيط لكروم تحكم combobox، فتحات مؤشر على محفّزات accordion. المظهر الأساسي ما زال من المرفق المشترك.

**`data-state`** و**`data-highlighted`** على الأجزاء تأتي من الآلة، لا من HEEx. يستخدم CSS التصميم محدّدات سمة على تلك الحالات التي يصونها الـ hook، مثل تنسيق جزء محتوى combobox المفتوح عند **`data-state="open"`**. نادرًا ما تضبط تلك السمات في القوالب؛ تنسّق ما يصونه العقل أصلًا.

## التباين واللون يعيشان في الرموز، لا في الصفحات

تُولَّد لوحات الألوان بـ [Adobe Leonardo](https://leonardocolor.io/) API مقابل نسب تباين مستهدفة. ملفات الرموز تسجّل النتيجة (مثل **7.0:1** للحبر الأساسي على خلفية الصفحة). `--color-ink` و`--color-ink-muted` و`--color-border` واللهجات الدلالية تغذي مرافق Tailwind (`text-ink`، `border-border`) والمرافق أعلاه.

```corex-callout note
Contrast from day one

رموز التصميم مُصدَرة مع حزمة Hex. بعد ترقية Corex، شغّل **`mix corex.design --force`** حتى يطابق `assets/corex/` CSS المكوّن الذي تتوقعه الـ hooks.

عامل التباين كالتباعد: اختر الرموز والمعدّلات عن قصد. إن فشلت تسمية في التدقيق، بدّل السمة أو الوضع أو معدّلًا دلاليًا (`button--accent` مقابل `button--muted`) قبل إضافة تجاوزات لمرة واحدة في `site.css`.
```

لأن `ui-input` يقرأ `var(--color-border)` و`var(--color-ink-muted)` للنصوص البديلة، ينتشر إصلاح الرمز إلى كل جزء على شكل مدخل. تبقى إمكانية الوصول والاتساق البصري مربوطين بنفس المصدر.

## انسخ شجرة التصميم مرة واحدة

```bash
mix corex.design
```

تأليف الرموز اختياري:

```bash
mix corex.design --designex
```

تستقر الملفات تحت `assets/corex/`. بعد ترقية Corex، حدّث بـ `--force` حتى يبقى CSS المكوّن والمرافق متوافقين مع إصدار Hex. المسارات الموجودة تُتخطى افتراضيًا حتى لا يُمسح عمل الرموز المحلي عن طريق الخطأ.

## الاستيرادات: main، ثم السمة، ثم ما تعرضه فقط

يبقى `site.css` رفيعًا. لا محدّدات جديدة على داخليات Corex.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/native-input.css";
@import "../corex/components/combobox.css";
@import "../corex/components/button.css";
```

أضف `@import "../corex/components/<name>.css"` لكل مكوّن في الصفحة. `main.css` يجلب أصلًا `utilities.css` حيث يعيش `ui-input` و`ui-trigger`.

وجّه Tailwind إلى نفس الشجرة:

```css
@source "../corex";
```

اضبط السمة والوضع على المستند؛ الطباعة والتخطيط على body:

```heex
<html lang="en" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

السمات **neo** و**uno** و**duo** و**leo** تُصدّر كلٌّ منها ملفات رموز للوضعين الفاتح والداكن. غيّر `data-theme` أو `data-mode` على `<html>` ويتحدّث كل مكوّن يقرأ الرموز دون ملفات CSS مكررة لكل سمة.

إن كان التطبيق ما زال يحمّل **daisyUI** من `phx.new` الافتراضي، أزله. نظاما رموز يتنافسان على نفس المرافق.

## Tokens Studio إلى متغيّرات CSS

تعيش رموز التصميم في **JSON لـ Tokens Studio**. **Style Dictionary** يصدّر متغيّرات Tailwind v4 تحت `assets/corex/`. مع `--designex`، يمكن لـ `assets.build` و`assets.deploy` تشغيل `designex corex` لتعديل تحت `assets/corex/design/` وإعادة البناء محليًا. لا تحتاج Designex لـ **استخدام** Design في الإنتاج، فقط لـ **تغيير** الرموز.

| عائلة الرموز | أمثلة | الاستخدام في الترميز |
|--------------|----------|----------------|
| الحبر | `--color-ink`، `--color-ink-muted` | `text-ink`، `text-ink-muted` |
| الأسطح | `--color-layer`، `--color-root` | `bg-layer`، خلفية الصفحة |
| التباعد | `--spacing-space`، `--spacing-space-lg` | `gap-space`، `p-space-lg` |
| الطباعة | `--text-base`، `--text-lg` | `.typo` على body، معدّلات `--text-lg` |
| نصف القطر | `--radius-md`، `--radius-xl` | `rounded-md`، `accordion--rounded-xl` |

فضّل هذه الأسماء على أرقام عشوائية في HEEx حتى يبقى التخطيط والمكوّنات على نفس المقياس عند تغيّر الرموز.

## المعدّلات على جذر المكوّن

لكل مكوّن مُنسَّق فئة جذر تطابق اسمه (`accordion`، `select`، `combobox`، `button`). المعدّلات تتراكم على ذلك الجذر:

```text
<component> <component>--<axis> …
```

مثال accordion بلون وحجم ونصف قطر من الرموز:

```heex
<.accordion
  class="accordion accordion--accent accordion--lg accordion--rounded-lg"
  id="faq"
  items={
    Corex.Content.new([
      %{
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus."
      },
      %{
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus."
      }
    ])
  }
/>
```

| المحور | أمثلة | الأثر |
|------|----------|--------|
| اللون | `button--accent`، `combobox--alert` | لوحة دلالية من الرموز |
| الحجم | `button--sm`، `dialog--lg` | تباعد ومقياس طباعة |
| نصف القطر | `accordion--rounded-xl` | نصف قطر الزوايا على الأجزاء |
| الطباعة | `tabs--text-lg` | حجم الخط على المحفّزات والمحتوى |

المعدّلات تربط بمتغيّرات CSS عبر كتل `@utility` في كل ملف مكوّن. لا تُفرّع `ui-input`؛ تلوّن أجزاء المكوّن التي تستخدم المرافق المشتركة أصلًا.

## كيف يستهدف CSS المكوّن الشجرة

الـ hooks تضبط **`data-scope`** و**`data-part`**. CSS المكوّن يحدّد تلك العُقد ويطبّق المرافق المشتركة:

```css
[data-scope="combobox"][data-part="input"] {
  @apply ui-input;
}
[data-scope="combobox"][data-part="control"] {}
[data-scope="combobox"][data-part="content"] {}
[data-scope="combobox"][data-part="item"] {}
```

لا تكتب هذه المحدّدات في التطبيق عادة. تشرح لماذا يبدو مدخل combobox وحقل `native-input` مرتبطين: نفس المرفق، أسماء أجزاء مختلفة.

## HEEx يبقى ثابتًا عندما يتحرك التصميم

القوالب تمرّر المعدّلات على الجذر وheroicons عارية داخل الفتحات:

```heex
<.combobox
  class="combobox combobox--accent combobox--lg"
  id="airport"
  items={@items}
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

```heex
<.native_input class="native-input native-input--accent" id="email" type="email" />
```

لا `class` على heroicon. CSS الأب يحدّد حجم الأيقونات. لا قاعدة لكل صفحة لـ «combobox في الدفع». إن احتاج الدفع مظهر تنبيه، يكفي `combobox--alert` على الجذر.

## الطباعة والتخطيط على body

**`.typo`** و**`.layout`** على `<body>` ينسّقان العناوين والفقرات والقوائم وإيقاع الصفحة من الرموز. النص التسويقي يستخدم وسومًا دلالية؛ عناصر التحكم التفاعلية تستخدم جذور المكوّنات.

```heex
<body class="typo layout">
  <main>
    <h1>Account</h1>
    <p>Profile and billing share the same input and button language.</p>
    <.native_input class="native-input" id="name" />
    <.button class="button button--accent">Save</.button>
  </main>
</body>
```

## منتقي السمة دون CSS جديد لكل شاشة

بدّل السمة عند الجذر؛ المكوّنات تتبع عبر المتغيّرات:

```heex
<.select
  class="select select--accent"
  id="theme-picker"
  items={
    Corex.List.new([
      %{label: "Neo", value: "neo"},
      %{label: "Uno", value: "uno"},
      %{label: "Duo", value: "duo"},
      %{label: "Leo", value: "leo"}
    ])
  }
  value={[@current_theme]}
  on_value_change="theme_changed"
/>
```

```elixir
def handle_event("theme_changed", %{"value" => [theme]}, socket) do
  {:noreply, push_event(socket, "corex:set-theme", %{theme: theme})}
end
```

الوضع الداكن نفس الآلية: `data-mode="dark"` على `<html>`، نفس أسماء المتغيّرات، قيم مختلفة في ملف السمة.

## تغيير نموذجي من البداية للنهاية

مثال: حقول أكبر ونصوص بديلة أفتح.

1. عدّل رموز التباعد والطباعة في مصدر الرموز؛ أعد البناء بـ Designex إن استخدمته.
2. تأكد أن `ui-input` يربط `min-height` بـ `var(--spacing-size)` والنصوص البديلة بـ `var(--color-ink-muted)`.
3. `native_input` وcombobox وحقول كلمة المرور وخلايا pin تتحدّث معًا.
4. لصفحة خطأ واحدة فقط، أضف `combobox--alert` لتلك النسخة بدل تفرّع `ui-input`.

ينطبق الشيء نفسه على المحفّزات: غيّر `ui-trigger` مرة، تتبع الأزرار وأسهم select.

يبقى HEEx ثابتًا: `class="combobox combobox--accent"` و`class="native-input"` يصمدان عند تحديث الرموز. حدّث CSS المنسوخ من Hex عندما يكتسب مكوّن أجزاء أو محاور معدّلات جديدة.

## ما لا تفعله في القوالب

- لا محدّدات جديدة في `site.css` تتجاوز داخليات `[data-scope]`
- لا أنماط تركيز مكررة لكل LiveView
- لا أسماء فئات مبتكرة بجانب المعدّلات الموثّقة
- لا `class` على heroicons داخل مكوّنات Corex

Corex Design لا يغيّر التشريح ولا الـ hooks ولا أحداث الخادم. يغيّر المظهر فقط بعد mount. عندما يكون السلوك صحيحًا والمظهر خاطئًا، غيّر الرموز أو المرافق أو المعدّلات، ثم `mix corex.design --force` بعد ترقية Corex إن لزم.

## اختياري: رموز فقط، أو تخطّ Design

استورد `main.css` والسمات واكتب قواعدك على `data-scope` / `data-part`. أو تخطّ Design كليًا واستخدم نظامًا آخر. Zag ومكوّنات Phoenix لا تعتمد على طبقة CSS.

---

الرموز تعرّف اللوحة والمقياس. المرافق المشتركة تعرّف المدخلات والمحفّزات والعناصر والأسطح. CSS المكوّن يربط المرافق بـ `data-part`. المعدّلات تضبط نسخة واحدة على الجذر. حدّث `ui-input` مرة ويتحرك كل عنصر تحكم يبني عليه معًا.
