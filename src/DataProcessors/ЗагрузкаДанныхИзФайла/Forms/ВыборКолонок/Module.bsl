///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокКолонок = Параметры.СписокКолонок;
	СписокКолонок.СортироватьПоПредставлению();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокКолонокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СписокКолонок.НайтиПоИдентификатору(ВыбраннаяСтрока).Пометка = НЕ СписокКолонок.НайтиПоИдентификатору(ВыбраннаяСтрока).Пометка;
КонецПроцедуры

&НаКлиенте
Процедура СписокКолонокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Строка = СписокКолонок.НайтиПоИдентификатору(Элементы.СписокКолонок.ТекущаяСтрока);
	Если СтрНачинаетсяС(Строка.Значение, "КонтактнаяИнформация_") Тогда
		Для Каждого ИнформацияОКолонке Из СписокКолонок Цикл
			Если СтрНачинаетсяС(ИнформацияОКолонке.Значение, "ДополнительныйРеквизит_") Тогда
				ИнформацияОКолонке.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли СтрНачинаетсяС(Строка.Значение, "ДополнительныйРеквизит_") Тогда
		Для Каждого ИнформацияОКолонке Из СписокКолонок Цикл
			Если СтрНачинаетсяС(ИнформацияОКолонке.Значение, "КонтактнаяИнформация_") Тогда
				ИнформацияОКолонке.Пометка = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбор(Команда)
	Закрыть(СписокКолонок);
КонецПроцедуры

#КонецОбласти
