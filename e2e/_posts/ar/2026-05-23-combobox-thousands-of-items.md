---
title: "كيف تعرض أكثر من 9000 عنصر في Combobox؟"
description: "أبقِ العرض على العميل، أوقف التصفية على العميل، ودع الخادم يعيد ملء العناصر في كل استعلام."
date: "2026-05-23 12:00:00 +0000"
permalink: /ar/blog/combobox-thousands-of-items/
tags:
  - Combobox
  - LiveView
  - الأداء
sitemap:
  priority: 0.8
  changefreq: monthly
---

لـ combobox نفس التقسيم ككل مكوّن Corex. **الآلة** تحافظ على سلوك listbox على العميل: فتح القائمة، تمييز الصف، المفاتيح، ARIA. **LiveView** يزوّد **البيانات**: أي خيارات موجودة في `items` في هذه اللحظة.

مع بضع مئات من الصفوف، التصفية الافتراضية على العميل كافية: الـ hook يحتفظ بالقائمة ويصفّيها محلياً. مع الآلاف، تتوقف عن إرسال الكتالوج في كل patch. تحتفظ بالعقل؛ وتغيّر التغذية.

مرّر قائمة **`items`** صغيرة من الخادم في كل استعلام (`filter={false}`، `on_input_value_change`). المشغّل، الحالة الفارغة، وصفوف الخيارات المخصصة تبقى خيارات تشريح على نفس المكوّن.

## Assigns وتتبع التغيير و`handle_event`

يخزّن LiveView **`items`** في socket كـ assign. القالب يربط **`items={@items}`**. عندما **`assign(socket, :items, Corex.List.new(rows))`** داخل **`handle_event/3`**، يُعاد إرسال الأجزاء الديناميكية فقط من شجرة combobox التي تعتمد على `@items` إلى العميل. callback **`updated`** في الـ hook يقرأ بيانات التجميع الجديدة `data-*` ويحدّث الآلة دون إعادة كتابة الخيارات في HEEx.

