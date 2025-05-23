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

	ПоИсполнителю = Пользователи.АвторизованныйПользователь();
	УстановитьОтбор();
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеБизнесПроцессов(Список.УсловноеОформление);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если Пользователи.ЭтоСеансВнешнегоПользователя() Тогда
		Элементы.ПоИсполнителю.Видимость = Ложь;
	КонецЕсли;

	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.БизнесПроцессы._ДемоЗаданиеСРолевойАдресацией);
	Элементы.ФормаГрупповоеИзменениеОбъектов.Видимость = МожноРедактировать;
	Элементы.СписокКонтекстноеМенюГрупповоеИзменениеОбъектов.Видимость = МожноРедактировать;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьОтборСписка(Настройки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоИсполнителюПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоРолиИсполнителяПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьВыполненныеЗаданияПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)

	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)

	БизнесПроцессыИЗадачиКлиент.Остановить(
		Элементы.Список.ВыделенныеСтроки);

	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОповеститьОбИзменении(ВыделеннаяСтрока);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)

	БизнесПроцессыИЗадачиКлиент.СделатьАктивным(
		Элементы.Список.ВыделенныеСтроки);

	Для Каждого ВыделеннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОповеститьОбИзменении(ВыделеннаяСтрока);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	ПараметрыОтбора = Новый Соответствие;
	ПараметрыОтбора.Вставить("ПоказыватьВыполненныеЗадания", ПоказыватьВыполненныеЗадания);
	ПараметрыОтбора.Вставить("ПоИсполнителю", ПоИсполнителю);
	ПараметрыОтбора.Вставить("ПоРолиИсполнителя", ПоРолиИсполнителя);
	УстановитьОтборСписка(ПараметрыОтбора);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСписка(ПараметрыОтбора)

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Завершен");

	Если Не ПараметрыОтбора["ПоказыватьВыполненныеЗадания"] Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Завершен", Ложь);
	КонецЕсли;

	Если ПараметрыОтбора["ПоИсполнителю"].Пустая() Тогда
		Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", Null);
	Иначе
		Список.Параметры.УстановитьЗначениеПараметра("Исполнитель", ПараметрыОтбора["ПоИсполнителю"]);
	КонецЕсли;

	Если ПараметрыОтбора["ПоРолиИсполнителя"].Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "РольИсполнителя");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "РольИсполнителя", ПараметрыОтбора["ПоРолиИсполнителя"]);
	КонецЕсли;

КонецПроцедуры

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

#КонецОбласти