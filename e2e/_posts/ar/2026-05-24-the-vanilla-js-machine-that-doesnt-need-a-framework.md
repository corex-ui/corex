---
title: "آلة Vanilla JS التي لا تحتاج إطار عمل"
description: "Corex اعتمد على سطر واحد في سجل تغييرات Zag. بدونه، الآلات تبدأ لكن لا تأخذ props جديدة. به، انفتح تكامل Phoenix كاملاً في بعد الظهر."
date: "2026-05-24 12:00:00 +0000"
permalink: /ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/
tags:
  - JavaScript
  - Corex
  - Phoenix
  - LiveView
sitemap:
  priority: 0.7
  changefreq: monthly
---

النسخة من هذه القصة التي تتسع على شريحة قصيرة. اخترت Zag.js كطبقة سلوك لـ Corex، انتظرت قدرة واحدة مفقودة، ثم انفتح تكامل Phoenix كاملاً في بعد الظهر. النسخة الأطول نفس القصة، مع سياق لسبب أهمية هذا الفتح، وما يجعله ممكناً الآن.

## لماذا آلات الحالة أصلاً

أفكّر كثيراً في من يُسمح له بامتلاك دعم لوحة المفاتيح. معظم الفرق التي عملت معها تحصل على إمكانية الوصول صحيحة مرة واحدة: يوم يهتم فيه المصمم، أو يوم يصل التدقيق. ثم تنجرف. ترتيب Tab يختل لأن أحد أضاف غلافاً. مفاتيح الأسهم تتوقف على قائمة منسدلة لأن أحد أعاد هيكلة slot. ARIA تعود `false` لأن لا أحد يتذكر أي سمة كان يجب أن تكون حية.

آلات الحالة تحل ذلك بتشفير السلوك في مكان واحد وترك بقية التطبيق يرفض الاهتمام. Zag.js مكتبة من تلك الآلات، كتبها Segun Adebayo، مستقلة عن الإطار في الجوهر، مع محولات لـ React وSolid وVue وSvelte. الأجزاء الصعبة (حلقات التركيز، typeahead، roving tabindex، كل اختصار لوحة مفاتيح يتوقعه مصمم جيد، قاموس WAI-ARIA كامل) في TypeScript نقي. مُختبرة في المعركة من آلاف الفرق لم تضطر للتفكير فيها.

كان لدي حوار مع Segun على YouTube. إن أردت فهم لماذا Zag قاعدة صلبة، ذلك الفيديو المكان الصحيح. اعتذار عن جودة الميكروفون فوق لهجتي.

<div class="blog__embed">
<iframe width="560" height="315" src="https://www.youtube.com/embed/D1To2_5o8e8?si=yPg6P6oL4dph6H_L" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

ما أوصلني هناك كان Corex. كنت أبني مكوّنات يمكن الوصول إليها لـ Phoenix LiveView ولم أرد شحن سلوكيات صحيحة 90% لأنني أعدت كتابتها بنفسي.

## لمحول vanilla آراءه الخاصة، عن قصد

محولات إطار Zag تقوم بعمل محدد: تشترك في آلة وتخبر إطارها بإعادة الرسم عند تغيّر الحالة. React يستخدم hooks. Vue يستخدم refs. Svelte يستخدم runes. كل محول يتحدث لهجة reactivity المحلية.

محول vanilla لا يستطيع الاعتماد على أي منها. ليس لديه نموذج reactivity للاشتراك فيه. ويجب أن يفعل شيئاً لا تفعله محولات الإطار مباشرة: لمس DOM نفسه. يقرأ المواضع، يضبط التركيز، يكتب `aria-*`، يدير التمرير. في React، الإطار يوسّط كل ذلك. بلا إطار، أنت الجسر بين الآلة والمستند.

