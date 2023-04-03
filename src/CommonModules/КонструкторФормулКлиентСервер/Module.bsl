///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  СтрокаТаблицыЗначений: см. КонструкторФормулСлужебный.ОписаниеСписковПолей
//
Функция НастройкиСпискаПолей(Форма, ИмяСпискаПолей) Экспорт
	
	Отбор = Новый Структура("ИмяСпискаПолей", ИмяСпискаПолей);
	Для Каждого СписокПолей Из Форма.ПодключенныеСпискиПолей.НайтиСтроки(Отбор) Цикл
		Возврат СписокПолей;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПараметрыРедактированияФормулы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Формула");
	Параметры.Вставить("Операнды");
	Параметры.Вставить("Операторы");
	Параметры.Вставить("ИмяКоллекцииСКДОперандов");
	Параметры.Вставить("ИмяКоллекцииСКДОператоров");
	Параметры.Вставить("Наименование");
	Параметры.Вставить("ДляЗапроса");
	Параметры.Вставить("СкобкиОперандов", Истина);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти