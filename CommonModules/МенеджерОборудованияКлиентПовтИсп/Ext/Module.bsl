﻿
// Функция возвращает список подключенного в справочнике ПО
//
Функция ПолучитьСписокОборудования(ТипыПО = Неопределено, Идентификатор = Неопределено, РабочееМесто = Неопределено) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьСписокОборудования(ТипыПО, Идентификатор, РабочееМесто);

КонецФункции

// Возвращает структуру параметров конкретного экземпляра устройства
// При первом обращении получает из БД сохраненные ранее параметры.
Функция ПолучитьПараметрыУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьПараметрыУстройства(Идентификатор);

КонецФункции

// Функция возвращает структуру с данными устройства
//(со значениями реквизитов элемента справочника)
Функция ПолучитьДанныеУстройства(Идентификатор) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьДанныеУстройства(Идентификатор);

КонецФункции

// Возвращает имя формы настройки обработчика драйвера
// При первом обращении возвращает сформированное на сервере имя
Функция ПолучитьИмяФормыНастройкиПараметров(НаименованиеОбработчикаДрайвера) Экспорт

	НаименованиеФормыНастройки = 
	    СтрЗаменить(МенеджерОборудованияСервер.ПолучитьИмяДрайвераЭкземпляра(НаименованиеОбработчикаДрайвера),
	                "Обработчик",
	                "ФормаНастройки");

	Возврат НаименованиеФормыНастройки;

КонецФункции

// Возвращает имя компьютера клиента
// При первом обращении получает имя компьютера из переменной сеанса
Функция ПолучитьРабочееМестоКлиента() Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьРабочееМестоКлиента();

КонецФункции

// Возвращает имя компьютера клиента
// При первом обращении получает имя компьютера из переменной сеанса
Функция НайтиРабочиеМестаПоИД(ИдентификаторКлиента) Экспорт

	Возврат МенеджерОборудованияСервер.НайтиРабочиеМестаПоИД(ИдентификаторКлиента);

КонецФункции

// Возвращает макет слип чека по наименованию макета
//
Функция ПолучитьСлипЧек(ИмяМакета, ШиринаСлипЧека, Параметры) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьСлипЧек(ИмяМакета, ШиринаСлипЧека, Параметры);

КонецФункции

// Функция возвращает имя перечисления из его метаданных
Функция ПолучитьИмяТипаОборудования(ТипОборудования) Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьИмяТипаОборудования(ТипОборудования);

КонецФункции

Функция ПолучитьПользовательскиеНастройкиПодключаемогоОборудования() Экспорт

	Возврат МенеджерОборудованияСервер.ПолучитьПользовательскиеНастройкиПодключаемогоОборудования();

КонецФункции

Функция СохранитьПользовательскиеНастройкиПодключаемогоОборудования(СписокНастроек) Экспорт

	МенеджерОборудованияСервер.СохранитьПользовательскиеНастройкиПодключаемогоОборудования(СписокНастроек);

КонецФункции