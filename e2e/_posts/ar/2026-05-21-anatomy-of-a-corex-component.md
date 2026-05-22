---
title: "تشريح مكوّن Corex"
description: "تضيف Corex مكوّنات Phoenix تفاعلية بشكل HTML ثابت وخطافات عميل. التشريح هو مقدار HEEx الذي تكتبه لهذا الشكل؛ السلوك يعيش في الـ hook."
date: "2026-05-21 12:00:00 +0000"
permalink: /ar/blog/anatomy-of-a-corex-component/
tags:
  - Corex
  - Phoenix
  - Anatomy
sitemap:
  priority: 0.9
  changefreq: monthly
---

تستخدم Corex داخل تطبيق Phoenix عادي. أجزاؤها [function components](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html): نفس استدعاءات `<.accordion />` التي تكتبها أصلاً في HEEx. تساعد على عناصر التحكم التفاعلية. بناء الأكورديون وselect وcheckbox يدوياً مملّ؛ الأخطاء تتراكم عند المفاتيح والتركيز وإمكانية الوصول وحالة الفتح/الإغلاق. Corex يوفّر ذلك السلوك حتى لا تعيد اختراعه في كل شاشة.

هذا المنشور عن خيار واحد فقط. لنفس المكوّن، كم HEEx ما زلت تكتبه بنفسك؟ هذا الاختيار هو ما نسميه **Anatomy**. كيف يتصرّف المكوّن على العميل موضوع منفصل: [آلات الحالة](/ar/blog/state-machines/). المظهر منفصل أيضاً: [تصميم Corex](/ar/blog/corex-design-a11y/).

إن كنت تستخدم LiveView أصلاً، يبقى تدفق البيانات مألوفاً. LiveView يحتفظ بـ **assigns**. Function components تحوّل تلك assigns إلى HTML. المتصفح يتحدّث عندما يرسل الخادم patch. [دليل Phoenix](https://hexdocs.pm/phoenix/overview.html) يغطي التوجيه والcontrollers وLiveView بالكامل؛ لن نكرّره هنا. ما زلت تستدعي Corex من HEEx، مثلاً `<.accordion id="faq" items={@topics} />`، مع `@topics` في `mount/3` أو `handle_event/3`. ما تضيفه Corex شكل HTML متوقّع و**client hook** على الجذر للعمل التفاعلي الصعب.

ذلك الـ hook هو Phoenix القياسي. راجع [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html). تمرّر خريطة **`hooks`** إلى **`LiveSocket`**. تعلّم الجذر بـ **`phx-hook`** و**`id`** فريد. LiveView يستدعي **`mounted`** و**`updated`** وباقي دورة الحياة عند تغيّر DOM. Corex يوفّر تلك الـ hooks. بداخلها، **آلة حالة Zag.js** تدير اللوحات المفتوحة والتركيز وحركة لوحة المفاتيح. HEEx يوفّر attrs وslots و`items` والفئات؛ الـ hook والآلة يديران ما بعد الرسم.

**Anatomy** هو نصف HEEx فقط. moduledocs تستخدم نفس الأسماء في كل مكوّن. **Minimal** استدعاء واحد وقائمة. **With slots** يكرّر slot واحداً على كل صف. **Custom Slots** تستخدم `:let` عندما يختلف شكل كل صف. **Manual Slots** و**compound** للتخطيطات التي ليست قائمة بسيطة. الآلة تبقى كما هي؛ يتغيّر فقط HTML الذي تتصل بها. قارن المستويات في [عرض تشريح الأكورديون](/ar/accordion/anatomy)، ونفس الفكرة في [select](/ar/select/anatomy) و[tabs](/ar/tabs/anatomy) و[checkbox](/ar/checkbox/anatomy). المقتطفات الكاملة في الوثائق وتلك الصفحات؛ هنا نركّز على متى تختار كل مستوى.

## Assigns وتتبع التغيير

attrs التشريح (`items`، slots، **`compound`**) هي assigns عادية من منظور المستدعي. قد **`assign`** المكوّن قيماً مشتقة (قوائم اللوحات، `ctx` لـ `:let`) قبل الرسم. كيف تتدفق assigns عبر HEEx وكيف تُعاد رسم المناطق الديناميكية فقط موثّق في [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html#assigns-and-heex-templates); اقرأ ذلك الدليل لـ **`attr`** و**`slot`** وتتبع التغيير بدلاً من تكراره هنا.

اتفاقيات مهمة عندما تغذّي قائمة مكوّناً مربوطاً بـ hook:

- ابنِ **`items`** في **`mount/3`** أو **`handle_event/3`**، ثم مرّر **`items={@topics}`**. لا تحمّل البيانات داخل القالب.
- استخدم **`assign/2`** و**`update/3`** في LiveView. تجنّب **`Map.put/3`** على assigns داخل function component.
- فضّل attrs صريحة على **`{assigns}`** إلى الأبناء حتى تبقى التصحيحات دقيقة.

اختيار مستوى تشريح لا يستبدل **`phx-hook`** أو آلة Zag؛ يشكّل فقط HTML الذي تتصل بها تلك الـ callbacks. **`value`** و**`controlled`** و**`on_value_change`** و**`pushEvent`** هي [bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) وواجهات الـ hook: راجع [آلات الحالة](/ar/blog/state-machines/) و[vanilla JS](/ar/blog/vanilla-js/)، وليس هذا المنشور.

## الإعداد

سجّل Corex في خيار **`hooks`** على **`LiveSocket`** كما في [Client hooks via `phx-hook`](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook):

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})

liveSocket.connect()
```

استورد CSS لكل مكوّن ترسمه، أو استخدم Corex Design مع `mix corex.design`. السلوك لا يعتمد على CSS مجمّع.

## Minimal: `items` فقط

الأكورديون وtabs المدفوعة بقائمة تأخذ **`items`**. القيمة قائمة من `Corex.Content.new/1`. كل خريطة تحتاج **`label`** و**`content`**. حقول اختيارية: **`value`** (معرّف ثابت)، **`disabled`**، **`meta`** (إضافات لـ Custom Slots).

```heex
<.accordion
  class="accordion"
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

Corex يرسم مُشغّلاً من كل `label` ولوحة من كل `content`. تحصل على دعم لوحة المفاتيح، سلوك الفتح الافتراضي، وشجرة `data-scope` / `data-part` للـ hook. أضف فئات BEM على الجذر، مثلاً `class="accordion accordion--accent"`. التشريح لا يغيّر attrs؛ يغيّر عدد العقد الابنة التي تعلنها.

من قاعدة البيانات، ابنِ القائمة في LiveView ومرّرها. الخاصية دائماً **`items`**:

```elixir
items =
  Corex.Content.new(
    Enum.map(rows, fn row ->
      %{
        value: row.slug,
        label: row.title,
        content: row.body,
        disabled: row.archived
      }
    end)
  )
```

```heex
<.accordion class="accordion" id="faq" items={items} />
```

## slot مشترك على كل صف

احتفظ بنفس قائمة `items` وأضف slot واحداً `<:indicator>`. Corex يكرره لكل عنصر. سلوك الفتح ولوحة المفاتيح دون تغيير. moduledocs تسمي هذا **With Indicator**.

```heex
<.accordion
  class="accordion"
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
>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

## Custom Slots: `:let` لكل صف

عندما يحتاج كل صف ترميزاً مختلفاً، احتفظ بـ `items` واستخدم `:let={item}` على الـ slots التي تستبدلها. ضع بيانات كل صف في **`meta`**. هذا تشريح **Custom Slots**.

```heex
<.accordion
  class="accordion"
  id="faq"
  value="lorem"
  items={
    Corex.Content.new([
      %{
        value: "lorem",
        label: "Lorem ipsum dolor sit amet",
        content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique.",
        meta: %{indicator: "hero-arrow-long-right", icon: "hero-chat-bubble-left-right"}
      },
      %{
        label: "Duis dictum gravida odio ac pharetra?",
        content: "Nullam eget vestibulum ligula, at interdum tellus.",
        meta: %{indicator: "hero-chevron-right", icon: "hero-device-phone-mobile"}
      },
      %{
        value: "donec",
        label: "Donec condimentum ex mi",
        content: "Congue molestie ipsum gravida a. Sed ac eros luctus.",
        disabled: true,
        meta: %{indicator: "hero-chevron-double-right", icon: "hero-phone"}
      }
    ])
  }
>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
  <:content :let={item}>
    <p>{item.content}</p>
  </:content>
  <:indicator :let={item}>
    <.heroicon name={item.meta.indicator} />
  </:indicator>
