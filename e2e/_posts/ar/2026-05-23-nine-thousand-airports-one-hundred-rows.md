---
title: "تسعة آلاف مطار، مئة صف"
description: "أوقف التصفية على العميل، أعد ملء items من الخادم عند كل استعلام، واترك آلة Zag تحافظ على سلوك listbox على شريحة محدودة."
date: "2026-05-23 12:00:00 +0000"
permalink: /ar/blog/nine-thousand-airports-one-hundred-rows/
tags:
  - Combobox
  - LiveView
  - Performance
sitemap:
  priority: 0.8
  changefreq: monthly
---

احتجت combobox على كل مطار في مجموعة البيانات. آلاف رموز IATA، تسميات طويلة، مجمّعة حسب المدينة. combobox Corex الافتراضي يصفّي بسعادة على العميل: يحتفظ بقائمة `items` كاملة في DOM ويضيّق محلياً عند كل ضغطة.

هذا مثالي لاختيار الدولة والقوائم القصيرة. أداة خاطئة عندما لا يدخل الكتالوج الذاكرة أو patch LiveView.

الحل ليس مكوّناً مختلفاً. إنه **تغذية** مختلفة: نفس آلة Zag، نفس الـ hook، نفس لوحة المفاتيح وARIA. الخادم يرسل شريحة `items` صغيرة عند كل استعلام. خيارات التشريح ([صفوف `<:item>` مخصّصة](/ar/blog/anatomy-of-a-corex-component/)، خيارات مجمّعة) تبقى على نفس الجذر.

شاهده على جدول مطارات حقيقي في [/ar/combobox/patterns](/ar/combobox/patterns).

## ما يبقى على العميل

`filter={false}` **لا** ينقل سلوك listbox للخادم. الـ hook ما زال:

- يفتح ويغلق القائمة
- يحرّك التمييز بأسهم
- يضبط ARIA على صفوف `[data-part="item"]`
- يطلق **`on_input_value_change`** عند تغيّر قيمة الإدخال

الخادم يجيب فقط: لهذا النص، أي صفوف يجب أن توجد في **`items`** الآن؟

## ما ينتقل للخادم

مرّر **`filter={false}`** وعالج **`on_input_value_change`** في LiveView. ابحث في قاعدة البيانات أو الفهرس عند كل تغيير؛ عيّن قائمة جديدة ملفوفة في **`Corex.List.new/1`**.

```heex
<.combobox
  id="airport-combobox"
  class="combobox combobox--accent combobox--lg"
  placeholder="ابحث عن مطارات…"
  items={@items}
  filter={false}
  on_input_value_change="search_airports"
>
  <:empty>لا نتائج</:empty>
  <:trigger>
    <.heroicon name="hero-chevron-down" />
  </:trigger>
</.combobox>
```

الحمولة تتضمن **`value`** و**`reason`**. عالج **`input-change`** و**`clear-trigger`** و**`item-select`** صراحةً ليبقى assigns متوافقاً مع الآلة.

| `reason` | إجراء خادم معتاد |
|----------|------------------|
| `input-change` | تنفيذ بحث؛ assign `items` جديدة |
| `clear-trigger` | استعادة الشريحة الأولى (مثلاً أول 120 صفاً) |
| `item-select` | غالباً لا شيء لـ`items`؛ حدّث `value` عبر `on_value_change` إن كان controlled |

## LiveView بسيط

ابنِ `items` في `mount/3` و`handle_event/3`، أبداً داخل القالب.

```elixir
defmodule MyAppWeb.AirportComboboxLive do
  use MyAppWeb, :live_view

  @page_size 120

  def mount(_params, _session, socket) do
    rows = Airports.list_first(@page_size)
    {:ok, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", %{"reason" => "clear-trigger"}, socket) do
    rows = Airports.list_first(@page_size)
    {:noreply, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", %{"reason" => "item-select"}, socket) do
    {:noreply, socket}
  end

  def handle_event("search_airports", %{"value" => value}, socket) when is_binary(value) do
    rows =
      if String.trim(value) == "" do
        Airports.list_first(@page_size)
      else
        Airports.search(value, limit: @page_size)
      end

    {:noreply, assign(socket, :items, Corex.List.new(format_rows(rows)))}
  end

  def handle_event("search_airports", _params, socket), do: {:noreply, socket}

  defp format_rows(rows) do
    Enum.map(rows, fn row ->
      %{value: row.iata_code, label: "#{row.name} (#{row.iata_code})"}
    end)
  end
end
```

استخدم **حدّاً** على كل استعلام. debounce في `handle_event` أو `handle_info` إن احتاج المخزن، وألغِ مؤقتات قديمة حتى لا تومض نتائج متأخرة.

## اختيار controlled

عندما يجب أن يملك النموذج القيمة المختارة، أضف **`controlled`** و**`value={@selected}`** و**`on_value_change`** مع بحث الخادم. [عقلان](/ar/blog/two-brains-liveview-assigns-and-zag-machines/) يشرح حلقة controlled؛ البحث والاختيار assigns منفصلان.

## أنماط يجب تجنبها

- آلاف `items` عند mount مع `filter={true}`
- إعادة بناء `items` في `render/1` بلا حدث إدخال
- تجاهل `reason` بعد مسح أو اختيار
- قوائم خام في assigns بلا `Corex.List.new/1`

القوائم الافتراضية تساعد مجموعات ضخمة **على العميل**. هنا تبقى على combobox وتحدّ **`items`** لكل استعلام.

---

أوقف التصفية على العميل. أعد ملء **`items`** بـ`Corex.List.new/1` عند كل استعلام. الـ hook يحافظ على لوحة المفاتيح وARIA؛ الخادم يحدّ الكتالوج.

تلوين listbox في [تصميم Corex](/ar/blog/paint-the-parts-the-machine-already-owns/). توصيل الـ hook في [vanilla JS](/ar/blog/the-vanilla-js-machine-that-doesnt-need-a-framework/). شجرة HEEx في [تشريح مكوّن Corex](/ar/blog/anatomy-of-a-corex-component/).