لهذا شكل `@zag-js/vanilla` كما هو. تحصل على `VanillaMachine` قائم على class مع دورة حياة واضحة `start()` / `stop()`. تشترك في تغيّرات الحالة وتكتب DOM بنفسك. مستودع Zag يشحن [مثال vanilla TypeScript كامل](https://github.com/chakra-ui/zag/tree/main/examples/vanilla-ts) يوضح النمط.

لصفحة ثابتة تُشحن مرة وتعمل محلياً، هذا رائع. أعدّ الآلة، يتفاعل المستخدم، انتهى. Props تدخل مرة والآلة تعمل من هناك.

Phoenix LiveView له إيقاع مختلف.

## ما يحتاجه LiveView فعلاً

LiveView يرسم HTML على الخادم ويرسل patches DOM صغيرة عبر WebSocket عندما تتغيّر الحالة. المتصفح يطبّق الفرق. لا virtual DOM. لا رسم بياني مكوّنات على العميل. فقط HTML الصحيح في اللحظة الصحيحة.

لتعامل JavaScript، LiveView يعطيك hooks. كائنات صغيرة تربطها بعناصر DOM بـ `phx-hook`، تستقبل callbacks دورة الحياة: `mounted`، `updated`، `destroyed`، والمزيد. من داخل hook تدفع أحداثاً للخادم، تستمع لأحداث من الخادم، وتقرأ DOM مباشرة.

هذا نموذج جيد حقاً. الخادم يبقى مسؤولاً عن البيانات. العميل يتولى السلوك. لمكوّنات يمكن الوصول إليها، هذا التقسيم بالضبط حيث تريد الخط: LiveView يقرر القيم، Zag يقرر كيف يتصرّف المكوّن.

المكمن أن LiveView يمكنه دفع تحديثات لعنصر مربوط في أي وقت. select controlled حيث الخادم يثبت الخيار الحالي. combobox حيث الخادم يستبدل كل خيار عند كل ضغطة. حوار يغلقه الخادم من مؤقت أو حدث Presence. كل واحد يحتاج إخبار الآلة الجارية: prop تغيّر للتو، حدّث نفسك.

الإصدارات المبكرة من `@zag-js/vanilla` كانت تبدأ آلة وتشغّلها جيداً، لكن لا يمكنك تغيير props بعد التهيئة. الآلة كانت مختومة فعلياً بعد `start()`. لموقع ثابت هذا كان جيداً. لـ LiveView، كان الشيء الوحيد المفقود.

## سطر في سجل التغييرات

يوماً سطر في سجل تغييرات Zag:

> Fix issue where vanilla machines do not have the option to change their props during runtime.

هذه الجملة كلها. لا إعلان. لا تسويق. إصلاح واحد.

ما عناه فعلاً أن `VanillaMachine` ستقبل الآن استدعاءات `updateProps` في أي وقت بعد `start()`. أي عندما يطلق LiveView `updated` على hook، يمكن للـ hook قراءة `data-*` الطازجة من العنصر المُصحَّح وتمريرها مباشرة للآلة الجارية. تتفاعل الآلة. يتحدّث ARIA. تتزامن القيم controlled. الخادم يبقى مسؤولاً والمستخدم لا يلاحظ.

تكامل Phoenix انتقل من «ليس ممكناً حقاً» إلى «لنبنِه» بين ذلك الإصدار والعشاء.

## كيف يجمع Corex الأمر

عندما تضع مكوّن Corex في قالب، الخادم يرسم الـ markup كاملاً: `data-scope` و`data-part` الصحيحة، هيكل ARIA الصحيح، و`phx-hook="ComponentName"` على الجذر.

على العميل، ثلاثة callbacks دورة الحياة تقوم بكل العمل.

`mounted` يقرأ props المُسلسلة من `data-*`، يبدأ `VanillaMachine`، يشترك في انتقالات الحالة، ويبدأ إبقاء DOM متزامناً مع ما تقرر الآلة.

`updated` يقرأ props المُصحَّحة من نفس الجذر ويستدعي `updateProps` على الآلة. إن غيّر الخادم `value`، تعرف الآلة فوراً. إن أصبح عنصر معطّلاً، نفس الشيء. لا remount. لا فقدان تركيز. لا رمي حالة تفاعل.

`destroyed` يستدعي `machine.stop()` لتفكيك نظيف.

فوق ذلك، Corex يطبّق `JS.ignore_attributes` على كل جذر عند mount، حتى لا يزيل diffing في LiveView `data-state` و`aria-*` التي كتبها الـ hook للتو. patch والآلة يكتبان سمات مختلفة ويبقيان بعيدين عن بعضهما بأدب.

الآلة تتولى كل شيء سلوكي. LiveView يتولى البيانات. الـ hook رسول صغير بلا منطق خاص.

## إصداران، قصة واحدة

هذه في الواقع الفصل الثاني من Corex. الإصدار الأول للمواقع الثابتة: Vite، Astro، Eleventy، أي شيء تكتب فيه HTML عادي مع bundler. تلك النسخة تعمل بجمال لأن الصفحات الثابتة لا تحتاج تحديث props في وقت التشغيل. تضبط props مرة، الآلة تعمل، المستخدمون يتفاعلون.

تكامل LiveView يبني على كل ما نجح هناك، ويضيف الشيء الذي يحتاجه LiveView تحديداً: آلات تبقى متزامنة مع خادم يغيّر رأيه.

على جانب الخادم، تستخدم مكوّنات Corex كأي مكوّن HEEx. على العميل، قصة التسجيل استيراد واحد.

```javascript
import corex from "corex"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: { ...corex }
})
```

هذا الإعداد كله لمعظم التطبيقات.

## لماذا استيراد واحد ليس استيراداً ثقيلاً

Corex يشحن عشرات المكوّنات التفاعلية. كل واحد يسحب آلة Zag، بعض مساعدات DOM، وقليل من منطق collection مشترك. إن هبط كل hook في حزمة واحدة، كل صفحة في تطبيقك تدفع date pickers وحوارات وcomboboxes لا تستخدمها.

لذلك JavaScript مُقسَّم عن قصد. عند بناء Corex لـ Hex، esbuild يجمّع كل hook كمدخل ESM خاص (`accordion.mjs`، `combobox.mjs`، وهكذا) مع `--splitting` مفعّل. الكود المشترك بين hooks يذهب لقطع مُهاشة. أدوات Zag ومحولات vanilla تُعاد استخدامها، لا تُكرَّر.

التصدير الافتراضي من `corex` ليس الكتالوج كاملاً مضمناً. هو خريطة stubs كسولة. كل واحد كائن `phx-hook` صغير أنشأه `createLazyHook`. عندما ي mount LiveView عنصراً مربوطاً، الـ stub يشغّل `import("corex/accordion")` ديناميكياً (أو أي مكوّن طابق)، ثم يمرّر كل callback لاحق للـ hook الحقيقي. مسار فيه accordions وcheckboxes فقط لا يحمّل combobox أو dialog.

لكي يعمل هذا من البداية للنهاية، تطبيق Phoenix يجب أن يشارك. وسائط esbuild لـ `assets/js/app.js` يجب أن تتضمن `--format=esm --splitting`، ووسم script في التخطيط الجذر يجب أن يستخدم `type="module"`. بلا splitting، استدعاءات `import()` الديناميكية لا تصبح ملفات منفصلة وتفقد الفائدة. [دليل التثبيت اليدوي](https://hexdocs.pm/corex/manual_installation.html) فيه الأعلام بالضبط.

إن أردت رسم بياني أصغر، استورد فقط hooks التي ترسمها فعلاً:

```javascript
import { hooks } from "corex/hooks"

const liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    ...hooks({
      Accordion: () => import("corex/accordion"),
      Combobox: () => import("corex/combobox"),
    }),
  },
})
```

كل قيمة دالة تُرجع `import()`. Esbuild يصدّر قطعاً فقط للـ hooks المدرجة. المكوّنات غير المستخدمة يمكن اقتلاعها من حزمتك. المفاتيح تطابق أسماء `phx-hook` المُصدرة على الخادم.

## فكرة الجسر

إن نسيت كل شيء آخر في هذا المنشور، الجزء الذي يستحق الاحتفاظ بهذا. آلات Zag لا تعرف أنها تعمل داخل Phoenix. تعمل فقط. لا تهتم إن جاءت props من حالة React أو من patch LiveView. hook Corex هو المحول الصغير الذي يتيح لخادم Phoenix تغيير رأيه حول قيمة دون سحب تفاعل المستخدم معها.

سطر في سجل تغييرات. أشهر من العمل أصبحت ممكنة. عادة هكذا تسير هذه الأمور.

بعد وضع hooks، [تصميم Corex](/ar/blog/paint-the-parts-the-machine-already-owns/) ينسّق هيكل `data-part` الذي تحافظ عليه الآلات، [عقلان](/ar/blog/two-brains-liveview-assigns-and-zag-machines/) يشرح العقد بين assigns والآلات، و[بحث combobox المغذّى من الخادم](/ar/blog/nine-thousand-airports-one-hundred-rows/) هو النمط الذي يضغط `updated` عند كل ضغطة.
