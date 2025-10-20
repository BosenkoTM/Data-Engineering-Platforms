# Платформы Data Engineering


- [Требования](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master?tab=readme-ov-file#%D1%82%D1%80%D0%B5%D0%B1%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F).
- [Подготовка к курсу по Analytics (Data) Engineering](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master?tab=readme-ov-file#%D0%BF%D0%BE%D0%B4%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D0%BA%D0%B0-%D0%BA-%D0%BA%D1%83%D1%80%D1%81%D1%83-%D0%BF%D0%BE-analytics-data-engineering).
- [Модуль 01 - Роль Аналитики](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module01/readme.md). ![Ready](https://img.shields.io/badge/-ready-green)
- [Модуль   - Базы данных и SQL](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module02/readme.md). ![Ready](https://img.shields.io/badge/-ready-green)
- [Модуль 02 - Интеграция и трансформация данных - ETL и ELT](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module04/readme.md#%D0%BC%D0%BE%D0%B4%D1%83%D0%BB%D1%8C-4--%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0%D1%86%D0%B8%D1%8F-%D0%B8-%D1%82%D1%80%D0%B0%D0%BD%D1%81%D1%84%D0%BE%D1%80%D0%BC%D0%B0%D1%86%D0%B8%D1%8F-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85---etl-%D0%B8-elt). ![Ready](https://img.shields.io/badge/-ready-green) 
- [Модуль 03 - Business Intelligence](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master/modules/Module03#%D0%BC%D0%BE%D0%B4%D1%83%D0%BB%D1%8C-3-%D0%B2%D0%B8%D0%B7%D1%83%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-%D0%B4%D0%B0%D1%88%D0%B1%D0%BE%D1%80%D0%B4%D1%8B-%D0%B8-%D0%BE%D1%82%D1%87%D0%B5%D1%82%D0%BD%D0%BE%D1%81%D1%82%D1%8C---business-intelligence). ![Ready](https://img.shields.io/badge/-ready-green) 
- [Модуль 04 - Cloud Computing](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master/modules/Module05). ![Ready](https://img.shields.io/badge/-ready-green)
- [Модуль    - Аналитические Хранилища Данных](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master/modules/Module06#%D0%BC%D0%BE%D0%B4%D1%83%D0%BB%D1%8C-6--%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D1%82%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B5-%D1%85%D1%80%D0%B0%D0%BD%D0%B8%D0%BB%D0%B8%D1%89%D0%B0-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85). ![Ready](https://img.shields.io/badge/-ready-green)
- [Модуль    - Знакомство с Apache Spark](). ![In Process](https://img.shields.io/badge/-in%20process-yellow)

## Требования
Несколько ключевых компонентов:
- доступ в интернет ;
- желательно экран 15" и больше;
- желательно 16 Gb оперативки (мин 8 Gb), иначе будет тормозить;
- операционные системы Windows, Maс, Linux;
- аккаунт github;
- знание английского на уровне чтения.

## Подготовка к курсу по Analytics (Data) Engineering

Давайте посмотрим на ключевые инструменты и навыки, которые мы будем осваивать. Не страшно, если вы не знакомы с чем-то из этого списка — мы пройдем все с основ.

> **_Примечание:_** Если вы чего-то не знаете, не беда, по ходу курса мы со всем познакомимся. Начиная с Excel в Модуле 1. Главное, что вам нужно для любой работы с данными — это **Excel** и **SQL**, так как данные почти всегда хранятся в таблицах.

-   **Excel**. Это универсальный стартовый инструмент. Если вы никогда с ним не работали, изучите базовые операции: работа с ячейками, формулы, фильтры. Таблицы Excel — отличная аналогия для понимания структуры баз данных. Мы также затронем сводные таблицы (Pivot Tables), которые являются прообразом BI-инструментов. С Excel мы познакомимся на **1-м модуле**.

-   **SQL**. Самый важный язык для аналитика и инженера данных. Несмотря на популярность Python/Scala, большинство компаний хранят данные в реляционных базах, и SQL — основной способ их извлечения. Мне нравится ресурс `sql-ex.ru`. Пройдите первые 30-40 упражнений, чтобы освоить `SELECT`, `JOIN`, `GROUP BY`, `ORDER BY` и подзапросы. Этого будет более чем достаточно для старта! Мы начнем использовать SQL на **модуле 2**.

-   **dbt (Data Build Tool)**. Это современный стандарт для трансформации данных прямо в хранилище. dbt позволяет инженерам и аналитикам применять лучшие практики разработки (версионирование, тестирование, документирование) к SQL-коду. Он превращает простые SQL-скрипты в надежный, тестируемый и переиспользуемый конвейер данных. Мы начнем работать с dbt на **модуле 4**, сразу после изучения основ SQL.

-   **CLI (Command Line Interface)**. Командная строка — важный навык, так как многие инструменты (Git, Docker, dbt) управляются через нее. Часто приходится работать с удаленными серверами на Linux без графического интерфейса. Вот отличный курс: [Introduction to Shell](https://www.datacamp.com/courses/introduction-to-shell). Мы начнем активно использовать CLI начиная с **модуля 3**.

-   **Docker**. Это технология, которая позволяет "упаковывать" приложения и их окружение в изолированные контейнеры. Забудьте о проблеме "а у меня на компьютере все работало"! Docker гарантирует, что ваше приложение будет работать одинаково везде. Это стандарт для развертывания и локальной разработки, особенно для таких инструментов, как Airflow. С основами Docker мы познакомимся на **модуле 4**.

-   **GitHub**. Мы используем GitHub как платформу для курса и для сдачи домашних заданий. Git — это система контроля версий, стандарт для совместной работы над кодом (включая SQL и Python). Убедитесь, что у вас есть аккаунт и вы понимаете базовые операции: `clone`, `commit`, `push`. Вот [инструкция на русском](http://bi0morph.github.io/hello-world/).

-   **Cloud**. Облачные платформы (AWS, GCP, Azure) позволяют быстро разворачивать масштабируемые аналитические решения, не закупая собственное "железо". Мы познакомимся с ключевыми облачными сервисами для хранения и обработки данных на **4-м модуле** курса.

-   **Python**. Главный язык для автоматизации, работы с API и продвинутой обработки данных, но не главнее SQL. С помощью Python можно делать все: от простых скриптов до сложных моделей машинного обучения. В работе инженера данных Python часто используется в связке с такими инструментами, как Apache Airflow и Spark. **Python нам понадобится в модуле 2** для автоматизации и оркестрации, а также в **модуле 4** для работы с Apache Spark.

## Домашнее задание
Почти каждый урок будет иметь домашнее задание.

Курс состоит из 4 модулей. Необходимо в Github создать папку `DEP-MGPU`, а внутри подпапки:
- Module01
- Module02
- ModuleXX

Если сделали домашнее задание, то в папку `DEP-MGPU` сможете добавить новый документ по шаблону.
