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
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Календари.Ссылка
	|ИЗ
	|	Справочник.Календари КАК Календари";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Календарь	= Выборка.Ссылка;
	КонецЕсли;
	
	Дата			= ТекущаяДатаСеанса();
	КоличествоДней	= 3;
	
	ТаблицаДатПоКалендарю.Добавить().КоличествоДней = 2;
	ТаблицаДатПоКалендарю.Добавить().КоличествоДней = 3;
	ТаблицаДатПоКалендарю.Добавить().КоличествоДней = 5;
	
	ДатыРабочихДней.Добавить().Дата = '20160818000000';
	ДатыРабочихДней.Добавить().Дата = '20160613000000';
	ДатыРабочихДней.Добавить().Дата = '20161104000000';
	ДатыРабочихДней.Добавить().Дата = '20200330000000';
	ДатыРабочихДней.Добавить().Дата = '20241231000000';
	
	ДатаНачала = ТекущаяДатаСеанса();
	ДатаОкончания = ДатаНачала + 7 * 86400; // 86400 - длина суток
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Календарь.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ДатаОкончания.ВысотаЗаголовка = 2;
		Элементы.РазностьДат.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
		Элементы.РазностьДат.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
		Элементы.ДатаПоКалендарю.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Авто;
	Иначе
		Элементы.ОтступМежду.Видимость = Ложь;
		Элементы.ОтступПосле.Видимость = Ложь;
		Элементы.ОтступДоПримеров.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы(ЭтотОбъект);
	ЗаполнитьНерабочиеПериоды(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КалендарьПриИзменении(Элемент)
	УстановитьСвойстваЭлементовФормы(ЭтотОбъект);
	ЗаполнитьНерабочиеПериоды(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РассчитатьДату(Команда)
	
	Попытка
		ДатаПоКалендарю = ДатаПоКалендарю(Календарь, Дата, КоличествоДней);
		
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Календарь);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьМассивДат(Команда)
	
	Попытка
		МассивДней = Новый Массив;
		
		Для Каждого СтрокаТаблицы Из ТаблицаДатПоКалендарю Цикл
			МассивДней.Добавить(СтрокаТаблицы.КоличествоДней);
		КонецЦикла;
		
		МассивДат = ДатыПоКалендарю(Календарь, Дата, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей);
		
		Для Каждого СтрокаТаблицы Из ТаблицаДатПоКалендарю Цикл
			СтрокаТаблицы.ДатаПоКалендарю = МассивДат[ТаблицаДатПоКалендарю.Индекс(СтрокаТаблицы)];
		КонецЦикла;
		
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Календарь);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьКоличествоДней(Команда)
	
	Попытка
		РазностьДат = ПолучитьРазностьДатКалендарю(Календарь, ДатаНачала, ДатаОкончания);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), Календарь);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДатыРабочихДней(Команда)
	
	ЗаполнитьДатыРабочихДней();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывает функцию общего модуля КалендарныеГрафики для получения даты по календарю.
//
// Параметры:
//   ГрафикРаботы	- СправочникСсылка.Календари
//   Дата			- Дата
//   КоличествоДней	- Число
//
// Возвращаемое значение
//  Дата - увеличенная на количество дней, входящих в график.
//
&НаСервереБезКонтекста
Функция ДатаПоКалендарю(Календарь, Дата, КоличествоДней)
	
	Возврат КалендарныеГрафики.ДатаПоКалендарю(Календарь, Дата, КоличествоДней);
	
КонецФункции

// Вызывает функцию общего модуля КалендарныеГрафики для получения массива дат по календарю.
//
// Параметры:
//   ГрафикРаботы	- СправочникСсылка.Календари
//   Дата			- Дата
//   МассивДней		- Массив из Число
//
// Возвращаемое значение
//  МассивДат		- массив дат, увеличенных на количество дней, входящих в график.
//
&НаСервереБезКонтекста
Функция ДатыПоКалендарю(Календарь, Дата, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей)
	
	Возврат КалендарныеГрафики.ДатыПоКалендарю(Календарь, Дата, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей);
	
КонецФункции

// Вызывает функцию общего модуля КалендарныеГрафики для получения даты по календарю.
//
// Параметры:
//   ГрафикРаботы	- СправочникСсылка.Календари
//   ДатаНачала		- Дата
//   ДатаОкончания	- Дата
//
// Возвращаемое значение
//  ДатаКалендаря	- Дата - увеличенная на количество дней, входящих в график.
//
&НаСервереБезКонтекста
Функция ПолучитьРазностьДатКалендарю(Календарь, ДатаНачала, ДатаОкончания)
	
	Возврат КалендарныеГрафики.РазностьДатПоКалендарю(Календарь, ДатаНачала, ДатаОкончания);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДатыРабочихДней()
	
	Если ТипЗнч(Календарь) = Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		ПараметрыПолучения = КалендарныеГрафики.ПараметрыПолученияБлижайшихРабочихДат();
		ПараметрыПолучения.ПолучатьПредшествующие = ПолучатьПредшествующие;
		ПараметрыПолучения.УчитыватьНерабочиеПериоды = УчитыватьНерабочиеПериоды;
		ПараметрыПолучения.НерабочиеПериоды = ОбщегоНазначения.ВыгрузитьКолонку(
			НерабочиеПериоды.НайтиСтроки(Новый Структура("Учитывать", Истина)), "Номер");
		ПараметрыПолучения.ПолучатьДатыЕслиКалендарьНеЗаполнен = ПолучатьДатыЕслиКалендарьНеЗаполнен;
		РабочиеДаты = КалендарныеГрафики.БлижайшиеРабочиеДаты(
			Календарь, ДатыРабочихДней.Выгрузить().ВыгрузитьКолонку("Дата"), ПараметрыПолучения);
	Иначе
		ПараметрыПолучения = ГрафикиРаботы.ПараметрыПолученияБлижайшихДатПоГрафику();
		ПараметрыПолучения.ПолучатьПредшествующие = ПолучатьПредшествующие;
		РабочиеДаты = ГрафикиРаботы.БлижайшиеДатыВключенныеВГрафик(
			Календарь, ДатыРабочихДней.Выгрузить().ВыгрузитьКолонку("Дата"), ПараметрыПолучения);
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ДатыРабочихДней Цикл
		СтрокаТаблицы.РабочаяДата = РабочиеДаты[СтрокаТаблицы.Дата];
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовФормы(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "УчитыватьНерабочиеПериоды",
		"Доступность", ТипЗнч(Форма.Календарь) = Тип("СправочникСсылка.ПроизводственныеКалендари"));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Форма.Элементы, "ПолучатьДатыЕслиКалендарьНеЗаполнен",
		"Видимость", ТипЗнч(Форма.Календарь) = Тип("СправочникСсылка.ПроизводственныеКалендари"));
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьНерабочиеПериоды(Форма)
	
	Форма.НерабочиеПериоды.Очистить();
	
	Если ТипЗнч(Форма.Календарь) <> Тип("СправочникСсылка.ПроизводственныеКалендари") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Период Из ПериодыНерабочихДней(Форма.Календарь) Цикл
		НоваяСтрока = Форма.НерабочиеПериоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Период);
		НоваяСтрока.Учитывать = Истина;
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПериодыНерабочихДней(ПроизводственныйКалендарь)
	Возврат КалендарныеГрафики.ПериодыНерабочихДней(ПроизводственныйКалендарь, Новый СтандартныйПериод());
КонецФункции

#КонецОбласти
