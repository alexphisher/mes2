///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Запускает периодическую проверку текущих напоминаний пользователя.
Процедура Включить() Экспорт
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Отключает периодическую проверку текущих напоминаний пользователя.
Процедура Выключить() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
КонецПроцедуры

// Создает новое напоминание на указанное время.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Время - Дата - дата и время напоминания;
//  Предмет - ЛюбаяСсылка - предмет напоминания.
//
Процедура НапомнитьВУказанноеВремя(Текст, Время, Предмет = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, Время, , Предмет);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает новое напоминание на время, рассчитанное относительно времени в предмете.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
//
Процедура НапомнитьДоВремениПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Ложь);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает напоминание с произвольным временем или расписанием выполнения.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  ВремяСобытия - Дата - дата и время события, о котором надо напомнить;
//               - РасписаниеРегламентногоЗадания - расписание периодического события;
//               - Строка - имя реквизита предмета напоминания, в котором содержится время наступления события.
//  ИнтервалДоСобытия - Число - время в секундах, за которое необходимо напомнить относительно времени события;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  Идентификатор - Строка - уточняет предмет напоминания, например, "ДеньРождения".
//
Процедура Напомнить(Текст, ВремяСобытия, ИнтервалДоСобытия = 0, Предмет = Неопределено, Идентификатор = Неопределено) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминание(
		Текст, ВремяСобытия, ИнтервалДоСобытия, Предмет, Идентификатор);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

// Создает ежегодное напоминание на дату предмета.
//
// Параметры:
//  Текст - Строка - текст напоминания;
//  Интервал - Число - время в секундах, за которое необходимо напомнить относительно даты в реквизите предмета;
//  Предмет - ЛюбаяСсылка - предмет напоминания;
//  ИмяРеквизита - Строка - имя реквизита предмета, относительно которого устанавливается срок напоминания.
//
Процедура НапомнитьОЕжегодномСобытииПредмета(Текст, Интервал, Предмет, ИмяРеквизита) Экспорт
	
	Напоминание = НапоминанияПользователяВызовСервера.ПодключитьНапоминаниеДоВремениПредмета(
		Текст, Интервал, Предмет, ИмяРеквизита, Истина);
		
	ОбновитьЗаписьВКэшеОповещений(Напоминание);
	СброситьТаймерПроверкиТекущихОповещений();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.НастройкиНапоминаний.ИспользоватьНапоминания Тогда
		НастройкиНаКлиенте().СписокТекущихНапоминаний =
			ПараметрыРаботыКлиента.НастройкиНапоминаний.СписокТекущихНапоминаний;
		ПодключитьОбработчикОжидания("ПроверитьТекущиеНапоминания", 60, Истина); // Через 60 секунд после запуска клиента.
	КонецЕсли;
	
КонецПроцедуры

// См. СтандартныеПодсистемыКлиент.ПриПолученииСерверногоОповещения.
Процедура ПриПолученииСерверногоОповещения(ИмяОповещения, Результат) Экспорт
	
	Если ИмяОповещения <> НапоминанияПользователяКлиентСервер.ИмяСерверногоОповещения() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Результат; // см. НапоминанияПользователяСлужебный.НовыеИзмененныеНапоминания
	
	Для Каждого Напоминание Из Результат.Удаленные Цикл
		УдалитьЗаписьИзКэшаОповещений(Напоминание);
	КонецЦикла;
	
	Для Каждого Напоминание Из Результат.Добавленные Цикл
		ОбновитьЗаписьВКэшеОповещений(Напоминание);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращаемое значение:
//  Структура:
//   * СписокТекущихНапоминаний - см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//
Функция НастройкиНаКлиенте()
	
	ИмяПараметра = "СтандартныеПодсистемы.НапоминанияПользователя";
	Настройки = ПараметрыПриложения[ИмяПараметра];
	
	Если Настройки = Неопределено Тогда
		Настройки = Новый Структура;
		Настройки.Вставить("СписокТекущихНапоминаний", Новый Массив);
		ПараметрыПриложения[ИмяПараметра] = Настройки;
	КонецЕсли;
	
	Возврат Настройки;
	
КонецФункции

