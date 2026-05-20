---
title: "Corex مع Vanilla JS"
description: "سجّل خطافات Corex من npm في أي تطبيق Phoenix LiveView، أو استخدم الآلات نفسها خارج Phoenix."
date: "2026-05-24 12:00:00 +0000"
permalink: /ar/blog/vanilla-js/
tags:
  - JavaScript
  - Corex
  - Node.js
sitemap:
  priority: 0.7
  changefreq: monthly
---

يوفّر Phoenix LiveView تجارب تفاعلية غنية وفورية مع HTML يُعرَض من الخادم. يمر التفاعل بين العميل والخادم عبر **`LiveSocket`**: اتصال دائم بعد أول عرض HTTP، مع إرسال التحديثات كفروق DOM بدلاً من إعادة تحميل الصفحة كاملة. راجع دليل [الترحيب](https://hexdocs.pm/phoenix_live_view/welcome.html) لفهم هذا النموذج.

يوجد Corex في طبقة **التشغيل البيني لـ JavaScript**: نفس **الخطافات على العميل** الموضّحة في [الخطافات على العميل عبر `phx-hook`](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook)، مدعومة بآلات حالة Zag.js. يوفّر Phoenix الترميز والخصائص المسلسلة. يوفّر الخطاف السلوك.

## LiveSocket وخيار `hooks`

لتفعيل التفاعل بين عميل LiveView والخادم، تنشئ مثيلاً من `LiveSocket`. يبدو `app.js` النموذجي في Phoenix 1.8 هكذا:

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }
})
liveSocket.connect()
```

تتضمن خيارات LiveView **`hooks`**: مرجع إلى مساحة أسماء خطافات يعرّفها المستخدم وتحتوي على استدعاءات العميل للتشغيل البيني بين الخادم والعميل. يسجّل Corex هناك:

```javascript
import corex from "corex"

let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: { ...corex }
})

liveSocket.connect()
```

يُضيف **`...corex`** كل التصدير (`Accordion`, `Combobox`, `Select`, `Dialog`, …) إلى تلك المساحة. يجب أن يطابق النص في **`phx-hook`** اسم التصدير حرفياً.

لصفحة بها عنصر تحكم واحد، استورد وحدة خطاف واحدة:

```javascript
const { Accordion } = await import("corex/hooks/accordion")

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: { Accordion }
})
```

حافظ على توافق إصدار حزمة **corex** من npm مع إصدار Hex **corex**. الجانب Elixir يُسلسل السمات إلى `data-*` على الجذر؛ يقرأ الخطاف ذلك الشكل في `mounted` و`updated`.

## الخطافات على العميل عبر `phx-hook`

من [دليل التشغيل البيني لـ JavaScript](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook):

> لمعالجة JavaScript مخصّص على العميل عند إضافة عنصر أو تحديثه أو إزالته من الخادم، يمكن توفير كائن خطاف عبر `phx-hook`.

تعرض مكوّنات Corex عنصر جذر مشابهاً لـ:

```heex
<div
  id={@id}
  phx-hook="Accordion"
  data-loading
  {Connect.props(...)}
