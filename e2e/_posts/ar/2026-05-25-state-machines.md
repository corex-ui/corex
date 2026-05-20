---
title: "Corex وآلات الحالة"
description: "كيف تدفع آلات Zag.js مكوّنات Corex، وكيف يتفاعل assign و DOM patching في الوضع controlled، ولماذا يبقى غلاف HEEx رقيقاً."
date: "2026-05-25 12:00:00 +0000"
permalink: /ar/blog/state-machines/
tags:
  - State Machines
  - Zag.js
  - Corex
sitemap:
  priority: 0.7
  changefreq: monthly
---

LiveView هو **process** يستقبل أحداثاً، يحدّث حالته، ويعرض التحديثات على الصفحة كـ **diffs**. الحالة تعيش في **socket** ضمن **`assigns`**. نموذج البرمجة تصريحي: الأحداث قد تغيّر الحالة؛ عند تغيّر الحالة يعيد LiveView رسم الأجزاء ذات الصلة من قالب HEEx ويدفع النتيجة إلى المتصفح. راجع [Welcome to Phoenix LiveView](https://hexdocs.pm/phoenix_live_view/welcome.html).

يضيف Corex طبقة حالة ثانية على العميل: **آلة حالة Zag.js** داخل كل **`phx-hook`**. HEEx الذي تكتبه يبقى غلاف [function component](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html). الآلة هي العقل الذي يقرر اللوحات المفتوحة والخيارات المحددة والتركيز.

## ثلاث طبقات

| الطبقة | المسؤولية |
|-------|----------------|
| **HEEx / function component** | البنية الثابتة، `data-scope` / `data-part`، slots، `items={…}`، تسلسل props إلى `data-*` |
| **LiveView hook** | `mounted`، `beforeUpdate`، `updated`، `destroyed`؛ جسر بين DOM والآلة |
| **Zag `VanillaMachine`** | الحالة، الانتقالات، ARIA؛ `subscribe` → `render` → `spreadProps` على الأجزاء |

**Anatomy** هو مقدار HEEx الذي تكتبه في كل استدعاء (items، slots، compound). **Runtime state** هو ما تملكه الآلة، وفي الوضع controlled أيضاً **assigns** في LiveView.

## Assigns و HEEx وتتبع التغيير

كل البيانات في LiveView مخزّنة في socket. في القوالب تقرأ **`@name`** بدلاً من `socket.assigns.name`. عند أول رسم للقالب يرسل LiveView الأجزاء الثابتة والديناميكية إلى العميل. في الرسوم اللاحقة يعيد إرسال الأجزاء **الديناميكية** فقط عندما يتغيّر **assign** الأساسي.

من [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html):

> The tracking of changes is done via assigns. If the `@title` assign changes, then LiveView will execute the dynamic parts of the template … If `@title` is the same, nothing is executed and nothing is sent.

**تحميل البيانات لا يجب أن يحدث داخل القالب.** عيّن القوائم في `mount/3` أو `handle_event/3`، ثم مرّرها كـ attrs:

```elixir
assign(socket, :topics, Corex.List.new([...]))
```

```heex
<.accordion id="faq" items={@topics} />
```

نفس الدليل يحذّر من المتغيرات المحلية في HEEx التي تكسر تتبع التغيير. فضّل **`assign/2`** و **`assign/3`** و **`update/3`** و **`assign_new/3`** في LiveViews و function components. مكوّنات Corex تتبع ذلك: الخصائص المحسوبة تمر عبر **`assign`** في `accordion/1`، وليس `Map.put/3` مباشرة على `assigns` داخل القالب.

### فخ: تمرير كل assigns

تمرير **`{assigns}`** إلى function components فرعية يعطّل تتبع التغيير الدقيق ويعيد رسم الأبناء عند كل تغيير في الأب. فضّل attrs صريحة (`items={@topics}`، `value={@open}`) كما في [دليل assigns](https://hexdocs.pm/phoenix_live_view/assigns-eex.html#the-assigns-variable).

## Bindings وخصائص أحداث Corex

[Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) تربط أحداث DOM بالخادم. مثال:

```heex
<button phx-click="inc_temperature">+</button>
```

```elixir
def handle_event("inc_temperature", _params, socket) do
  {:noreply, update(socket, :temperature, &(&1 + 1))}
end
```

جذور Corex لا تلزمك بربط `phx-click` على كل جزء داخلي. بدلاً من ذلك خصائص مثل **`on_value_change`** تُسلسل إلى **`data-on-value-change`**. الـ hook يستمع للآلة و **`pushEvent`** بهذا الاسم. LiveView ما زال ينفّذ **`handle_event/3`** ويعيد **`{:noreply, socket}`**.

| Phoenix binding | المقابل في Corex |
|-----------------|----------------|
| `phx-click="event"` | خصائص `on_*` → `data-on-*` → hook `pushEvent` |
| `phx-value-*` | حمولة تبنيها الآلة والـ hook |
| `handle_event/3` | نفس الـ callback؛ تحديث assigns |
| `{:noreply, socket}` | إعادة الرسم؛ patch للـ DOM؛ hook **`updated`** |

للنماذج، يوثّق LiveView **`phx-change`** و **`phx-submit`** و debounce و throttle. مدخلات Corex (combobox، select، native-input) تتبع نفس نمط **assign على الخادم**: القالب يعكس `@value` أو `@items`؛ الأحداث تحدّث assigns؛ الـ diff التالي يحدّث `data-*` على الجذر.

## أول رسم، ثم الاتصال المستمر

كل LiveView يُرسم أولاً كجزء من طلب **HTTP** عادي (أول طلاء سريع، HTML مناسب لـ SEO). ثم **`liveSocket.connect()`** يفتح WebSocket؛ **`mount/3`** يعمل في process الـ LiveView و **`mounted`** في hook العميل يعمل على عنصر الجذر.

Corex يشحن **HTML ثابتاً** في ذلك الرد الأول: `data-scope` و `data-part` صحيحة وخصائص `data-*` أولية. بعد الاتصال تعزّز الآلة السلوك دون استبدال الصفحة كاملة.

## Controlled مقابل uncontrolled

**Uncontrolled** (الافتراضي): الآلة تحتفظ بالقيمة في الذاكرة. HEEx قد يضبط **`value`** للرسم الأول فقط (`data-default-value` على السلك). تفاعل المستخدم لا يحتاج جولة LiveView ما لم تفعّل callbacks على الخادم.

**Controlled**: تضبط **`controlled`** و **`value={@assign}`**. الآلة تعتبر الخادم مصدر الحقيقة. عند كل تغيير من المستخدم يقوم الـ hook بـ **`pushEvent`**؛ **`handle_event`** يحدّث assign؛ LiveView يعمل patch للجذر؛ **`updated`** يمرّر القيمة الجديدة إلى **`machine.api.setValue`**.

كاتبان دون تنسيق يسببان وميضاً أو واجهة «عالقة»:

1. assigns في LiveView (`value`، `items`، …)
2. حالة Zag بعد تفاعل محلي

اختر سلطة واحدة لكل جزء من الحالة. استخدم **controlled** عندما يعيش التحقق أو الصلاحيات أو المنطق عبر المكوّنات على الخادم. استخدم **uncontrolled** لواجهة محلية (accordion FAQ، لوحات disclosure) مع **`on_value_change`** اختياري للتحليلات.

مثال accordion controlled:

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

## DOM patching والـ hook

عند تغيّر assigns يحسب LiveView diff ويعمل patch للـ DOM. للعناصر ذات **`phx-hook`** يعمل **`beforeUpdate`** و **`updated`** حول ذلك الـ patch.

Corex يعلّم السمات التي تملكها الآلة بـ **`JS.ignore_attributes`** على **`phx-mounted`** حتى لا يكتب LiveView فوق `data-state` و `aria-expanded` وما شابهها التي كتبها الـ hook للتو. ذلك يطابق [دليل bindings](https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching): **`ignore`** يتخطى تحديثات داخلية جملة؛ تغييرات **سمات data** قد تدمج مع الـ hook.

إذا غيّرت **`items`** أو **`value`** في `handle_event`، توقّع أن **`updated`** يحدّث خصائص الآلة. إذا غيّرت assigns غير ذات صلة فقط، قد لا يعاد تنفيذ الأجزاء الديناميكية في فرع accordion، وهذا بالضبط ما يحسّنه تتبع التغيير.

## الخادم → العميل: `push_event`

أحياناً يجب على الخادم أن يأمر الواجهة دون نقر مستخدم، مثل تبديل السمة أو **`set_value`** برمجياً. استخدم **`Phoenix.LiveView.push_event/3`** من LiveView أو LiveComponent. العميل يستقبل **`phx:event-name`**؛ **`handleEvent`** في الـ hook يستدعي API الآلة.

مساعدات مثل **`Corex.Accordion.set_value/2`** تغلّف هذا النمط حتى لا تكرر أسماء الأحداث في كل قالب.

## Form bindings ومدخلات Corex

form bindings في LiveView ([دليل form bindings](https://hexdocs.pm/phoenix_live_view/form-bindings.md)) تستخدم **`phx-change`** و **`phx-submit`** على `<form>` أو المدخلات. **`native-input`** و **`combobox`** و **`select`** في Corex ما زالت تشارك في النماذج: القيم المخفية أو الظاهرة تتحدّث عبر **`controlled`** + **`value`** + **`on_value_change`**، أو عبر خصائص **`name`** حيث يعرضها المكوّن.

الانقسام يبقى: **أحداث النموذج** تحدّث assigns و changesets على الخادم؛ **الآلات** تحافظ على سلوك listbox والحقل على العميل. لـ combobox داخل **`to_form`**، عالج **`on_value_change`** كأي حدث يجب أن **`assign`** القيمة المختارة قبل الرسم التالي.

## Streams مقابل list assigns

للقوائم **الثابتة** الطويلة جداً المرسومة بـ **`phx-update="stream"`**، يمكن لـ LiveView إلحاق الصفوف وعمل patch دون الاحتفاظ بالمجموعة كاملة في ذاكرة الخادم. **`data_table`** في Corex يدمج streams على صفوف tbody. عناصر تفاعلية مثل accordion و combobox تأخذ بدلاً من ذلك **`items={Corex.List.new(...)}`** كـ assign واحد يُسلسله الـ hook إلى الجذر. وسّع combobox بـ **تحديد `items` لكل استعلام**، وليس ببث آلاف عقد DOM في listbox واحد.

## Combobox: `items` من الخادم

القوائم الكبيرة تنتمي إلى **assigns**، وليس إلى قالب HEEx كاستعلامات مؤقتة. تدفق نموذجي:

1. **`mount`**: `assign(socket, :items, Corex.List.new([...]))`
2. **`on_input_value_change`**: `handle_event` يصفّي أو يحمّل صفوفاً، `assign(socket, :items, new_list)`
3. القالب: `items={@items}`، واختيارياً **`filter={false}`** عندما يعمل التصفية على الخادم

الآلة تتولى التنقل بلوحة المفاتيح والاختيار؛ LiveView يملك **أي صفوف موجودة**. هذا الفصل يتوسع إلى آلاف الصفوف دون شحن مجموعة البيانات كاملة في كل ضغطة مفتاح داخل القالب نفسه.

## LiveComponent وأحداث موجّهة

**`Phoenix.LiveComponent`** يعمل في نفس process BEAM كالـ LiveView الأب لكن له **`handle_event/3`** خاص. خصائص Corex على قالب المكوّن تتصرف بنفس الشكل: أحداث **`on_value_change`** تصل إلى callback المكوّن عندما يُرسم الجذر ذو الـ hook هناك.

إذا بنيت hooks مخصصة بجانب Corex، **`pushEventTo(selectorOrTarget, event, payload)`** من [دليل js-interop](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook) يمكنه استهداف LiveView أو LiveComponent محدد. hooks Corex تستخدم **`pushEvent`** بأسماء تعلنها على خصائص **`data-on-*`**.

لمنطق أحداث مشترك عبر LiveViews، يوثّق Phoenix **`Phoenix.LiveView.attach_hook/4`** لإعادة استخدام فقرات **`handle_event`** دون تكرار الوحدات. ذلك مستقل عن Zag: الـ hooks تُلحق بـ callbacks الـ LiveView؛ **`phx-hook`** يُلحق بعقد DOM.

## ما لا تعيد تنفيذه في HEEx

Zag يشفّر مسبقاً:

- مفتوح/مغلق، موسّع/مطوي، محدد/غير محدد
- roving tabindex ومفاتيح الأسهم
- typeahead وفهرسة المجموعة
- أدوار ARIA وخصائصها على كل **`data-part`**

HEEx يوفّر **البنية** و **البيانات**. الـ hook يشترك مرة:

```typescript
this.accordion = new Accordion(this.el, { props: this.getProps(), name: "Accordion" })
this.accordion.machine.subscribe(() => {
  this.accordion.render()
})
this.accordion.init()
```

بعد **`init`**، اعتبر الآلة سلطة التفاعل داخل الجذر ما لم تكن في وضع **controlled**.

## نموذج ذهني للتصحيح

1. **واجهة خاطئة أو قديمة بعد التفاعل**: assign controlled غير متزامن مع الآلة؟ **`handle_event`** ناقص؟
2. **تغيير الخادم مُتجاهل**: هل `value` / `items` معيّنة فعلاً؟ هل تتبع التغيير تخطى الجزء الديناميكي الذي توقّعته؟
3. **السمات تومض ثم تعود**: صراع بين patch LiveView و `render` للآلة؛ راجع **`ignore_attributes`** على الجذر والأجزاء.
4. **الـ hook لا يتحدّث أبداً**: **`id`** فريد ناقص على عنصر `phx-hook`؟ الـ hook خارج LiveView دون connect؟

اقرأ [Client hooks](https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook) لـ **`pushEvent`** و **`handleEvent`**. اقرأ [Assigns and HEEx](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) لما يُعاد رسمه. اقرأ [Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) لأحداث الخادم.

## أوامر JS عند mount

أوامر **`Phoenix.LiveView.JS`** تعمل على العميل عند إطلاق bindings. Corex يستخدمها على **`phx-mounted`** حتى لا يزيل أول patch سمات التحميل أو الآلة. مثلاً جذور accordion تستخدم **`JS.ignore_attributes(["data-loading"])`** و **`Connect.ignore_root/1`** حتى يبقى **`data-state`** على الأجزاء بعد diffs الخادم.

هذه نفس فكرة [JS commands](https://hexdocs.pm/phoenix_live_view/bindings.html#js-commands) في دليل bindings: تأثيرات عميل مركّبة دون جولة شبكة. Corex يخفي معظم ذلك داخل **`Connect`**؛ تختار **`animation="js"`** عندما تحتاج انتقالات الارتفاع JS منسّقة.

## ملخص التقسيم

يوصي Phoenix بثلاث مستويات ([Welcome](https://hexdocs.pm/phoenix_live_view/welcome.html)):

| الآلية | متى تستخدمها |
|-----------|----------|
| **Function components** (`<.accordion>`) | إعادة استخدام markup؛ Corex هو هذه الطبقة |
| **LiveComponent** | حالة وأحداث إضافية في نفس process |
| **Nested LiveView** | عزل صارم وحدود تعطل |

Corex يستهدف function components أولاً. استخدم LiveComponent عندما يكون combobox أو accordion جزيرة قابلة لإعادة الاستخدام بفقرات **`handle_event`** خاصة. استخدم nested LiveView فقط عندما تتطلب مجالات الفشل processes منفصلة.

## ترتيب السلسلة

1. **State machines** (هذا المنشور): assigns، bindings، الوضع controlled  
2. **[Vanilla JS](/ar/blog/vanilla-js/)**: `LiveSocket`، دورة حياة الـ hook، `push_event`  
3. **[Anatomy](/ar/blog/anatomy-of-a-corex-component/)**: مقدار HEEx الذي تكتبه  
4. **[Design](/ar/blog/corex-design-a11y/)**: CSS على أشجار `data-part`  
5. **[Combobox scale](/ar/blog/combobox-thousands-of-items/)**: **`items`** من الخادم

---

**Anatomy** هو سطح HEEx و function component. **State machines** هي سلوك وقت التشغيل داخل **`phx-hook`**. **LiveView** يملك حالة process في **assigns** و **bindings** (أو خصائص Corex `on_*`) و **DOM diffs**. افصل هذه الأدوار ويبقى Corex متوقعاً من accordions FAQ إلى comboboxes يقودها الخادم.

عند الشك، اقرأ الأدلة الرسمية بهذا الترتيب: [Welcome](https://hexdocs.pm/phoenix_live_view/welcome.html) لنموذج process، [Assigns and HEEx](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) للقوالب، [Bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) للأحداث، [JavaScript interoperability](https://hexdocs.pm/phoenix_live_view/js-interop.html) للـ hooks، و [`Phoenix.Component`](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) لـ function components. Corex طبقة رقيقة ومُنمّطة فوق هذه البنى.