// Сбрасывает таймер проверки текущих напоминаний и выполняет проверку немедленно.
Процедура СброситьТаймерПроверкиТекущихОповещений() Экспорт
	ОтключитьОбработчикОжидания("ПроверитьТекущиеНапоминания");
	ПроверитьТекущиеНапоминания();
КонецПроцедуры

// Открывает форму оповещения
Процедура ОткрытьФормуОповещения() Экспорт
	// Хранение формы в переменной требуется для предотвращения открытия дублей формы,
	// а также для уменьшения количества серверных вызовов.
	ИмяПараметра = "СтандартныеПодсистемы.ФормаОповещения";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ИмяФормыОповещения = "РегистрСведений.НапоминанияПользователя.Форма.ФормаОповещения";
		ПараметрыПриложения.Вставить(ИмяПараметра, ПолучитьФорму(ИмяФормыОповещения));
	КонецЕсли;
	ФормаОповещения = ПараметрыПриложения[ИмяПараметра];
	ФормаОповещения.Открыть();
КонецПроцедуры

// Возвращает кэшированные оповещения текущего пользователя, исключив из результата ненаступившие оповещения.
//
// Параметры:
//  ВремяБлижайшего - Дата - в этот параметр возвращается время ближайшего будущего напоминания. Если
//                           ближайшее напоминание за пределами выборки кэша, то возвращается Неопределено.
//
// Возвращаемое значение: 
//   см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//
Функция ПолучитьТекущиеОповещения(ВремяБлижайшего = Неопределено) Экспорт
	
	ТаблицаОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Результат = Новый Массив;
	
	ВремяБлижайшего = Неопределено;
	
	Для Каждого Оповещение Из ТаблицаОповещений Цикл
		Если Оповещение.СрокНапоминания <= ОбщегоНазначенияКлиент.ДатаСеанса() Тогда
			Результат.Добавить(Оповещение);
		Иначе                                                           
			Если ВремяБлижайшего = Неопределено Тогда
				ВремяБлижайшего = Оповещение.СрокНапоминания;
			Иначе
				ВремяБлижайшего = Мин(ВремяБлижайшего, Оповещение.СрокНапоминания);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;		
	
	Возврат Результат;
	
КонецФункции

// Обновляет запись в кэше напоминаний текущего пользователя.
Процедура ОбновитьЗаписьВКэшеОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Запись, ПараметрыОповещения);
	Иначе
		КэшОповещений.Добавить(ПараметрыОповещения);
	КонецЕсли;
КонецПроцедуры

// Удаляет запись из кэша напоминаний текущего пользователя.
Процедура УдалитьЗаписьИзКэшаОповещений(ПараметрыОповещения) Экспорт
	КэшОповещений = НастройкиНаКлиенте().СписокТекущихНапоминаний;
	Запись = НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения);
	Если Запись <> Неопределено Тогда
		КэшОповещений.Удалить(КэшОповещений.Найти(Запись));
	КонецЕсли;
КонецПроцедуры

// Возвращает запись из кэша напоминаний текущего пользователя.
//
// Параметры:
//  КэшОповещений - см. НапоминанияПользователяСлужебный.СписокТекущихНапоминанийПользователя
//  ПараметрыОповещения - Структура:
//   * Источник - ОпределяемыйТип.ПредметНапоминания
//   * ВремяСобытия - Дата
//
Функция НайтиЗаписьВКэшеОповещений(КэшОповещений, ПараметрыОповещения)
	Для Каждого Запись Из КэшОповещений Цикл
		Если Запись.Источник = ПараметрыОповещения.Источник
		   И Запись.ВремяСобытия = ПараметрыОповещения.ВремяСобытия Тогда
			Возврат Запись;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

// Получает из строки интервал времени и возвращает его текстовое представление.
//
// Параметры:
//  ВремяСтрокой - Строка - текстовое описание времени, где числа записаны цифрами,
//							а единицы измерения - строкой.
//
// Возвращаемое значение:
//  Строка - оформленное представление времени.
//
Функция ОформитьВремя(ВремяСтрокой) Экспорт
	Возврат ПредставлениеВремени(ПолучитьИнтервалВремениИзСтроки(ВремяСтрокой));
КонецФункции

