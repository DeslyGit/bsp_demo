﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ИзвлечениеТекста

// Добавляет и удаляет записи в регистр сведений ОчередьИзвлеченияТекста при изменении
// состояние извлечения текста версий файлов.
//
// Параметры:
//  ИсточникТекста - ОпределяемыйТип.ПрисоединенныйФайл - файл, у которого изменилось состояние извлечения текста.
//  СостояниеИзвлеченияТекста - ПеречислениеСсылка.СтатусыИзвлеченияТекстаФайлов - новый статус.
//
Процедура ОбновитьСостояниеОчередиИзвлеченияТекста(ИсточникТекста, СостояниеИзвлеченияТекста) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		Возврат;
	КонецЕсли;
	
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОчередьИзвлеченияТекста.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбластьДанныхВспомогательныеДанные.Установить(МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	НаборЗаписей.Отбор.ИсточникТекста.Установить(ИсточникТекста);
	
	Если СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен
			ИЛИ СостояниеИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.ПустаяСсылка() Тогда
			
		Запись = НаборЗаписей.Добавить();
		Запись.ОбластьДанныхВспомогательныеДанные = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		Запись.ИсточникТекста = ИсточникТекста;
			
	КонецЕсли;
		
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПодсистемКонфигурации

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.ИзвлечьТекстИзФайлов");
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.ОчиститьНенужныеФайлы");
	СоответствиеИменПсевдонимам.Вставить("РаботаСФайламиСлужебный.РегламентнаяСинхронизацияФайловWebdav");
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииИспользованияРегламентныхЗаданий.
Процедура ПриОпределенииИспользованияРегламентныхЗаданий(ТаблицаИспользования) Экспорт
	
	НоваяСтрока = ТаблицаИспользования.Добавить();
	НоваяСтрока.РегламентноеЗадание = "ПланированиеИзвлеченияТекстаВМоделиСервиса";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
		МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
		НоваяСтрока.Использование = МодульПолнотекстовыйПоискСервер.ИспользоватьПолнотекстовыйПоиск();
	Иначе
		НоваяСтрока.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.Имя);
	ШаблоныЗаданий.Добавить(Метаданные.РегламентныеЗадания.СинхронизацияФайлов.Имя);
	
КонецПроцедуры

// См. ИнтерфейсODataПереопределяемый.ПриЗаполненииЗависимыхТаблицДляВыгрузкиЗагрузкиOData
Процедура ПриЗаполненииЗависимыхТаблицДляВыгрузкиЗагрузкиOData(Таблицы) Экспорт
	
	ЗависимыеТаблицы = СправочникиФайловИОбъектыХранения().ОбъектыХранения;
	Для Каждого ЗависимаяТаблица Из ЗависимыеТаблицы Цикл
		Таблицы.Добавить(ЗависимаяТаблица.Ключ);
	КонецЦикла;
	
КонецПроцедуры

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.РегистрыСведений.ОчередьИзвлеченияТекста);
	Типы.Добавить(Метаданные.Константы.ПутьКТомуБезУчетаРегиональныхНастроек);
	
	ИсключаемыеТипы = СправочникиФайловИОбъектыХранения().ОбъектыХранения;
	Для Каждого ИсключаемыйТип Из ИсключаемыеТипы Цикл
		Типы.Добавить(ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ИсключаемыйТип.Ключ));
	КонецЦикла;
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	СправочникиФайлов = СправочникиФайловИОбъектыХранения().СправочникиФайлов;
	Для Каждого СправочникФайлов Из СправочникиФайлов Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(СправочникФайлов.Ключ);
		НовыйОбработчик.Обработчик = РаботаСФайламиСлужебныйВМоделиСервиса;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = "1.0.0.1";
		
	КонецЦикла;
	
	Если ТаблицаОбработчиков.Найти(Метаданные.Справочники.Файлы, "ОбъектМетаданных") = Неопределено Тогда
	
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = Метаданные.Справочники.Файлы;
		НовыйОбработчик.Обработчик = РаботаСФайламиСлужебныйВМоделиСервиса;
		НовыйОбработчик.ПередВыгрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = "1.0.0.1";
	
	КонецЕсли;
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных.
Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	СправочникиФайлов = СправочникиФайловИОбъектыХранения().СправочникиФайлов;
	Для Каждого СправочникФайлов Из СправочникиФайлов Цикл
		
		НовыйОбработчик = ТаблицаОбработчиков.Добавить();
		НовыйОбработчик.ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(СправочникФайлов.Ключ);
		НовыйОбработчик.Обработчик = РаботаСФайламиСлужебныйВМоделиСервиса;
		НовыйОбработчик.ПередЗагрузкойОбъекта = Истина;
		НовыйОбработчик.Версия = "1.0.0.1";
		
	КонецЦикла;
	
КонецПроцедуры

