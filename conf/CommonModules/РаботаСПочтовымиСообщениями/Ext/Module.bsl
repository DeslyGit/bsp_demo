﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет отправку одного письма.
// Функция может вызвать исключение, которое требуется обработать.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - почтовый ящик, с которого необходимо
//                                                                   выполнить  отправку.
//  Письмо - ИнтернетПочтовоеСообщение - отправляемое письмо.
//
// Возвращаемое значение:
//  Структура - результат отправки письма:
//   * ОшибочныеПолучатели - Соответствие из КлючИЗначение - адреса получателей с ошибками:
//    ** Ключ     - Строка - адрес получателя;
//    ** Значение - Строка - текст ошибки.
//   * ИдентификаторПисьмаSMTP - Строка - уникальный идентификатор письма, присвоенный при отправке по протоколу SMTP.
//   * ИдентификаторПисьмаIMAP - Строка - уникальный идентификатор письма, присвоенный при отправке по протоколу IMAP.
//
Функция ОтправитьПисьмо(УчетнаяЗапись, Письмо) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
	
КонецФункции

// Выполняет отправку нескольких писем.
// Функция может вызвать исключение, которое требуется обработать.
// Если до наступления ошибки отправки было успешно отправлено хотя бы одно письмо, исключение не вызывается,
// поэтому при обработке результата функции необходимо проверять какие письма не были отправлены.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - почтовый ящик, с которого необходимо
//                                                                   выполнить  отправку.
//  Письма - Массив из ИнтернетПочтовоеСообщение - коллекция почтовых сообщений. Элемент коллекции - ИнтернетПочтовоеСообщение.
//  ТекстОшибки - Строка - сообщение об ошибке в случае, когда удалось отправить не все письма.
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение:
//   * Ключ     - ИнтернетПочтовоеСообщение - отправляемое письмо;
//   * Значение - Структура - результат отправки письма:
//    ** ОшибочныеПолучатели - Соответствие из КлючИЗначение - адреса получателей с ошибками:
//     *** Ключ     - Строка - адрес получателя;
//     *** Значение - Строка - текст ошибки.
//    ** ИдентификаторПисьмаSMTP - Строка - уникальный идентификатор письма, присвоенный при отправке по протоколу SMTP.
//    ** ИдентификаторПисьмаIMAP - Строка - уникальный идентификатор письма, присвоенный при отправке по протоколу IMAP.
//
Функция ОтправитьПисьма(УчетнаяЗапись, Письма, ТекстОшибки = Неопределено) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ОтправитьПисьма(УчетнаяЗапись, Письма, ТекстОшибки);
	
КонецФункции

