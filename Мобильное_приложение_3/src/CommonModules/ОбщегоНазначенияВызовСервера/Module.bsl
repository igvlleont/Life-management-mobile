
#Область ПрограммныйИнтерфейс

// Устанавливает указанное значение у указанной константы.
//
// Параметры:
//  ИмяКонстанты      - Строка - Имя константы;
//  ЗначениеКонстанты - Произвольный - Устанавливаемое значение константы..
//
Процедура УстановитьЗначениеКонстанты(ИмяКонстанты, ЗначениеКонстанты) Экспорт

	Константы[ИмяКонстанты].Установить(ЗначениеКонстанты);

КонецПроцедуры

// Возвращает значение указанной константы.
//
// Параметры:
//  ИмяКонстанты - Строка - Имя константы.
// 
// Возвращаемое значение:
//  Произвольный - Значение константы.
//
Функция ЗначениеКонстанты(ИмяКонстанты) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	&Константа КАК ЗначениеКонстанты
		|ИЗ
		|	Константы КАК Константы";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Константа", "Константы." + ИмяКонстанты);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить()[0].ЗначениеКонстанты;
	
КонецФункции

// Получает значение реквизита у ссылки на объект.
//
// Параметры:
//  Ссылка		 - Ссылка - Ссылка на объект;
//  ИмяРеквизита - Строка - Имя получаемого реквизита.
// 
// Возвращаемое значение:
//  Произвольный - Значение реквизита объекта.
//
Функция ЗначениеРеквизита(Ссылка, ИмяРеквизита) Экспорт
	
	Если Ссылка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПолноеИмя = Ссылка.Метаданные().ПолноеИмя();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	&ПолноеИмяРеквизита КАК ЗначениеРеквизита
		|ИЗ
		|	&ПолноеИмяТаблицы КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка = &Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяТаблицы", ПолноеИмя);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяРеквизита", "Таблица." + ИмяРеквизита);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Попытка
		ЗначениеРеквизита = РезультатЗапроса.Выгрузить()[0].ЗначениеРеквизита;
	Исключение
		ЗначениеРеквизита = Неопределено;
	КонецПопытки; 
	
	Возврат ЗначениеРеквизита;

КонецФункции

