﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//************* КОМПЛЕКТ **********************//
	//Если ЭтоКомплект - то Формируем Комплект
	 Если ЭтоКомплект Тогда
		 Если ДокументыКомплекта.Количество() >0 Тогда
			//Группируем по ДокКомплекта чтобы не было задвоений
			ТЗ=ДокументыКомплекта.Выгрузить();
			ТЗ.Свернуть("ДокБЯС");
			ДокументыКомплекта.Загрузить(ТЗ);
			//Проверяем что у них один Контрагент
			Контрагент=ДокументыКомплекта[0].ДокБЯС.Получатель;
			Для Каждого стр_БЯС Из ДокументыКомплекта Цикл
				Если Контрагент<>стр_БЯС.ДокБЯС.Получатель Тогда
					Сообщить("Нельзя создать комплект для разных клиентов.");
					Отказ=Истина;
					Возврат;
				КонецЕсли;
				
			КонецЦикла;
			НачатьТранзакцию();
			//***** Формируем комплект *********//
			Получатель=Контрагент;
			Организация=ДокументыКомплекта[0].ДокБЯС.Организация;
			МестаОтгрузки.Очистить();
			ДокументыРасхода.Очистить();
			Для Каждого стр_БЯС Из ДокументыКомплекта Цикл
				док_БЯС=стр_БЯС.ДокБЯС;
				//Заполняем ТЧ  МестаОтгрузки
				Для Каждого стр_ТЧ_док_БЯС из док_БЯС.МестаОтгрузки Цикл
					Если  док_БЯС.Возврат тогда
						СтрММ="";
						Для Каждого стр_Место из МестаОтгрузки Цикл
							Если стр_Место.МестоОтгрузки.Наименование="А01"  тогда
								СтрММ="А01";
							КонецЕсли;	
						КонецЦикла;	
						Если СтрММ="" тогда
							новаяСтрока=МестаОтгрузки.Добавить();
							новаяСтрока.МестоОтгрузки=стр_ТЧ_док_БЯС.МестоОтгрузки;
							новаяСтрока.КоличествоКоробок=стр_ТЧ_док_БЯС.КоличествоКоробок;
						КонецЕсли;	
					Иначе
						новаяСтрока=МестаОтгрузки.Добавить();
						новаяСтрока.МестоОтгрузки=стр_ТЧ_док_БЯС.МестоОтгрузки;
						новаяСтрока.КоличествоКоробок=стр_ТЧ_док_БЯС.КоличествоКоробок;
					КонецЕсли;	
				КонецЦикла;
				//Заполняем ТЧ  ДокументыРасхода
				Для Каждого стр_ТЧ_док_БЯС из док_БЯС.ДокументыРасхода Цикл
					новаяСтрока=ДокументыРасхода.Добавить();
					новаяСтрока.Док=стр_ТЧ_док_БЯС.Док;
					новаяСтрока.ДокНомер=стр_ТЧ_док_БЯС.ДокНомер;
					новаяСтрока.Комментарий=стр_ТЧ_док_БЯС.Комментарий;
					новаяСтрока.Проверен=стр_ТЧ_док_БЯС.Проверен;
					новаяСтрока.СчетФ=стр_ТЧ_док_БЯС.СчетФ;
					новаяСтрока.ШК=стр_ТЧ_док_БЯС.ШК;
					новаяСтрока.Сумма=стр_ТЧ_док_БЯС.Сумма;
					новаяСтрока.КолПозиций=стр_ТЧ_док_БЯС.КолПозиций;
					новаяСтрока.Количество=стр_ТЧ_док_БЯС.Количество;
					новаяСтрока.Объем=стр_ТЧ_док_БЯС.Объем;
					новаяСтрока.Вес=стр_ТЧ_док_БЯС.Вес;
					новаяСтрока.АдресДоставки=стр_ТЧ_док_БЯС.АдресДоставки;
				КонецЦикла;
				
				Коробки = МестаОтгрузки.Итог("КоличествоКоробок");
				//Изменяем Док БЯС (Перепроводим)
				ДокОбъект=док_БЯС.ПолучитьОбъект();
				Если Не ЗначениеЗаполнено(ДокОбъект.КонецОтгрузки) Тогда
					ДокОбъект.КонецОтгрузки=ТекущаяДата();
				КонецЕсли;
				ДокОбъект.ВходитВКомплект=Истина;
				ДокОбъект.КомплектБЯС=Ссылка;
				ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
			КонецЦикла;
			
			ЗафиксироватьТранзакцию();
			//**********************************//
			
		 КонецЕсли;
 
	 КонецЕсли;
	//************* КОМПЛЕКТ **********************// 

	Если ЭтотОбъект.МестаОтгрузки.Количество()=0 тогда
		Если ЭтотОбъект.Направление.Код<>"100" тогда
			Если ЭтотОбъект.Коробки=0 Тогда 
				ЭтотОбъект.Коробки=1;
			КонецЕсли;	
			 Стр=ЭтотОбъект.МестаОтгрузки.Добавить();
			 Стр.КоличествоКоробок=1;
			 Стр.МестоОтгрузки=Справочники.МестаХранения.НайтиПоКоду("000001051");
		КонецЕсли;	
	КонецЕсли;	
		
		//******************* Проверка на ШК  Для АСК и НФС ****************************//
   
  
	Для Каждого Стр из ЭтотОбъект.ДокументыРасхода Цикл
		
		Если СокрЛП(Стр.ШК)="" Тогда
			//ПолучитШК  Дельфи	
			Попытка
				//Стр.ШК=модСерверПолныеПрава.ПолучитьШК_Дельфи(СокрЛП(Стр.СчетФ),СокрЛП(ЭтотОбъект.Организация));
				Стр.ШК=модСерверПолныеПрава.ПолучитьШК_ДельфиПоНомеруРасходногоОрдера(СокрЛП(Стр.ДокНомер),СокрЛП(ЭтотОбъект.Организация));
			Исключение
			КонецПопытки;
		КонецЕсли;	
		
	КонецЦикла;
	
	//Если  ВнешниеИсточникиДанных.SRVGLOB.ПолучитьСостояние()=СостояниеВнешнегоИсточникаДанных.Подключен Тогда
	//	ВнешниеИсточникиДанных.SRVGLOB.РазорватьСоединение();
	//КонецЕсли;
	
