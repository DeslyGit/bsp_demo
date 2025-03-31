﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает значение перечисления по имени значения.
//
// Параметры:
//  ИмяЗначения	- Строка - имя значения, как оно передается через API
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.РолиПользователейАбонентов - значение перечисления по имени.
//
Функция ЗначениеПоИмени(ИмяЗначения) Экспорт
    
    Если ИмяЗначения = "owner" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ВладелецАбонента");
    ИначеЕсли ИмяЗначения = "administrator" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.АдминистраторАбонента");
    ИначеЕсли ИмяЗначения = "operator" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ОператорОбслуживающейОрганизации");
    ИначеЕсли ИмяЗначения = "user" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ПользовательАбонента");
    Иначе
        Возврат ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ПустаяСсылка");
    КонецЕсли; 
    
КонецФункции

// Возвращает имя значения для API по значению перечисления.
//
// Параметры:
//  Значение - ПеречислениеСсылка.ПраваПользователяПриложения - значение перечисления для получения имени значения для API
// 
// Возвращаемое значение:
//  Строка - имя значения для API
//
Функция ИмяПоЗначению(Значение) Экспорт
	
    Если Значение = ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ВладелецАбонента") Тогда
        Возврат "owner";
    ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.АдминистраторАбонента") Тогда
        Возврат "administrator";
    ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ОператорОбслуживающейОрганизации") Тогда
        Возврат "operator";
    ИначеЕсли Значение = ПредопределенноеЗначение("Перечисление.РолиПользователейАбонентов.ПользовательАбонента") Тогда
        Возврат "user";
    Иначе 
        Возврат Неопределено;
    КонецЕсли; 
	
КонецФункции

#КонецОбласти

#КонецЕсли