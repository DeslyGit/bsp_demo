﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область Анкетирование

Процедура ЗаполнитьПримечание(МассивОбъектов, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	ОткрытьФорму("ОбщаяФорма._ДемоПримечание", 
		Новый Структура("ПараметрыПодключаемыхКоманд", Форма.ПараметрыПодключаемыхКоманд), 
		Форма, Форма.УникальныйИдентификатор);	
	
КонецПроцедуры

#КонецОбласти

#Область БазоваяФункциональность

// См. ОбщегоНазначенияКлиентПереопределяемый.
Процедура ПредлагатьПерейтиНаСайтПриЗапуске(Параметры, ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПредлагатьПерейтиНаСайтПриЗапускеЗавершение", ЭтотОбъект, Параметры);
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
		"ru = 'Перед началом работы с программой рекомендуется ознакомиться с ее документацией. 
		|Перейти на сайт сейчас?
		|
		|Этот пример демонстрирует открытие диалогов, блокирующих запуск программы,
		|из общего модуля %1.'"),
		"ОбщегоНазначенияКлиентПереопределяемый");
		
	Кнопки = Новый СписокЗначений();
	Кнопки.Добавить("Перейти", НСтр("ru = 'Перейти на сайт'"));
	Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить("Завершить", НСтр("ru = 'Завершить работу'"));
	Кнопки.Добавить("Перезапустить", НСтр("ru = 'Перезапустить программу'"));
	
	ПараметрыВопроса = СтандартныеПодсистемыКлиент.ПараметрыВопросаПользователю();
	ПараметрыВопроса.Заголовок = НСтр("ru = 'Переход на сайт'");
	ПараметрыВопроса.БлокироватьВесьИнтерфейс = Истина;
	
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(Оповещение, ТекстВопроса, Кнопки, ПараметрыВопроса);
	
КонецПроцедуры

Процедура ПредлагатьПерейтиНаСайтПриЗапускеЗавершение(РезультатВопроса, Параметры) Экспорт
	
	Если РезультатВопроса <> Неопределено Тогда
		Если РезультатВопроса.Значение = "Перейти" Тогда
			ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(
				СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске().АдресСайтаОКонфигурации);
		ИначеЕсли РезультатВопроса.Значение = "Завершить" Тогда
			Параметры.Отказ = Истина;
		ИначеЕсли РезультатВопроса.Значение = "Перезапустить" Тогда
			Параметры.Отказ = Истина;
			Параметры.Перезапустить = Истина;
		КонецЕсли;
		
		Если РезультатВопроса.БольшеНеЗадаватьЭтотВопрос Тогда
			ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
				"ОбщиеНастройкиПользователя",
				"ПредлагатьПерейтиНаСайтПриЗапуске",
				Ложь);
		КонецЕсли;
	КонецЕсли;
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти

#Область ВариантыОтчетов

// См. ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
Процедура НачатьРедактированиеОтчета(ФормаОтчета) Экспорт 
	
	ТабличныйДокумент = ФормаОтчета.ОтчетТабличныйДокумент;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Редактирование таблицы сформированного отчета ""%1""'"),
		ФормаОтчета.Заголовок);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ИмяДокумента",      Заголовок);
	ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
	ПараметрыОткрытия.Вставить("Редактирование",    Истина);
	
	ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия);
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
Процедура ОформитьВыделенныеОбластиОтчета(ФормаОтчета, КатегорияДанных) Экспорт 
	
	Если СтрЗаканчиваетсяНа(КатегорияДанных, "ОшибочныеДанные") Тогда 
		ЦветОформления = WebЦвета.СветлоРозовый;
	ИначеЕсли СтрЗаканчиваетсяНа(КатегорияДанных, "КорректныеДанные") Тогда 
		ЦветОформления = WebЦвета.СветлоЗеленый;
	ИначеЕсли СтрЗаканчиваетсяНа(КатегорияДанных, "СомнительныеДанные") Тогда 
		ЦветОформления = WebЦвета.СветлоЖелтый;
	Иначе
		Возврат;
	КонецЕсли;
	
	ТабличныйДокумент = ФормаОтчета.ОтчетТабличныйДокумент;
	Для Каждого Область Из ТабличныйДокумент.ВыделенныеОбласти Цикл 
		Для НомерСтроки = Область.Верх По Область.Низ Цикл 
			Для НомерКолонки = Область.Лево По Область.Право Цикл 
				Ячейка = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки); // ОбластьЯчеекТабличногоДокумента
				Ячейка.ЦветФона = ЦветОформления;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область КонтрольВеденияУчета

// Открывает форму для проведения документов _ДемоСчетФактураПолученный,
// выявленные проверкой поиска непроведенных документов.
// См. _ДемоСтандартныеПодсистемы.ПроверитьПроведенностьСчетаФактурыПолученного.
//
// Параметры:
//    ПараметрыИсправления  - Структура:
//      * ИдентификаторПроверки - Строка - строковый идентификатор проверки.
//      * ВидПроверки           - СправочникСсылка.ВидыПроверок - вид проверки, к которому
//                                относится выполненная проверка.
//    ДополнительныеПараметры - Неопределено - параметр не используется.
//
Процедура ПровестиСчетаФактурыПоПроблемнымКонтрагентам(ПараметрыИсправления, ДополнительныеПараметры) Экспорт
	
	ОткрытьФорму("Документ._ДемоСчетФактураПолученный.Форма.ПроведениеДокументов", ПараметрыИсправления);
	
КонецПроцедуры

#КонецОбласти

#Область КонтактнаяИнформация

// Открывает заполненную форму документа встреча
// 
// Параметры:
//  КонтактнаяИнформация    - см. УправлениеКонтактнойИнформациейКлиент.ПараметрКонтактнаяИнформацияДляВыполненияКоманд
//  ДополнительныеПараметры - см. УправлениеКонтактнойИнформациейКлиент.ДополнительныеПараметрыДляВыполненияКоманд
//
Процедура ОткрытьФормуДокументаВстреча(КонтактнаяИнформация, ДополнительныеПараметры) Экспорт

	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("МестоПроведенияВстречи", КонтактнаяИнформация.Представление);
	Если ТипЗнч(ДополнительныеПараметры.ВладелецКонтактнойИнформации) = Тип("ДокументСсылка._ДемоЗаказПокупателя") Тогда
		ЗначенияЗаполнения.Вставить("Предмет", ДополнительныеПараметры.ВладелецКонтактнойИнформации);
		ЗначенияЗаполнения.Вставить("Контакт", "");
	Иначе
		ЗначенияЗаполнения.Вставить("Контакт", ДополнительныеПараметры.ВладелецКонтактнойИнформации);
		ЗначенияЗаполнения.Вставить("Предмет", "");
	КонецЕсли;

	ОткрытьФорму("Документ.Встреча.ФормаОбъекта", Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения),
		ДополнительныеПараметры.Форма);

КонецПроцедуры	

#КонецОбласти

#Область МашиночитаемыеДоверенности

// См. МашиночитаемыеДоверенностиФНСКлиентПереопределяемый.ПриИзмененииСтатусаДоверенности.
Процедура ПриИзмененииСтатусаДоверенности(СтатусыДоверенностей) Экспорт
	Если СтатусыДоверенностей.Количество() = 1 Тогда
		Текст = НСтр("ru='Демо: Изменился статус МЧД'");
		Для Каждого СтатусДоверенности Из СтатусыДоверенностей Цикл
			НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(СтатусДоверенности.Ключ);
			Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1: %2'"),
				СтатусДоверенности.Значение.НовыйСтатус, СтатусДоверенности.Ключ);
		КонецЦикла;
	Иначе
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Демо: Изменился статус МЧД (%1)'"),
			СтатусыДоверенностей.Количество());
		НавигационнаяСсылка = "e1cib/list/Справочник.МашиночитаемыеДоверенностиФНС";
		Пояснение = НСтр("ru='Открыть список'");
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(Текст, НавигационнаяСсылка, Пояснение);
КонецПроцедуры

