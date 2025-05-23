﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала)
				Или Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания) Тогда
			
			Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала)
				И Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаОкончания) Тогда
			
				ТекстСообщения= НСтр("ru='По сотруднику %1 не задан период отпуска'");
				ИмяРеквизита = "ДатаНачала";
				
			Иначе
				
				ТекстСообщения = НСтр("ru='По сотруднику %1 неверно задан период отпуска'");
				Если Не ЗначениеЗаполнено(СтрокаСотрудника.ДатаНачала) Тогда
					ИмяРеквизита = "ДатаНачала";
				Иначе
					ИмяРеквизита = "ДатаОкончания";
				КонецЕсли;
					
			КонецЕсли;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаСотрудника.Сотрудник);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				,
				"Сотрудники[" + (СтрокаСотрудника.НомерСтроки - 1) + "]." + ИмяРеквизита,
				"Объект",
				Отказ);
	
		КонецЕсли; 
		
	КонецЦикла;
	     	
			
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка._ДемоОтпускаСотрудников") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, Сотрудники");
		Организация = ЗначенияРеквизитов.Организация; 
		ТЧСотрудники = ЗначенияРеквизитов.Сотрудники;
		Ответственный = Пользователи.ТекущийПользователь();
		Для Каждого СтрокаСотрудники Из ТЧСотрудники Цикл
			НоваяСтрока = Сотрудники.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСотрудники);
		КонецЦикла;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	СформироватьДвиженияВРеестрДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//
Процедура СформироватьДвиженияВРеестрДокументов()
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка));
	Движение = РегистрыСведений._ДемоРеестрДокументов.СоздатьМенеджерЗаписи();
	Движение.ТипСсылки = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",(МетаданныеОбъекта.Имя));
	Движение.Организация = Организация;
	Движение.ДатаДокументаИБ = Дата;
	Движение.Ссылка = Ссылка;
	Движение.НомерДокументаИБ = Номер;
	Движение.Ответственный = Ответственный;
	Движение.Комментарий = Комментарий;
	Движение.Проведен = Истина;
	Движение.ПометкаУдаления = Ложь;
	Движение.ДатаПервичногоДокумента = Дата;
	Движение.НомерПервичногоДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Истина) ;
	Движение.ДатаОтраженияВУчете = Дата;
	Движение.Записать();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли