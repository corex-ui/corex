---
title: "آلة Vanilla JS التي لا تحتاج إطار عمل"
description: "آلات Zag vanilla في hooks LiveView، وupdateProps وقت التشغيل، وتقسيم esbuild بحيث يُحمَّل كل مكوّن عند mount فقط."
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

Zag.js من المكتبات التي تغيّر فعلاً طريقة تفكيرك في الواجهة. آلات حالة لمكوّنات يمكن الوصول إليها، جوهرها بلا إطار، مع محوّلات لـ React وSolid وVue وSvelte. Segun (المنشئ) فعل نادراً: منطق التركيز ولوحة المفاتيح وسمات ARIA وانتقالات الفتح/الإغلاق كله في TypeScript خالص يستهلكه أي إطار.

تحدثت مع Segun على YouTube، وإن أردت فهم لماذا Zag أساس متين، تلك المحادثة نقطة بداية جيدة (آسف على جودة الميك فوق لهجتي 😅).

<div class="blog__embed">
<iframe width="560" height="315" src="https://www.youtube.com/embed/D1To2_5o8e8?si=yPg6P6oL4dph6H_L" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>

ما أوصلني هناك كان Corex. كنت أبني مكوّنات UI يمكن الوصول إليها لـ Phoenix LiveView، وZag كان الخيار الواضح للطبقة السلوكية. الآلات مجرّبة. إمكانية الوصول صحيحة. لم أرد إعادة كتابة أي من ذلك.

كم HEEx تكتبه لكل عنصر قرار منفصل: [تشريح مكوّن Corex](/ar/blog/anatomy-of-a-corex-component/). من يملك حالة التشغيل على الخادم مقابل الآلة قرار آخر: [عقلان](/ar/blog/two-brains-liveview-assigns-and-zag-machines/). ربط Zag بـ LiveView كان أثره أعمق مما توقّعت.

## الطبقة المناسبة لكل إطار

Zag يوفّر محوّلات للإطارات الكبرى لأن لكل منها نموذج تفاعلية. `@zag-js/react` يستخدم `useMachine` وhooks. `@zag-js/vue` يعتمد refs وwatchers. `@zag-js/svelte` يتصل بـ runes. هذه المحوّلات هي ما يُحيي الآلة داخل الإطار: تشترك في انتقالات الحالة وتعيد رسم المكوّنات تلقائياً.

Vanilla JS قصة مختلفة عن قصد. محوّل vanilla لا يفترض تفاعلية. ويجب أن يفعل ما لا تفعله محوّلات الإطارات: لمس DOM مباشرة. الآلات تحتاج مواقع العناصر وإدارة التركيز و`aria-*` والتمرير. في React الإطار يوسّط كل ذلك. بلا إطار، أنت تربط الآلة بالمستند نفسه.

لذلك `@zag-js/vanilla` رأي. يعطيك غلاف `VanillaMachine` قائم على class مع دورة `start()` / `stop()` واضحة، وتشترك في تغيّرات الحالة وتحدّث DOM بنفسك. Zag يوفّر أيضاً [مثال vanilla TypeScript](https://github.com/chakra-ui/zag/tree/main/examples/vanilla-ts) كاملاً.

لصفحة ثابتة هذا النموذج رائع. تُعدّ الآلة، يتفاعل المستخدم، انتهى. الـ props مرة واحدة.

Phoenix LiveView إيقاع مختلف.

## ما يحتاجه LiveView فعلاً

LiveView يرسم HTML على الخادم ويرسل patches DOM صغيرة عبر WebSocket عند تغيّر الحالة. المتصفح يطبّق diff. بلا virtual DOM، بلا شجرة مكوّنات على العميل. HTML الصحيح في اللحظة الصحيحة.

لتكامل JavaScript، LiveView لديه hooks: كائنات صغيرة على عقد DOM بـ`phx-hook`. تستقبل `mounted` و`updated` و`destroyed`. من داخل الـ hook تدفع أحداثاً للخادم وتستمع لما يعود.

نموذج جيد. الخادم يبقى يتحكّم بالبيانات، والعميل يتحكّم بالسلوك. للعناصر التي يمكن الوصول إليها هذا التقسيم المثالي: LiveView يدير القيم، Zag يدير سلوك العنصر.

التحدي أن LiveView يمكنه دفع تحديثات لعنصر مربوط في أي وقت. Select controlled حيث الخادم يحدد القيمة. Combobox يصفّي العناصر عند كل ضغطة. Dialog يغلقه الخادم برمجياً. كل ذلك يحتاج إخبار الآلة الجارية: شيء تغيّر، حدّث نفسك.

إصدارات مبكرة من `@zag-js/vanilla` شغّلت الآلة جيداً، لكن بلا تحديث props بعد التهيئة. الآلة مغلقة بعد `start`. للصفحات الثابتة هذا كافٍ. لـ LiveView، كان الشيء الناقص.

## إصلاح هادئ بعواقب كبيرة

ثم سطر في سجل Zag:

> Fix issue where vanilla machines do not have the option to change their props during runtime.

هذا كل ما قاله. بلا إعلان. إصلاح واحد.

لكنه يعني أن `VanillaMachine` يقبل `updateProps` بعد التشغيل. وعندما LiveView يطلق `updated` على hook، أقرأ `data-*` من العنصر بعد patch وأمرّرها للآلة. الآلة تتفاعل. ARIA يتحدّث. القيم controlled تتزامن. الخادم يبقى مسيطراً.

تكامل Phoenix انتقل من «غير ممكن فعلاً» إلى «لنبنِه».

## كيف يجمع Corex الأمر

Corex يلفّ `VanillaMachine` داخل كائنات hook Phoenix. عندما تكتب:

```heex
<.accordion id="faq" on_value_change="accordion_changed">
  ...
</.accordion>
```

Corex يرسم تشريح HTML كاملاً (جذر، محفّزات، لوحات، `data-part`، هيكل ARIA) ويربط `phx-hook="Accordion"` بالجذر.

على العميل، ثلاث callbacks تنجز العمل:

`mounted` يقرأ props من `data-*`، يشغّل `VanillaMachine`، يشترك في الانتقالات، ويبقي DOM متزامناً مع قرار الآلة.

`updated` يقرأ props من العنصر بعد patch ويستدعي `updateProps`. إن غيّر الخادم `value`، تعرف الآلة فوراً. إن أصبح عنصر معطّلاً، نفس الشيء. بلا إعادة mount، بلا فقدان حالة تفاعل.

Corex يستخدم أيضاً `JS.ignore_attributes` عند mount حتى لا تمحو patches LiveView `data-state` وحقول ARIA التي كتبها الـ hook. diff الخادم يدمج مع مخرجات الآلة بدل الاشتباك.

`destroyed` يستدعي `machine.stop()` لتفكيك نظيف.

الآلة تتولى كل السلوك: لوحة المفاتيح، أدوار ARIA، فتح/إغلاق، controlled/uncontrolled، إدارة التركيز. LiveView يتولى البيانات. الـ hook جسر.

## تقسيم chunks والتحميل عند mount

Corex يوفّر عشرات المكوّنات التفاعلية. كل واحد يسحب آلات Zag ومساعدات DOM وغالباً منطق مجموعة مشترك. لو كل hook في حزمة واحدة سمينة، كل صفحة تدفع ثمن حوارات وdate pickers وcomboboxes لا ترسمها.

نقسّم JavaScript عن قصد.

عند بناء Corex لـ Hex، esbuild يجمّع كل hook كمدخل ESM (`accordion.mjs`، `combobox.mjs`، …) مع **`--splitting`**. الكود المشترك يذهب إلى chunks مُجزّأة تحت `priv/static/chunks/`. أدوات Zag والمحوّلات vanilla تُعاد استخدامها بدل التكرار في كل ملف.

التصدير الافتراضي من `corex` ليس ذلك الكتالوج مضمّناً. إنه خريطة **أغلفة hooks كسولة**: كائنات `phx-hook` رقيقة عبر `createLazyHook`. عند `mounted`، الغلاف يشغّل `import("corex/accordion")` (أو المكوّن المطابق)، ثم يمرّر `updated` و`destroyed` و`beforeUpdate` للـ hook الحقيقي. الجلب يحدث في الخلفية والصفحة حية. مسار فيه أكورديون وcheckbox فقط لا يحمّل combobox أو dialog.

```javascript
import corex from "corex"

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...corex }
})
```

`...corex` يسجّل كل اسم قد يحتاجه LiveView، لكن المتصفح يطلب chunks للـ hooks التي mount فعلاً.

تطبيق Phoenix يجب أن يشارك النموذج نفسه. في `config/config.exs`، وسائط Esbuild لـ`assets/js/app.js` تحتاج **`--format=esm`** و**`--splitting`**، ووسم `<script>` في التخطيط الجذري **`type="module"`**. بلا splitting، `import()` الديناميكي لا يصبح ملفات منفصلة وتفقد مكسب الأداء. [دليل التثبيت اليدوي](https://hexdocs.pm/corex/manual_installation.html) يشرح الأعلام بالتفصيل.

لحزمة أصغر، استورد فقط الـ hooks التي ترسمها:

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

كل قيمة دالة تُرجع `import()`. Esbuild يصدّر chunks للقائمة فقط. المفاتيح يجب أن تطابق أسماء `phx-hook` (`Accordion`، `Combobox`، …).

في الإنتاج، `mix assets.deploy` يصغّر ويهضم نفس المدخل وchunks الـ hooks. راجع [دليل الإنتاج](https://hexdocs.pm/corex/production.html).

JS أولي أصغر، chunks مشتركة بين العناصر، تحميل كسول عند ظهور عقدة مربوطة: هكذا يبقى Corex قابلاً للاستخدام في تطبيقات LiveView ثقيلة دون تحميل كتالوج مكوّنات كاملاً في كل صفحة.

## إصداران، قصة واحدة

هذا الفصل الثاني. الإصدار الأول من Corex للمواقع الثابتة: Vite وAstro وEleventy، أي إعداد HTML عادي مع bundler. يعمل هناك لأن الصفحات الثابتة لا تحتاج تحديث props وقت التشغيل.

تكامل LiveView يبني على ما نجح هناك، ويضيف ما يحتاجه LiveView: آلات تتزامن مع خادم يغيّر رأيه.

على الخادم تستخدم مكوّنات Corex كأي HEEx. `import corex from "corex"` أعلاه هو قصة تسجيل العميل لمعظم التطبيقات.

آلات Zag تحت لا تعرف ولا تهتم أنها داخل Phoenix. تعمل وتبقي العناصر صحيحة ويمكن الوصول إليها، وLiveView يفعل ما يجيده: تحديث خادم فعّال عند الحاجة.

سطر صغير في changelog. أشهر عمل أصبحت ممكنة. هكذا يجري الأمر عادة.

بعد الـ hooks، [تصميم Corex](/ar/blog/paint-the-parts-the-machine-already-owns/) يلوّن شجرة `data-part`، و[بحث combobox من الخادم](/ar/blog/nine-thousand-airports-one-hundred-rows/) هو النمط الذي يضغط `updated` عند كل ضغطة.