//*******************************************************************//

	Если ЗначениеЗаполнено(Коробки) Тогда
		Если не ЗначениеЗаполнено(ЭтотОбъект.НачалоОтгрузки) Тогда
			ЭтотОбъект.НачалоОтгрузки=ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	
	
	//Установка Коментариев и мест отгрузки
	ЭтотОбъект.Комментарий="";
	ТЗкомментарий=ЭтотОбъект.ДокументыРасхода .Выгрузить();
	ТЗкомментарий.Свернуть("Комментарий");
	Для Каждого ТекСтрока Из ТЗкомментарий Цикл
		Если ЗначениеЗаполнено(ТекСтрока.Комментарий) Тогда
			ЭтотОбъект.Комментарий = ЭтотОбъект.Комментарий + ТекСтрока.Комментарий + " ;";
		КонецЕсли;
		
	КонецЦикла;
	ЭтотОбъект.СписокМестХранений="";
	Для Каждого ТекСтрока Из ЭтотОбъект.МестаОтгрузки Цикл
		ЭтотОбъект.СписокМестХранений = ЭтотОбъект.СписокМестХранений + " " + ТекСтрока.МестоОтгрузки;
	КонецЦикла;
	
	//EУстановка НомераСчетФактур, ШК, Вес, Объем
	ЭтотОбъект.НомераСФ="";
	ЭтотОбъект.Отладка="";
	ЭтотОбъект.ОбщийВес=0;
	ЭтотОбъект.ОбщийОбъем=0;
	Для Каждого Стр из ДокументыРасхода Цикл
		НомераСФ = НомераСФ + ", " + СокрЛП(Стр.СчетФ);	
		Отладка = Отладка + ", " + СокрЛП(Стр.ШК);
		 ЭтотОбъект.ОбщийВес=ЭтотОбъект.ОбщийВес+Стр.Вес;
		ЭтотОбъект.ОбщийОбъем=ЭтотОбъект.ОбщийОбъем+Стр.Объем;
     КонецЦикла;
     НомераСФ = Прав(НомераСФ,СтрДлина(НомераСФ)-2);
     Отладка = Прав(Отладка,СтрДлина(Отладка)-2);
	 Если МестаОтгрузки.Количество()>0 И НЕ ЗначениеЗаполнено(Коробки) ТОГДА
		 Отказ=Истина;
	 КонецЕсли;
	 ТМС.ОтправитьБС(Ссылка);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ТоварыНаСкладах Приход
	//Движения.ТоварыНаСкладах.Записывать = Истина;
	
	
	Движения.ЗонаОтгрузки.Записывать = Истина;
	Если ЗначениеЗаполнено(Коробки) Тогда
		Если не ЗначениеЗаполнено(ЭтотОбъект.НачалоОтгрузки) Тогда
			ЭтотОбъект.НачалоОтгрузки=ТекущаяДата();
		КонецЕсли;	
		
		Для Каждого ТекСтрокаДокументыРасхода Из МестаОтгрузки Цикл
			Движение = Движения.ЗонаОтгрузки.Добавить();
			Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
			Движение.Период 			= ЭтотОбъект.НачалоОтгрузки;
			Движение.ДокументПрихода	= Ссылка;
			Движение.НомерМестаОтгрузки	= ТекСтрокаДокументыРасхода.МестоОтгрузки;
			Движение.КоличествоКоробок	= ТекСтрокаДокументыРасхода.КоличествоКоробок;
			//Движение.Объем				= ОбщийОбъем;
			//Движение.Вес				= ОбщийВес;
		КонецЦикла;
		
		//Если Входит в комплект  Тогда Списываем на дату комплектаци Проводим	
		Если ВходитВКомплект Тогда
			Для Каждого ТекСтрокаДокументыРасхода Из МестаОтгрузки Цикл
				Движение = Движения.ЗонаОтгрузки.Добавить();
				Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
				Движение.ДокументПрихода	= Ссылка;
				Движение.НомерМестаОтгрузки	= ТекСтрокаДокументыРасхода.МестоОтгрузки;
				Движение.КоличествоКоробок	= ТекСтрокаДокументыРасхода.КоличествоКоробок;
				//Движение.Объем				= ОбщийОбъем;
				//Движение.Вес				= ОбщийВес;
				Если ЗначениеЗаполнено(ЭтотОбъект.КонецОтгрузки) Тогда
					Движение.Период 			= ЭтотОбъект.КонецОтгрузки;
				Иначе
					Движение.Период 			= ТекущаяДата();
					ЭтотОбъект.КонецОтгрузки	= ТекущаяДата();
				КонецЕсли;
				
				
			КонецЦикла;
			
		КонецЕсли;
		
		
		//Проверяем есть ли Погрузка В Авто
		// Если Есть то перепроводим если заполнена зона места отгрузки
		Если ЗначениеЗаполнено(ПогрузкаВАвто) Тогда
			Если МестаОтгрузки.Количество()>0 Тогда
				докПогрузка=ПогрузкаВАвто.ПолучитьОбъект();
				докПогрузка.Записать(РежимЗаписиДокумента.Проведение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	Движения.РегТарыПоШК.Записывать=Истина;
	Для каждого Стр Из Тара Цикл
	
			Движение=Движения.РегТарыПоШК.Добавить();
			Движение.Период=Дата;
			Движение.Тара=Стр.Контейнер;
			Движение.Кому= Получатель ;
			Движение.НаКом="Контролер";
			Движение.Причина="Идет Сборка";
		Если МестаОтгрузки.Количество()>0 Тогда
			Движение=Движения.РегТарыПоШК.Добавить();
			Движение.Период=НачалоОтгрузки;
			Движение.Тара=Стр.Контейнер;
			Движение.Кому= Получатель ;
			Движение.НаКом="Отгрузка";
			Движение.Причина="Места "+СписокМестХранений;
		КонецЕсли;
		Если ЗначениеЗаполнено(КомплектБЯС) Тогда
			Если ЗначениеЗаполнено(КомплектБЯС.ПутевойЛист) Тогда
				Движение=Движения.РегТарыПоШК.Добавить();
				Движение.Период=КомплектБЯС.ПутевойЛист.Дата;
				Движение.Тара=Стр.Контейнер;
				Движение.Кому= Получатель ;
				Движение.НаКом="На Аптеке";
				Движение.Причина="Отвез водитель "+КомплектБЯС.ПутевойЛист.Водитель;
			КонецЕсли;
		Иначе 
			Если ЗначениеЗаполнено(ПутевойЛист) Тогда
				Движение=Движения.РегТарыПоШК.Добавить();
				Движение.Период=ПутевойЛист.Дата+1;
				Движение.Тара=Стр.Контейнер;
				Движение.Кому= Получатель ;
				Движение.НаКом="На Аптеке";
				Движение.Причина="Отвез водитель "+ПутевойЛист.Водитель;
			КонецЕсли;
		КонецЕсли;
		Если Самовывоз Тогда
			Движение=Движения.РегТарыПоШК.Добавить();
			Движение.Период=НачалоОтгрузки+3600;
			Движение.Тара=Стр.Контейнер;
			Движение.Кому= Получатель ;
			Движение.НаКом="На Аптеке";
			Движение.Причина="Самовывоз";
		КонецЕсли;
	КонецЦикла;
	ТМС.ОтправитьБС(Ссылка);
КонецПроцедуры



Процедура ПередУдалением(Отказ)
	Если ЭтоКомплект Тогда
		Сообщить("Перед Удалением выполните разборку комплекта.");
		//Отказ=Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.Номер) Тогда
		НайтиНачальныйДокумент=Документы.БольшаяЯчеистаяСборка.НайтиПоНомеру("ОТГ0000000000000",ТекущаяДата());	
		Если Не ЗначениеЗаполнено(НайтиНачальныйДокумент)  Тогда
			СтандартнаяОбработка=Ложь;
			ЭтотОбъект.Номер="ОТГ0000000000000";	
		КонецЕсли;
	КонецЕсли;


КонецПроцедуры