// Подключается в ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковВыгрузкиДанных.
//
// Параметры:
//   Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
//   МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы
//   Сериализатор - СериализаторXDTO
//   Объект - КонстантаМенеджерЗначения
//          - СправочникОбъект
//          - ДокументОбъект
//          - БизнесПроцессОбъект
//          - ЗадачаОбъект
//          - ПланСчетовОбъект
//          - ПланОбменаОбъект
//          - ПланВидовХарактеристикОбъект
//          - ПланВидовРасчетаОбъект
//          - РегистрСведенийНаборЗаписей
//          - РегистрНакопленияНаборЗаписей
//          - РегистрБухгалтерииНаборЗаписей
//          - РегистрРасчетаНаборЗаписей
//          - ПоследовательностьНаборЗаписей
//          - ПерерасчетНаборЗаписей
//   Артефакты - Массив из ОбъектXDTO
//   Отказ - Булево
//
Процедура ПередВыгрузкойОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты, Отказ) Экспорт
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.Файлы") Тогда
		ОчиститьСсылкаНаТомХраненияФайлов(Объект);
		Если Объект.ХранитьВерсии Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СправочникиФайлов = СправочникиФайловИОбъектыХранения().СправочникиФайлов;
	
	Обработчик = СправочникиФайлов.Получить(Объект.Метаданные().ПолноеИмя());
	
	Если Обработчик = Неопределено Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком
				|%2.'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			Объект.Метаданные().ПолноеИмя(), "РаботаСФайламиСлужебныйВМоделиСервиса.ПередВыгрузкойОбъекта()");
		
	КонецЕсли;
	
	МодульОбработчика = ОбщегоНазначения.ОбщийМодуль(Обработчик);
	РасширениеФайла = МодульОбработчика.РасширениеФайла(Объект);
	ИмяФайла = Контейнер.СоздатьПроизвольныйФайл(РасширениеФайла);
	
	Попытка
		
		МодульОбработчика.ВыгрузитьФайл(Объект, ИмяФайла);
		
		Артефакт = ФабрикаXDTO.Создать(ТипАртефактФайла());
		Артефакт.RelativeFilePath = Контейнер.ПолучитьОтносительноеИмяФайла(ИмяФайла);
		Артефакты.Добавить(Артефакт);
		
	Исключение
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		
			МодульТехнологияСервиса = ОбщегоНазначения.ОбщийМодуль("ТехнологияСервиса");
			Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(МодульТехнологияСервиса.ВерсияБиблиотеки(), "2.0.2.15") >= 0 Тогда
				Предупреждение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Выгрузка файла %1 (тип %2) пропущена по причине
					|%3'"),
					Объект,
					Объект.Метаданные().ПолноеИмя(),
					ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				
				Контейнер.ДобавитьПредупреждение(Предупреждение);
			КонецЕсли;
			
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Выгрузка данных для перехода в сервис'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Объект.Метаданные(),
			Объект.Ссылка,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
		Контейнер.ИсключитьФайл(ИмяФайла);
		
	КонецПопытки;
	
	ОчиститьСсылкаНаТомХраненияФайлов(Объект);
	
КонецПроцедуры

// Подключается в ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных.
//
// Параметры:
//   Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
//   Объект - КонстантаМенеджерЗначения
//          - СправочникОбъект
//          - ДокументОбъект
//          - БизнесПроцессОбъект
//          - ЗадачаОбъект
//          - ПланСчетовОбъект
//          - ПланОбменаОбъект
//          - ПланВидовХарактеристикОбъект
//          - ПланВидовРасчетаОбъект
//          - РегистрСведенийНаборЗаписей
//          - РегистрНакопленияНаборЗаписей
//          - РегистрБухгалтерииНаборЗаписей
//          - РегистрРасчетаНаборЗаписей
//          - ПоследовательностьНаборЗаписей
//          - ПерерасчетНаборЗаписей
//   Артефакты - Массив из ОбъектXDTO
//   Отказ - Булево
//
Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	СправочникиФайлов = СправочникиФайловИОбъектыХранения().СправочникиФайлов;
	
	Обработчик = СправочникиФайлов.Получить(Объект.Метаданные().ПолноеИмя());
	
	Если Обработчик = Неопределено Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком
				|%2.'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Объект.Метаданные().ПолноеИмя(), "РаботаСФайламиСлужебныйВМоделиСервиса.ПередВыгрузкойОбъекта()");
		
	КонецЕсли;
	
	МодульОбработчика = ОбщегоНазначения.ОбщийМодуль(Обработчик);
	
	Для Каждого Артефакт Из Артефакты Цикл
		
		Если Артефакт.Тип() = ТипАртефактФайла() Тогда
			
			МодульОбработчика.ЗагрузитьФайл(Объект, Контейнер.ПолучитьПолноеИмяФайла(Артефакт.RelativeFilePath));
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// АПК:299-выкл - обработчики событий и обновления ИБ.

#Область ОбновлениеИнформационнойБазы