// Возвращает структуру, содержащую значения реквизитов прочитанные из информационной базы
// по ссылке на объект.
// 
//  Если доступа к одному из реквизитов нет, возникнет исключение прав доступа.
//  Если необходимо зачитать реквизит независимо от прав текущего пользователя,
//  то следует использовать предварительный переход в привилегированный режим.
// 
// Функция не предназначена для получения значений реквизитов пустых ссылок.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//
//  Реквизиты - Строка - имена реквизитов, перечисленные через запятую, в формате
//              требований к свойствам структуры.
//              Например, "Код, Наименование, Родитель".
//            - Структура, ФиксированнаяСтруктура - в качестве ключа передается
//              псевдоним поля для возвращаемой структуры с результатом, а в качестве
//              значения (опционально) фактическое имя поля в таблице.
//              Если значение не определено, то имя поля берется из ключа.
//            - Массив, ФиксированныйМассив - имена реквизитов в формате требований
//              к свойствам структуры.
//
// Возвращаемое значение:
//  Структура - содержит имена (ключи) и значения затребованных реквизитов.
//              Если строка затребованных реквизитов пуста, то возвращается пустая структура.
//              Если в качестве объекта передана пустая ссылка, то все реквизиты вернутся со значением Неопределено.
//
Функция ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты = Неопределено) Экспорт
	
	ТекстПолей = "";
	
	Если ТипЗнч(Реквизиты) = Тип("Строка") Тогда

		Если ПустаяСтрока(Реквизиты) Тогда
			Возврат Новый Структура;
		КонецЕсли;

		Реквизиты = СтрРазделить(Реквизиты, ",");

	КонецЕсли;

	СтруктураРеквизитов = Новый Структура;
	Если ТипЗнч(Реквизиты) = Тип("Структура") 
		Или ТипЗнч(Реквизиты) = Тип("ФиксированнаяСтруктура") Тогда

		СтруктураРеквизитов = Реквизиты;

	ИначеЕсли ТипЗнч(Реквизиты) = Тип("Массив") 
		Или ТипЗнч(Реквизиты) = Тип("ФиксированныйМассив") Тогда

		Для Каждого Реквизит Из Реквизиты Цикл
			СтруктураРеквизитов.Вставить(СтрЗаменить(Реквизит, ".", ""), Реквизит);
		КонецЦикла;
		
	ИначеЕсли Реквизиты = Неопределено Тогда
		
		ТекстПолей = "*";
		МетаданныеСсылки = Ссылка.Метаданные();
		Для Каждого Реквизит Из МетаданныеСсылки.Реквизиты Цикл
			СтруктураРеквизитов.Вставить(Реквизит.Имя);
		КонецЦикла;
		
		Для Каждого Реквизит Из МетаданныеСсылки.СтандартныеРеквизиты Цикл
			СтруктураРеквизитов.Вставить(Реквизит.Имя);
		КонецЦикла;
		
		Для Каждого ТЧ Из МетаданныеСсылки.ТабличныеЧасти Цикл
			СтруктураРеквизитов.Вставить(ТЧ.Имя);
		КонецЦикла;

	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("en='Wrong parameter type: %1';ru='Неверный тип второго параметра Реквизиты: %1';vi='Sai kiểu tham số thứ hai Mục tin: %1'"),
			Строка(ТипЗнч(Реквизиты)));

	КонецЕсли;

	Если Не ЗначениеЗаполнено(ТекстПолей) Тогда
		
		Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
			
			ИмяПоля = ?(ЗначениеЗаполнено(КлючИЗначение.Значение),
				СокрЛП(КлючИЗначение.Значение), СокрЛП(КлючИЗначение.Ключ));
			
			Псевдоним  = СокрЛП(КлючИЗначение.Ключ);
			
			ТекстПолей = ТекстПолей + ?(ПустаяСтрока(ТекстПолей), "", ",") + "
				|	" + ИмяПоля + " КАК " + Псевдоним;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|" + ТекстПолей + "
	|ИЗ
	|	" + Ссылка.Метаданные().ПолноеИмя() + " КАК ПсевдонимЗаданнойТаблицы
	|ГДЕ
	|	ПсевдонимЗаданнойТаблицы.Ссылка = &Ссылка
	|";

	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Результат = Новый Структура;
	Для Каждого КлючИЗначение Из СтруктураРеквизитов Цикл
		Результат.Вставить(КлючИЗначение.Ключ);
	КонецЦикла;

	ЗаполнитьЗначенияСвойств(Результат, Выборка);

	Возврат Результат;

КонецФункции

// Получает имя значения перечисления как объекта метаданных.
//
// Параметры:
//  Значение - ЗначениеПеречисления - для которого необходимо получить имя перечисления.
//
// Возвращаемое значение:
//  Строка - имя значения перечисления как объекта метаданных.
//
Функция ИмяЗначенияПеречисления(Значение) Экспорт
	
	Если Не ЗначениеЗаполнено(Значение)  Тогда
		Возврат "";
	КонецЕсли;
	
	ОбъектМетаданных = Значение.Метаданные();
	ИндексЗначения = Перечисления[ОбъектМетаданных.Имя].Индекс(Значение);
	Возврат ОбъектМетаданных.ЗначенияПеречисления[ИндексЗначения].Имя;

КонецФункции 