// См. МашиночитаемыеДоверенностиФНСКлиентПереопределяемый.ПриРегистрацииДоверенности
Процедура ПриРегистрацииДоверенности(Доверенность, СтандартнаяОбработка, ОбработчикЗавершения) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриРегистрацииДоверенностиПродолжение", ЭтотОбъект, ОбработчикЗавершения);
	ТекстВопроса = НСтр("ru = 'Будет выполнена регистрация доверенности в реестре ФТС. Продолжить?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

Процедура ПриРегистрацииДоверенностиПродолжение(РезультатВопроса, ОбработчикЗавершения) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьОбработкуОповещения(ОбработчикЗавершения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Выполняет проверку печати непроведенного документа,
//  которая в обычном сценарии выполняться перед подготовкой документа к печати
//  (роль "Демо: печать непроведенных документов" используется, как дополнительное право с ограничением доступа).
//
// Параметры:
//  ПараметрыПечати - см. УправлениеПечатьюКлиент.ОписаниеПараметровПечати
//
// Возвращаемое значение:
//  Неопределено - возвращать результат не требуется.
//
Функция ПроверитьРазрешениеНаПечать(ПараметрыПечати) Экспорт
	ПоказатьПредупреждение(, _ДемоСтандартныеПодсистемыВызовСервера.ПечатьРазрешена(ПараметрыПечати.ОбъектыПечати[0]));
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область ПодключаемыеКоманды

// Параметры:
//  МассивСсылок - Массив из СправочникСсылка
//  ПараметрыВыполнения - Структура:
//    * Форма - ФормаКлиентскогоПриложения:
//     ** Объект - ДанныеФормыСтруктура:
//      *** Наименование - Строка
//
Процедура ЗаполнитьНаименование(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	Объект = ПараметрыВыполнения.Форма.Объект;
	НовоеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Наименование заполнено %1.'"),
		Формат(ОбщегоНазначенияКлиент.ДатаСеанса(), "ДФ=yyyy-MM-dd"));
	
	Если Не ПустаяСтрока(Объект.Наименование) И Объект.Наименование = НовоеЗначение Тогда
		ПоказатьОповещениеПользователя(, , НСтр("ru = 'Наименование уже заполнено.'"), БиблиотекаКартинок.Информация32);
		Возврат;
	КонецЕсли;
	
	Объект.Наименование = НовоеЗначение;
	ПоказатьОповещениеПользователя(, , НСтр("ru = 'Наименование успешно заполнено.'"), БиблиотекаКартинок.Успешно32);
	ПараметрыВыполнения.Форма.Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

#Область ЭлектроннаяПодпись

// См. ЭлектроннаяПодписьПереопределяемый.ПриДополнительнойПроверкеСертификата.
Процедура ПриДополнительнойПроверкеСертификата(Параметры) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Параметры", Параметры);
	
	Если Параметры.Проверка = "ТестСвязиСОператором" Тогда
		
		Параметры.ОжидатьПродолжения = Истина;
		НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения(
			"ПриДополнительнойПроверкеСертификатаПослеПодключенияРасширенияРаботыСФайлами", ЭтотОбъект, Контекст));
		
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПриДополнительнойПроверкеСертификата.
//
// Параметры:
//  Контекст - Структура:
//   * Параметры - см. ЭлектроннаяПодписьПереопределяемый.ПриДополнительнойПроверкеСертификата.Параметры
//
Процедура ПриДополнительнойПроверкеСертификатаПослеПодключенияРасширенияРаботыСФайлами(Подключено, Контекст) Экспорт
	
	ВыполнитьОбработкуОповещения(Контекст.Параметры.Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область ЦентрМониторинга

Процедура ПриНачалеРаботыСистемыЦентрМониторинга() Экспорт
    
    СистемнаяИнформация = Новый СистемнаяИнформация();
    ОперативнаяПамять = Формат((ЦЕЛ(СистемнаяИнформация.ОперативнаяПамять/512) + 1) * 512, "ЧГ=0");
    ИмяОперации = "_ДемоСтатистикаКлиента.ИнформацияОСистеме.ОперативнаяПамять." + ОперативнаяПамять; 
    
    ЦентрМониторингаКлиент.ЗаписатьОперациюБизнесСтатистикиСутки(ИмяОперации, 1);
    
КонецПроцедуры

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Для проверки обратной совместимости программного интерфейса подсистемы "Печать".
// Формирует печатные формы документов _ДемоСчетНаОплатуПокупателю с использованием макета в формате офисного документа.
//
// Параметры:
//  ПараметрыПечати - см. УправлениеПечатьюКлиент.ОписаниеПараметровПечати
//
// Возвращаемое значение:
//  Неопределено - возвращать результат не требуется.
//
Функция ПечатьСчетовНаОплатуПокупателю(ПараметрыПечати) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение НСтр("ru = 'Для формирования этой печатной формы воспользуйтесь тонким клиентом.'");
#КонецЕсли
	
	ИмяМенеджераПечати = ПараметрыПечати.МенеджерПечати;
	ИмяМакета = ПараметрыПечати.Идентификатор;
	СоставДокументов = ПараметрыПечати.ОбъектыПечати;
	
	ТекстСообщения = ?(СоставДокументов.Количество() > 1, 
		НСтр("ru = 'Выполняется формирование печатных форм...'"),
		НСтр("ru = 'Выполняется формирование печатной формы...'"));
	Состояние(ТекстСообщения);
	
	МакетИДанныеОбъекта = УправлениеПечатьюВызовСервера.МакетыИДанныеОбъектовДляПечати(ИмяМенеджераПечати, ИмяМакета, СоставДокументов);
	
	Для Каждого ДокументСсылка Из СоставДокументов Цикл
		НапечататьСчетНаОплатуПокупателю(ДокументСсылка, МакетИДанныеОбъекта, ИмяМакета);
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Для проверки обратной совместимости программного интерфейса подсистемы "Печать".
// Формирует печатную форму документа _ДемоСчетНаОплатуПокупателю с использованием макета в формате офисного документа.
//
Процедура НапечататьСчетНаОплатуПокупателю(ДокументСсылка, МакетИДанныеОбъекта, ИмяМакета)
	
	ТипМакета				= МакетИДанныеОбъекта.Макеты.ТипыМакетов[ИмяМакета];
	ДвоичныеДанныеМакетов	= МакетИДанныеОбъекта.Макеты.ДвоичныеДанныеМакетов;
	Области					= МакетИДанныеОбъекта.Макеты.ОписаниеОбластей;
	ДанныеОбъекта = МакетИДанныеОбъекта.Данные[ДокументСсылка][ИмяМакета];
	
	Макет = УправлениеПечатьюКлиент.ИнициализироватьМакетОфисногоДокумента(ДвоичныеДанныеМакетов[ИмяМакета], ТипМакета, ИмяМакета);
	Если Макет = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗакрытьОкноПечатнойФормы = Ложь;
	Попытка
		ПечатнаяФорма = УправлениеПечатьюКлиент.ИнициализироватьПечатнуюФорму(ТипМакета, Макет.НастройкиСтраницыМакета, Макет);
		Если ПечатнаяФорма = Неопределено Тогда
			УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
			Возврат;
		КонецЕсли;
		
		// Вывод колонтитулов документа.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ВерхнийКолонтитул"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["НижнийКолонтитул"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область);
		
		// Вывод верхней части документа - обычная область с параметрами.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["Заголовок"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		// Вывод коллекции данных из информационной базы в виде таблицы.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ШапкаТаблицыТоварыТекст"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ШапкаТаблицыТовары"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["СтрокаТаблицаТовары"]);
		УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, Область, ДанныеОбъекта.Товары, Ложь);
		
		// Вывод коллекции данных из информационной базы в виде нумерованного списка.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ШапкаТоварыНоменклатура"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ТоварыНоменклатура"]);
		УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, Область, ДанныеОбъекта.Товары, Ложь);
		
		// Вывод коллекции данных из информационной базы в виде списка.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ШапкаТоварыВсего"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбласть(ПечатнаяФорма, Область, Ложь);
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["ТоварыВсего"]);
		УправлениеПечатьюКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, Область, ДанныеОбъекта.Товары, Ложь);
		
		// Вывод нижней части документа - обычная область с параметрами.
		Область = УправлениеПечатьюКлиент.ОбластьМакета(Макет, Области[ИмяМакета]["НижняяЧасть"]);
		УправлениеПечатьюКлиент.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, Область, ДанныеОбъекта, Ложь);
		
		УправлениеПечатьюКлиент.ПоказатьДокумент(ПечатнаяФорма);
	Исключение
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗакрытьОкноПечатнойФормы = Истина;
		Возврат;
	КонецПопытки;
	
	УправлениеПечатьюКлиент.ОчиститьСсылки(ПечатнаяФорма, ЗакрытьОкноПечатнойФормы);
	УправлениеПечатьюКлиент.ОчиститьСсылки(Макет);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
