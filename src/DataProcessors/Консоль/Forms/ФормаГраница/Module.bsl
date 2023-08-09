&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПараметрГраница = Неопределено;
	Отбор = Неопределено;
	Если Параметры.Свойство("ПараметрГраница", ПараметрГраница) Тогда

		М = Новый Массив;
		Если ТипЗнч(ПараметрГраница) = Тип("Дата") Тогда
			М.Добавить(ТипЗнч(ПараметрГраница));
		ИначеЕсли ТипЗнч(ПараметрГраница) = Тип("Граница") Тогда
			Если ТипЗнч(ПараметрГраница.Значение) = Тип("Дата") Тогда
				М.Добавить(Тип("Дата"));
				Элементы.Дата.ОграничениеТипа = Новый ОписаниеТипов(М);
				ЭтотОбъект.Дата = ПараметрГраница.Значение;
			ИначеЕсли ТипЗнч(ПараметрГраница.Значение) = Тип("МоментВремени") Тогда
				М.Добавить(ТипЗнч(ПараметрГраница.Значение.Ссылка));
				Элементы.Дата.ОграничениеТипа = Новый ОписаниеТипов(М);
				ЭтотОбъект.Дата = ПараметрГраница.Значение.Ссылка;
			КонецЕсли;
			ЭтотОбъект.ЭтотВидГраницы = Строка(ПараметрГраница.ВидГраницы);
			Иначе
			Элементы.Дата.ОграничениеТипа = Новый ОписаниеТипов(ПолучитьТипВсехДокументов(), "Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
		КонецЕсли;

	ИначеЕсли Параметры.Свойство("ОтборПараметрЗапроса", Отбор) Тогда

		пХранилище = ПолучитьИзВременногоХранилища(Параметры.ОбъектПутьКХранилищу);
		ТабПараметров = пХранилище.ТабПараметров;

		СтрокаПараметра = ТабПараметров.НайтиСтроки(Отбор)[0];

		ОписаниеТипаГраница = Новый ОписаниеТипов("Граница");
		ПараметрГраница = ОписаниеТипаГраница.ПривестиЗначение(СтрокаПараметра.Значение);

		Элементы.Дата.ОграничениеТипа = Новый ОписаниеТипов(ПолучитьТипВсехДокументов(), "Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
		ЭтотОбъект.ЭтотВидГраницы = Строка(ПараметрГраница.ВидГраницы);
		Если ТипЗнч(ПараметрГраница.Значение) = Тип("Дата") Тогда
			ЭтотОбъект.Дата = ПараметрГраница.Значение;
		ИначеЕсли ПараметрГраница.Значение = Неопределено Тогда
			ЭтотОбъект.Дата = Дата(1,1,1);
		Иначе
			ЭтотОбъект.Дата = ПараметрГраница.Значение.Ссылка;
		КонецЕсли;

	Иначе
		Элементы.Дата.ОграничениеТипа = Новый ОписаниеТипов(ПолучитьТипВсехДокументов(), "Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидГраницыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Список = Новый СписокЗначений;
	Список.Добавить("Включая");
	Список.Добавить("Исключая");

	Если Объект.МодальностьРазрешена Тогда
		// 8.2
		КодВыполнения = "
		|Значение = ВыбратьИзСписка(Список, Элемент, Список.НайтиПоЗначению(ЭтотОбъект.ЭтотВидГраницы));
		|ВидГраницыНачалоВыбораЗавершение(Значение, Неопределено);";
	Иначе
		// Такси
		КодВыполнения = "
		|Оповещение = Новый ОписаниеОповещения(""ВидГраницыНачалоВыбораЗавершение"", ЭтотОбъект);
		|ПоказатьВыборИзСписка(Оповещение, Список, Элемент, Список.НайтиПоЗначению(ЭтотОбъект.ЭтотВидГраницы));";
	КонецЕсли;

	Выполнить(КодВыполнения);

КонецПроцедуры

&НаКлиенте
Процедура ВидГраницыНачалоВыбораЗавершение(Значение, Параметры) Экспорт

	Если Значение <> Неопределено Тогда
		ЭтотОбъект.ЭтотВидГраницы = Значение.Значение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если ЗначениеЗаполнено(ЭтотОбъект.Дата) Тогда
		М = Новый Массив;
		Если ТипЗнч(ЭтотОбъект.Дата) = Тип("Дата") Тогда
			М.Добавить(ТипЗнч(ЭтотОбъект.Дата));
		ИначеЕсли ТипЗнч(ЭтотОбъект.Дата) = Тип("Граница")
			И ЗначениеЗаполнено(ЭтотОбъект.Дата) Тогда
			М.Добавить(ТипЗнч(ЭтотОбъект.Дата.Ссылка));
		ИначеЕсли ЭтоСсылкаНаДокумент(ЭтотОбъект.Дата) Тогда
			М.Добавить(ТипЗнч(ЭтотОбъект.Дата));
		КонецЕсли;
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(М);
	Иначе
		Элемент.ОграничениеТипа = Новый ОписаниеТипов(ПолучитьТипВсехДокументов(), "Дата", , , , Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьТипВсехДокументов()

	Возврат Новый ОписаниеТипов(Документы.ТипВсеСсылки().Типы());

КонецФункции // ПолучитьТипВсехДокументов()

&НаСервере
Функция ЭтоСсылкаНаДокумент(Значение)

	Возврат Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Значение));

КонецФункции // ПолучитьТипВсехДокументов()

&НаКлиенте
Процедура Ок(Команда)

	СтрокаПредставления = "";
	ОкНаСервере(СтрокаПредставления);
	Закрыть(СтрокаПредставления);

КонецПроцедуры

&НаСервере
Процедура ОкНаСервере(СтрокаПредставления)

	Парам = Новый Массив(2);
	Парам[0] = ?(ТипЗнч(ЭтотОбъект.Дата) = Тип("Дата"), ЭтотОбъект.Дата, ЭтотОбъект.Дата.МоментВремени());
	Парам[1] = ВидГраницы[ЭтотОбъект.ЭтотВидГраницы];
	Граница = Новый(Тип("Граница"),Парам);

	Если Параметры.ОтборПараметрЗапроса <> Неопределено Тогда

		пХранилище = ПолучитьИзВременногоХранилища(Параметры.ОбъектПутьКХранилищу);
		ТабПараметров = пХранилище.ТабПараметров;

		СтрокаПараметра = ТабПараметров.НайтиСтроки(Параметры.ОтборПараметрЗапроса)[0];

		СтрокаПараметра.Значение = Граница;
		СтрокаПредставления = Строка(ЭтотОбъект.ЭтотВидГраницы) + ":" + Строка(Парам[0]);
		Возврат;

	КонецЕсли;

	СтрокаПредставления = Граница;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)

	Закрыть(Неопределено);

КонецПроцедуры

СисИнфо = Новый СистемнаяИнформация;
Объект.ВерсияПриложения = СисИнфо.ВерсияПриложения;
