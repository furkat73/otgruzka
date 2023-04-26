﻿
&НаКлиенте
Процедура ЗаполнитьСписок()
	
	// Для восстановления позиции запомним текущий сеанс
	ТекущийСеанс = Неопределено;
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийСеанс = ТекущиеДанные.Сеанс;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
	// Восстанавливаем текущую строку по запомненному сеансу
	Если ТекущийСеанс <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сеанс", ТекущийСеанс);
		НайденныеСеансы = СписокПользователей.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСеансы.Количество() = 1 Тогда
			Элементы.СписокПользователей.ТекущаяСтрока = НайденныеСеансы[0].ПолучитьИдентификатор();
			Элементы.СписокПользователей.ВыделенныеСтроки.Очистить();
			Элементы.СписокПользователей.ВыделенныеСтроки.Добавить(Элементы.СписокПользователей.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоКолонке(Направление)
	
	Колонка = Элементы.СписокПользователей.ТекущийЭлемент;
	Если Колонка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонкиСортировки = Колонка.Имя;
	НаправлениеСортировки = Направление;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()
	ТЗСписокПользователей = РеквизитФормыВЗначение("СписокПользователей");
	ТЗСписокПользователей.Очистить();
	
	ТекущиеСоединенияИБ = ПолучитьСоединенияИнформационнойБазы();
	Если ТекущиеСоединенияИБ <> Неопределено Тогда
		Для Каждого СоединениеИБ Из ТекущиеСоединенияИБ Цикл
			СтрПользователя = ТЗСписокПользователей.Добавить();
			
			СтрПользователя.Приложение   = ПредставлениеПриложения(СоединениеИБ.ИмяПриложения);
			СтрПользователя.НачалоРаботы = СоединениеИБ.НачалоСеанса;
			СтрПользователя.Компьютер    = СоединениеИБ.ИмяКомпьютера;
			СтрПользователя.Сеанс        = СоединениеИБ.НомерСеанса;
			СтрПользователя.Соединение   = СоединениеИБ.НомерСоединения;

			Если СоединениеИБ.Пользователь <> Неопределено Тогда
				СтрПользователя.Пользователь		= СоединениеИБ.Пользователь.Имя;
				СтрПользователя.ИмяПользователя		= СоединениеИБ.Пользователь.ПолноеИмя;
				СтрПользователя.ПользовательСсылка	= НайтиСсылкуПоИдентификаторуПользователя(СоединениеИБ.Пользователь.УникальныйИдентификатор);
			Иначе
				СтрПользователя.Пользователь    = "";
				СтрПользователя.ИмяПользователя = "";
			КонецЕсли;

			Если СоединениеИБ.НомерСеанса = НомерСеансаИнформационнойБазы Тогда
				СтрПользователя.НомерРисункаПользователя = 0;
			Иначе
				СтрПользователя.НомерРисункаПользователя = 1;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоАктивныхПользователей = ТекущиеСоединенияИБ.Количество();
	ТЗСписокПользователей.Сортировать(ИмяКолонкиСортировки + " " + НаправлениеСортировки);
	ЗначениеВРеквизитФормы(ТЗСписокПользователей, "СписокПользователей");
	
КонецПроцедуры

Функция НайтиСсылкуПоИдентификаторуПользователя(Идентификатор)
	
	//Запрос = Новый Запрос;
	//
	//ШаблонТекстаЗапроса = "ВЫБРАТЬ
	//				|	Ссылка
	//				|ИЗ
	//				|	%1
	//				|ГДЕ
	//				|	ИдентификаторПользователяИБ = &Идентификатор";
	//				
	//ТекстЗапросаПоПользователям = 
	//		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//				ШаблонТекстаЗапроса,
	//				"Справочник.Пользователи");
	//
	//ТекстЗапросаПоВнешниемПользователям = 
	//		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//				ШаблонТекстаЗапроса,
	//				"Справочник.ВнешниеПользователи");
	//				
	//Запрос.Текст = ТекстЗапросаПоПользователям;
	//Запрос.Параметры.Вставить("Идентификатор", Идентификатор);
	//Результат = Запрос.Выполнить();
	//
	//Если НЕ Результат.Пустой() Тогда
	//	Выборка = Результат.Выбрать();
	//	Выборка.Следующий();
	//	Возврат Выборка.Ссылка;
	//КонецЕсли;
	//
	//Запрос.Текст = ТекстЗапросаПоВнешниемПользователям;
	//Результат = Запрос.Выполнить();
	//
	//Если НЕ Результат.Пустой() Тогда
	//	Выборка = Результат.Выбрать();
	//	Выборка.Следующий();
	//	Возврат Выборка.Ссылка;
	//КонецЕсли;
	//
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы, элементов формы и команд формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерСеансаИнформационнойБазы = НомерСеансаИнформационнойБазы();
	
	//Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
	//	Если Элементы.Найти("РазорватьСоединение") <> Неопределено Тогда
	//		Элементы.РазорватьСоединение.Видимость = Ложь;
	//	КонецЕсли;
	//	Если Элементы.Найти("ПараметрыАдминистрированияИнформационнойБазы") <> Неопределено Тогда
	//		Элементы.ПараметрыАдминистрированияИнформационнойБазы.Видимость = Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
	// Вставить содержимое обработчика.
	ИмяКолонкиСортировки = "НачалоРаботы";
	НаправлениеСортировки = "Возр";
	ЗаполнитьСписокПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура РазорватьСоединение(Команда)
	
	Сообщение = "";
	
	Если Элементы.СписокПользователей.ТекущиеДанные.Сеанс = НомерСеансаИнформационнойБазы Тогда
		// Текущее соедеинение не разрываем - иначе останется сеанс
		Предупреждение(НСтр("ru = 'Нельзя разорвать текущее соединение.'"));
		Возврат;
	КонецЕсли;
	
	Отключено = СоединенияИБ.ОтключитьСоединениеИБ(СоединенияИБ.ПолучитьПараметрыАдминистрированияИБ(),
										Элементы.СписокПользователей.ТекущиеДанные.Соединение,
										Сообщение);
	
	Если НЕ Отключено И Сообщение <> "" Тогда
		Предупреждение(Сообщение);
	КонецЕсли;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации()
	
	Если Элементы.СписокПользователей.ВыделенныеСтроки.Количество() > 1 Тогда
		Предупреждение(НСтр("ru = 'Для просмотра журнала регистрации выберите в списке только одного пользователя.'"));
		Возврат;
	КонецЕсли;
		
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Предупреждение(НСтр("ru = 'Невозможно открыть журнал регистрации для выбранного пользователя.'"));
		Возврат;
	КонецЕсли;
	
	ИмяПользователя  = ТекущиеДанные.ИмяПользователя;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя));
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию()
	
	СортировкаПоКолонке("Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию()
	
	СортировкаПоКолонке("Убыв");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Пользователь = Элементы.СписокПользователей.ТекущиеДанные.ПользовательСсылка;
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Пользователь);
		Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			ОткрытьФорму("Справочник.ВнешниеПользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАдминистрированияИнформационнойБазы(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыАдминистрированияСервернойИБ");
	
КонецПроцедуры
