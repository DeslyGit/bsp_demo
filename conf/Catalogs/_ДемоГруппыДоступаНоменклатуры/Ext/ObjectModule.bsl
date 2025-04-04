﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(Ссылка) Тогда
		ГруппаДоступа = Ссылка;
	Иначе
		СсылкаНового = ПолучитьСсылкуНового();
		Если Не ЗначениеЗаполнено(СсылкаНового) Тогда
			СсылкаНового = Справочники._ДемоГруппыДоступаНоменклатуры.ПолучитьСсылку();
			УстановитьСсылкуНового(СсылкаНового);
		КонецЕсли;
		ГруппаДоступа = СсылкаНового;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Иначе
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли