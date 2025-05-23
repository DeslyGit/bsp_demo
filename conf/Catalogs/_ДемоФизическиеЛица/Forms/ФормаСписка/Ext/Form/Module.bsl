﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	ИзменитьОтображениеСписка();

	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ТекстЗапроса = ТекстЗапросаСпискаСЗащитойПерсональныхДанных();
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	ЗащитаПерсональныхДанных.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ЭлектроннаяПодпись
	Элементы.ФормаЗаявлениеНаСертификат.Видимость = ЭлектроннаяПодпись.ДоступностьСозданияЗаявления().ДляФизическихЛиц;
	// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанныхКлиент.ОбработкаОповещенияФормыСписка(Элементы.Список, ИмяСобытия);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)

	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	ЗащитаПерсональныхДанных.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПоискИУдалениеДублей

&НаКлиенте
Процедура ОбъединитьВыделенные(Команда)

	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьМестаИспользования(Команда)

	ПоискИУдалениеДублейКлиент.ПоказатьМестаИспользования(Элементы.Список);

КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
&НаКлиенте
Процедура Подключаемый_ПоказыватьСоСкрытымиПДн(Команда)
	ЗащитаПерсональныхДанныхКлиент.ПоказыватьСоСкрытымиПДн(ЭтотОбъект, Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

// СтандартныеПодсистемы.ЭлектроннаяПодпись
&НаКлиенте
Процедура ЗаявлениеНаСертификат(Команда)

	Если Не ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Или Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выделите строку с физическим лицом'"));
		Возврат;
	КонецЕсли;

	ОбработчикРезультата = Новый ОписаниеОповещения("ЗаявлениеНаСертификатПослеДобавления", ЭтотОбъект);

	ПараметрыДобавления = ЭлектроннаяПодписьКлиент.ПараметрыДобавленияСертификата();
	ПараметрыДобавления.ФизическоеЛицо = Элементы.Список.ТекущаяСтрока;
	ПараметрыДобавления.ИзЛичногоХранилища = Ложь;
	ЭлектроннаяПодписьКлиент.ДобавитьСертификат(ОбработчикРезультата, ПараметрыДобавления);

КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ЭлектроннаяПодпись

// Параметры:
//  Результат - Неопределено
//            - Структура:
//          * Ссылка   - СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования
//          * Добавлен - Булево
//
//  Контекст - Неопределено
//
&НаКлиенте
Процедура ЗаявлениеНаСертификатПослеДобавления(Результат, Контекст) Экспорт

	Если Результат = Неопределено Тогда
		ТекстПредупреждения = НСтр("ru = 'Заявление не добавлено'");

	ИначеЕсли Не Результат.Добавлен Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявление добавлено, но не исполнено:
				 |%1'"), Результат.Ссылка);
	Иначе
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Заявление добавлено, и исполнено:
				 |%1'"), Результат.Ссылка);
	КонецЕсли;

	ПоказатьПредупреждение(, ТекстПредупреждения);

КонецПроцедуры

// Конец СтандартныеПодсистемы.ЭлектроннаяПодпись

// СтандартныеПодсистемы.ЗащитаПерсональныхДанных

&НаСервере
Функция ТекстЗапросаСпискаСЗащитойПерсональныхДанных()
	Возврат "ВЫБРАТЬ
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.Ссылка КАК Ссылка,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.ПометкаУдаления КАК ПометкаУдаления,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.Родитель КАК Родитель,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.ЭтоГруппа КАК ЭтоГруппа,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.Наименование КАК Наименование,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.ДатаРождения КАК ДатаРождения,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.Пол КАК Пол,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.МестоРождения КАК МестоРождения,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.Гражданство КАК Гражданство,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.СерияДокумента КАК СерияДокумента,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.НомерДокумента КАК НомерДокумента,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.КемВыданДокумент КАК КемВыданДокумент,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.КодПодразделенияДокумента КАК КодПодразделенияДокумента,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.ДатаВыдачиДокумента КАК ДатаВыдачиДокумента,
			|	Справочник_ДемоФизическиеЛицаПереопределяемый.СНИЛС КАК СНИЛС,
			|	ВЫРАЗИТЬ(NULL КАК ЧИСЛО(1, 0)) КАК ОтсутствуетСогласие,
			|	ВЫБОР
			|		КОГДА СубъектыСоКрытымиПДн.Субъект ЕСТЬ NULL
			|			ТОГДА ЛОЖЬ
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ КАК ПДнСкрыты
			|ИЗ
			|	Справочник._ДемоФизическиеЛица КАК Справочник_ДемоФизическиеЛицаПереопределяемый
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СубъектыДляСкрытияПерсональныхДанных КАК СубъектыСоКрытымиПДн
			|		ПО Справочник_ДемоФизическиеЛицаПереопределяемый.Ссылка = СубъектыСоКрытымиПДн.Субъект
			|		И (СубъектыСоКрытымиПДн.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияСубъектовДляСкрытия.СкрытиеВыполнено))
			|ГДЕ
			|	(СубъектыСоКрытымиПДн.Субъект ЕСТЬ NULL
			|	ИЛИ &ПоказыватьСоСкрытымиПДн)"
КонецФункции

// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных

&НаСервере
Процедура ИзменитьОтображениеСписка()

	Если Параметры.ОтборПоСсылке Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти