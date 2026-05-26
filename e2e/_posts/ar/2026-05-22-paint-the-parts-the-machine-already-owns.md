---
title: "لوّن الأجزاء التي تملكها الآلة"
description: "hooks Corex تملك السلوك وARIA. Corex Design يملك الرموز والأدوات المشتركة ومعدّلات BEM على نفس شجرة data-part."
date: "2026-05-22 12:00:00 +0000"
permalink: /ar/blog/paint-the-parts-the-machine-already-owns/
tags:
  - Corex
  - Design tokens
  - Accessibility
sitemap:
  priority: 0.8
  changefreq: monthly
---

مكوّنات Corex تعمل بلا CSS مجمّع. الـ hook ما زال يعمل. الشجرة ما زالت تحصل على `data-state` و`data-part`. يمكنك شحن سلوك يمكن الوصول إليه أولاً والتفكير في الطلاء لاحقاً.

ما زلت ألجأ إلى **Corex Design** في كل تطبيق حقيقي، لأن السلوك والمظهر يجيبان عن سؤالين مختلفين. الآلة لا تقرأ `site.css`. لا تهتم إن كان حقل combobox يستخدم رموز neo أو uno. التصميم يستهدف **الجسد** الذي يحدّثه الـ hook: عقد `[data-scope][data-part]` بأسماء ثابتة.

[تشريح مكوّن Corex](/ar/blog/anatomy-of-a-corex-component/) يحدد كم HEEx تكتب. [آلات الحالة](/ar/blog/two-brains-liveview-assigns-and-zag-machines/) و[vanilla JS](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/) يحددان كيف يبقى التفاعل صحيحاً. التصميم ما يراه المستخدم بعد mount.

## لماذا المركزية بدل CSS لكل صفحة

بلا Design، كل صفحة نموذج تنمو قواعدها. حلقة تركيز combobox في `site.css`. حشوة حقل كلمة المرور لحملة واحدة. إصلاح تباين على `native-input` لا يصل لحقل combobox لأنهما selectorان كُتبا في أشهر مختلفة.

Corex Design يعكس ذلك:

- **الرموز** تعرّف الحبر والحدود والتباعد والزوايا مرة واحدة.
- **الأدوات المشتركة** (`ui-input`، `ui-trigger`، `ui-item`، `ui-content`) تجمّع الرموز في أنماط.
- **CSS المكوّن** يطبّق `@apply` على `data-part` المناسب.
- **المعدّلات** على الجذر (`combobox--accent`، `button--lg`) تضبط نسخة واحدة.

غيّر `ui-input` مرة وكل عنصر يكتب عبره يتحرك معاً: `native-input` وcombobox وpassword-input وpin-input وeditable.

```css
.native-input [data-scope="native-input"][data-part="input"] {
  @apply ui-input;
}
```

المحفّزات تستخدم `ui-trigger` بنفس الطريقة. صفوف القوائم `ui-item`. الأسطح العائمة `ui-content`. نادراً تضيف هذه الفئات في HEEx؛ CSS المكوّن يجمّعها.

## التباين في الرموز، لا استثناءات عشوائية

