#Использовать 1commands

Перем Команда;
Перем Настройки;

Перем ПередВыполнением;
Перем ПослеВыполнения;

Перем ВыключитьИБКМД;

&Желудь
&Характер("Компанейский")
Процедура ПриСозданииОбъекта(&Пластилин НастройкиРабочейОбласти)

	Настройки = НастройкиРабочейОбласти;

	Команда = Новый Команда;
	Команда.УстановитьКоманду("vrunner");

	ПередВыполнением = Новый Массив;
	ПослеВыполнения = Новый Массив;

	ВыключитьИБКМД = Ложь;

КонецПроцедуры

Функция ДобавитьПередВыполнением(Действие, Параметры = Неопределено) Экспорт

	ПередВыполнением.Добавить(Новый Структура("Действие, Параметры", Действие, Параметры));

	Возврат ЭтотОбъект;

КонецФункции

Функция ДобавитьПослеВыполнения(Действие, Параметры = Неопределено) Экспорт

	ПослеВыполнения.Добавить(Новый Структура("Действие, Параметры", Действие, Параметры));

	Возврат ЭтотОбъект;

КонецФункции

Функция ДобавитьПараметр(Параметр) Экспорт
	Команда.ДобавитьПараметр(Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция ВыключитьИБКМД() Экспорт
	ВыключитьИБКМД = Истина;
	Возврат ЭтотОбъект;
КонецФункции

Процедура ПередИсполнением()
	ОбработатьПодписки(ПередВыполнением);
КонецПроцедуры

Процедура ПослеИсполнения()
	ОбработатьПодписки(ПослеВыполнения);
КонецПроцедуры

Процедура ОбработатьПодписки(МассивПодписок)

	Для Каждого Подписка Из МассивПодписок Цикл
		Попытка
			Если Подписка.Параметры = Неопределено Тогда
				Подписка.Действие.Выполнить();
			Иначе
				Подписка.Действие.Выполнить(Подписка.Параметры);
			КонецЕсли;
		Исключение
			Сообщить("Ошибка выполнения подписки команды враннера: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;

КонецПроцедуры

Функция Исполнить() Экспорт

	Если НЕ ЗначениеЗаполнено(Настройки.СтрокаПодключения) Тогда
		ВызватьИсключение "Не указана строка подключения";
	КонецЕсли;

	Команда.ДобавитьПараметр("--ibconnection " + Настройки.СтрокаПодключения);

	Если ЗначениеЗаполнено(Настройки.ВерсияПлатформы) Тогда
		Команда.ДобавитьПараметр("--v8version " + Настройки.ВерсияПлатформы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Настройки.Пользователь) Тогда
		Команда.ДобавитьПараметр("--db-user " + Настройки.Пользователь);
	КонецЕсли;

	Если ЗначениеЗаполнено(Настройки.Пароль) Тогда
		Команда.ДобавитьПараметр("--db-pwd " + Настройки.Пароль);
	КонецЕсли;

	Если Не ВыключитьИБКМД И Настройки.ИБКМД = Истина Тогда
		Команда.ДобавитьПараметр("--ibcmd");
	КонецЕсли;

	Команда.ДобавитьПараметр("--nocacheuse");

	ПередИсполнением();

	Команда.Исполнить();

	ПослеИсполнения();

	Возврат Команда.ПолучитьВывод();

КонецФункции