>
```

عند استخدام **`phx-hook`**، يجب دائماً تعيين **`id` فريد في DOM**. يستخدمه LiveView لإيجاد مثيل الخطاف عبر التصحيحات.

### استدعاءات دورة الحياة

يجب أن يشير `phx-hook` إلى كائن يحتوي هذه الاستدعاءات (تنفّذها Corex كلها على المكوّنات التفاعلية):

| الاستدعاء | متى يُنفَّذ |
|----------|----------------|
| **`mounted`** | أُضيف العنصر إلى DOM وانتهى LiveView الخادم من التثبيت |
| **`beforeUpdate`** | على وشك تحديث العنصر في DOM (متزامن؛ لا يمكن تأجيله) |
| **`updated`** | حدّث الخادم العنصر في DOM |
| **`destroyed`** | أُزيل العنصر من الصفحة |
| **`disconnected`** | انقطع LiveView الأب عن الخادم |
| **`reconnected`** | أعاد LiveView الأب الاتصال |

داخل كل استدعاء، للخطافات وصول إلى:

- **`this.el`**: عقدة DOM المرتبطة
- **`this.liveSocket`**: مثيل `LiveSocket`
- **`this.pushEvent(event, payload)`**: إرسال حدث من العميل إلى LiveView، كربط `phx-click`
- **`this.pushEventTo(selectorOrTarget, event, payload)`**: استهداف LiveView أو LiveComponent محدّد
- **`this.handleEvent(event, callback)`**: معالجة أحداث يدفعها الخادم

يربط Corex سمات الخادم مثل `on_value_change` بـ **`pushEvent`**، وأحداث الخادم **`push_event`** / `handle_event` على الخطاف بواجهات الآلة.

### خطافات خارج LiveView

تذكر وثائق LiveView: عند استخدام الخطافات **خارج** سياق LiveView، يُستدعى **`mounted` فقط**، وتُتتبَّع فقط العناصر الموجودة عند جاهزية DOM. لإضافة أو إزالة أو تحديث عقد مربوطة بخطاف ديناميكياً، تحتاج LiveView (أو اتصال `LiveSocket` بسيطاً) حتى يُشغَّل **`updated`** و**`destroyed`** عندما يصحّح الخادم الشجرة.

لهذا السبب تحمّل صفحات الأسئلة الشائعة الثابتة `phoenix_live_view` وتستدعي `liveSocket.connect()` حتى عندما يكون معظم الصفحة HTML عادياً.

## ماذا يحدث في `mounted`

في **`mounted`**، يقوم خطاف Corex بما يلي:

1. يقرأ **خصائص `data-*`** من `this.el` (حالة الفتح، الوضع المُتحكَّم به، أسماء الأحداث، بيانات المجموعة).
2. يبني غلاف TypeScript (`new Accordion(this.el, { … })`).
3. يشغّل **`VanillaMachine`** من Zag ويشترك بحيث يعيد كل انتقال رسم ARIA و`data-state` على عقد `[data-part="…"]`.
4. يسجّل مستمعي **`handleEvent`** لأحداث الخادم والأحداث الداخلية في DOM.

حتى يكتمل **`mounted`**، يبقى الجذر في الغالب HTML ثابتاً مع `data-loading`. بعده تكون الآلة هي العقل؛ يحافظ **`render`** على توافق DOM مع الحالة.

## ماذا يحدث في `updated`

يعيد LiveView العرض تصريحياً عند تغيّر **assigns**، ثم يدفع تصحيح DOM. للجذور المربوطة بخطاف، يُشغَّل **`updated`** بعد أن يغيّر الخادم العنصر.

يقرأ Corex التسلسل الجديد من الجذر (`data-value`, `data-controlled`, أعلام التعطيل، سمات التخطيط) ويستدعي **`updateProps`** على الآلة. في الوضع **controlled**، يجب أن يطابق assign `value` على الخادم ما يمرّره الخطاف إلى الآلة، وإلا سيتعارض الواجهة بعد التصحيح التالي.

هذا هو نصف العميل من [تتبّع التغيير](https://hexdocs.pm/phoenix_live_view/assigns-eex.html): يعيد LiveView إرسال الأجزاء **الديناميكية** من القالب فقط عند تغيّر assigns. يتفاعل الخطاف مع ما وصل إلى الجذر كـ `data-*`، وليس مع `@assigns` مباشرة.

## ماذا يحدث في `destroyed`

عند إزالة العنصر، يفكّ الخطاف المستمعين ويستدعي **`machine.stop()`**. لا آلات مكرّرة إذا أعاد LiveView تثبيت نفس `id` لاحقاً.

## تصحيح DOM والسمات التي تملكها الآلة

يمكن لـ [تصحيح DOM](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching) في LiveView استخدام `phx-update` بقيم مثل `replace` و`stream` أو **`ignore`**. الحاويات ذات **`ignore`** تتخطى استبدال DOM الداخلي حتى تملك المكتبات على العميل (أو الخطافات) الشجرات الفرعية.

يستخدم Corex **`phx-mounted`** مع `Phoenix.LiveView.JS.ignore_attributes/1` حتى لا يمحو LiveView السمات التي تكتبها الآلة (`data-state`, `aria-*`, بيانات التركيز) في كل تصحيح. **`JS.ignore_attributes`** على مستوى العنصر في أجزاء الـ accordion تلعب الدور نفسه للمحفّزات واللوحات.

بعبارة أخرى: **LiveView يصحّح الغلاف؛ الخطاف والآلة يحدّثان السلوك داخله.**

## معالجة الأحداث التي يدفعها الخادم

عندما يستخدم الخادم **`Phoenix.LiveView.push_event/3`**، يُوزَّع الحدث في المتصفح ببادئة **`phx:`**. مثلاً `push_event(socket, "corex:set-theme", %{theme: "neo"})` يصبح حدث `phx:corex:set-theme`.

يمكن لـ **`handleEvent`** في الخطاف الاستماع والاستدعاء في واجهة Zag (`setValue`, إلخ). مساعدات Corex مثل **`Corex.Accordion.set_value/2`** تستخدم المسار نفسه من Elixir دون إعادة تنفيذ منطق لوحة المفاتيح في HEEx.

الأحداث المدفوعة من الخادم **عالمية** على `window`. إذا احتجت استهداف مكوّن واحد، ضمّن **`id`** في الحمولة وصفِّ في المستمع، كما في [دليل js-interop](https://hexdocs.pm/phoenix_live_view/js-interop.html#handling-server-pushed-events).

## الربطات مقابل سمات أحداث Corex

[الربطات](https://hexdocs.pm/phoenix_live_view/bindings.html) تربط السلوك بعقد DOM: `phx-click`, `phx-change`, `phx-submit`, وغيرها. على الخادم، تُعالَج الربطات في **`handle_event/3`**، الذي يعيد **`{:noreply, socket}`** لإعادة العرض دون إعادة تحميل كاملة.

تستخدم مكوّنات Corex التفاعلية سمات **data** موازية على الجذر، مثل `data-on-value-change`، يحوّلها الخطاف إلى **`pushEvent`** عندما تطلق الآلة `onValueChange`. تقسيم المسؤوليات نفسه:

- **الربطات / سمات Corex على الخادم** → عملية LiveView، assigns، `handle_event`
- **الخطاف + الآلة** → التركيز، حالة الفتح، ARIA، المفاتيح داخل الودجت

يمكنك الجمع بينهما في صفحة واحدة: `phx-click` على زر عادي، `phx-hook="Accordion"` على جذر Corex.

## الخطافات المجمّعة مقابل حزمة Corex

يدعم Phoenix 1.8 [**الخطافات المجمّعة**](https://hexdocs.pm/phoenix_live_view/js-interop.html#colocated-hooks-colocated-javascript) عبر `Phoenix.LiveView.ColocatedHook` بجانب مكوّنات الدالة. Corex بدلاً من ذلك يوفّر حزمة npm واحدة **`corex`** تعكس `mix corex.install`: استيراد واحد، كل الآلات. اختر الخطافات المجمّعة لتعديلات DOM خاصة بالتطبيق؛ اختر خطافات Corex لمكوّنات مشتركة يمكن الوصول إليها.

## التصحيح

يعرّض `LiveSocket` **`enableDebug()`** و**`disableDebug()`** لتسجيل أحداث دورة الحياة والحمول بين العميل والخادم. تعيين `window.liveSocket = liveSocket` في التطوير يسهّل التفعيل من وحدة تحكم المتصفح، كما في [دليل js-interop](https://hexdocs.pm/phoenix_live_view/js-interop.html#debugging-client-events).

## قائمة تحقق للترميز الثابت

لـ HTML خارج LiveView، انسخ شجرة **Anatomy** من moduledoc:

- `id` على الجذر و`phx-hook="ComponentName"`
- `data-scope` و`data-part` على كل عقدة تتوقعها الآلة
- خصائص `data-*` أولية إن احتجت حالة بداية محددة

بحث combobox المدفوع بالخادم ما زال يحتاج شيئاً يعيّن **`items`** جديدة عند كل تغيير إدخال. ذلك هو **`handle_event`** على LiveView، وليس شيئاً تبتكره الخطافات وحدها.

---

حزمة Corex على npm هي **التشغيل البيني لـ JavaScript** لـ Corex: نفس وحدات **`phx-hook`** التي يستخدمها Phoenix، وتشغّل آلات Zag نفسها. **`LiveSocket`** يصل الصفحة؛ **`mounted`** و**`updated`** و**`destroyed`** يصلون جذر كل مكوّن بالسلوك وقت التشغيل. افهم هذا المسار ويمكنك استخدام Corex في صفحات LiveView، أو صفحات هجينة، أو HTML ثابت مع socket بسيط.