// Возвращает текстовое представление интервала времени, заданного в секундах.
//
// Параметры:
//
//  Время - Число - интервал времени в секундах.
//
//  ПолноеПредставление	- Булево - кратное или полное представление времени.
//		Например, интервал 1 000 000 секунд:
//		1) полное представление:  11 дней 13 часов 46 минут 40 секунд;
//		2) краткое представление: 11 дней 13 часов.
//  
//  ВыводитьСекунды - Булево - Ложь, если секунды не требуются.
//  
// Возвращаемое значение:
//   Строка - представление интервала времени.
//
Функция ПредставлениеВремени(Знач Время, ПолноеПредставление = Истина, ВыводитьСекунды = Истина) Экспорт
	Результат = "";
	
	// Представление единиц измерения времени в винительном падеже для количеств: 1, 2-4, 5-20.
	ПредставлениеНедель = НСтр("ru = ';%1 неделю;;%1 недели;%1 недель;%1 недели'");
	ПредставлениеДней   = НСтр("ru = ';%1 день;;%1 дня;%1 дней;%1 дня'");
	ПредставлениеЧасов  = НСтр("ru = ';%1 час;;%1 часа;%1 часов;%1 часа'");
	ПредставлениеМинут  = НСтр("ru = ';%1 минуту;;%1 минуты;%1 минут;%1 минуты'");
	ПредставлениеСекунд = НСтр("ru = ';%1 секунду;;%1 секунды;%1 секунд;%1 секунды'");
	
	Время = Число(Время);
	
	Если Время < 0 Тогда
		Время = -Время;
	КонецЕсли;
	
	КоличествоНедель = Цел(Время / 60/60/24/7);
	КоличествоДней   = Цел(Время / 60/60/24);
	КоличествоЧасов  = Цел(Время / 60/60);
	КоличествоМинут  = Цел(Время / 60);
	КоличествоСекунд = Цел(Время);
	
	КоличествоСекунд = КоличествоСекунд - КоличествоМинут * 60;
	КоличествоМинут  = КоличествоМинут - КоличествоЧасов * 60;
	КоличествоЧасов  = КоличествоЧасов - КоличествоДней * 24;
	КоличествоДней   = КоличествоДней - КоличествоНедель * 7;
	
	Если Не ВыводитьСекунды Тогда
		КоличествоСекунд = 0;
	КонецЕсли;
	
	ФорматнаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("L=%1", ТекущийЯзык());
	
	Если КоличествоНедель > 0 И КоличествоДней+КоличествоЧасов+КоличествоМинут+КоличествоСекунд=0 Тогда
		Результат = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеНедель, КоличествоНедель,, ФорматнаяСтрока);
	Иначе
		КоличествоДней = КоличествоДней + КоличествоНедель * 7;
		
		Счетчик = 0;
		Если КоличествоДней > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеДней, КоличествоДней,, ФорматнаяСтрока) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если КоличествоЧасов > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеЧасов, КоличествоЧасов,, ФорматнаяСтрока) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И КоличествоМинут > 0 Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеМинут, КоличествоМинут,, ФорматнаяСтрока) + " ";
			Счетчик = Счетчик + 1;
		КонецЕсли;
		
		Если (ПолноеПредставление Или Счетчик < 2) И (КоличествоСекунд > 0 Или КоличествоНедель+КоличествоДней+КоличествоЧасов+КоличествоМинут = 0) Тогда
			Результат = Результат + СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ПредставлениеСекунд, КоличествоСекунд,, ФорматнаяСтрока);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СокрП(Результат);
	
КонецФункции