// Формирует письмо по переданным параметрам.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - ссылка на
//                 учетную запись электронной почты.
//  ПараметрыПисьма - Структура - содержит всю необходимую информацию о письме:
//
//   * Кому - Массив
//          - Строка - интернет адреса получателей письма.
//          - Массив - коллекция структур адресов:
//              * Адрес         - Строка - почтовый адрес (должно быть обязательно заполнено).
//              * Представление - Строка - имя адресата.
//          - Строка - интернет-адреса получателей письма, разделитель - ";".
//
//   * ПолучателиСообщения - Массив - массив структур, описывающий получателей:
//      ** Адрес - Строка - почтовый адрес получателя сообщения.
//      ** Представление - Строка - представление адресата.
//
//   * Копии        - Массив
//                  - Строка - адреса получателей копий письма. См. описание поля Кому.
//
//   * СкрытыеКопии - Массив
//                  - Строка - адреса получателей скрытых копий письма. См. описание поля Кому.
//
//   * Тема       - Строка - (обязательный) тема почтового сообщения.
//   * Тело       - Строка - (обязательный) текст почтового сообщения (простой текст в кодировке win-1251).
//   * Важность   - ВажностьИнтернетПочтовогоСообщения
//
//   * Вложения - Массив - файлы, которые необходимо приложить к письму (описания в виде структур):
//     ** Представление - Строка - имя файла вложения;
//     ** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//     ** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//     ** Идентификатор - Строка - (необязательный) используется для отметки картинок, отображаемых в теле письма.
//
//   * АдресОтвета - Соответствие
//                 - Строка - см. описание поля Кому.
//   * ИдентификаторыОснований - Строка - идентификаторы оснований данного письма.
//   * ОбрабатыватьТексты  - Булево - необходимость обрабатывать тексты письма при отправке.
//   * УведомитьОДоставке  - Булево - необходимость запроса уведомления о доставке.
//   * УведомитьОПрочтении - Булево - необходимость запроса уведомления о прочтении.
//   * ТипТекста   - Строка
//                 - ПеречислениеСсылка.ТипыТекстовЭлектронныхПисем
//                 - ТипТекстаПочтовогоСообщения - определяет тип
//                  переданного теста допустимые значения:
//                  HTML/ТипыТекстовЭлектронныхПисем.HTML - текст почтового сообщения в формате HTML.
//                  ПростойТекст/ТипыТекстовЭлектронныхПисем.ПростойТекст - простой текст почтового сообщения.
//                                                 Отображается "как есть" (значение по
//                                                 умолчанию).
//                  РазмеченныйТекст/ТипыТекстовЭлектронныхПисем.РазмеченныйТекст - текст почтового сообщения в формате
//                                                 Rich Text.
//
// Возвращаемое значение:
//  ИнтернетПочтовоеСообщение - подготовленное письмо.
//
Функция ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма) Экспорт
	
	Если ТипЗнч(УчетнаяЗапись) <> Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты")
		Или НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Почта не указана или заполнена неправильно.'");
	КонецЕсли;
	
	Если ПараметрыПисьма = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не заданы параметры отправки.'");
	КонецЕсли;
	
	ТипЗнчКому = ?(ПараметрыПисьма.Свойство("Кому"), ТипЗнч(ПараметрыПисьма.Кому), Неопределено);
	ТипЗнчКопии = ?(ПараметрыПисьма.Свойство("Копии"), ТипЗнч(ПараметрыПисьма.Копии), Неопределено);
	СкрытыеКопии = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПисьма, "СкрытыеКопии");
	
	Если ТипЗнчКому = Неопределено И ТипЗнчКопии = Неопределено И СкрытыеКопии = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не указано ни одного получателя.'");
	КонецЕсли;
	
	Если ТипЗнчКому = Тип("Строка") Тогда
		ПараметрыПисьма.Кому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыПисьма.Кому);
	ИначеЕсли ТипЗнчКому <> Тип("Массив") Тогда
		ПараметрыПисьма.Вставить("Кому", Новый Массив);
	КонецЕсли;
	
	Если ТипЗнчКопии = Тип("Строка") Тогда
		ПараметрыПисьма.Копии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыПисьма.Копии);
	ИначеЕсли ТипЗнчКопии <> Тип("Массив") Тогда
		ПараметрыПисьма.Вставить("Копии", Новый Массив);
	КонецЕсли;
	
	Если ТипЗнч(СкрытыеКопии) = Тип("Строка") Тогда
		ПараметрыПисьма.СкрытыеКопии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СкрытыеКопии);
	ИначеЕсли ТипЗнч(СкрытыеКопии) <> Тип("Массив") Тогда
		ПараметрыПисьма.Вставить("СкрытыеКопии", Новый Массив);
	КонецЕсли;
	
	Если ПараметрыПисьма.Свойство("АдресОтвета") И ТипЗнч(ПараметрыПисьма.АдресОтвета) = Тип("Строка") Тогда
		ПараметрыПисьма.АдресОтвета = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыПисьма.АдресОтвета);
	КонецЕсли;
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

