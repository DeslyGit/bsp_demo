﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер; // ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
Перем ТекущиеОбработчики;
Перем ТекущееИмяХранилищаНастроек;
Перем ТекущееХранилищеНастроек; // СтандартноеХранилищеНастроекМенеджер
Перем ТекущийСериализатор;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ИмяХранилищаНастроек, Обработчики, Сериализатор) Экспорт
	
	ТекущийКонтейнер = Контейнер; // ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
	ТекущееИмяХранилищаНастроек = ИмяХранилищаНастроек;
	ТекущиеОбработчики = Обработчики;
	ТекущийСериализатор = Неопределено; // Проектное решение БТС.
	
	ТекущееХранилищеНастроек = ОбщегоНазначения.ВычислитьВБезопасномРежиме(ИмяХранилищаНастроек); // СтандартноеХранилищеНастроекМенеджер
	
КонецПроцедуры

Процедура ВыгрузитьДанные() Экспорт
	
	Если ТекущееИмяХранилищаНастроек <> "ХранилищеСистемныхНастроек" И Метаданные[ТекущееИмяХранилищаНастроек] <> Неопределено Тогда
		// Выполняется выгрузка данных только из стандартных хранилищ настроек.
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ТекущиеОбработчики.ПередВыгрузкойХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек,
		Отказ);
	
	Если Не Отказ Тогда
		
		ВыгрузитьНастройкиСтандартногоХранилища();
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиХранилищаНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		ТекущееХранилищеНастроек);
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыгрузитьНастройкиСтандартногоХранилища()
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(
		ВыгрузкаЗагрузкаДанныхСлужебный.UserSettings(),
		ТекущееИмяХранилищаНастроек);
	
	ПотокЗаписи = Обработки.ВыгрузкаЗагрузкаДанныхПотокЗаписиДанныхИнформационнойБазы.Создать();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла, ТекущийСериализатор);
	
	ПользователиИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
	
	Для Каждого ПользовательИБ Из ПользователиИБ Цикл // ПользовательИнформационнойБазы
		ВыгрузитьНастройкиПользователя(ПользовательИБ.Имя, ПотокЗаписи);
	КонецЦикла;
	
	ПотокЗаписи.Закрыть();
	
	КоличествоОбъектов = ПотокЗаписи.КоличествоОбъектов();
	Если КоличествоОбъектов = 0 Тогда
		ТекущийКонтейнер.ИсключитьФайл(ИмяФайла);
	Иначе
		ТекущийКонтейнер.УстановитьКоличествоОбъектов(ИмяФайла, КоличествоОбъектов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьНастройкиПользователя(ИмяПользователя, ПотокЗаписи)
	
	Отбор = Новый Структура("Пользователь", ИмяПользователя);
	Выборка = ТекущееХранилищеНастроек.Выбрать(Отбор);
	
	Продолжать = Истина;
	
	Пока Продолжать Цикл
		
		НастройкиПрочитаны = Ложь;
		
		Попытка
			
			Продолжать = Выборка.Следующий();
			НастройкиПрочитаны = Истина;
			
			Если НЕ Продолжать Тогда
				Прервать;
			КонецЕсли;
			
			Настройки = Выборка.Настройки;
			
			ВыгрузитьЭлементНастроек(
				ПотокЗаписи,
				Выборка.КлючНастроек,
				Выборка.КлючОбъекта,
				Выборка.Пользователь,
				Выборка.Представление,
				Настройки);
			
		Исключение
			
			Если НастройкиПрочитаны Тогда
				
				ТекстОшибки = НСтр("ru = 'Выгрузка настройки пропущена, т.к. произошла ошибка:'");
				ТекстОшибкиПодробно = Символы.ПС + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
			Иначе
				
				ТекстОшибки = НСтр("ru = 'Выгрузка настройки пропущена, т.к. настройка не может быть прочитана:'");
				ТекстОшибкиПодробно = "";
				
			КонецЕсли;
			
			СобытиеЖР = НСтр(
				"ru = 'Выгрузка загрузка данных. Выгрузка настройки пропущена'",
				ОбщегоНазначения.КодОсновногоЯзыка());
			Комментарий = СтрШаблон("%1
				|КлючНастроек=%2
				|КлючОбъекта=%3
				|Пользователь=%4
				|Представление=%5
				|%6",
				ТекстОшибки,
				Выборка.КлючНастроек,
				Выборка.КлючОбъекта,
				Выборка.Пользователь,
				Выборка.Представление,
				ТекстОшибкиПодробно);
			
			ЗаписьЖурналаРегистрации(СобытиеЖР, УровеньЖурналаРегистрации.Предупреждение, , , Комментарий);
			
			Продолжать = Истина;
			
		КонецПопытки;
		
	КонецЦикла;
			
КонецПроцедуры

Процедура ВыгрузитьЭлементНастроек(ПотокЗаписи, Знач КлючНастроек, Знач КлючОбъекта, Знач Пользователь, Знач Представление, Знач Настройки)
	
	Отказ = Ложь;
	
	Если ОбработкаСтрокиXML.НайтиНедопустимыеСимволыXML(КлючНастроек) > 0
		ИЛИ ОбработкаСтрокиXML.НайтиНедопустимыеСимволыXML(КлючОбъекта) > 0
		ИЛИ ОбработкаСтрокиXML.НайтиНедопустимыеСимволыXML(Пользователь) > 0
		ИЛИ ОбработкаСтрокиXML.НайтиНедопустимыеСимволыXML(Представление) > 0 Тогда
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Выгрузка загрузка данных. Выгрузка настройки пропущена'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,,,
			НСтр("ru = 'Выгрузка настройки пропущена, т.к. в ключевых параметрах содержатся недопустимые символы.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		Отказ = Истина;
		
	КонецЕсли;
	
	Артефакты = Новый Массив();
	
	ТекущиеОбработчики.ПередВыгрузкойНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		КлючНастроек,
		КлючОбъекта,
		Настройки,
		Пользователь,
		Представление,
		Артефакты,
		Отказ);
	
	СериализацияЧерезХранилищеЗначения = Ложь;
	Если Не НастройкиСериализуютсяВXDTO(Настройки) Тогда
		Настройки = Новый ХранилищеЗначения(Настройки);
		СериализацияЧерезХранилищеЗначения = Истина;
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ЗаписьНастроек = ВыгрузкаЗагрузкаДанныхСлужебный.НоваяЗаписьНастроек();
		ЗаписьНастроек.КлючНастроек = КлючНастроек;
		ЗаписьНастроек.КлючОбъекта = КлючОбъекта;
		ЗаписьНастроек.Пользователь = Пользователь;
		ЗаписьНастроек.Представление = Представление;
		ЗаписьНастроек.СериализацияЧерезХранилищеЗначения = СериализацияЧерезХранилищеЗначения;
		ЗаписьНастроек.Настройки = Настройки;
		
		ПотокЗаписи.ЗаписатьОбъектДанныхИнформационнойБазы(ЗаписьНастроек, Артефакты);
		
	КонецЕсли;
	
	ТекущиеОбработчики.ПослеВыгрузкиНастроек(
		ТекущийКонтейнер,
		ТекущийСериализатор,
		ТекущееИмяХранилищаНастроек,
		КлючНастроек,
		КлючОбъекта,
		Настройки,
		Пользователь,
		Представление);
	
КонецПроцедуры

Функция НастройкиСериализуютсяВXDTO(Знач Настройки)
	
	Если ТипЗнч(Настройки) = Тип("НастройкиИнтерфейсаКлиентскогоПриложения") 
		Или ТипЗнч(Настройки) = Тип("НастройкиКомандногоИнтерфейса") 
		Или ТипЗнч(Настройки) = Тип("НастройкиИсторииВыбора")
		Или ТипЗнч(Настройки) = Тип("НастройкиФормы")
		Или ТипЗнч(Настройки) = Тип("ИсторияПоискаТаблицы")
		Или ТипЗнч(Настройки) = Тип("НастройкиКомандногоИнтерфейса")
		Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Результат = Истина;
	
	Попытка
		
		ПотокПроверки = Новый ЗаписьXML();
		ПотокПроверки.УстановитьСтроку();
		
		СериализаторXDTO.ЗаписатьXML(ПотокПроверки, Настройки);
		
	Исключение
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