// Получает из текстового описания интервал времени в секундах.
//
// Параметры:
//  СтрокаСоВременем - Строка - текстовое описание времени, где числа записаны цифрами,
//								а единицы измерения - строкой. 
//
// Возвращаемое значение:
//  Число - интервал времени в секундах.
// 
Функция ПолучитьИнтервалВремениИзСтроки(Знач СтрокаСоВременем) Экспорт
	
	Если ПустаяСтрока(СтрокаСоВременем) Тогда
		Возврат 0;
	КонецЕсли;
	
	СтрокаСоВременем = НРег(СтрокаСоВременем);
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, Символы.НПП," ");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, ".",",");
	СтрокаСоВременем = СтрЗаменить(СтрокаСоВременем, "+","");
	
	ПодстрокаСЦифрами = "";
	ПодстрокаСБуквами = "";
	
	ПредыдущийСимволЭтоЦифра = Ложь;
	ЕстьДробнаяЧасть = Ложь;
	
	Результат = 0;
	Для Позиция = 1 По СтрДлина(СтрокаСоВременем) Цикл
		ТекущийКодСимвола = КодСимвола(СтрокаСоВременем,Позиция);
		Символ = Сред(СтрокаСоВременем,Позиция,1);
		Если (ТекущийКодСимвола >= КодСимвола("0") И ТекущийКодСимвола <= КодСимвола("9"))
			ИЛИ (Символ="," И ПредыдущийСимволЭтоЦифра И Не ЕстьДробнаяЧасть) Тогда
			Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
				ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
				Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
					* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
					
				ПодстрокаСЦифрами = "";
				ПодстрокаСБуквами = "";
				
				ПредыдущийСимволЭтоЦифра = Ложь;
				ЕстьДробнаяЧасть = Ложь;
			КонецЕсли;
			
			ПодстрокаСЦифрами = ПодстрокаСЦифрами + Сред(СтрокаСоВременем,Позиция,1);
			
			ПредыдущийСимволЭтоЦифра = Истина;
			Если Символ = "," Тогда
				ЕстьДробнаяЧасть = Истина;
			КонецЕсли;
		Иначе
			Если Символ = " " И ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами) = "0" Тогда
				ПодстрокаСБуквами = "";
			КонецЕсли;
			
			ПодстрокаСБуквами = ПодстрокаСБуквами + Сред(СтрокаСоВременем,Позиция,1);
			ПредыдущийСимволЭтоЦифра = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ПодстрокаСБуквами) Тогда
		ПодстрокаСЦифрами = СтрЗаменить(ПодстрокаСЦифрами,",",".");
		Результат = Результат + ?(ПустаяСтрока(ПодстрокаСЦифрами), 1, Число(ПодстрокаСЦифрами))
			* ЗаменитьЕдиницуИзмеренияНаМножитель(ПодстрокаСБуквами);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Анализирует слово на предмет соответствия единице времени и, если соответствие установлено,
// возвращает количество секунд, содержащееся в единице времени.
//
// Параметры:
//  Единица - Строка - анализируемое слово.
//
// Возвращаемое значение:
//  Число - количество секунд в Единице. Если единица не определена или пустая, то возвращается 0.
//
Функция ЗаменитьЕдиницуИзмеренияНаМножитель(Знач Единица)
	
	Результат = 0;
	Единица = НРег(Единица);
	
	ДопустимыеСимволы = НСтр("ru = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'"); // АПК:163; АПК:1036 (см. 456:1.1) символы, которые может вводить пользователь.
	ПосторонниеСимволы = СтрСоединить(СтрРазделить(Единица, ДопустимыеСимволы, Ложь), "");
	Если ПосторонниеСимволы <> "" Тогда
		Единица = СтрСоединить(СтрРазделить(Единица, ПосторонниеСимволы, Ложь), "");
	КонецЕсли;
	
	СловоформыНедели = СтрРазделить(НСтр("ru = 'нед,н'"), ",", Ложь);
	СловоформыДня = СтрРазделить(НСтр("ru = 'ден,дне,дня,дн,д'"), ",", Ложь);
	СловоформыЧаса = СтрРазделить(НСтр("ru = 'час,ч'"), ",", Ложь);
	СловоформыМинуты = СтрРазделить(НСтр("ru = 'мин,м'"), ",", Ложь);
	СловоформыСекунды = СтрРазделить(НСтр("ru = 'сек,с'"), ",", Ложь);
	
	ПервыеТриСимвола = Лев(Единица, 3);
	Если СловоформыНедели.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60*24*7;
	ИначеЕсли СловоформыДня.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60*24;
	ИначеЕсли СловоформыЧаса.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60*60;
	ИначеЕсли СловоформыМинуты.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 60;
	ИначеЕсли СловоформыСекунды.Найти(ПервыеТриСимвола) <> Неопределено Тогда
		Результат = 1;
	КонецЕсли;
	
	Возврат Формат(Результат,"ЧН=0; ЧГ=0");
	
КонецФункции

#КонецОбласти