// Загружает сообщения с сервера для указанной почты.
// Предварительно проверяется корректность заполнения настроек почты.
// Функция может вызвать исключение, которое требуется обработать.
//
// Параметры:
//   УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - электронная почта, с которой загружаются письма.
//
//   ПараметрыЗагрузки - Структура:
//     * Колонки - Массив - массив строк названий колонок
//                          названия колонок должны соответствовать полям объекта
//                          ИнтернетПочтовоеСообщение.
//     * РежимТестирования - Булево - используется для проверки подключения к серверу.
//     * ПолучениеЗаголовков - Булево - если Истина, то в возвращаемом наборе есть только
//                                       заголовки писем.
//     * Отбор - Структура - соответствует параметру ПараметрыОтбора встроенной функции ИнтернетПочта.ПолучитьЗаголовки.
//     * ЗаголовкиИдентификаторы - Массив - заголовки или идентификаторы сообщений, полные
//                                    сообщения по которым требуется получить.
//     * ПриводитьСообщенияКТипу - Булево - возвращать набор полученных почтовых сообщений
//                                    в виде таблицы значений с простыми типами. По умолчанию Истина.
//
// Возвращаемое значение:
//  ТаблицаЗначений, Булево - список почтовых сообщений с колонками:
//   * Важность - ВажностьИнтернетПочтовогоСообщения
//   * Вложения - ИнтернетПочтовыеВложения - в случае если вложениями являются другие почтовые сообщения,
//                 они сами не возвращаются, но возвращаются их вложения - двоичные
//                 данные и их тексты в виде двоичных данных, рекурсивно.
//   * ДатаОтправления - Дата
//   * ДатаПолучения - Дата
//   * Заголовок - Строка
//   * ИмяОтправителя - Строка
//   * Идентификатор - Массив из Строка
//   * Копии - ИнтернетПочтовыеАдреса
//   * ОбратныйАдрес - ИнтернетПочтовыеАдреса
//   * Отправитель - Строка
//                 - ИнтернетПочтовыйАдрес
//   * Получатели - ИнтернетПочтовыеАдреса
//   * Размер - Число
//   * Тексты - ИнтернетТекстыПочтовогоСообщения
//   * Кодировка - Строка
//   * СпособКодированияНеASCIIСимволов - СпособКодированияНеASCIIСимволовИнтернетПочтовогоСообщения
//   * Частичное - Булево - заполняется если статус Истина. В режиме тестирования возвращается Истина.
//
Функция ЗагрузитьПочтовыеСообщения(Знач УчетнаяЗапись, Знач ПараметрыЗагрузки = Неопределено) Экспорт
	
	ИспользоватьДляПолучения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗапись, "ИспользоватьДляПолучения");
	Если НЕ ИспользоватьДляПолучения Тогда
		ВызватьИсключение НСтр("ru = 'Почта не предназначена для получения сообщений.'");
	КонецЕсли;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ПараметрыЗагрузки = Новый Структура;
	КонецЕсли;
	
	Результат = РаботаСПочтовымиСообщениямиСлужебный.ЗагрузитьСообщения(УчетнаяЗапись, ПараметрыЗагрузки);
	Возврат Результат;
	
КонецФункции

// Получить доступные учетные записи электронной почты.
//
//  Параметры:
//   ДляОтправки  - Булево - выбирать только учетные записи, настроенные для отправки почты.
//   ДляПолучения - Булево - выбирать только учетные записи, настроенные на получение почты.
//   ВключатьСистемнуюУчетнуюЗапись - Булево - включать системную учетную запись, если настроена для отправки/получения.
//
// Возвращаемое значение:
//  ТаблицаЗначений - описание учетных записей:
//   * Ссылка       - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись;
//   * Наименование - Строка - наименование почты;
//   * Адрес        - Строка - адрес электронной почты.
//
Функция ДоступныеУчетныеЗаписи(Знач ДляОтправки = Неопределено,
								Знач ДляПолучения  = Неопределено,
								Знач ВключатьСистемнуюУчетнуюЗапись = Истина) Экспорт
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка,
	|	УчетныеЗаписиЭлектроннойПочты.Наименование КАК Наименование,
	|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты КАК Адрес,
	|	ВЫБОР
	|		КОГДА УчетныеЗаписиЭлектроннойПочты.Ссылка = ЗНАЧЕНИЕ(Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И ВЫБОР
	|			КОГДА &ДляОтправки = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = &ДляОтправки
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ДляПолучения = НЕОПРЕДЕЛЕНО
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = &ДляПолучения
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ВключатьСистемнуюУчетнуюЗапись
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ УчетныеЗаписиЭлектроннойПочты.Ссылка <> ЗНАЧЕНИЕ(Справочник.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты)
	|		КОНЕЦ
	|	И УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты <> """"
	|	И ВЫБОР
	|			КОГДА УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения
	|				ТОГДА УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты <> """"
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки
	|				ТОГДА УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты <> """"
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И (УчетныеЗаписиЭлектроннойПочты.ВладелецУчетнойЗаписи = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|			ИЛИ УчетныеЗаписиЭлектроннойПочты.ВладелецУчетнойЗаписи = &ТекущийПользователь)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("ДляОтправки", ДляОтправки);
	Запрос.Параметры.Вставить("ДляПолучения", ДляПолучения);
	Запрос.Параметры.Вставить("ВключатьСистемнуюУчетнуюЗапись", ВключатьСистемнуюУчетнуюЗапись);
	Запрос.Параметры.Вставить("ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Получает настройки почты для рассылки различных уведомлений из программы.
//
// Возвращаемое значение:
//  СправочникСсылка.УчетныеЗаписиЭлектроннойПочты
//
Функция СистемнаяУчетнаяЗапись() Экспорт
	
	Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
КонецФункции

// Проверяет, что почта для рассылки различных уведомлений доступна (может быть использована).
//
// Возвращаемое значение:
//  Булево
//
Функция ПроверитьСистемнаяУчетнаяЗаписьДоступна() Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ПроверитьСистемнаяУчетнаяЗаписьДоступна();
	
КонецФункции

// Возвращает Истина, если доступна по меньшей мере одна настроенная учетная запись для отправки почты
// либо достаточно прав на настройку почты.
//
// Возвращаемое значение:
//  Булево
//
Функция ДоступнаОтправкаПисем() Экспорт
	
	Если ПравоДоступа("Изменение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.УчетныеЗаписиЭлектроннойПочты) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	1 КАК Количество
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки
	|	И УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты <> """"
	|	И (УчетныеЗаписиЭлектроннойПочты.ВладелецУчетнойЗаписи = ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|			ИЛИ УчетныеЗаписиЭлектроннойПочты.ВладелецУчетнойЗаписи = &ТекущийПользователь)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.Параметры.Вставить("ТекущийПользователь", Пользователи.ТекущийПользователь());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Следующий();
	
КонецФункции

// Проверяет, настроена ли учетная запись для отправки и/или получения почты.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - проверяемая учетная запись;
//  ДляОтправки  - Булево - проверять параметры, необходимые для отправки почты;
//  ДляПолучения - Булево - проверять параметры, необходимые для получения почты.
// 
// Возвращаемое значение:
//  Булево - Истина, если настроена.
//
Функция УчетнаяЗаписьНастроена(УчетнаяЗапись, Знач ДляОтправки = Неопределено, Знач ДляПолучения = Неопределено) Экспорт
	
	Параметры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, "АдресЭлектроннойПочты,СерверВходящейПочты,СерверИсходящейПочты,ИспользоватьДляПолучения,ИспользоватьДляОтправки,ПротоколВходящейПочты");
	Если ДляОтправки = Неопределено Тогда
		ДляОтправки = Параметры.ИспользоватьДляОтправки;
	КонецЕсли;
	Если ДляПолучения = Неопределено Тогда
		ДляПолучения = Параметры.ИспользоватьДляПолучения;
	КонецЕсли;
	
	Возврат Не (ПустаяСтрока(Параметры.АдресЭлектроннойПочты) 
		Или ДляПолучения И ПустаяСтрока(Параметры.СерверВходящейПочты)
		Или ДляОтправки И (ПустаяСтрока(Параметры.СерверИсходящейПочты)
			Или (Параметры.ПротоколВходящейПочты = "IMAP" И ПустаяСтрока(Параметры.СерверВходящейПочты))));
		
КонецФункции

// Выполняет проверку настроек электронной почты.
//
// Параметры:
//  УчетнаяЗапись     - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - проверяемая почта.
//  СообщениеОбОшибке - Строка - текст сообщения об ошибке либо пустая строка, если ошибок не было.
//  ДополнительноеСообщение - Строка - сообщения о том, какие проверки были выполнены для почты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, СообщениеОбОшибке, ДополнительноеСообщение) Экспорт
	
	РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, 
		СообщениеОбОшибке, ДополнительноеСообщение);
	
КонецПроцедуры

// Проверяет наличие в документе HTML ссылок на ресурсы, загружаемые по http(s).
//
// Параметры:
//  ДокументHTML - ДокументHTML - документ HTML, в котором необходимо выполнить проверку.
//
// Возвращаемое значение:
//  Булево - Истина, если в документе HTML есть внешние ресурсы.
//
Функция ЕстьВнешниеРесурсы(ДокументHTML) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ЕстьВнешниеРесурсы(ДокументHTML);
	
КонецФункции

// Удаляет из документа HTML скрипты, обработчики событий, а также очищает ссылки на ресурсы, загружаемые по http(s).
//
// Параметры:
//  ДокументHTML - ДокументHTML - документ HTML, в котором необходимо очистить небезопасное содержимое.
//  ОтключитьВнешниеРесурсы - Булево - признак необходимости очистки ссылок на ресурсы, загружаемые по http(s).
// 
Процедура ОтключитьНебезопасноеСодержимое(ДокументHTML, ОтключитьВнешниеРесурсы = Истина) Экспорт
	
	РаботаСПочтовымиСообщениямиСлужебный.ОтключитьНебезопасноеСодержимое(ДокументHTML, ОтключитьВнешниеРесурсы);
	
