﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:    Организация И (МестоХраненияИсточник ИЛИ МестоХраненияПриемник).
	// Изменения: Организация И  МестоХраненияИсточник И   МестоХраненияПриемник И Ответственный.
	
	// Чтение: набор №1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.ЗначениеДоступа = МестоХраненияИсточник;
	
	// Чтение: набор №2
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.ЗначениеДоступа = МестоХраненияПриемник;
	
	// Изменение: набор №3.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.ЗначениеДоступа = МестоХраненияИсточник;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.ЗначениеДоступа = МестоХраненияПриемник;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.ЗначениеДоступа = Ответственный;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка._ДемоПоступлениеТоваров") Тогда
		ДокументОбъект = ДанныеЗаполнения.ПолучитьОбъект();
		
		Организация = ДокументОбъект.Организация;
		МестоХраненияИсточник = ДокументОбъект.МестоХранения;
		Ответственный = Пользователи.ТекущийПользователь();
		Для Каждого СтрокаТовары Из ДокументОбъект.Товары Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовары);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияВРеестрДокументов();

	СформироватьДвиженияПоМестамХранения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияВРеестрДокументов()
	
	УстановитьПривилегированныйРежим(Истина);

	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка));
	Движение = РегистрыСведений._ДемоРеестрДокументов.СоздатьМенеджерЗаписи();
	Движение.ТипСсылки = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",(МетаданныеОбъекта.Имя));
	Движение.Организация = Организация;
	Движение.МестоХранения = МестоХраненияПриемник;
	Движение.ДатаДокументаИБ = Дата;
	Движение.Ссылка = Ссылка;
	Движение.НомерДокументаИБ = Номер;
	Движение.Ответственный = Ответственный;
	Движение.Дополнительно = НСтр("ru='Перемещение с'")+" "+ """"+МестоХраненияИсточник+"""";
	Движение.Комментарий = Комментарий;
	Движение.Проведен = Истина;
	Движение.ПометкаУдаления = Ложь;
	Движение.ДатаПервичногоДокумента = Дата;
	Движение.НомерПервичногоДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Истина);
	Движение.ДатаОтраженияВУчете = Дата;
	Движение.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

Процедура СформироватьДвиженияПоМестамХранения()
	
	Движения._ДемоОстаткиТоваровВМестахХранения.Записывать = Истина;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		Движение = Движения._ДемоОстаткиТоваровВМестахХранения.Добавить();
		
		Движение.Период        = Дата;
		Движение.ВидДвижения   = ВидДвиженияНакопления.Расход;
		
		Движение.Организация   = Организация;
		Движение.МестоХранения = МестоХраненияИсточник;
		
		Движение.Номенклатура  = СтрокаТовары.Номенклатура;
		Движение.Количество    = СтрокаТовары.Количество;
		
		Движение = Движения._ДемоОстаткиТоваровВМестахХранения.Добавить();
		
		Движение.Период        = Дата;
		Движение.ВидДвижения   = ВидДвиженияНакопления.Приход;
		
		Движение.Организация   = Организация;
		Движение.МестоХранения = МестоХраненияПриемник;
		
		Движение.Номенклатура  = СтрокаТовары.Номенклатура;
		Движение.Количество    = СтрокаТовары.Количество;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли