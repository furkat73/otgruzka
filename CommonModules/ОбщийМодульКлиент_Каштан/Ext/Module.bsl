﻿Функция СтрокаТоварыПриИзменении(Строка, Изменяю = "ТоварыКоличество", Таблица = "Товары" ) Экспорт
	Если Строка.Свойство("Количество") и Строка.Свойство("Цена") и Строка.Свойство("Сумма") Тогда
		Если Изменяю = Таблица+"Количество" или Изменяю = Таблица+"Цена" тогда
		    Строка.Сумма = Строка.Количество * Строка.Цена;
		ИначеЕсли Изменяю = Таблица+"Сумма"	тогда
		    Если  Строка.Количество <> 0 тогда 
		    	Строка.Цена = Строка.Сумма / Строка.Количество;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Строка.Свойство("ПроцентСкидки") и Строка.Свойство("СуммаСкидки") и Строка.Свойство("Сумма") тогда 
		Если Изменяю = Таблица+"Количество" или Изменяю = Таблица+"Цена" или Изменяю = Таблица+"ПроцентСкидки" или Изменяю = Таблица+"Сумма" тогда
	        Строка.СуммаСкидки = Строка.Сумма * Строка.ПроцентСкидки / 100;
		ИначеЕсли Изменяю = Таблица+"СуммаСкидки" тогда
			Если Строка.Сумма<>0 тогда
				Строка.ПроцентСкидки = Строка.СуммаСкидки*100 / Строка.Сумма ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Строка.Свойство("РучнаяСкидка") и Строка.Свойство("СуммаСкидки") и Строка.Свойство("Сумма") тогда 
		Если Изменяю = Таблица+"Количество" или Изменяю = Таблица+"Цена" или Изменяю = Таблица+"РучнаяСкидка" или Изменяю = Таблица+"Сумма" тогда
	    Строка.СуммаСкидки = Строка.Количество*Окр(Строка.Цена*Строка.РучнаяСкидка/100,2);//Строка.Сумма * Строка.РучнаяСкидка / 100;
		ИначеЕсли Изменяю = Таблица+"СуммаСкидки" тогда
			Если Строка.Сумма<>0 тогда
				Строка.РучнаяСкидка = Строка.СуммаСкидки*100 / Строка.Сумма ;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Строка.Свойство("РучнаяСкидка") и Строка.Свойство("АвтоматическаяСкидка") и Строка.Свойство("СуммаСкидки") и Строка.Свойство("Сумма") тогда 
		Если Изменяю = Таблица+"АвтоматическаяСкидка" или Изменяю = Таблица+"Цена" или Изменяю = Таблица+"Сумма" тогда
			
		Если (Строка.Свойство("ОграничениеСкидки") и Строка.ОграничениеСкидки <> 0) и Строка.Сумма * Строка.АвтоматическаяСкидка / 100 > Строка.ОграничениеСкидки тогда
			Строка.СуммаСкидки = Строка.Сумма * Строка.РучнаяСкидка / 100 + Строка.ОграничениеСкидки;
		Иначе	
			Строка.СуммаСкидки = Строка.Сумма * Строка.РучнаяСкидка / 100 + Строка.Сумма * Строка.АвтоматическаяСкидка / 100;
		КонецЕсли;
			
		ИначеЕсли Изменяю = Таблица+"СуммаСкидки" тогда
			Если Строка.Сумма<>0 тогда
				Если (Строка.Свойство("ОграничениеСкидки") и Строка.ОграничениеСкидки <> 0) и Строка.Сумма * Строка.АвтоматическаяСкидка / 100 > Строка.ОграничениеСкидки тогда
					Строка.РучнаяСкидка = (Строка.СуммаСкидки - Строка.ОграничениеСкидки)*100 / Строка.Сумма ;
				Иначе	
					Строка.РучнаяСкидка = Строка.СуммаСкидки*100 / Строка.Сумма - Строка.АвтоматическаяСкидка;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если Строка.Свойство("СуммаВсего") и Строка.Свойство("СуммаСкидки") и Строка.Свойство("Сумма") тогда
		Попытка
			Строка.СуммаВсего = Строка.Количество*Окр(Строка.Цена - Строка.Цена*Строка.РучнаяСкидка/100 - Строка.Цена*Строка.АвтоматическаяСкидка/100,2);//Строка.Сумма - Строка.СуммаСкидки;
		Исключение
			Строка.СуммаВсего = Строка.Сумма - Строка.СуммаСкидки;
		КонецПопытки;
	КонецЕсли;
			
КонецФункции
	
Функция ПолучитьРеквизитОбъекта(Объект, НаименованиеРеквизита) Экспорт
        Возврат ОбщийМодуль_Каштан.ПолучитьРеквизитОбъекта(Объект, НаименованиеРеквизита);
КонецФункции

Функция ПолучитьЕдИзм(Номенклатура) Экспорт
        Возврат ОбщийМодуль_Каштан.ПолучитьРеквизитОбъекта(Номенклатура, "БазоваяЕдиницаИзмерения");
КонецФункции

Функция ПолучитьСериюНоменклатуры(СерияНоменклатуры) Экспорт 
	    СтруктураСерии = Новый Структура;
		СтруктураСерии.Вставить("НомерСерии","НомерСерии");
		СтруктураСерии.Вставить("СрокГодности","СрокГодности");
		СтруктураСерии.Вставить("НомерСертификата","НомерСертификата");
		СтруктураСерии.Вставить("ДатаСертификата","ДатаСертификата");
		СтруктураСерии.Вставить("СканСертификата","СканСертификата");
		СтруктураСерии.Вставить("СкладскаяЕдиницаИзмерения","СкладскаяЕдиницаИзмерения");
		//СтруктураСерии.Вставить("Производитель","Производитель");		
		//СтруктураСерии.Вставить("ЦенаБазовая","ЦенаБазовая"); 		
		//СтруктураСерии.Вставить("ШтрихКодУпаковки","ШтрихКодУпаковки");
	    Возврат ОбщийМодуль_Каштан.ПолучитьСтруктуруОбъекта(СерияНоменклатуры, СтруктураСерии);
КонецФункции

Функция ПолучитьЦену(Дата, ТипЦен, Номенклатура, ДокументПоступления, Валюта) Экспорт
	Если ЗначениеЗаполнено(ТипЦен) и ЗначениеЗаполнено(Номенклатура) и ЗначениеЗаполнено(ДокументПоступления) и	ЗначениеЗаполнено(Валюта) тогда
		Возврат ОбщийМодуль_Каштан.ПолучитьЦену(Дата, ТипЦен, Номенклатура, ДокументПоступления, Валюта);
	КонецЕсли;		
КонецФункции

Функция НайтиИОткрытьДокументПоШК(ШК) Экспорт 
	Если СтрДлина(ШК)<>13 тогда
		Возврат Ложь;
	КонецЕсли;
	КоличествоИзменений = Лев(ШК, 2);
	КодДокумента = ОбщийМодуль_Каштан.ПолучитьНомерДокументаПоШК(ШК);
	Если КодДокумента = Неопределено тогда
		Возврат Ложь;
	КонецЕсли;
	ВидДокумента = ОбщийМодуль_Каштан.ПолучитьВидДокументаПоШК(ШК);
	Если ВидДокумента = Неопределено или ПустаяСтрока(ВидДокумента) тогда
		Возврат Ложь;
	КонецЕсли;
	МассивДок = ОбщийМодуль_Каштан.НайтиДокумент(ВидДокумента, КодДокумента);
	Если МассивДок.Количество() > 1 тогда
		ФормаВыбораДокументов = ПолучитьФорму("ОбщаяФорма.ФормаВыбораДокумента", Новый Структура("МассивДокументов, ВидДокумента", МассивДок, ВидДокумента));
		ПорНомерДок = ФормаВыбораДокументов.ОткрытьМодально()-1;
		Если ПорНомерДок >=0 тогда
			Док = МассивДок[ПорНомерДок];
		КонецЕсли;
	ИначеЕсли МассивДок.Количество() = 1 тогда
		Док = МассивДок[0];
	Иначе
		Док = Неопределено
	КонецЕсли;
	
	Если Док = Неопределено тогда
		Возврат Ложь;
	КонецЕсли;	
	ТекущееЗначениеКоличестваИзменений = ОбщийМодуль_Каштан.ПолучитьРеквизитОбъекта(Док, "СчетчикИзменений");
	ОткрытьЗначение(Док);
	Если ТекущееЗначениеКоличестваИзменений <> Число(КоличествоИзменений) тогда
   		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Данные печатной формы могут не соответствовать данным документа!", Док);
    КонецЕсли;
	
	Возврат Истина;

КонецФункции

Процедура СохранитьОтборСпискаФормы(Форма) Экспорт
    ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("СохраненныйОтбор",    Форма.Список.Отбор);
	РаботаСФайлами.ХранилищеОбщихНастроекСохранить(Форма.ИмяФормы, , ПараметрыЗакрытия);

КонецПроцедуры

Процедура ХранилищеОбщихНастроекСохранить(Объект, Настройка, Значение) Экспорт
	//ХранилищеОбщихНастроек.Сохранить(Объект, Настройка, Значение);
КонецПроцедуры