// Заполняет очередь извлечения текста для текущей области данных. Используется для начального заполнения при
// обновлении.
//
Процедура ЗаполнитьОчередьИзвлеченияТекста() Экспорт
	
	ЭтоРазделеннаяКонфигурация = Ложь;
	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		ЭтоРазделеннаяКонфигурация = МодульРаботаВМоделиСервиса.ЭтоРазделеннаяКонфигурация();
	КонецЕсли;
	
	Если Не ЭтоРазделеннаяКонфигурация Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = РаботаСФайламиСлужебный.ТекстЗапросаДляИзвлеченияТекста(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбновитьСостояниеОчередиИзвлеченияТекста(Выборка.Ссылка,
			Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

// АПК:299-вкл

#Область ИзвлечениеТекста

// Определяет перечень областей данных, в которых требуется извлечение текста и планирует
// для них его выполнение с использованием очереди заданий.
//
Процедура ОбработатьОчередьИзвлеченияТекста() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ПланированиеИзвлеченияТекстаВМоделиСервиса);
	
	Если НЕ ОбщегоНазначения.РазделениеВключено()
		Или Не ОбщегоНазначения.ЭтоWindowsСервер() Тогда
		Возврат;
	КонецЕсли;
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяРазделенногоМетода = "РаботаСФайламиСлужебный.ИзвлечьТекстИзФайлов";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
	|	ВЫБОР
	|		КОГДА ЧасовыеПояса.Значение = """"
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ ЕСТЬNULL(ЧасовыеПояса.Значение, НЕОПРЕДЕЛЕНО)
	|	КОНЕЦ КАК ЧасовойПояс
	|ИЗ
	|	РегистрСведений.ОчередьИзвлеченияТекста КАК ОчередьИзвлеченияТекста
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константа.ЧасовойПоясОбластиДанных КАК ЧасовыеПояса
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ЧасовыеПояса.ОбластьДанныхВспомогательныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|		ПО ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные = ОбластиДанных.ОбластьДанныхВспомогательныеДанные
	|ГДЕ
	|	НЕ ОчередьИзвлеченияТекста.ОбластьДанныхВспомогательныеДанные В (&ОбрабатываемыеОбластиДанных)
	|	И ОбластиДанных.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОбластейДанных.Используется)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ОбрабатываемыеОбластиДанных", МодульОчередьЗаданий.ПолучитьЗадания(
		Новый Структура("ИмяМетода", ИмяРазделенногоМетода)));
		
	Если ТранзакцияАктивна() Тогда
		ВызватьИсключение(НСтр("ru = 'Транзакция активна. Выполнение запроса в транзакции невозможно.'"));
	КонецЕсли;
	
	КоличествоПопыток = 0;
	
	Результат = Неопределено;
	Пока Истина Цикл
		Попытка
			Результат = Запрос.Выполнить(); // Чтение вне транзакции, возможно появление ошибки.
			                                // Could not continue scan with NOLOCK due to data movement
			                                // в этом случае нужно повторить попытку чтения.
			Прервать;
		Исключение
			КоличествоПопыток = КоличествоПопыток + 1;
			Если КоличествоПопыток = 5 Тогда
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
	КонецЦикла;
		
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		// Проверка блокировки области.
		Если МодульРаботаВМоделиСервиса.ОбластьДанныхЗаблокирована(Выборка.ОбластьДанных) Тогда
			// Область заблокирована, перейти к следующей записи.
			Продолжить;
		КонецЕсли;
		
		НовоеЗадание = Новый Структура();
		НовоеЗадание.Вставить("ОбластьДанных", Выборка.ОбластьДанных);
		НовоеЗадание.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(ТекущаяУниверсальнаяДата(), Выборка.ЧасовойПояс));
		НовоеЗадание.Вставить("ИмяМетода", ИмяРазделенногоМетода);
		МодульОчередьЗаданий.ДобавитьЗадание(НовоеЗадание);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ТипАртефактФайла()
	
	Возврат ФабрикаXDTO.Тип(Пакет(), "FileArtefact");
	
КонецФункции

Функция Пакет()
	
	Возврат "http://www.1c.ru/1cFresh/Data/Artefacts/Files/1.0.0.1";
	
КонецФункции

Функция СправочникиФайловИОбъектыХранения()
	
	Возврат РаботаСФайламиСлужебныйВМоделиСервисаПовтИсп.СправочникиФайловИОбъектыХранения();
	
КонецФункции

Процедура ОчиститьСсылкаНаТомХраненияФайлов(Объект)
	
	Для Каждого РеквизитОбъекта Из Объект.Метаданные().Реквизиты Цикл
		Если РеквизитОбъекта.Тип.СодержитТип(Тип("СправочникСсылка.ТомаХраненияФайлов")) 
			И ЗначениеЗаполнено(Объект[РеквизитОбъекта.Имя]) Тогда
			Объект[РеквизитОбъекта.Имя] = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
