﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.БольшаяЯчеистаяСборка") Тогда
		// Заполнение шапки
		ДокументБЯС = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ЗонаОтгрузки Приход
	
	Если ЗначениеЗаполнено(ДокументБЯС) Тогда
		Движения.ЗонаОтгрузки.Записывать = Истина;
		
		
		Если ЗначениеЗаполнено(МестоОтгрузки) И КолКоробок<>0 Тогда
			    Движение = Движения.ЗонаОтгрузки.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.НомерМестаОтгрузки = МестоОтгрузки;
				Движение.ДокументПрихода = ДокументБЯС;
                Движение.КоличествоКоробок = КолКоробок;
				
			
		Иначе // Списываем Всю Сборку	
			
			Для Каждого стр_МестаОтгрузки Из  ДокументБЯС.МестаОтгрузки Цикл
				Движение = Движения.ЗонаОтгрузки.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.НомерМестаОтгрузки = стр_МестаОтгрузки.МестоОтгрузки;
				Движение.ДокументПрихода = ДокументБЯС;
				//Движение.Вес = ДокументБЯС.ОбщийВес;
				Движение.КоличествоКоробок = стр_МестаОтгрузки.КоличествоКоробок;
				//Движение.Объем = ДокументБЯС.ОбщийОбъем;	
				
				
			КонецЦикла;                                                  
		КонецЕсли;
		//Модифицируем ДокБЯС
		ДокБЯС=ДокументБЯС.ПолучитьОбъект();
		ДокБЯС.Списан=Истина;
		ДокБЯС.ДокументСписания=Ссылка;
		ДокБЯС.Записать(РежимЗаписиДокумента.Запись);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	//Модифицируем ДокБЯС
	Попытка
	ДокБЯС=ДокументБЯС.ПолучитьОбъект();
			ДокБЯС.Списан=Ложь;
			ДокБЯС.ДокументСписания="";
			ДокБЯС.Записать(РежимЗаписиДокумента.Запись);
		Исключение
			КонецПопытки;
КонецПроцедуры
