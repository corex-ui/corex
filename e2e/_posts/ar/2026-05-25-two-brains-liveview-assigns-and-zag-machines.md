---
title: "عقلان: assigns في LiveView وآلات Zag"
description: "عملية LiveView تملك assigns. آلة Zag تملك التفاعل داخل الـ hook. الوضع controlled هو كيف تختار من يفوز."
date: "2026-05-25 12:00:00 +0000"
permalink: /ar/blog/two-brains-liveview-assigns-and-zag-machines/
tags:
  - State Machines
  - Zag.js
  - Corex
sitemap:
  priority: 0.7
  changefreq: monthly
---

كل شاشة Corex فيها عقلان.

الأول مألوف: **عملية** LiveView مع **assigns**. الأحداث تصل إلى `handle_event/3`. الحالة تتغيّر. LiveView يعيد رسم أجزاء HEEx الديناميكية ويرسل patch عبر WebSocket.

الثاني يسهل تفويته حتى يوم يرمش الواجهة: **آلة حالة Zag.js** داخل `phx-hook`. تقرر أي لوحة مفتوحة، أي خيار مميّز، أين يذهب التركيز، وأي `aria-*` على كل `data-part`.

HEEx هو الهيكل. الآلة هي الجهاز العصبي. [تشريح مكوّن Corex](/ar/blog/anatomy-of-a-corex-component/) يحدد حجم الهيكل. هذا المنشور عن من يملك حالة التشغيل، وكيف تمنعهم من الاشتباك.

## ثلاث طبقات، جذر واحد

| الطبقة | تملك |
|--------|------|
| HEEx function component | البنية، `data-scope` / `data-part`، slots، `items={…}`، props على `data-*` |
| LiveView hook | `mounted` و`beforeUpdate` و`updated` و`destroyed`؛ الجسر إلى الآلة |
| `VanillaMachine` | الانتقالات، لوحة المفاتيح، ARIA؛ `updateProps` عند patch الخادم |

الـ hook يشترك مرة، يعيد رسم الأجزاء عند كل انتقال، وعلى `updated` يقرأ props من العنصر بعد patch. دورة الحياة في [آلة Vanilla JS التي لا تحتاج إطار عمل](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). هنا نبقى على العقد بين assigns وحالة الآلة.

## Uncontrolled: الآلة تقود

افتراضياً مكوّنات Corex **غير controlled**. يمكنك تعيين `value` للرسم الأول. بعدها الآلة تحتفظ باللوحات المفتوحة والاختيار في الذاكرة. التفاعل بلا round trip ما لم تفعّل الخيار.

يناسب واجهة محلية: FAQ، إفصاحات، تبويبات لا تهم إلا في هذه الصفحة. `on_value_change` اختياري للتحليلات أو رد خفيف من الخادم.

## Controlled: الخادم يقود

عندما التحقق أو الصلاحيات أو منطق عبر عناصر يعيش على الخادم، استخدم **`controlled`** مع **`value={@assign}`** و**`on_value_change`**.

الحلقة:

1. المستخدم يتصرّف داخل العنصر.
2. الـ hook يستدعي `pushEvent` بالاسم من `data-on-value-change`.
3. `handle_event/3` يحدّث assign.
4. LiveView يعدّل الجذر؛ `updated` يمرّر القيمة الجديدة للآلة.

```elixir
def handle_event("faq_value_change", %{"value" => value}, socket) do
  {:noreply, assign(socket, :open, Corex.Accordion.validate_value!(value))}
end
```

```heex
<.accordion
  id="faq"
  controlled
  value={@open}
  on_value_change="faq_value_change"
  items={@topics}
/>
```

كاتبان بلا تنسيق يسببان وميضاً أو واجهة عالقة: assign والآلة يعتقدان أنهما يملكان `value`. اختر سلطة واحدة لكل جزء من الحالة.

## Patches دون دوس على الآلة

عند تغيّر assigns، LiveView يحسب diff ويشغّل `beforeUpdate` / `updated` على الجذور المربوطة. Corex يعلّم سمات الآلة حتى لا يمسح patch `data-state` و`aria-expanded` وما شابه. الجذور تستخدم `JS.ignore_attributes` على `phx-mounted` لدمج diff الخادم مع حالة العميل.

إذا غيّرت `items` أو `value` في `handle_event`، توقّع `updated` لتحديث props الآلة. إذا تغيّرت assigns غير مرتبطة فقط، قد يتخطى change tracking شجرة combobox. هذا Phoenix يعمل كما يجب.

## أوامر من الخادم بلا نقرة

أحياناً يجب تحريك الواجهة من الخادم: تبديل سمة، إغلاق حوار بمؤقت، فتح لوحة من بانر. **`Phoenix.LiveView.push_event/3`** يصل إلى `handleEvent` في الـ hook. مساعدات مثل **`Corex.Accordion.set_value/3`** تغلّف النمط نفسه.

## Combobox: سلوك الآلة، كتالوج الخادم

القوائم الكبيرة تبقى assign واحداً: **`items`**. الآلة تدير التمييز والفتح والمفاتيح. LiveView يدير **أي صفوف موجودة**.

التدفق المعتاد:

1. `mount`: `assign(socket, :items, Corex.List.new([...]))`
2. `on_input_value_change`: بحث في قاعدة البيانات، assign لقائمة محدودة
3. القالب: `items={@items}` و**`filter={false}`** عندما التصفية على الخادم

النمط الكامل في [تسعة آلاف مطار، مئة صف](/ar/blog/nine-thousand-airports-one-hundred-rows/). جرّبه حياً على [/ar/combobox/patterns](/ar/combobox/patterns).

## ما لا تعيد تنفيذه في HEEx

Zag يشفّر مسبقاً الفتح/الإغلاق، roving tabindex، typeahead، فهرسة المجموعة، وARIA على كل جزء. قالبك يوفّر البنية والبيانات. الـ hook يشترك ويستدعي `render` بعد الانتقالات.

إن بدا شيء خاطئاً بعد التفاعل، اسأل:

1. assign controlled غير متزامن مع الآلة؟ `handle_event` ناقص؟
2. تغيير الخادم مُهمَل: هل عُيّنت `value` أو `items` فعلاً؟
3. السمات تومض ثم تعود: patch مقابل `render` الآلة؛ راجع ignore attributes على الجذر.
4. الـ hook لا يتحدّث: **`id`** ثابت على العنصر المربوط؟

## نموذج ذهني

**التشريح** سطح HEEx. **آلات الحالة** سلوك وقت التشغيل داخل `phx-hook`. **LiveView** يملك حالة العملية في assigns والأحداث. **التصميم** ([تصميم Corex](/ar/blog/paint-the-parts-the-machine-already-owns/)) يلوّن عقد `data-part` التي تحافظ عليها الآلة.

افصل هذه الأدوار ويبقى Corex متوقّعاً من FAQ إلى بحث مطارات يغذّيه الخادم.
