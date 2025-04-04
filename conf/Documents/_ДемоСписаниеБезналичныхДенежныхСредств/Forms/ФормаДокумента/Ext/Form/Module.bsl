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
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Дата.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.Номер.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.Комментарий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
	КонецЕсли;
	
	УстановитьВалюту();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	УстановитьВалюту();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВалюту()
	Валюта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.БанковскийСчет, "Валюта");
КонецПроцедуры
	
#КонецОбласти