﻿
&НаКлиенте
Процедура ШКПриИзменении(Элемент)
	//Если 13 = СтрДлина(ШК) Тогда
	//	Док = НайденыйДок(ШК);
	//	Если Не ЗначениеЗаполнено(Док) Тогда
	//		ОчиститьСообщения();
	//		Сообщить("Документ не найден!!!");
	//		ШК = "";
	//	Иначе
	//		ОчиститьСообщения();
	//		ДоступностьДокумента = ПроверитьДоступностьДокумента(Док);
	//		Если ДоступностьДокумента Тогда
	//			ДобавитьДокументНаСеревере(Док);
	//			ШК = "";
	//		Иначе
	//			Сообщение = Новый СообщениеПользователю;
	//			Сообщение.Текст = "Расходный ордер №" + ШК + " уже оприходован!";
	//			Сообщение.Сообщить();
	//		КонецЕсли;
	//	КонецЕсли;
	//Иначе
	//	ОчиститьСообщения();
	//	Сообщить("Не правильно введен штрих код!! Будьте внимательны при сканировании!");
	//	ШКВодителя = "";
	//	Элементы.ШКВодителя.Доступность = Истина;
	//КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПроверитьДоступностьДокумента(Док)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПогрузкаТоваровВАвтомобиль1РасходныеОрдера.Ссылка
	|ИЗ
	|	Документ.ПогрузкаТоваровВАвтомобиль1.РасходныеОрдера КАК ПогрузкаТоваровВАвтомобиль1РасходныеОрдера
	|ГДЕ
	|	ПогрузкаТоваровВАвтомобиль1РасходныеОрдера.РасходныйОрдер = &РасходныйОрдер";
	Запрос.УстановитьПараметр("РасходныйОрдер", Док);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура ДобавитьДокументНаСеревере(Док)
	Если Объект.Контрагент = Док.Контрагент Тогда
		НайденныеДокументы = Объект.РасходныеОрдера.НайтиСтроки(Новый Структура("РасходныйОрдер", Док));
		Если НайденныеДокументы.Количество() = 0 Тогда
			
			Объект.КоличествоКоробок		= Объект.КоличествоКоробок	+ Док.КоличествоКоробок;
			Объект.ОбщийВес					= Объект.ОбщийВес 			+ Док.ОбщийВес;
			Объект.ОбщийОбъем				= Объект.ОбщийОбъем			+ Док.ОбщийОбъем;
			
			НоваяСтрока						= Объект.РасходныеОрдера.Добавить();
			НоваяСтрока.РасходныйОрдер		= Док
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Документ уже добавлен";
			Сообщение.Сообщить();	
		КонецЕсли;
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Контрагент";
		Сообщение.Сообщить();
	КонецЕсли; 
КонецПроцедуры

Функция НайденыйДок(Ном)
	КодДокумента = ОбщийМодуль_Каштан.ПолучитьНомерДокументаПоШК(Ном);
	
	Если КодДокумента = Неопределено тогда
		Сообщить("Документ не найден!!!");
		Возврат Неопределено;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасходныйОрдерНаТовары.Ссылка
		|ИЗ
		|	Документ.РасходныйОрдерНаТовары КАК РасходныйОрдерНаТовары
		|ГДЕ
		|	РасходныйОрдерНаТовары.Номер = &Номер";
		Запрос.УстановитьПараметр("Номер", КодДокумента);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Ссылка;
		Иначе
			Возврат Неопределено;
		КонецЕсли; 
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник = "СканерШтрихкода" И Событие = "Barcode" И ЗначениеЗаполнено(Данные) Тогда
		
			Если Данные="111111111111" Тогда
				П=Новый Структура;
				П.Вставить("РежимЗаписи",РежимЗаписиДокумента.Проведение);
				ЭтаФорма.Записать(П);
				Сообщить("Документ Сохранен.");
				ЭтаФорма.Закрыть();
			КонецЕсли;
		 //Сообщить(Данные);
		//Выбираем ШК СчетФ
		//ШК = Лев(Данные, СтрДлина(Данные) - 1);	
		
		ШКсчетФ = Лев(Данные, СтрДлина(Данные) - 1);
		 //Сообщить(ШКсчетФ);
		Для Каждого строкаТЧ Из Объект.ДокументыРасхода Цикл
			
			Если ШКсчетФ=СокрЛП(строкаТЧ.ШК) Тогда
			П=Новый Структура;
			П.Вставить("РежимЗаписи",РежимЗаписиДокумента.Проведение);
			ЭтаФорма.Записать(П);
		 	Сообщить("Документ Сохранен.");
          	ЭтаФорма.Закрыть();
			КонецЕсли;
         КонецЦикла;
		
	КонецЕсли;
	
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьСписокОтгруженныхБЯС");
КонецПроцедуры

&НаКлиенте
 Процедура ПриОткрытии(Отказ)
 ЗаписатьФлагОзнакомления();
 КонецПроцедуры

&НаСервере
 Процедура ЗаписатьФлагОзнакомления()
 //Об = РеквизитФормыВЗначение("Объект");
 //Об.КоличествоКоробок =Объект.КоличествоКоробок+1 ;
 //Об.Записать();
 //ЗначениеВРеквизитФормы(Об,"Объект");
 КонецПроцедуры
&НаКлиенте
Процедура КоличествоКоробокПриИзменении(Элемент)
	//ЭтаФорма.Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура КоличествоКоробокНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//ЭтаФорма.Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
         Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
             Возврат;
         КонецЕсли;
         ЭтаФорма.Прочитать();
		 //ЗаполнитьКоординаты(Параметр);
         ЭтаФорма.Прочитать();

КонецПроцедуры