اللوحات تُولَّد بـ [Adobe Leonardo](https://leonardocolor.io/) ضد نسب تباين مستهدفة. ملفات الرموز تسجّل النتيجة (مثلاً **7.0:1** للحبر الأساسي على خلفية الصفحة). `--color-ink` و`--color-ink-muted` و`--color-border` والألوان الدلالية تغذي أدوات Tailwind (`text-ink`، `border-border`) والأدوات أعلاه.

```corex-callout note
تباين من اليوم الأول

بعد ترقية Corex، شغّل **`mix corex.design --force`** حتى يطابق `assets/corex/` CSS المكوّنات التي تتوقعها hooks.

إن فشل تسمية في التدقيق، بدّل السمة أو الوضع أو معدّلاً دلالياً (`button--accent` مقابل `button--muted`) قبل overrides في `site.css`.
```

لأن `ui-input` يقرأ `var(--color-border)` و`var(--color-ink-muted)` للـ placeholder، إصلاح الرمز ينتشر لكل جزء على شكل حقل.

## انسخ شجرة التصميم مرة واحدة

```bash
mix corex.design
```

تحرير الرموز اختياري:

```bash
mix corex.design --designex
```

الملفات تحت `assets/corex/`. المسارات الموجودة تُتخطى افتراضياً. استخدم `--force` بعد ترقية Hex عند تغيّر CSS المكوّن.

## `site.css` رفيع، استيراد صريح

القوالب تبقى رفيعة: بلا selectors جديدة على داخليات Corex.

```css
@import "../corex/main.css";
@import "../corex/theme/neo.css";
@import "../corex/components/typo.css";
@import "../corex/components/layout.css";
@import "../corex/components/native-input.css";
@import "../corex/components/combobox.css";
@import "../corex/components/button.css";
```

أضف `@import "../corex/components/<name>.css"` لكل مكوّن في الصفحة. وجّه Tailwind بالشجرة: `@source "../corex";`.

السمة والوضع على المستند؛ الطباعة والتخطيط على body:

```heex
<html lang="ar" data-theme="neo" data-mode="light">
  <body class="typo layout">
    {@inner_content}
  </body>
</html>
```

السمات **neo** و**uno** و**duo** و**leo** لكل منها ملفات light وdark. بدّل `data-theme` أو `data-mode` على `<html>` وكل مكوّن يقرأ المتغيّرات يتحدّث معاً.

إن كان التطبيق ما زال يحمّل daisyUI من `phx.new` الافتراضي، أزله. نظاما رموز يتنافسان على نفس الأدوات.

## معدّلات على الجذر

كل مكوّن منمّق له فئة جذر بنفس الاسم. كدّس المعدّلات على الجذر:

```heex
<.accordion
  class="accordion accordion--accent accordion--lg accordion--rounded-lg"
  id="faq"
  items={@topics}
/>
```

```heex
<.combobox class="combobox combobox--accent combobox--lg" id="airport" items={@items}>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

اللون (`--accent`، `--alert`) والحجم (`--sm`، `--lg`) ونصف القطر (`--rounded-xl`) والنوع (`--text-lg`) تربط متغيّرات CSS عبر `@utility` في ملف المكوّن. تلوّن أجزاء تستخدم الأدوات المشتركة؛ لا تفرّع `ui-input`.

## `data-state` ليست مهمتك

**`data-state`** و**`data-highlighted`** وسمات الفتح/الإغلاق من الآلة، لا من HEEx. CSS التصميم يختارها على أجزاء يحافظ عليها الـ hook. تلوّن ما كتبه العقل.

## HEEx ثابت عندما يتحرك التصميم

القوالب تمرّر معدّلات على الجذر وheroicons عارية داخل slots. بلا `class` على heroicon. CSS الأب يحدّد حجم الأيقونات. بلا قاعدة لكل صفحة لـ«combobox في الدفع». إن احتاج الدفع تنبيه، `combobox--alert` على الجذر يكفي.

عندما السلوك صحيح والمظهر خطأ، غيّر الرموز أو الأدوات أو المعدّلات، ثم حدّث CSS المنسوخ من Hex إن لزم.

## ما لا تفعله في القوالب

- بلا selectors جديدة في `site.css` تتجاوز داخليات `[data-scope]`
- بلا أنماط تركيز مكررة لكل LiveView
- بلا أسماء فئات مخترعة بجانب المعدّلات الموثّقة
- بلا `class` على heroicons داخل مكوّنات Corex

Corex Design لا يغيّر التشريح أو hooks أو أحداث الخادم. يغيّر المظهر بعد mount فقط.

---

الرموز تعرّف اللوحة والمقياس. الأدوات تعرّف الحقول والمحفّزات والعناصر والأسطح. CSS المكوّن يربط الأدوات بـ`data-part`. المعدّلات تضبط نسخة واحدة على الجذر.

عندما يكبر الكتالوج عن المتصفح، [حجم combobox](/ar/blog/nine-thousand-airports-one-hundred-rows/) يحافظ على نفس اللغة البصرية مع `items` من الخادم.