</.accordion>
```

داخل كل slot، `item` يحتوي `label` و`content` و`value` و`disabled` و`meta`. يمكنك استبدال `:trigger` فقط أو `:content` فقط.

## Manual Slots

لعدد قليل من اللوحات الثابتة مع HTML غني في كل جسم، احذف `items` واعلن slots بنفس **`value`** على `:trigger` و`:content` و`:indicator` الاختياري.

```heex
<.accordion class="accordion" id="faq" value="lorem">
  <:trigger value="lorem">
    <.heroicon name="hero-chevron-right" />
    Lorem ipsum dolor sit amet
  </:trigger>
  <:content value="lorem">
    <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
  </:content>
  <:indicator value="lorem">
    <.heroicon name="hero-chevron-down" />
  </:indicator>

  <:trigger value="duis">
    <.heroicon name="hero-chevron-right" />
    Duis dictum gravida odio ac pharetra?
  </:trigger>
  <:content value="duis">
    <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
  </:content>
  <:indicator value="duis">
    <.heroicon name="hero-chevron-down" />
  </:indicator>

  <:trigger value="donec">
    <.heroicon name="hero-chevron-right" />
    Donec condimentum ex mi
  </:trigger>
  <:content value="donec">
    <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
  </:content>
  <:indicator value="donec">
    <.heroicon name="hero-chevron-down" />
  </:indicator>
</.accordion>
```

استخدم `items` لصفوف كثيرة موحّدة من البيانات؛ استخدم **Manual Slots** عندما شكل القائمة لا يناسب. كل `value` في slot يربط المُشغّل باللوحة، مثل `value` في خريطة `items`.

## compound

عندما لا تنتج الـ slots الـ DOM الذي تحتاجه، استخدم **`compound`** على `<.accordion>` مع `:let={ctx}` ومكوّنات فرعية: `accordion_root`، `accordion_item`، `accordion_trigger`، `accordion_content`، `accordion_indicator`.

عناصر موضوعة يدوياً:

```heex
<.accordion :let={ctx} compound class="accordion" id="faq">
  <.accordion_root ctx={ctx}>
    <.accordion_item :let={item} ctx={ctx} value="lorem">
      <.accordion_trigger item={item}>
        Lorem ipsum dolor sit amet
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Consectetur adipiscing elit. Sed sodales ullamcorper tristique.</p>
      </.accordion_content>
    </.accordion_item>
    <.accordion_item :let={item} ctx={ctx} value="duis">
      <.accordion_trigger item={item}>
        Duis dictum gravida odio ac pharetra?
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Nullam eget vestibulum ligula, at interdum tellus.</p>
      </.accordion_content>
    </.accordion_item>
    <.accordion_item :let={item} ctx={ctx} value="donec">
      <.accordion_trigger item={item}>
        Donec condimentum ex mi
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>Congue molestie ipsum gravida a. Sed ac eros luctus.</p>
      </.accordion_content>
    </.accordion_item>
  </.accordion_root>
</.accordion>
```

مع قائمة في assigns، استخدم `:for`:

```heex
<.accordion :let={ctx} compound id="faq" class="accordion">
  <.accordion_root ctx={ctx}>
    <.accordion_item :for={entry <- @entries} :let={item} ctx={ctx} value={entry.value}>
      <.accordion_trigger item={item}>
        {entry.label}
        <:indicator>
          <.accordion_indicator item={item}>
            <.heroicon name="hero-chevron-right" />
          </.accordion_indicator>
        </:indicator>
      </.accordion_trigger>
      <.accordion_content item={item}>
        <p>{entry.content}</p>
      </.accordion_content>
    </.accordion_item>
  </.accordion_root>
</.accordion>
```

جرّب `items` والـ slots أولاً. استخدم compound عندما تحتاج غلافات بين العناصر أو شكل DOM لا تستطيع الـ slots إصداره.

## Select: `Corex.List.new`

`<.select>` يأخذ **`items`** كخيارات (`label` + `value`)، وليس مُشغّلاً وجسماً. استخدم `Corex.List.new/1`. **`group`** اختياري على كل خريطة لعناوين الأقسام.

select **Minimal**: قائمة مع سهم في slot المُشغّل:

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra", disabled: true},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.select>
```

خيارات مجمّعة بنفس قائمة `items` مع حقل `group` على كل خريطة:

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra", group: "Europe"},
      %{label: "Belgium", value: "bel", group: "Europe"},
      %{label: "Germany", value: "deu", group: "Europe"},
      %{label: "Netherlands", value: "nld", group: "Europe"},
      %{label: "Switzerland", value: "che", group: "Europe"},
      %{label: "Austria", value: "aut", group: "Europe"},
      %{label: "Japan", value: "jpn", group: "Asia"},
      %{label: "China", value: "chn", group: "Asia"},
      %{label: "South Korea", value: "kor", group: "Asia"},
      %{label: "Thailand", value: "tha", group: "Asia"},
      %{label: "USA", value: "usa", group: "North America"},
      %{label: "Canada", value: "can", group: "North America"},
      %{label: "Mexico", value: "mex", group: "North America"}
    ])
  }
