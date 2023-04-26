﻿
&НаКлиенте
Процедура РазобратьКомплект(Команда)
	Если Вопрос("Разобрать комплекты?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда	
	Возврат;
КонецЕсли;

	
	ДокКомплект=Элементы.Список.ТекущиеДанные.Ссылка;
	Если ДокКомплект.ЭтоКомплект Тогда
		Рез=модСерверПолныеПрава.РазобратьКомплектБЯС(ДокКомплект);	
	Иначе
		Сообщить("Это не комплект.");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЭлементыОтбора=Список.Отбор.Элементы;
	Кол=ЭлементыОтбора.Количество();
	Для Н=1 По Кол Цикл
		ЭлементыОтбора.Удалить(Кол-Н);	
	КонецЦикла;
	
	//Добавляем Отбор
	Если ИмяПользователя()= "АСК" Тогда
		новыйЭлемент=ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		новыйЭлемент.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("Организация");
		новыйЭлемент.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		новыйЭлемент.ПравоеЗначение="Асклепий";
	ИначеЕсли  ИмяПользователя()= "НФС" Тогда
		новыйЭлемент=ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		новыйЭлемент.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("Организация");
		новыйЭлемент.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		новыйЭлемент.ПравоеЗначение="НФС";

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШКПриИзменении(Элемент)
	ПоискДокБЯС=модСерверПолныеПрава.НайтиДокБЯСпоШК(ШК);
	Если ЗначениеЗаполнено(ПоискДокБЯС) Тогда
		ОткрытьЗначение(ПоискДокБЯС);
	Иначе 
		Сообщить("Документ с ШК-"+ШК+" не найден.");
	КонецЕсли;
	
	ТекущийЭлемент=Элементы.ШК;

КонецПроцедуры

&НаКлиенте
Процедура СчетФПриИзменении(Элемент)
	ПоискДокБЯС=модСерверПолныеПрава.НайтиБЯСпоСчетФактуре(СчетФ);
	Если ЗначениеЗаполнено(ПоискДокБЯС) Тогда
		ОткрытьЗначение(ПоискДокБЯС);
	Иначе 
		Сообщить("СчетФактура-"+СчетФ+" не найдена.");
	КонецЕсли;
	ТекущийЭлемент=Элементы.ШК;
	ТекущийЭлемент=Элемент;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "СканерШтрихкода" И Событие = "Barcode" И ЗначениеЗаполнено(Данные) Тогда
		ШК=Лев(Данные,12);
		ШКПриИзменении(Null);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьШКсДЕЛЬФИ(Команда)
	
Если Вопрос("Обновить Штрихкоды для выделенных документов?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
     Возврат;
 КонецЕсли;
 
	
	
	масДок=Элементы.Список.ВыделенныеСтроки;
	
	Для Каждого эл_масДок Из масДок Цикл
		
		модСерверПолныеПрава.ОбновитьШКдокумента_Дельфи(эл_масДок);
		Сообщить(эл_масДок);
		
	КонецЦикла;
	
	
КонецПроцедуры