КонецПроцедуры

// Получает с сайта ИТС рекомендации по устранению ошибки подключения к почтовому серверу.
// 
// Параметры:
//   ТекстОшибки - Строка - исходный текст ошибки.
// 	
// Возвращаемое значение:
//  Структура:
//   * ВозможныеПричины - Массив из ФорматированнаяСтрока
//   * СпособыУстранения - Массив из ФорматированнаяСтрока
//
Функция ПоясненияПоОшибке(ТекстОшибки) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.ПоясненияПоОшибке(ТекстОшибки);
	
КонецФункции

// Подготавливает расширенное описание ошибки подключения к почтовому серверу.
// 
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке
//  КодЯзыка - Строка - код языка реквизита. Например, "ru".
//  ВключитьПодробноеПредставлениеОшибки - Булево - добавляет в текст ошибки стек.
//  
// Возвращаемое значение:
//  Строка
//
Функция РасширенноеПредставлениеОшибки(ИнформацияОбОшибке, КодЯзыка, ВключитьПодробноеПредставлениеОшибки = Истина) Экспорт
	
	Возврат РаботаСПочтовымиСообщениямиСлужебный.РасширенноеПредставлениеОшибки(
		ИнформацияОбОшибке, КодЯзыка, ВключитьПодробноеПредставлениеОшибки);
	
КонецФункции

