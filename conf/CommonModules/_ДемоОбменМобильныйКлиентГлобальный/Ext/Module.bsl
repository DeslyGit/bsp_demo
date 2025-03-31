﻿#Область СлужебныйПрограммныйИнтерфейс

// Процедура осуществляет запуск обмена данными с заданным интервалом
//
Процедура ЗапуститьСинхронизацию() Экспорт

#Если МобильныйКлиент Тогда
	Если ОсновнойСерверДоступен() = Истина Тогда
		_ДемоОбменМобильныйКлиентАвтономныйКлиент.НачатьСинхронизацию();
	КонецЕсли;
#КонецЕсли

КонецПроцедуры

#Если МобильныйКлиент Тогда

// Процедура проверяет завершение синхронизации основного и автономного сервере с оповещением пользователя о завершении.
//
Процедура ОжидатьЗавершениеСинхронизации() Экспорт
	
	ТекстОшибки = "";
	ИдентификаторФоновогоЗадания = _ДемоОбменМобильныйКлиентКлиент.ИдентификаторФоновогоЗадания();
	Если _ДемоОбменМобильныйКлиентАвтономныйВызовСервера.ОбменДаннымиЗакончен(ИдентификаторФоновогоЗадания, ТекстОшибки) Тогда
		ОтключитьОбработчикОжидания("ОжидатьЗавершениеСинхронизации");
		Если  ТекстОшибки <> "" Тогда
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстОшибки;
			Сообщение.Сообщить();
		Иначе
			Если ОсновнойСерверДоступен() = Истина Тогда
				_ДемоОбменМобильныйКлиентКлиент.ОповеститьОЗавершении();
			КонецЕсли
		КонецЕсли
	КонецЕсли
	
КонецПроцедуры
#КонецЕсли

#КонецОбласти