من [Assigns and HEEx templates](https://hexdocs.pm/phoenix_live_view/assigns-eex.html): لا تبنِ `items` باستدعاء قاعدة بيانات داخل القالب. لا تعرّف `rows = …` في أعلى **`render/1`** وتتوقع تحديثات دقيقة. حمّل وصفّي في **`mount/3`**، **`handle_event/3`**، أو **`handle_info/2`**، ثم عيّن.

**`on_input_value_change`** هو المقابل لـ combobox لـ [form binding](https://hexdocs.pm/phoenix_live_view/bindings.html): العميل يدفع اسم حدث تعلنه، والخادم يرد بـ **`{:noreply, socket}`**. هذا نفس العقد كـ **`phx-change`** على نموذج، باستثناء أن الـ hook يبدأ الحدث من آلة Zag عندما تتغيّر قيمة الإدخال.

للبحث المكلف، يمكنك debounce على الخادم (مؤقت في **`handle_event`**) أو الاعتماد على [rate limiting](https://hexdocs.pm/phoenix_live_view/bindings.html#rate-limiting-events-with-debounce-and-throttle) على العميل لربطات أخرى في نفس الصفحة. أحداث إدخال combobox ليست مثل **`phx-debounce`** على `<input>` عادي، لأن جذر Corex يملك جزء الإدخال؛ debounce ينتمي إلى **`handle_event`** عندما تستدعي قاعدة البيانات.

## قوائم صغيرة: تصفية على العميل (افتراضي)

مع `filter={true}` (الافتراضي)، يحتفظ الـ hook بقائمة `items` الكاملة في DOM ويصفّي حسب نص الإدخال محلياً. استخدم هذا لاختيار الدول، الوسوم، والتعدادات التي تتسع في الذاكرة.

```heex
<.combobox
  id="country"
  class="combobox combobox--accent"
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
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

بعد بضع مئات من الصفوف، تكبر حمولات mount وكل ضغطة مفتاح تصفّي DOM بالكامل. بدّل النمط قبل أن يشعر المستخدمون بالبطء.

### ما يفعله العميل مع `filter={false}`

إيقاف التصفية **لا** ينقل سلوك listbox إلى الخادم. الـ hook ما زال:

- يفتح ويغلق القائمة
- ينقل التمييز بمفاتيح الأسهم
- يضبط أدوار ARIA على صفوف **`[data-part="item"]`**
- يطلق **`on_input_value_change`** عندما تتغيّر القيمة المكتوبة

الخادم يجيب فقط: «بناءً على نص الاستعلام هذا، أي صفوف يجب أن توجد في **`items`** الآن؟» هذا نفس التقسيم كـ [bindings](https://hexdocs.pm/phoenix_live_view/bindings.html) في أماكن أخرى: تفاعل العميل، حالة الخادم في **assigns**.

## قوائم كبيرة: `filter={false}` وبحث على الخادم

مرّر **`filter={false}`** وعالج **`on_input_value_change`** في LiveView. ابحث في قاعدة البيانات أو الفهرس عند كل تغيير؛ عيّن قائمة جديدة. الـ hook ما زال يملك التمييز، حالة الفتح، ودلالات listbox.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent combobox--lg"
  placeholder="Search airports…"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
>
  <:empty>No results</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
  <:clear_trigger>
    <.heroicon name="hero-backspace" />
  </:clear_trigger>
</.combobox>
```

الحمولة تتضمن **`value`** و**`reason`**. عالج **`input-change`**، **`clear-trigger`**، و**`item-select`** صراحةً حتى تبقى assigns متوافقة مع الآلة.

| `reason` | إجراء خادم نموذجي |
|----------|------------------------|
| `input-change` | نفّذ البحث؛ **`assign`** لـ **`items`** جديدة |
| `clear-trigger` | أعد شريحة الإدخال (مثلاً أول 120 صفاً) |
| `item-select` | غالباً لا شيء لـ **`items`**؛ حدّث **`value`** عبر **`on_value_change`** إن كان controlled |

إرجاع **`{:noreply, socket}`** دون تحديث **`items`** عند الاختيار صحيح عندما يكون الصف المختار موجوداً بالفعل في القائمة. بعد الاختيار، قد تصغّر **`items`** إلى الصف المختار فقط إن كان UX يتطلب ذلك.

## وحدة LiveView (قائمة في الذاكرة أولاً)

ابدأ بقائمة في الذاكرة، ثم استبدل التصفية بـ SQL.

```elixir
defmodule MyAppWeb.AirportComboboxLive do
  use MyAppWeb, :live_view

  defp all_rows do
    [
      %{value: "LHR", label: "London Heathrow (LHR)"},
      %{value: "CDG", label: "Paris Charles de Gaulle (CDG)"},
      %{value: "JFK", label: "New York John F. Kennedy (JFK)"},
      %{value: "NRT", label: "Tokyo Narita (NRT)"},
      %{value: "SYD", label: "Sydney Kingsford Smith (SYD)"}
    ]
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :items, Corex.List.new(all_rows()))}
  end

  def handle_event("filter_airports", %{"reason" => "clear-trigger"}, socket) do
    {:noreply, assign(socket, :items, Corex.List.new(all_rows()))}
  end

  def handle_event("filter_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
    q = value |> String.trim() |> String.downcase()

    rows =
      if q == "" do
        all_rows()
      else
        Enum.filter(all_rows(), fn r ->
          String.contains?(String.downcase(r.label), q)
        end)
      end

    {:noreply, assign(socket, :items, Corex.List.new(rows))}
  end

  def handle_event("filter_airports", _params, socket), do: {:noreply, socket}

  def render(assigns) do
    ~H"""
    <.combobox
      id="airport-combobox"
      class="combobox combobox--accent"
      placeholder="Search airports…"
      items={@items}
      filter={false}
      on_input_value_change="filter_airports"
    >
      <:empty>No results</:empty>
      <:trigger>
        <.heroicon name="hero-chevron-down" />
      </:trigger>
      <:clear_trigger>
        <.heroicon name="hero-backspace" />
      </:clear_trigger>
    </.combobox>
    """
  end
end
```

## استعلام قاعدة بيانات مع حد

استبدل `Enum.filter/2` باستعلام محدود. أعد دائماً `Corex.List.new/1`:

```elixir
def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
  q = String.trim(value)

  rows =
    if q == "" do
      Airports.list_first(120)
    else
      Airports.search(q, limit: 120)
    end

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
      end)
    )

  {:noreply, assign(socket, :items, items)}
end
```

استخدم **limit** في كل استعلام. نفّذ debounce في LiveView إن احتاج مخزن البيانات ذلك.

## شريحة أولية عند mount

لا تحتاج `items={[]}`. صفحة أولى من النتائج تحسّن الاكتشاف:

```elixir
def mount(_params, _session, socket) do
  rows = Airports.list_first(120)

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
      end)
    )

  {:ok, assign(socket, :items, items)}
end
```

عند **`clear-trigger`**، أعد تلك الشريحة بدلاً من قائمة فارغة.

## خيارات مجمّعة

اضبط **`group`** على كل map:

```heex
<.combobox
  id="airport-combobox-grouped"
  class="combobox combobox--accent"
  placeholder="Search by city…"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports_grouped"
>
  <:empty>No results</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

```elixir
def handle_event("filter_airports_grouped", %{"value" => value}, socket)
    when is_binary(value) do
  rows = Airports.search_grouped(value, limit: 80)

  items =
    Corex.List.new(
      Enum.map(rows, fn row ->
        %{
          value: row.iata_code,
          label: "#{row.name} (#{row.iata_code})",
          group: row.city_name
        }
      end)
    )

  {:noreply, assign(socket, :items, items)}
end
```

عناوين المجموعات تُرسم من حقل `group` على كل map.

## صفوف خيارات مخصصة

أبقِ `filter={false}` وأضف **`<:item :let={item}>`** عندما تحتاج الصفوف أيقونات أو ترميزاً إضافياً. منطق البحث على الخادم دون تغيير.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
>
  <:item :let={item}>
    <.heroicon name="hero-globe-alt" />
    {item.label}
  </:item>
  <:item_indicator>
    <.heroicon name="hero-check" />
  </:item_indicator>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

## اختيار controlled

استخدم `value` و`on_value_change` مع **`controlled`** عندما يجب أن يملك النموذج القيمة المختارة:

```heex
<.combobox
  id="airport-combobox"
  class="combobox"
  items={@items}
  filter={false}
  controlled
  value={@selected}
  on_input_value_change="filter_airports"
  on_value_change="airport_selected"
/>
```

```elixir
def handle_event("airport_selected", %{"value" => values}, socket) do
  {:noreply, assign(socket, :selected, values)}
end
```

## Placeholder والترجمات

استخدم **`translation`** للـ placeholder، الحالة الفارغة، وسلاسل aria ذات الصلة:

```heex
<.combobox
  id="airport-combobox"
  class="combobox"
  items={@items}
  filter={false}
  on_input_value_change="filter_airports"
  translation={%Corex.Combobox.Translation{placeholder: "Search airports…"}}
>
  <:empty>No airports match your search</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

## Debounce للاستعلامات الثقيلة

إن كل ضغطة مفتاح تضرب قاعدة البيانات، نفّذ debounce في LiveView:

```elixir
def handle_event("filter_airports", %{"value" => value}, socket) when is_binary(value) do
  ref = Process.send_after(self(), {:run_airport_search, value}, 200)
  {:noreply, assign(socket, :search_timer, ref)}
end

def handle_info({:run_airport_search, value}, socket) do
  items = Airports.search_items(value, limit: 120)
  {:noreply, assign(socket, :items, items)}
end
```

ألغِ أو تجاهل المؤقتات القديمة حتى لا تومض استجابات غير مرتبة بنتائج قديمة.

## القيمة controlled مقابل البحث

| Assign / حدث | الدور |
|----------------|------|
| `items` | الخيارات في listbox (من بحث الخادم) |
| `value` + `on_value_change` | الخيار/الخيارات المختارة للنموذج |
| `on_input_value_change` | نص الإدخال يقود البحث |

## حجم الحمولة وتتبع التغيير

كل **`assign(socket, :items, …)`** يعيد رسم الأجزاء الديناميكية من القالب التي تشير إلى **`@items`**. يرسل LiveView diff لشجرة combobox. الإبقاء على **`limit: 120`** (أو ما شابه) يحدّ عمل قاعدة البيانات وحجم السلك.

إن تغيّرت assigns غير ذات صلة في نفس LiveView (flash، شريط جانبي، عدادات)، يضمن تتبع التغيير أن الأجزاء الديناميكية لـ combobox تعمل فقط عندما تتغيّر **`@items`** أو **`@selected`** أو attrs أخرى تمرّرها إلى **`<.combobox>`**. تجنّب تمرير **`{assigns}`** إلى مكوّنات غلاف حول combobox؛ مرّر **`items={@items}`** صراحةً.

## LiveComponent داخل النموذج

عندما يعيش combobox في **`live_component`**، **`on_input_value_change`** ما زال يوجّه إلى **`handle_event/3`** في ذلك المكوّن إن كان الجذر في قالب المكوّن. **`pushEventTo`** من hooks مخصصة يستهدف بالمحدّد؛ Corex يستخدم اسم الحدث الذي تقدّمه على الجذر. أبقِ **`id`** ثابتاً لكل مثيل مكوّن.

## أنماط يجب تجنبها

- آلاف `items` عند mount مع `filter={true}`
- إعادة بناء `items` في `render/1` دون حدث إدخال
- تجاهل `reason` بعد clear أو select
- maps خام في assigns دون `Corex.List.new/1`

القوائم الافتراضية تساعد مجموعات بيانات ضخمة **على العميل**. هنا تحتفظ بـ combobox وتقيّد **`items`** لكل استعلام.

## `Corex.List.new/1` وتنسيق السلك

يجب أن تستخدم assigns على الخادم **`Corex.List.new/1`** (أو **`Corex.Content.new/1`** حيث ينطبق)، وليس قوائم maps عارية. المساعد يطبّع labels وvalues وأعلام disabled و**`group`** للتسلسل على جذر combobox. الـ hook يقرأ هذا الشكل في **`mounted`** و**`updated`**.

كل **`handle_event`** بحث يجب أن ينتج **`Corex.List.new(...)`** جديداً حتى عندما لا يطابق أي صف، ليُرسم slot الفارغ (**`<:empty>`**). قائمة فارغة صالحة؛ assign قديم بعد بحث فاشل ليس كذلك.

## اختبار البحث على الخادم

في **`Phoenix.LiveViewTest`**، اعرض LiveView، ثم **`render_click`** أو **`render_change`** على إدخال combobox حسب كيف تستهدف مساعدات الاختبار التحكم. تأكد من **`html`** يحتوي التسميات المتوقعة بعد تشغيل **`handle_event`**. لـ **`on_input_value_change`**، استخدم **`render_hook`** على id جذر combobox مع اسم الحدث وخريطة الحمولة التي يرسلها الـ hook (راجع **Events** في HexDocs لأسماء الحقول).

ركّز الاختبارات على نتائج assign: بإدخال `"lon"`، **`@items`** يتضمن Heathrow، وليس على فهارس `data-highlighted` الداخلية. الآلة تملك التمييز؛ assign يملك عضوية الكتالوج.

## المراقبة

سجّل مدة الاستعلام داخل **`handle_event`**، وليس في HEEx. إن شعرت أن patches بطيئة، تحقق من حجم diffs لـ **`items`** وهل assigns الأب غير ذات الصلة تبطل القالب بالكامل. assigns ضيقة وattrs صريحة إلى **`<.combobox>`** تمنع إعادة تشغيل الأقسام الدينامية لـ combobox عند كل tick للأب.

ملعب أنماط combobox على هذا الموقع يشغّل نفس التدفق على جدول مطارات كبير.

---

أوقف التصفية على العميل. أعد ملء **`items`** بـ `Corex.List.new/1` في كل استعلام. الـ hook يحافظ على سلوك لوحة المفاتيح وARIA؛ الخادم يحافظ على حجم الكتالوج محدوداً.

هذا النمط يطابق ما يتوقعه Phoenix لواجهات قابلة للتوسع: **assigns** و**`handle_event`** يملكان البيانات، [change tracking](https://hexdocs.pm/phoenix_live_view/assigns-eex.html) يملك ما يُعاد رسمه، و**client hooks** تملك التفاعل داخل جذر combobox. اقرأ هذا المنشور مع [آلات الحالة](/ar/blog/state-machines/) للاختيار controlled ومع [تشريح المكوّن](/ar/blog/anatomy-of-a-corex-component/) لتخصيص **`<:item :let={item}>`**.
