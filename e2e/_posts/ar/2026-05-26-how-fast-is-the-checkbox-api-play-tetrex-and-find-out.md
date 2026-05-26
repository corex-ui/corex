---
title: "ما سرعة واجهة Checkbox؟ العب Tetrex واكتشف."
description: "Tetrex عرض LiveView حيث 180 checkbox من Corex تشكّل اللوحة. تحديثات API على العميل للعب الفوري؛ Presence وGenServer للوحة الصدارة."
date: "2026-05-26 12:00:00 +0000"
permalink: /ar/blog/how-fast-is-the-checkbox-api-play-tetrex-and-find-out/
tags:
  - Tetrex
  - Corex
  - Checkbox
  - Phoenix
  - LiveView
sitemap:
  priority: 0.8
  changefreq: monthly
---

أردت اختبار ضغط يشبه لعبة، لا صفحة معايير. شيئاً تلعبه دقيقة وتفهم حدسياً هل hooks Corex تلحق عندما تتغيّر الحالة بسرعة وكثافة.

Tetrex هذا العرض: شبكة 10×18 من checkboxes Corex تتظاهر بأنها قطع Tetris. نفس آلة Zag لكل checkbox. نفس شجرة `data-part`. مقياس مختلف.

العب على [/ar/showcases/tetrex](/ar/showcases/tetrex). المهم ليس محرك اللعبة (JavaScript عادي في `tetrex_engine.js`). المهم كيف نحرّك **كثيراً** من instances checkbox دون جعل كل إطار round trip إلى LiveView.

## لوحة من checkboxes

كل خلية `<.checkbox>` حقيقي بـ id ثابت ومعدّلات BEM للون القطعة (`checkbox--accent`، `checkbox--info`، …). أثناء اللعب، hook `GameBoard` يحدّث جذور الخلايا مباشرة فلا يعيد LiveView رسم الشبكة كل tick.

لديك 180 عنصر تحكم يمكن الوصول إليه على الشاشة. اللعب بلوحة المفاتيح وقواعد التركيز وحالة checked عبر نفس hook Checkbox الموثّق في [/ar/checkbox/api](/ar/checkbox/api). Tetrex يستدعي API بعنف.

عند تحرك القطعة أو تثبيتها، hook `GameBoard` يعيد حساب الخلية على العميل ويحدّث البلاطات مكانها. بلا `phx-click` لكل خلية. بلا `handle_event` لكل إحداثية.

## API على العميل: لعب وإعادة فورية

Corex يعرض طريقتين لتحريك حالة checkbox من خارج العنصر:

- **مسار الخادم**: `Corex.Checkbox.set_checked/3` وما شابه، يستدعي `push_event` للـ hook (ما يعلّمه عرض API).
- **مسار العميل**: حدث DOM يستمع له الـ hook على الجذر.

Tetrex يستخدم مسار العميل لكل ما يجب أن يبدو فورياً:

```javascript
root.dispatchEvent(
  new CustomEvent("corex:checkbox:set-checked", {
    bubbles: false,
    detail: { checked: nextChecked }
  })
)
```

hook Checkbox يسجّل `corex:checkbox:set-checked` ويستدعي `zagCheckbox.api.setChecked(checked)` مباشرة. `applyCell` يزامن `data-state` على جزء التحكم ويتخطى العمل عندما لا شيء تغيّر، فالإطارات المتتالية لا تهز DOM.

عند كل تحرك أو مسح خط أو تثبيت، `afterChange` يشغّل `applyCells` على قائمة الرسم الكاملة. الإعادة تعيد نفس الشيء لكل إطار، مع حركات Motion اختيارية على صفوف المسح. الآلة تبقى صحيحة؛ تحديثات API تبقى محلية.

قصة الأداء: **دفعات تحديث checkbox في المتصفح**، لا **diffs كثيرة من LiveView عبر الشبكة**.

## ما يبقى على الخادم

منطق اللعب يعمل في المتصفح بعد أول رسم. LiveView يزرع الجلسة، يعرض الخزانة، ويستمع لأحداث خشنة.

عند تقدّم المحرك المحلي، الـ hook أحياناً `pushEvent("sync", …)` بلقطة عميل مضغوطة. **GenServer** لكل لعبة (`E2e.Tetrex.Session`) يستقبل تلك المزامنات:

- يضيف إطارات للإعادة (محدودة ومُعيّنة عينة لألعاب طويلة)
- يبث تحديثات للمشاهدين على `tetrex:session:<id>` بقائمة patch للخلايا
- عند انتهاء اللعبة، يحفظ النتيجة والإطارات إن تأهلت للعشرة الأوائل

التقسيم مقصود: **طلاء checkbox محلي**؛ **النتيجة وشريط الإعادة وحالة اللوبي للخادم**.

وضع المشاهدة يشترك في topic الجلسة ويطبّق patches `game_apply` نفسها للمتفرجين، بلا إعادة رسم 180 checkbox من HEEx كل tick.

## لوحة الصدارة وPresence وإعادات العشرة الأوائل

الفهرس في [/ar/showcases/tetrex](/ar/showcases/tetrex) يدمج ثلاث مصادر حية:

- **Registry** لمعرّفات الجلسات النشطة والنتائج
- **Phoenix Presence** على `tetrex:lobby` لمن يلعب أو يشاهد (عدد المشاهدين لكل لعبة)
- **Store** للعشرة المحفوظة والأسماء وJSON الإطارات

عند نتيجة عالية، `Store.finalize/4` يكتب اللعبة، يقلّص إلى عشرة، ويبث `:leaderboard_updated`. LiveViews تحدّث الجدول بلا إعادة تحميل كاملة.

الأشواط المؤهلة تفتح مسار **replay**. الخادم يحمّل الإطارات المخزنة، يدفع `replay_init` مرة، ونفس hook `GameBoard` يمشي التاريخ بـ`corex:checkbox:set-checked` مجدداً. تشغيل/إيقاف يستخدم toggles Corex عبر `corex:toggle:set-pressed` على عناصر التحكم.

Presence يجيب «من متصل الآن؟». GenServer يجيب «ماذا حدث في هذا المعرّف لعبة؟». قاعدة البيانات تجيب «ما أفضل عشر جولات احتفظنا بها؟».

## صلة ببقية Corex

- [تشريح مكوّن Corex](/ar/blog/anatomy-of-a-corex-component/): كل خلية checkbox بمعدّلات، لا markup مخصّص.
- [عقلان](/ar/blog/two-brains-liveview-assigns-and-zag-machines/): وضع اللعب يبقي سلطة التفاعل على العميل؛ المزامنة ونهاية اللعبة تسلّم للخادم.
- [Vanilla JS](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/): Checkbox chunk يُحمّل كسولاً؛ Tetrex يضيف hook `GameBoard` بجانب `…corex`.
- [Checkbox API](/ar/checkbox/api): النسخة التي يقودها الخادم لنفس سطح `setChecked` التي يستدعيها Tetrex من JavaScript.

إن كنت تقيّم Corex لوحات معلومات أو ألعاب أو أي واجهة تقلب حالة عناصر كثيرة في الثانية، Tetrex الاختبار الصريح: مئات تحديثات checkbox، إعادة سلسة، وPhoenix ما زال يملك لوحة الصدارة.

العب جولة. انظر إن كانت اللوحة تلحق أصابعك.