// Удаляет из строки символы, недопустимые к использованию в XML.
//
// Параметры:
//  Текст - Строка - Анализируемый текст.
// 
// Возвращаемое значение:
//  Строка - Текст, из которого удалены недопустимые для XML символы.
//
Функция УдалитьНедопустимыеСимволыXML(Знач Текст) Экспорт

	#Если Не ВебКлиент Тогда

		ПозицияНачала = 1;

		Пока Истина Цикл

			Если ПозицияНачала > СтрДлина(Текст) Тогда
				Прервать;
			КонецЕсли;

			Позиция = НайтиНедопустимыеСимволыXML(Текст, ПозицияНачала);

			Если Позиция = 0 Тогда
				Прервать;
			КонецЕсли;

			// Если возвращаемая позиция, больше чем должна быть, то корректируем ее.
			Если Позиция > 1 Тогда
				НедопустимыйСимвол = Сред(Текст, Позиция - 1, 1);
				Если НайтиНедопустимыеСимволыXML(НедопустимыйСимвол) > 0 Тогда
					Текст = СтрЗаменить(Текст, НедопустимыйСимвол, "");
				КонецЕсли;
			КонецЕсли;

			НедопустимыйСимвол = Сред(Текст, Позиция, 1);
			Если НайтиНедопустимыеСимволыXML(НедопустимыйСимвол) > 0 Тогда
				Текст = СтрЗаменить(Текст, НедопустимыйСимвол, "");
			КонецЕсли;

			ПозицияНачала = Макс(1, Позиция - 1);

		КонецЦикла;

	#КонецЕсли

	Возврат Текст;

КонецФункции

// Формирует табличный документ 1С из файла на диске устройства.
//
// Параметры:
//  ИмяФайла - Строка - Имя открываемого файла в формате MXL.
// 
// Возвращаемое значение:
//  ТабличныйДокумент - Прочитанный табличный документ.
//
Функция ПолучитьТабличныйДокументИзФайлаНаСервере(ИмяФайла) Экспорт

	ТабличныйДокумент = Новый ТабличныйДокумент();
	ТабличныйДокумент.Прочитать(ИмяФайла);
	ТабличныйДокумент.ТолькоПросмотр = Истина;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;

	Возврат ТабличныйДокумент;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает указанное значение если текущее значение константы пустое или не заполненное.
//
// Параметры:
//  ИмяКонстанты		 - Строка - Имя устанавливаемой константы;
//  ЗначениеПоУмолчанию	 - Произвольный - Устанавливаемое значение.
//
Процедура УстановитьЗначениеКонстантыПоУмолчанию(ИмяКонстанты, ЗначениеПоУмолчанию) Экспорт

	ТекущееЗначение = Константы[ИмяКонстанты].Получить();

	Если Не ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Константы[ИмяКонстанты].Установить(ЗначениеПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Функция ЭтоСсылка(Тип) Экспорт
	
	Попытка
		Возврат Тип <> Тип("Неопределено")
			И (Справочники.ТипВсеСсылки().СодержитТип(Тип)
			ИЛИ Документы.ТипВсеСсылки().СодержитТип(Тип)
			ИЛИ Перечисления.ТипВсеСсылки().СодержитТип(Тип)
			ИЛИ ПланыОбмена.ТипВсеСсылки().СодержитТип(Тип));
	Исключение
		Возврат Ложь
	КонецПопытки;
	
КонецФункции

Функция СсылкаСуществует(Ссылка, ПолноеИмяМетаданных = Неопределено, ИмяРеквизитаПроверки = Неопределено) Экспорт
	
	Если ПолноеИмяМетаданных = Неопределено Тогда
		
		Попытка
			ПолноеИмяМетаданных = Ссылка.Метаданные().ПолноеИмя();
		Исключение
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Существует
		|ИЗ
		|	&ПолноеИмяМетаданных КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка = &Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяМетаданных", ПолноеИмяМетаданных);
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

Функция ТекущаяВерсияДанныхОбъекта(Ссылка) Экспорт
	
	ВерсияДанных = "";
	
	СсылкаОбъект = Ссылка.ПолучитьОбъект();
	
	Если СсылкаОбъект <> Неопределено Тогда
		ВерсияДанных = СсылкаОбъект.ВерсияДанных;
	КонецЕсли;
	
	Возврат ВерсияДанных;
	
КонецФункции

Процедура УдалитьОбъектИнтерактивно(СсылкаНаОбъект) Экспорт
	
	УдалениеОбъекта = Новый УдалениеОбъекта(СсылкаНаОбъект);
	
	УдалениеОбъекта.Записать();
	
КонецПроцедуры
#КонецОбласти