>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.select>
```

صفوف خيارات مخصّصة: احتفظ بـ `items` وأضف `<:item :let={item}>` (الأكورديون يستخدم `:trigger` لوجه الصف):

```heex
<.select
  class="select"
  id="country"
  items={
    Corex.List.new([
      %{label: "France", value: "fra"},
      %{label: "Belgium", value: "bel"},
      %{label: "Germany", value: "deu"},
      %{label: "Netherlands", value: "nld"},
      %{label: "Switzerland", value: "che"},
      %{label: "Austria", value: "aut"}
    ])
  }
>
  <:label>Country of residence</:label>
  <:item :let={item}>
    <.heroicon name="hero-globe-alt" />
    {item.label}
  </:item>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
  <:item_indicator>
    <.heroicon name="hero-check" />
  </:item_indicator>
</.select>
```

نص بديل: `translation={%Corex.Select.Translation{placeholder: "Choose a country"}}`.

## Tabs: نفس `items`، أجزاء مختلفة

`<.tabs>` يستخدم `Corex.Content.new/1` مثل الأكورديون. تشريح **Minimal** هو `items` فقط:

```heex
<.tabs
  class="tabs"
  id="settings-tabs"
  value="lorem"
  items={
    Corex.Content.new([
      %{label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
  }
/>
```

مؤشر منزلق مشترك: خاصية منطقية **`indicator`** على `<.tabs>`، وليس slot لكل تبويب:

```heex
<.tabs
  class="tabs"
  id="settings-tabs"
  indicator
  value="lorem"
  items={
    Corex.Content.new([
      %{value: "lorem", label: "Lorem", content: "Consectetur adipiscing elit. Sed sodales ullamcorper tristique."},
      %{label: "Duis", content: "Nullam eget vestibulum ligula, at interdum tellus."},
      %{value: "donec", label: "Donec", content: "Congue molestie ipsum gravida a. Sed ac eros luctus."}
    ])
  }
/>
```

تسميات ولوحات تبويب مخصّصة: `:trigger` و`:content` مع `:let={item}`.

## Checkbox: slots على عنصر تحكم واحد

`<.checkbox>` **بلا قائمة `items`**. استخدم `<:label>` و`<:indicator>` و`<:error>` و`<:indeterminate>`.

```heex
<.checkbox class="checkbox" id="terms">
  <:label>Accept the terms</:label>
</.checkbox>
```

مع أيقونة تحقق مخصّصة:

```heex
<.checkbox class="checkbox" id="terms">
  <:label>Accept the terms</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
</.checkbox>
```

التحقق وترميز خطأ مخصّص:

```heex
<.checkbox
  class="checkbox checkbox--accent"
  id="subscribe"
  invalid
  checked
  errors={["Required"]}
>
  <:label>Subscribe to updates</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
  <:error :let={msg}>
    <.heroicon name="hero-exclamation-circle" />
    {msg}
  </:error>
</.checkbox>
```

حالة غير محددة (مثلاً رأس جدول «تحديد بعض»):

```heex
<.checkbox class="checkbox" id="select-all" checked={:indeterminate}>
  <:label>Select some rows</:label>
  <:indicator>
    <.heroicon name="hero-check" />
  </:indicator>
  <:indeterminate>
    <.heroicon name="hero-minus" />
  </:indeterminate>
</.checkbox>
```

نفس فكرة الـ slot كالأكورديون. الشكل كان عنصر تحكم واحداً بدلاً من مجموعة.

## Core Components مقابل Corex من Hex

**Core Components** في Phoenix ملفات تعدّلها. Corex يأتي من Hex: خصّص بـ attrs وslots، لا تنسخ الوحدة وتلف الجذر. الـ hook يتوقع شجرة ثابتة.

في LiveView واحد يمكنك خلط التشريح لكل استدعاء. لا يوجد وضع عام للتطبيق.

## حالة الفتح من خارج المكوّن

لفتح لوحة من عنصر تحكم آخر، استخدم الـ API (احتفظ بنفس قائمة `items` في القالب):

```elixir
def handle_event("open-faq", _params, socket) do
  Corex.Accordion.set_value(socket, "faq", "lorem")
  {:noreply, socket}
end
```

`id` على `<.accordion id="faq" ...>` يجب أن يطابق الوسيط الأول لـ `set_value`. سلاسل `value` للوحات تأتي من خرائط `items` أو خصائص `value` في Manual Slots. تحت الغطاء ذلك يستخدم **`Phoenix.LiveView.push_event/3`** و**`handleEvent`** في الـ hook، نفس مسار العميل/الخادم في [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html#handling-server-pushed-events).

## اختيار التشريح في كل استدعاء

استخدم أخف خيار يطابق بياناتك وترميزك:

- **Minimal** (`items` فقط): صفوف موحّدة، نص المُشغّل واللوحة الافتراضي يكفي.
- **slot مشترك** (`<:indicator>` واحد أو `indicator` في tabs): نفس الزينة على كل صف، القائمة دون تغيير.
- **Custom Slots** (`:let={item}`): أيقونات أو تخطيط أو HTML لوحة مختلف لكل صف؛ ما زال مدفوعاً بـ `items`.
- **Manual Slots**: مجموعة ثابتة صغيرة من اللوحات؛ الأجسام ليست سلسلة واحدة لكل صف.
- **compound**: تحتاج مكوّنات فرعية للتحكم في شجرة DOM (غلافات، بنية عنصر غير قياسية).

الأكورديون وtabs يستخدمان `Corex.Content.new` لأن كل صف له `label` و`content`. Select وcombobox يستخدمان `Corex.List.new` لأن كل صف خيار (`label` + `value`). Checkbox بلا قائمة: مكوّن واحد، slots منطقة فقط.

يمكنك استخدام تشريح مختلف في استدعاءات مختلفة في نفس LiveView. لا يوجد إعداد على مستوى التطبيق. الـ hook وواجهة attrs تبقى كما هي؛ فقط HEEx الذي تكتبه يتغيّر.

ابدأ بـ **Minimal** في كل شاشة جديدة. انتقل إلى **Custom Slots** عندما يحتاج صف واحد أيقونة أو تخطيط لوحة مختلف. احتفظ بـ **Manual Slots** و**compound** للكتل التسويقية أو التخطيطات حيث خرائط `items` تصارع التصميم. العروض تحت `/ar/<component>/anatomy` على هذا الموقع تعرض كل مستوى جنباً إلى جنب؛ قارن حجم HTML وقابلية الصيانة قبل الالتزام بـ compound للتطبيق كاملاً.

## الاستيعابات و`:key` والتشريح المدفوع بقائمة

عندما ترسم صفوفاً كثيرة متشابهة بـ **`:for`**، يمكن لـ LiveView تتبع المدخلات بالفهرس أو بـ **`:key`**. **`items`** المدفوعة بقائمة في Corex تتوسع إلى بنية داخلية ثابتة؛ لحلقات slots مخصّصة تؤلفها بنفسك، اتبع [إرشادات الاستيعابات](https://hexdocs.pm/phoenix_live_view/assigns-eex.html#comprehensions): استخدم **`:key={item.value}`** عندما يمكن إعادة ترتيب الصفوف أو إدراجها حتى تبقى التصحيحات صغيرة.

**Manual Slots** و**compound** عندما لا يكون DOM قائمة موحّدة. تستبدل assign **`items`** واحداً بمحتوى slots صريح. الآلة ما زالت تتوقع شجرة **`data-part`** الموثّقة في **Anatomy** في moduledoc.

## ما لا يشمله التشريح

التشريح هو شكل القالب عند أول رسم. لا يستبدل:

- `value` controlled و`on_value_change`
- `Corex.Accordion.set_value/2` من عنصر تحكم آخر
- بحث combobox من الخادم (`filter={false}`، `on_input_value_change`)
- خصائص أحداث العميل لمستمعي DOM فقط

هذه حالة وتدفق بيانات، وليست شكل قالب.

---

ابدأ بـ `items` و`Corex.Content.new` أو `Corex.List.new`. أضف slots عندما لا يكفي الترميز الافتراضي. استخدم **Manual Slots** أو **compound** فقط عندما لا تستطيع `items` و`:let` مطابقة التخطيط.

المنشورات التالية في هذه السلسلة تغطي [آلات الحالة](/ar/blog/state-machines/) (assigns والوضع controlled)، [vanilla JS](/ar/blog/vanilla-js/) (`LiveSocket` والـ hooks)، [التصميم](/ar/blog/corex-design-a11y/) (الرموز على `data-part`)، و[حجم combobox](/ar/blog/combobox-thousands-of-items/) (قوائم من الخادم). التشريح هو الأساس: اجعل شجرة HEEx صحيحة ويكون للـ hook شيء موثوق لتحسينه.
