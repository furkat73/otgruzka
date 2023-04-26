﻿
&НаКлиенте
Процедура ПечатьШК(Команда)
	масСтрок=Элементы.Список.ВыделенныеСтроки;
	
	
	//Для Каждого эл_масСтрок Из масСтрок Цикл
	//	ШК= эл_масСтрок.Штрихкод;
	//	ФИО=эл_масСтрок.Наименование;
	//	//Сообщить(эл_масСтрок.Штрихкод);	
	//	
	//КонецЦикла;
	
	Если масСтрок.Количество()=0 Тогда
		Сообщить("Ничего не Выбрано.");
		Возврат;	
	КонецЕсли;
	
	Попытка
		ТабличныйДокумент = ПечатнаяФорма(масСтрок);
	Исключение
	КонецПопытки;
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ТабличныйДокумент.Показать();
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция  ПечатнаяФорма(масСтрок) 
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
	
	//Макет = Обработки.ПроизвольнаяПечатьШК.ПолучитьМакет("Макет");
	Макет=Справочники.ФизическиеЛица.ПолучитьМакет("Макет");
	Область1 = Макет.ПолучитьОбласть("Шапка");
	
	Для Каждого эл_масСтрок Из масСтрок Цикл
		Если эл_масСтрок.ЭтоГруппа Тогда
			Продолжить;	
		КонецЕсли;
		
		ШК= эл_масСтрок.Штрихкод;
		ФИО=эл_масСтрок.Наименование;
		//Сообщить(эл_масСтрок.Штрихкод);	
		Область1.Параметры.ПроизвольныйТекст = ФИО;
		КартинкаШтрихкода = ОбщийМодуль_Каштан.ПолучитьКартинкуШтрихкода(ШК, 100, 90);
		Рисунок = Область1.Область("ШК1");
		Рисунок.Картинка = КартинкаШтрихкода;
		ТабличныйДокумент.Вывести(Область1);
		Если ПечатьРаздельно Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
	КонецЦикла;	
	Возврат ТабличныйДокумент;
	
КонецФункции	
