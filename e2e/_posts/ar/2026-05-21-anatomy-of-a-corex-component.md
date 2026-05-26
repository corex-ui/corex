---
title: "تشريح مكوّن Corex"
description: "تشريح Corex سلم من استدعاء HEEx واحد إلى markup مركّب. نفس آلة Zag في كل خطوة؛ يتغيّر فقط HTML الذي تكتبه."
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

أول مرة ربطتُ أكورديون Corex، كتبتُ `<.accordion id="faq" items={@topics} />` وانتقلت. دعم لوحة المفاتيح يعمل. ARIA صحيح. اللوحات تفتح وتغلق دون أن أفكّر في `aria-expanded`.

بعد أسبوع طلب التصميم أيقونة مخصّصة على كل زر، سهم مختلف لكل صف، ولوحة واحدة فيها تخطيط وليس فقرة بسيطة. نفس المكوّن. نفس الـ hook. فجأة كنت أمام slots و`:let` ثم `compound`.

هذه الفجوة هي ما يسمّيه Corex **التشريح (anatomy)**: لمكوّن واحد، كم HEEx ما زلت تكتبه بنفسك؟ السلوك يعيش في آلة Zag والـ `phx-hook` على الجذر. التشريح هو قشرة HTML التي يتصل بها الـ hook فقط.

لقصة التشغيل (الوضع controlled، assigns، عندما يختلف الخادم والآلة) اقرأ [عقلان: assigns في LiveView وآلات Zag](/ar/blog/two-brains-liveview-assigns-and-zag-machines/). للـ hooks و`updateProps` اقرأ [آلة Vanilla JS التي لا تحتاج إطار عمل](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). هذا المنشور يبقى على شكل القالب.

## آلة واحدة، قشور متعددة

كل مكوّن Corex تفاعلي يتبع نفس التقسيم:

- **HEEx** يرسم `data-scope` و`data-part` والـ slots وprops على `data-*`.
- **الـ hook** يشغّل `VanillaMachine`، يشترك في الانتقالات، ويبقي DOM متزامناً.
- **LiveView** يوفّر البيانات: `items` و`value` والتسميات و`disabled`.

تغيّر التشريح يغيّر شجرة HTML. لا يغيّر أي hook يعمل ولا سلوك مفاتيح الأسهم. قارن المستويات في [عرض تشريح الأكورديون](/ar/accordion/anatomy)، أو نفس الفكرة في [select](/ar/select/anatomy) و[tabs](/ar/tabs/anatomy) و[checkbox](/ar/checkbox/anatomy).

سجّل الـ hooks مرة واحدة:

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})
```

استورد CSS لكل مكوّن ترسمه، أو Corex Design عبر `mix corex.design`. التشريح لا يعتمد على CSS مجمّع.

## السلم

moduledocs تسمّي خمس خطوات. فكّر فيها كتكلفة مقابل تحكّم.

| المستوى | متى تستخدمه |
|---------|-------------|
| **Minimal** | صفوف موحّدة من البيانات؛ نص الزّر واللوحة الافتراضي يكفي |
| **With slots** | نفس القائمة، زخرفة مشتركة على كل صف (مؤشر واحد، أو `indicator` في tabs) |
| **Custom slots** | markup لكل صف عبر `:let={item}` و`meta` |
| **Manual slots** | عدد قليل ثابت من اللوحات؛ المحتوى ليس سلسلة واحدة لكل صف |
| **Compound** | تحتاج غلافات أو شكل DOM لا تنتجه الـ slots |

ابدأ من أسفل السلم. اصعد فقط عندما يفرض التصميم ذلك.

## Minimal: ادفع مرة واحدة

أكورديون وtabs يأخذان `items` من `Corex.Content.new/1`. كل map يحتاج `label` و`content`. اختياري: `value` و`disabled` و`meta`.

```heex
<.accordion
  class="accordion accordion--accent"
  id="faq"
  items={
    Corex.Content.new([
      %{label: "الشحن", content: "الشحن خلال 3 أيام عمل."},
      %{label: "الإرجاع", content: "إرجاع خلال 30 يوماً للمنتجات غير المستخدمة."}
    ])
  }
/>
```

ابنِ القائمة في `mount/3` أو `handle_event/3`، ثم مرّر `items={@topics}`. المكوّن يرسم الأزرار واللوحات؛ الـ hook يكمل الباقي.

select وcombobox يستخدمان `Corex.List.new/1` (`label` + `value`، و`group` اختياري). checkbox بلا قائمة: عنصر واحد وslots للمناطق فقط.

## With slots: كرّر الزخرفة

أبقِ `items` وأضف slotاً يشاركه كل صف، مثلاً `<:indicator>` على الأكورديون:

```heex
<.accordion class="accordion" id="faq" items={@topics}>
  <:indicator>
    <.heroicon name="hero-chevron-right" />
  </:indicator>
</.accordion>
```

tabs يمكنها استخدام السمة `indicator` لمؤشر منزلق دون slot لكل تبويب. حالة الفتح ولوحة المفاتيح لا تتغيّر.

## Custom slots: `:let` لكل صف

عندما يحتاج كل صف markup مختلفاً، أبقِ `items` وعدّل الـ slots بـ`:let={item}`. ضع بيانات الصف في `meta`:

```heex
<.accordion class="accordion" id="faq" items={@topics}>
  <:trigger :let={item}>
    <.heroicon name={item.meta.icon} />
    {item.label}
  </:trigger>
  <:indicator :let={item}>
    <.heroicon name={item.meta.indicator} />
  </:indicator>
</.accordion>
```

داخل الـ slot، `item` يعرض `label` و`content` و`value` و`disabled` و`meta`. عدّل ما يختلف فقط.

## Manual slots: لوحات ثابتة

لثلاث لوحات FAQ بمحتوى HTML غني، تخطَّ `items`. عيّن `value` متطابقاً على `:trigger` و`:content` و`:indicator` اختياري:

```heex
<.accordion class="accordion" id="faq" value="shipping">
  <:trigger value="shipping">الشحن</:trigger>
  <:content value="shipping">
    <p>الشحن خلال <strong>3 أيام عمل</strong>.</p>
  </:content>
  <:trigger value="returns">الإرجاع</:trigger>
  <:content value="returns">
    <p>إرجاع خلال 30 يوماً للمنتجات غير المستخدمة.</p>
  </:content>
</.accordion>
```

استخدم manual slots عندما يقاتل شكل القائمة التخطيط. استخدم `items` لصفوف كثيرة موحّدة من قاعدة البيانات.

## Compound: امتلك الشجرة

عندما لا تنتج الـ slots الـ DOM المطلوب، فعّل `compound` وركّب sub-components: `accordion_root` و`accordion_item` و`accordion_trigger` و`accordion_content` و`accordion_indicator`. مرّر `ctx` من `:let={ctx}` على الأب.

جرّب `items` والـ slots أولاً. compound هو مخرج طوارئ لكتل تسويقية وغلافات غريبة. [عرض تشريح الأكورديون](/ar/accordion/anatomy) يعرض compound بجانب minimal لتقارن حجم HTML قبل الالتزام.

## تشريح select في سطر

`<.select>` يستخدم `Corex.List.new/1` للخيارات، لا `label` + `content`. جمّع بـ`group` على كل map. الصفوف المخصّصة: `<:item :let={item}>`. placeholder عبر `translation={%Corex.Select.Translation{placeholder: "اختر…"}}`. نفس السلم، أسماء slots مختلفة.

## ما ليس تشريحاً

التشريح هو شكل القالب عند أول رسم. لا يغطي:

- `value` controlled و`on_value_change` ([آلات الحالة](/ar/blog/two-brains-liveview-assigns-and-zag-machines/))
- بحث combobox من الخادم مع `filter={false}` ([حجم combobox](/ar/blog/nine-thousand-airports-one-hundred-rows/))
- الرموز والمعدّلات على `data-part` ([تصميم Corex](/ar/blog/paint-the-parts-the-machine-already-owns/))

هذه الطبقات على نفس الشجرة. اجعل التشريح صحيحاً ليكون للـ hook أساس موثوق.

## افتح لوحة من مكان آخر

لفتح لوحة من عنصر تحكم آخر، أبقِ نفس `items` في القالب واستدعِ API:

```elixir
def handle_event("open-faq", _params, socket) do
  Corex.Accordion.set_value(socket, "faq", "shipping")
  {:noreply, socket}
end
```

`id` في `<.accordion id="faq" …>` يجب أن يطابق الوسيط الأول لـ`set_value/3`.

---

اختر أخف تشريح يطابق بياناتك وmarkup. الآلة لا تهتم إن اخترت minimal أو compound. أنت في المستقبل تهتم بكم HEEx ستصون.

التالي في السلسلة: [آلات الحالة](/ar/blog/two-brains-liveview-assigns-and-zag-machines/) للـ assigns والوضع controlled، ثم [vanilla JS](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) لجسر الـ hook، [التصميم](/ar/blog/paint-the-parts-the-machine-already-owns/) للمظهر، و[حجم combobox](/ar/blog/nine-thousand-airports-one-hundred-rows/) عندما يملك الخادم قائمة الخيارات.
