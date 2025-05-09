
// Возвращает значение указанной константы в сеансе с повторным использованием.
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

функция ИмяМетаданныхСсылки(Ссылка) Экспорт
	
	Возврат Ссылка.Метаданные().Имя;
	
КонецФункции