// Возвращает список имен полей объекта ИнтернетПочтовоеСообщение.
//
// Возвращаемое значение:
//  Структура:
//    * АдресаУведомленияОДоставке - Строка
//    * АдресаУведомленияОПрочтении - Строка
//    * Важность - Строка
//    * Вложения - Строка
//    * ДатаОтправления - Строка
//    * ДатаПолучения - Строка
//    * Заголовок - Строка
//    * Идентификатор - Строка
//    * ИдентификаторСообщения - Строка
//    * ИмяОтправителя - Строка
//    * Категории - Строка
//    * Кодировка - Строка
//    * Копии - Строка
//    * ОбратныйАдрес - Строка
//    * Отправитель - Строка
//    * Получатели - Строка
//    * Размер - Строка
//    * СлепыеКопии - Строка
//    * СмещениеДатыОтправления - Строка
//    * СтатусРазбора - Строка
//    * Тема - Строка
//    * Тексты - Строка
//    * СпособКодированияНеASCIIСимволов - Строка
//    * УведомитьОДоставке - Строка
//    * УведомитьОПрочтении - Строка
//    * Частичное - Строка
//
Функция ПоляИнтернетПочтовогоСообщения() Экспорт
	
	ПоляСообщения = Новый Структура;

	ПоляСообщения.Вставить("АдресаУведомленияОДоставке", "АдресаУведомленияОДоставке"); 
	ПоляСообщения.Вставить("АдресаУведомленияОПрочтении", "АдресаУведомленияОПрочтении");
	ПоляСообщения.Вставить("Важность", "Важность");
	ПоляСообщения.Вставить("Вложения", "Вложения");
	ПоляСообщения.Вставить("ДатаОтправления", "ДатаОтправления");
	ПоляСообщения.Вставить("ДатаПолучения", "ДатаПолучения");
	ПоляСообщения.Вставить("Заголовок", "Заголовок");
	ПоляСообщения.Вставить("ИмяОтправителя", "ИмяОтправителя");
	ПоляСообщения.Вставить("Идентификатор", "Идентификатор");
	ПоляСообщения.Вставить("ИдентификаторСообщения", "ИдентификаторСообщения");
	ПоляСообщения.Вставить("Категории", "Категории");
	ПоляСообщения.Вставить("Кодировка", "Кодировка");
	ПоляСообщения.Вставить("Копии", "Копии");
	ПоляСообщения.Вставить("ОбратныйАдрес", "ОбратныйАдрес");
	ПоляСообщения.Вставить("Отправитель", "Отправитель");
	ПоляСообщения.Вставить("Получатели", "Получатели");
	ПоляСообщения.Вставить("Размер", "Размер");
	ПоляСообщения.Вставить("СлепыеКопии", "СлепыеКопии");
	ПоляСообщения.Вставить("СмещениеДатыОтправления", "СмещениеДатыОтправления");
	ПоляСообщения.Вставить("СтатусРазбора", "СтатусРазбора");
	ПоляСообщения.Вставить("Тема", "Тема");
	ПоляСообщения.Вставить("Тексты", "Тексты");
	ПоляСообщения.Вставить("СпособКодированияНеASCIIСимволов", "СпособКодированияНеASCIIСимволов");
	ПоляСообщения.Вставить("УведомитьОДоставке", "УведомитьОДоставке");
	ПоляСообщения.Вставить("УведомитьОПрочтении", "УведомитьОПрочтении");
	ПоляСообщения.Вставить("Частичное", "Частичное");
	
	Возврат ПоляСообщения;
	
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Выполняет отправку почтовых сообщений.
// Функция может вызвать исключение, которое требуется обработать.
//
// Параметры:
//  УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - ссылка на
//                 учетную запись электронной почты.
//  ПараметрыОтправки - Структура - содержит всю необходимую информацию о письме:
//
//   * Кому - Массив
//          - Строка - интернет адреса получателей письма.
//          - Массив - коллекция структур адресов:
//              * Адрес         - Строка - почтовый адрес (должно быть обязательно заполнено).
//              * Представление - Строка - имя адресата.
//          - Строка - интернет-адреса получателей письма, разделитель - ";".
//
//   * ПолучателиСообщения - Массив - массив структур, описывающий получателей:
//      ** Адрес - Строка - почтовый адрес получателя сообщения.
//      ** Представление - Строка - представление адресата.
//
//   * Копии        - Массив
//                  - Строка - адреса получателей копий письма. См. описание поля Кому.
//
//   * СкрытыеКопии - Массив
//                  - Строка - адреса получателей скрытых копий письма. См. описание поля Кому.
//
//   * Тема       - Строка - (обязательный) тема почтового сообщения.
//   * Тело       - Строка - (обязательный) текст почтового сообщения (простой текст в кодировке win-1251).
//   * Важность   - ВажностьИнтернетПочтовогоСообщения
//
//   * Вложения - Массив - файлы, которые необходимо приложить к письму (описания в виде структур):
//     ** Представление - Строка - имя файла вложения;
//     ** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//     ** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//     ** Идентификатор - Строка - (необязательный) используется для отметки картинок, отображаемых в теле письма.
//
//   * АдресОтвета - Соответствие
//                 - Строка - см. описание поля Кому.
//   * ИдентификаторОснования  - Строка - идентификатор основания данного письма.
//   * ИдентификаторыОснований - Строка - идентификаторы оснований данного письма.
//   * ОбрабатыватьТексты  - Булево - необходимость обрабатывать тексты письма при отправке.
//   * УведомитьОДоставке  - Булево - необходимость запроса уведомления о доставке.
//   * УведомитьОПрочтении - Булево - необходимость запроса уведомления о прочтении.
//   * ТипТекста   - Строка
//                 - ПеречислениеСсылка.ТипыТекстовЭлектронныхПисем
//                 - ТипТекстаПочтовогоСообщения - определяет тип
//                  переданного теста допустимые значения:
//                  HTML/ТипыТекстовЭлектронныхПисем.HTML - текст почтового сообщения в формате HTML.
//                  ПростойТекст/ТипыТекстовЭлектронныхПисем.ПростойТекст - простой текст почтового сообщения.
//                                                 Отображается "как есть" (значение по
//                                                 умолчанию).
//                  РазмеченныйТекст/ТипыТекстовЭлектронныхПисем.РазмеченныйТекст - текст почтового сообщения в формате
//                                                 Rich Text.
//   * Соединение - ИнтернетПочта - существующее соединение с почтовым сервером. Если не указано, то создается новое.
//   * ПротоколПочты - Строка - если указано значение "IMAP", то письмо будет передано по протоколу IMAP, если по
//                              указано значение "Все", то по протоколу SMTP и по протоколу IMAP, если ничего не указано
//                              то по протоколу SMTP. Параметр имеет смысл, только наличии действующего соединения,
//                              указанного в параметр Соединение. В противном случае протокол будет определен
//                              автоматически при установке соединения.
//   * ИдентификаторСообщения - Строка - (возвращаемый параметр) идентификатор отправленного почтового сообщения на SMTP-сервере;
//   * ИдентификаторСообщенияОтправкаIMAP - Строка - (возвращаемый параметр) идентификатор отправленного почтового
//                                         сообщения на IMAP сервере;
//   * ОшибочныеПолучатели - Соответствие - (возвращаемый параметр) список адресов, по которым отправка не выполнена. 
//                                          См. возвращаемое значение метода ИнтернетПочта.Послать() в синтакс-помощнике.
//
//  УдалитьСоединение - ИнтернетПочта - параметр устарел, см. параметр ПараметрыОтправки.Соединение.
//  УдалитьПротоколПочты - Строка     - параметр устарел, см. параметр ПараметрыОтправки.ПротоколПочты.
//
// Возвращаемое значение:
//  Строка - идентификатор отправленного сообщения.
//
Функция ОтправитьПочтовоеСообщение(Знач УчетнаяЗапись, Знач ПараметрыОтправки,
	Знач УдалитьСоединение = Неопределено, УдалитьПротоколПочты = "") Экспорт
	
	Если УдалитьСоединение <> Неопределено Тогда
		ПараметрыОтправки.Вставить("Соединение", УдалитьСоединение);
	КонецЕсли;
	
	Если Не ПустаяСтрока(УдалитьПротоколПочты) Тогда
		ПараметрыОтправки.Вставить("ПротоколПочты", УдалитьПротоколПочты);
	КонецЕсли;
	
	Если ТипЗнч(УчетнаяЗапись) <> Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты")
		Или НЕ ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ВызватьИсключение НСтр("ru = 'Почта не указана или заполнена неправильно.'");
	КонецЕсли;
	
	Если ПараметрыОтправки = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не заданы параметры отправки.'");
	КонецЕсли;
	
	ТипЗнчКому = ?(ПараметрыОтправки.Свойство("Кому"), ТипЗнч(ПараметрыОтправки.Кому), Неопределено);
	ТипЗнчКопии = ?(ПараметрыОтправки.Свойство("Копии"), ТипЗнч(ПараметрыОтправки.Копии), Неопределено);
	СкрытыеКопии = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтправки, "СкрытыеКопии");
	
	Если ТипЗнчКому = Неопределено И ТипЗнчКопии = Неопределено И СкрытыеКопии = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Не указано ни одного получателя.'");
	КонецЕсли;
	
	Если ТипЗнчКому = Тип("Строка") Тогда
		ПараметрыОтправки.Кому = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыОтправки.Кому);
	ИначеЕсли ТипЗнчКому <> Тип("Массив") Тогда
		ПараметрыОтправки.Вставить("Кому", Новый Массив);
	КонецЕсли;
	
	Если ТипЗнчКопии = Тип("Строка") Тогда
		ПараметрыОтправки.Копии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыОтправки.Копии);
	ИначеЕсли ТипЗнчКопии <> Тип("Массив") Тогда
		ПараметрыОтправки.Вставить("Копии", Новый Массив);
	КонецЕсли;
	
	Если ТипЗнч(СкрытыеКопии) = Тип("Строка") Тогда
		ПараметрыОтправки.СкрытыеКопии = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(СкрытыеКопии);
	ИначеЕсли ТипЗнч(СкрытыеКопии) <> Тип("Массив") Тогда
		ПараметрыОтправки.Вставить("СкрытыеКопии", Новый Массив);
	КонецЕсли;
	
	Если ПараметрыОтправки.Свойство("АдресОтвета") И ТипЗнч(ПараметрыОтправки.АдресОтвета) = Тип("Строка") Тогда
		ПараметрыОтправки.АдресОтвета = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПараметрыОтправки.АдресОтвета);
	КонецЕсли;
	
	РаботаСПочтовымиСообщениямиСлужебный.ОтправитьСообщение(УчетнаяЗапись, ПараметрыОтправки);
	РаботаСПочтовымиСообщениямиПереопределяемый.ПослеОтправкиПисьма(ПараметрыОтправки);
	
	Если ПараметрыОтправки.ОшибочныеПолучатели.Количество() > 0 Тогда
		ТекстОшибки = НСтр("ru = 'Следующие почтовые адреса не были приняты почтовым сервером:'");
		Для Каждого ОшибочныйПолучатель Из ПараметрыОтправки.ОшибочныеПолучатели Цикл
			ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1: %2",
				ОшибочныйПолучатель.Ключ, ОшибочныйПолучатель.Значение);
		КонецЦикла;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Возврат ПараметрыОтправки.ИдентификаторСообщения;
	
КонецФункции

#КонецОбласти

#КонецОбласти
