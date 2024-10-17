#Использовать fs

&Пластилин Перем КомпиляторИсходников;

Перем КаталогБинарников Экспорт;
Перем КаталогИсходников Экспорт;

Перем ТаблицаОбработок;

&Желудь
&Характер("Компанейский")
Процедура ПриСозданииОбъекта()

	ТаблицаОбработок = Новый ТаблицаЗначений;
	ТаблицаОбработок.Колонки.Добавить("Имя");
	ТаблицаОбработок.Колонки.Добавить("ПутьИсходников");
	ТаблицаОбработок.Колонки.Добавить("ПутьБинарника");

КонецПроцедуры

Функция ТаблицаОбработок() Экспорт

	ОбновитьТаблицу();

	Возврат ТаблицаОбработок;

КонецФункции

Функция СобратьВсе() Экспорт
	Возврат КомпиляторИсходников.СобратьОбработку(КаталогИсходников, КаталогБинарников);
КонецФункции

Функция РазобратьВсе() Экспорт
	Возврат КомпиляторИсходников.РазобратьОбработку(КаталогБинарников, КаталогИсходников);
КонецФункции

Функция Собрать(ИмяОбработки) Экспорт

	Обработка = СтрокаПоИмени(ИмяОбработки);

	Если Обработка.ПутьИсходников = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Для %1 нет исходников", ИмяОбработки);
	КонецЕсли;

	Возврат КомпиляторИсходников.СобратьОбработку(
		Обработка.ПутьИсходников, 
		ОбъединитьПути(
			КаталогБинарников,
			ФС.ОтносительныйПуть(КаталогИсходников, Новый Файл(Обработка.ПутьИсходников).Путь)
		)
	);

КонецФункции

Функция Разобрать(ИмяОбработки) Экспорт

	Обработка = СтрокаПоИмени(ИмяОбработки);

	Если Обработка.ПутьБинарника = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Для %1 нет бинарника", ИмяОбработки);
	КонецЕсли;
	
	Возврат КомпиляторИсходников.РазобратьОбработку(
		Обработка.ПутьБинарника, 
		ОбъединитьПути(
			КаталогИсходников,
			ФС.ОтносительныйПуть(КаталогБинарников, Новый Файл(Обработка.ПутьБинарника).Путь)
		)
	);

КонецФункции

Функция СтрокаПоИмени(ИмяОбработки) Экспорт
	Строка = ТаблицаОбработок.Найти(ИмяОбработки, "Имя");
	Если Строка = Неопределено Тогда
		Строка = ТаблицаОбработок.Добавить();
		Строка.Имя = ИмяОбработки;
	КонецЕсли;

	Возврат Строка;
КонецФункции

Процедура ОбновитьТаблицу()

	ТаблицаОбработок.Очистить();

	Если НЕ ЗначениеЗаполнено(КаталогИсходников) 
		ИЛИ НЕ ЗначениеЗаполнено(КаталогБинарников) Тогда

		Возврат;
	КонецЕсли;

	ПрочитатьИсходники();
	ПрочитатьБинарники();

	ТаблицаОбработок.Сортировать("Имя");

КонецПроцедуры

Процедура ПрочитатьИсходники(Каталог = Неопределено)

	Если ПустаяСтрока(Каталог) Тогда
		Каталог = КаталогИсходников;
	КонецЕсли;

	КаталогиИсходниковОбработок = НайтиФайлы(Каталог, "*");

	Для Каждого КаталогИсходниковОбработки Из КаталогиИсходниковОбработок Цикл

		Если Не КаталогИсходниковОбработки.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;

		Если НайтиФайлы(КаталогИсходниковОбработки.ПолноеИмя, "*.xml").Количество() = 0 Тогда
			ПрочитатьИсходники(КаталогИсходниковОбработки.ПолноеИмя);
		Иначе
			Строка = СтрокаПоИмени(КаталогИсходниковОбработки.Имя);
			Строка.ПутьИсходников = КаталогИсходниковОбработки.ПолноеИмя;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ПрочитатьБинарники()

	БинарныеОбработки = НайтиФайлы(КаталогБинарников, "*.epf", Истина);

	Для Каждого БинарнаяОбработка Из БинарныеОбработки Цикл
		Строка = СтрокаПоИмени(БинарнаяОбработка.ИмяБезРасширения);
		Строка.ПутьБинарника = БинарнаяОбработка.ПолноеИмя;
	КонецЦикла;
	
КонецПроцедуры
