
#Область ПрограммныйИнтерфейс

// Обработчик открытия гиперссылки в тексте письма.
//
// Параметры:
//  Гиперссылка			 - Строка - Анализируемая гиперссылка;
//  СтандартнаяОбработка - Булево - Признак стандартной обработки;
//  Объект				 - СправочникСсылка.Файлы - Ссылка на открываемый файл.
//
Процедура ОткрытьСсылку(Гиперссылка, СтандартнаяОбработка, Объект = Неопределено) Экспорт
		
	Если Не ЗначениеЗаполнено(Гиперссылка) Тогда
		СтандартнаяОбработка = Истина;
		Возврат;
	КонецЕсли;

	СхемаСсылки = РаботаСHTMLКлиентСервер.ОпределитьСхемуСсылки(Гиперссылка);

	Если СхемаСсылки = "v8doc:" Тогда
		
		Если СтрНайти(Гиперссылка, "mailattachment") > 0 Тогда
			//ИмяФайла = РаботаСФайламиВызовСервера.ИмяВременногоФайлаДляВложения(Объект);
			//РаботаСФайламиИПредметамиКлиент.ЗапуститьПриложениеПоИмениФайла(ИмяФайла);
			
		ИначеЕсли СтрНайти(Гиперссылка, "fileID") Тогда
		//	
		//	ИДФайла = СтрЗаменить(Гиперссылка, СтрШаблон("%1%2", СхемаСсылки, "fileID"), "");
		//
		//	Файл = РаботаСФайламиВызовСервера.ФайлПоИдентификаторуВложения(ИДФайла);
		//
		//	РаботаСФайламиИПредметамиКлиент.ЗагрузитьФайлССервера(Строка(Файл), Файл);
		//
		//	СтандартнаяОбработка = Ложь;
			
		ИначеЕсли СтрНайти(Гиперссылка, "e1cib/data") Тогда
			
			ОткрытьСсылкуИзБазы(Гиперссылка);
			
			СтандартнаяОбработка = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли СхемаСсылки = "http://"
		Или СхемаСсылки = "https://"
		Или СхемаСсылки = "ftp://"
		Или СхемаСсылки = "e1cib/data" Тогда

		Попытка
			
			ОткрытьСсылкуИзБазы(Гиперссылка);
			
		Исключение
			
			НачатьЗапускПриложения(Новый ОписаниеОповещения(), Гиперссылка);
			
		КонецПопытки;
	
	//ИначеЕсли СхемаСсылки = "mailto:" Тогда

	//	РаботаСПочтойКлиент.СоздатьПисьмоНаОснованииСсылкиMailto(Гиперссылка);
	//	
	//ИначеЕсли СхемаСсылки = "tel:" Тогда

	//	НомерТелефона = СтрЗаменить(Гиперссылка, СхемаСсылки, "");
	//	#Если МобильноеПриложениеКлиент Тогда
	//		Если СредстваТелефонии.ПоддерживаетсяНаборНомера() Тогда
	//			СредстваТелефонии.НабратьНомер(НомерТелефона, Ложь);
	//		КонецЕсли;
	//	#КонецЕсли
	КонецЕсли;

КонецПроцедуры

Функция ОткрытьСсылкуИзБазы(АдресСсылки) Экспорт
	
	АдресНавСсылки = Сред(АдресСсылки, СтрНайти(АдресСсылки, "e1cib/data"));
	
	АдресНавСсылки = СтрЗаменить(АдресНавСсылки, "Задача.ЗадачаИсполнителя", "Справочник.Задачи"); 
	
	АдресНавСсылки = СтрЗаменить(АдресНавСсылки, "БизнесПроцесс.Исполнение", "Справочник.ПроцессыИсполнение"); 
	
	ПерейтиПоНавигационнойСсылке(АдресНавСсылки);
	
КонецФункции

#КонецОбласти
