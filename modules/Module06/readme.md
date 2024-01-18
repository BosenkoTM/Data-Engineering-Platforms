# Модуль 6:  Аналитические Хранилища Данных

[Обратно в содержание курса :leftwards_arrow_with_hook:](https://github.com/BosenkoTM/Data-Engineering-Platforms?tab=readme-ov-file#%D0%BF%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D1%8B-data-engineering) 

В 6 модуле узнаем про аналитические и облачные хранилища данных которые используются в индустрии - Amazon Redshift, Microsoft Synapse, Google BigQuery или Snowflake. Но кроме облачных хранилищ есть еще много on-premise Teradata, Greenplum, Vertica, Exasol и тп. 

Темы:
- Основы аналитических хранилищ данных.
- MPP vs SMP.
- Облачные ETL инструменты.
- Обзор вакансий мирового рынка.
- Обзор решений для операционной аналитики - Splunk, Azure Data Explorer и ElasticSearch.

## Модуль 6.1 Введение

**Видео лекция - теория** - [Введение](https://youtu.be/yxNjsrePuqo). 

## Модуль 6.2 Что Такое Аналитическое Хранилище Данных?
В 95 процентах аналитических решений используется хранилище данных. Давайте будем считать, что это аналитическое хранилище данных. Но что это такое? Какие они бывают? Как давно они на рынке? На эти вопросы и другие я отвечу в это уроке. 

На этом уроке мы посмотрим фундаментальные вещи про хранилище данных, а на последующих уроках, мы будем уже пробовать различные решения хранилищ данных и ETL/ELT инструментов.  Практически каждый слайд можно трансформировать в вопрос для собеседования, и я сам, нираз, спрашивал на собеседованиях в Амазон эти вопросы на позицию инженера данных и bi разработчика.

Темы:
- История хранилищ данных
- База данных vs Хранилище данных
- Хранилище данных (DW) vs Платформа данных
- Характеристики хранилища данных
- Архитектура Shared Nothing vs Shared Everything
- Cloud vs On-premise Хранилища данных
- Облачная экономика на примере ETL jobs
- Open Source vs Commercial Хранилища данных
- Хранилища данных на базе существующей технологии (Postgres) или свои разработки
- Data warehouse as a Service или в ручную тюнить
- Современные и Legacy Хранилища данных
- OLTP vs OLAP
- ETL vs ELT
- Вендоры Хранилища данных на рынке (Gartner and Forrester)
- Сравнение скорости - benchmarking - TPC
- Benchmarking, отчет Gigaom и Fivetran по облачных хранилищам данных
- История Teradata
- Основы MPP Teradata, Data Distribution, Data Skew и Teradata CLI

**Видео лекция - теория** - [Что Такое Аналитическое Хранилище Данных?](https://youtu.be/JuQCUGUWqgU). 

### Вебинар от эксперта
- [GREENPLUM ЧТО ЗА ЗВЕРЬ И КАК ЕГО ПРИРУЧИТЬ](https://youtu.be/cVDIbEsCTow)

### Дополнительные материалы для изучения
- [Отчет по Gigaom DW Benchmarking](https://gigaom.com/report/data-warehouse-cloud-benchmark/)
- [Отчет Fivetran по DW Benchmarking](https://fivetran.com/blog/warehouse-benchmark)

Интересные статьи по теме (необязательно все читать, но можно ознакомиться, теперь вы точно будете знать ключевые слова по теме)
- [Что такое Teradata?](https://habr.com/ru/post/209078/)
- [Поколоночное и гибридное хранение записей в СУБД Teradata](https://habr.com/ru/company/teradata/blog/170321/)
- [Oracle vs Teradata vs Hadoop](https://habr.com/ru/post/235465/)
- [Из нагруженной MPP СУБД — бодрый Data Lake с аналитическими инструментами: делимся подробностями создания](https://habr.com/ru/company/vtb/blog/420141/)
- [Колоночные СУБД — принцип действия, преимущества и область применения](https://habr.com/ru/post/95181/)
- [Сравнение аналитических in-memory баз данных](https://habr.com/ru/company/tinkoff/blog/310620/)
- [Колоночные СУБД против строчных, как насчет компромисса?](https://habr.com/ru/post/413051/)
- [Тестирование производительности Oracle In-Memory Option c использованием TPC-H Benchmark](https://habr.com/ru/post/317774/)
- [HP Vertica, первый запущенный проект в РФ, опыт полтора года реальной эксплуатации](https://habr.com/ru/post/190740/)
- [Business Intelligence на очень больших данных: опыт Yota](https://habr.com/ru/company/yota/blog/541266/)
- [HP Vertica, проектирование хранилища данных, больших данных](https://habr.com/ru/post/227111/)
- [Просто и доступно о аналитических БД](https://habr.com/ru/post/149641/)

### Лабораторная работа 6.1
1. Установить виртуальную мащину [Teradata DW](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module06/DE%20-%20101%20Labs/Teradata/Teradata%20Lab.md), скачать ее и настроить доступ через конфигурацию сети.
2. Загрузить данные через CLI инструмент и подключить Power BI. Получить полноценное аналитическое решение (портативное), которое работает во многих компаниях.
3. Использовать Pentaho DI, чтобы добавить ETL компомент в ваше аналитическое решение. Реализовать одно из заданий цикла лабораторных работ из темы 4.

**Видео лекция - практика** - [Что Такое Аналитическое Хранилище Данных? - практика](https://youtu.be/JuQCUGUWqgU?t=2766). 


## Модуль 6.3 Основы Amazon Redshift
Мы начнем наше погружение в современный мир аналитических хранилищ данных с Amazon Redshift. Этот продует появился в 2012 году и породил целую индустрию облачных продуктов и решений. Сам по себе Redshift прост и удобен, и если вы в облаке AWS, то скорей всего вы будете использовать Amazon Redshift. Я использовал его много раз на различных проектав в Амазоне и за пределами, и он никогда не подводил. С развитием другой облачной DW, в последние годы, Redshift получил много новых фич, такие как ML, разделение storage&compute, и многое другое.

Из видео вы узнаете:
- В чем заключается роль Инженера Данных
- В чем заключается роль BI инженера
- История Amazon Redshift
- S curve в технологическом прогрессе
- Решение по аналитики мобильного приложения на Amazon Redshift
- Решения миграции с Oracle DW на Amazon Redshift в Амазоне
- Дизайн таблиц и оптимизация производительности в Amazon Redshift
- Способы загрузки данных в Amazon Redshift (COPY, Bulk Insert, Row Insert)
- Работа с ETL или ELT для Amazon Redshift
- Утилиты для адмиинстрирования и мониторинга Amazon Redshift
- Встроенный ML для Amazon Redshift
- Про главный недостаток Amazon Redshift - колличество одновременных сессий
- Про Хранилище данных Амазон Алекса и трудности масштабирования
- Несколько примеров архитектуры из индустрии

**Видео лекция - теория** - [Основы Amazon Redshift](https://youtu.be/K0TOh-Pl3q0). 

### Вебинар от эксперта
- [Путь Инженера Аналитики: Решение для Маркетинга / Артемий Козырь](https://youtu.be/SoOcvYPSm7o)

### Дополнительные материалы для изучения
- [Amazon Redshift Paper](https://homepages.cwi.nl/~manegold/UvA-ABS-MBA-BDBA-ISfBD/p1917-gupta.pdf)
- [Статья про S кривую и начало развития индустрии - The Modern Data Stack: Past, Present, and Future](https://blog.getdbt.com/future-of-the-modern-data-stack/)
- [Статья 2012 года! - Amazon Redshift: новое хранилище данных на петабайты ](https://habr.com/ru/post/160653/)
- [Мое выступление про 5 лет в Амазон](https://youtu.be/1lUhmSPdIJs)
- [Мое выступление на матемаркетинге 2018 года -  Роль BI-систем и DWH в маркетинге. Архитектура и кейсы](https://youtu.be/MVp7eTdwEyA)
- [Amazon Redshift Admin утилиты](https://github.com/awslabs/amazon-redshift-utils)
-[Мой пост про новое поколение Redshift - Meet a new generation of Redshift Data Platform — RA3](https://medium.com/rock-your-data/meet-a-new-generation-of-redshift-data-platform-ra3-e65544920866)
- [AWS Online Tech Talks - Getting Started with Amazon Redshift - AWS Online Tech Talks](https://youtu.be/dfo4J5ZhlKI)
- [AWS Redshift Architecture: Clusters & Nodes & Data Apps, oh my](https://www.intermix.io/blog/amazon-redshift-architecture/)
- [Гид по параллельному масштабированию Amazon Redshift и результаты тестирования](https://habr.com/ru/company/skyeng/blog/451538/)
- [Аналитический движок Amazon Redshift + преимущества Облака](https://habr.com/ru/company/wheely/blog/539154/)
- [Мое выступление в КРОК - Pizza as a service: как Amazon на Redshift мигрировал](https://habr.com/ru/company/croc/blog/481836/)

## Модуль 6.4 Основы Azure Synapse для Хранилища данных
У Microsoft тоже есть облако Azure, и в нем есть целая платформа для аналитики, которая называется Azure Synapse Analytics. В него входят уже устоявшиеся инструменты Azure SQL Data Warehouse (теперь называется Dedicated SQL Pool), Azure Data Factory, Azure ML, Power BI Service, так и были добавлены новые Azure Spark Pools, Serverless SQL Pool. Все достаточно удобно, каждый инструмент легко интегрируется с решениями Azure. Если вы работаете с решениями Microsoft, то облако Azure это следующий логический шаг вашего развития. Так же Azure Synapse способен заменить решения Azure HDInsights и Azure Databricks (решения для big data). По опыту я знаю и видел огромное количество решений на Microsoft SQL Server (on-premise), но вообще не знаю ниодного решения на Azure Synapse, но уверен скоро их появится много.


В этом видео мы:
- Посмотрим на история Azure хранилища данных
- Узнаем про стратегию создания продуктов Microsoft
- Узнаем про переход от Azure SQL Data warehouse к Azure Synapse Analytics
- Познакомимся с Azure Synapse Analytics: Deidcated SQL Pools, Spark Pools, Serverl SQL Pools
- Azure Synapse Serverless Pools vs Amazon Redshift Spectrum
- Посмотрим на пример архитектурты Azure Data Platfrom и узнаем какие инстурменты есть в Azure для аналитики
- Детально посмотрим на особенности Azure Dedicated SQL Pools (бывшее Azure SQL DW), узнаем, что внутнри и как с ним работать и оптимизировать (distribution stiles, indexes, statistics)
- Узнаем, что такое PolyBase или как загружать данные из Azure Hadoop
- Узнаем про Azure Data Factory
- Поговорим про бесполезность и полезность Azure Analyses Services
- Поговорим про конкуренция Azure Databricks и Azure Synapse Spark pools

**Видео лекция - теория** - [Знакомство с Azure Synapse](https://youtu.be/gQAGa3xZr_M)

**Видео лекция - практика** - [Демонстрация Azure Synapse Workspace и лабораторных работ с DW in a Day воркшопа](https://youtu.be/gQAGa3xZr_M?t=3082)

### Дополнительные материалы для изучения
- [Synapse Tutorials](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started)
- [Azure Naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Azure SQL DW paper - POLARIS: The Distributed SQL Engine in Azure Synapse](https://www.vldb.org/pvldb/vol13/p3204-saborit.pdf)
- [Моя статья для Matillion ETL - Creating a Modern Data Platform with Azure Synapse Analytics and Matillion ETL](https://www.matillion.com/resources/blog/creating-a-modern-data-platform-with-azure-synapse-analytics-and-matillion-etl)
- [Статья про Azure Synapse от Medium блоша Towards Data Science](https://towardsdatascience.com/tagged/azure-synapse-analytics)
- [Azure Synapse for Data Analytics — Create Workspaces with CLI](https://medium.com/microsoftazure/azure-synapse-for-data-analytics-create-workspaces-with-cli-bd5ef90fd489)
- [Introduction to Azure Synapse Analytics](https://medium.com/codex/introduction-to-azure-synapse-analytics-ff317e782f7b)
- [Azure Analytics: ясность в мгновение ока](https://habr.com/ru/company/microsoft/blog/503582/)

## Модуль 6.5 Основы Snowflake
Анилитическое хранилище данных Snowflake появилось в 2015 году и порвало всех конкурентов - on-premise (Oracle, Teradata, Netezza и др) и облачных (Redshift, Azure SQL DW, BigQuery). 


Продукт был создан с 0я выходцами и Оракл и они понимали проблемы индустрии и знали о возможностях облачных вычислений. И подарили нам замечательный продукт, где при помощи SQL, мы можем обрабатывать терабайты данных и не думать слишком много об организации данных. 

Snowflake одноверменно SMP и MPP, если вы смотрели другие уроки этого модуля, то вы должны знать, что это!;) Огромное спасибо команде снежинки за то, что они дали огромный пинок всей индустрии и заставили других вендоров шевелиться и улучшать их продукты. В Северной Америки снежинка в топе хранилищ данных среди организций и больше половины организаций от мало до велика использую снежинку как свое хранилище данных. 

Кстати, а вы знали, что Snowflake - это Lakehouse - смесь хранилища данных и озера данных? Теперь точно знаете!:) 
В этом видео вы узнает про:
- История Snowflake
- Материалы по изучения продукта
- Выход на IPO
- Кейсы миграции
- Архитектуру и особенности снежинки
- О продукта экосистемы снежники - SnowCLI, SnowPipe, SnowSight, SnowPark
- Ключевые фичи - Time Travel, Data Sharing, Zero Cloning
- Экосистему партнеров и конкурентов снежинки

**Видео лекция - теория** - [Основы Snowflake - The Elastic Data Warehouse](https://youtu.be/CzrOa15QbWk)

На hands-on работе:
- Я вам покажу как создать бесплатный кластер снежинки
- Загрузить данные SuperStore в хранилище данных
- Создать Database, Stage, IAM user (AWS)

**Видео лекция - практика** - [Демонстрация Snowflake](https://youtu.be/CzrOa15QbWk?t=2768)

### Вебинар от эксперта
- [SNOWFLAKE ИЛИ КАК БД ВЫБИРАЛИ / НИКОЛАЙ ГОЛОВ / MANYCHAT](https://youtu.be/XJa3gGWidg0)
- [DataVault / Anchor Modeling / Николай Голов](https://youtu.be/-ZgzpQXsxi0)
- [ЧАСТЬ 2 DataVault Anchor Modeling / Николай Голов](https://youtu.be/IZw1cB1uDts)

## Дополнительные материалы для изучения

- [The Snowflake Elastic Data Warehouse Paper](http://pages.cs.wisc.edu/~yxy/cs839-s20/papers/snowflake.pdf)
- [Snowflake, Anchor Model, ELT и как с этим жить](https://habr.com/en/company/manychat/blog/530054/)
- [Обзор первого эластичного хранилища данных Snowflake Elastic Data Warehouse](https://habr.com/en/company/lifestreet/blog/270167/)
- [Пример архитектуры аналитического решения с использованием платформы Snowflake](https://habr.com/en/company/epam_systems/blog/555102/)
- [Руководство по аналитике для основателя стартапа](https://habr.com/en/post/346326/)
- [Вебинар ДатаЛерн SNOWFLAKE ИЛИ КАК БД ВЫБИРАЛИ / НИКОЛАЙ ГОЛОВ / MANYCHAT](https://youtu.be/XJa3gGWidg0)

### Практикум

В качестве лабораторной работы вы можете:
- Выполнить оффициальные [tutorial Snowflake](https://www.snowflake.com/snowflake-essentials-training/), но уже переведнный Сергеем для вас - [Snowflake Workshop](https://github.com/Data-Learn/data-engineering/blob/master/DE-101%20Modules/Module06/DE%20-%20101%20Labs/Snowflake/snowflake-lab.md)
- Сделать близкий к реальному кейс с SalesForce, Fivetran, Snowflake, Tableau - [Zero To Snowflake](https://github.com/DecisiveData/ZeroToSnowflake)
- Зарегистрироваться и пройти бесплатные курсы [Snowflake Data Academy](https://www.snowflake.com/data-cloud-academy/)

## Модуль 6.6 Обзор современных ETL/ELT инструментов
ETL(ELT) инструменты нам нужны, чтобы наполнять наше хранилище данных, ну или платформу данных. Для современных аналитических инструментов лучше использовать современные инструменты интеграции. Прежде чем выбирать инструмент, нужно понимать фундаментальные основы построения аналитического решения, его слои и компоненты, разницу между ETL и ELT, между Batch и Stream, между on-premise и cloud и многое другое. Задача инженера данных выбрать правильное решение для обработки и хранения данных.

В этом видео:
- Рассмотрим простой пример интернет-магазина и необходимости интеграции данных и аналитического решения
- Что такое Data Pipeline?
- ETL App или Coding? (Python, Scala и тп)
- ETL on-premise и Cloud (AWS, Azure, GCP)
- ETL разработчик или Data Engineer
- Open Source or Not Open Source
- Архитектура современного решения с использованием On-premise tools
- Архитектура современного решения с использованием коммерческих продуктов
- Обзор решений западного рынка
- Пример ETL vs ELT с использованием Pentaho DI и Redshift
- ETL Job = DAG (Direct Acyclic Graph)
- Обзор решений: MatillionETL, Fivetran, Apache Airflow, Azure Data Factory, AWS Glue 

**Видео лекция - теория** - [Основы Snowflake - The Elastic Data Warehouse](https://youtu.be/4PA6IPO4P1A)

На лабораторной работе я покажу как запустить Matillion ETL, DBT cloud, Talend, Informatica, ETL Leap, Qlikview через Snowflake Partner Connect. Особенно детально я покажу как выглядит Matillion ETL и как вы можете выполнить задание 4го модуля по Superstore Star Schema (dimensional modelling) в Matillion ETL. 

**Видео лекция - практика** - [Запуск ETL/ELT из Snowflake Partner Connect](https://youtu.be/4PA6IPO4P1A?t=2835)


### Дополнительные материалы для изучения
- [Вебинар Data Learn - Введение в Apache Airflow](https://youtu.be/cVDIbEsCTow)
- [Код для вебинара](https://github.com/dmitry-brazhenko/airflow_tutorial)
- [Презентация вебинара](https://docs.google.com/presentation/d/1fpKEyoZul6hz2wR4idvHF1FGSoG078TMwwvm3f0yQeI/edit#slide=id.gf7633a37fa_0_20)

### Вебинар от эксперта
- [ВВЕДЕНИЕ В AIRFLOW / ПОНЯТИЕ DAG'а / НАСТРОЙКА DAG'а В AIRFLOW](https://youtu.be/cVDIbEsCTow)
- [ВВЕДЕНИЕ В ДОКЕР КОНТЕЙНЕР / DOCKER / ДМИТРИЙ БРАЖЕНКО](https://youtu.be/JQCTjz_PzSM)


### Лабораторная работа 6.2
Для лабораторной работы вам нужно:
	- Любое современное хранилище данных: Snowflake, Redshift, Synapse, BigQuery, Firebolt.
	- ETL/ELT инструмент.
	- BI.

1. Вам нужно загрузить данных из S3/Azure Storage/Google Storage в DW - Staging (вы можете использовать данные Superstore из модуля 4).
2. Преобразовать данные из Staging в Fact таблицу(ы) и таблицы измерений.
3. Подключить BI инструмент (JDBC/ODBC драйвер).
4. Нарисовать архитектуру решения в Draw.io.

## Модуль 6.7 Анти SQL решения для операционной аналитики

В этом уроке мы узнаем про термин Операционная Аналитика, и чем он отличается от традиционной аналитики. Заодно мы посмотрим на три самых популярных решения на рынке – Splunk, Azure Data Explorer и Kusto. Если кратко, то такие системы и решения не являются главными для Инженера Данных или BI инженера. Для BI инженера операционная аналитика – это про еще один источник данных, с которым придется работать. А для инженера данных, решения операционной аналитики могут был полезны по многим причинам, мы можем собирать машинные данные (логи) о работе наших data pipelines, ETL, Big Data и тп, мы можем забирать данные из решений операционной аналитики и загружать в хранилище данных или озеро. А иногда, нас просят создать NoSQL решение данных на основе Elastic Stack. 

В этом видео вы узнаете:

- Что такое операционная аналитика и ее роль в решениях BI/DW/BigData
- Основы и историю Splunk
- Про Azure Data Explorer и Kusto
- Про Elastic Stack
- Основные кейсы использования операционной аналитики и примеры из опыта
**Видео лекция - теория** - [Анти SQL решения для операционной аналитики](https://youtu.be/uDwgJGYI8Mw)

На лабораторной работе я покажу как Splunk и Azure Data Explorer.

**Видео лекция - практика** - [Анти SQL решения для операционной аналитики - демо](https://youtu.be/uDwgJGYI8Mw?t=2349)

### Вебинар от эксперта
- [ADX(KUSTO): INTERACTIVE BIG DATA ANALYTICS / GOR HAYRAPETYAN](https://youtu.be/CAdkL9vM6Do)

### Дополнительные материалы для изучения

- [Вебинар Data Learn про Azure Data Explorer](https://youtu.be/CAdkL9vM6Do)
- [Elastic Search Tutorial]( https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html)
- [Splunk Tutorial]( https://docs.splunk.com/Documentation/Splunk/8.2.3/SearchTutorial/WelcometotheSearchTutorial)
- [Splunk уходит из России (совсем)](https://habr.com/ru/post/441004/)
- [Год без Splunk — как американская компания изменила рынок аналитики машинных данных в РФ и кого оставила после себя](https://habr.com/ru/post/484904/)
- [Splunk — общее описание платформы, базовые особенности установки и архитектуры]( https://habr.com/ru/company/tssolution/blog/323814/)
- [Quickstart: Create an Azure Data Explorer cluster and database](https://docs.microsoft.com/en-us/azure/data-explorer/create-cluster-database-portal)
- [1.Elastic stack: анализ security логов. Введение]( https://habr.com/ru/company/tssolution/blog/480570/)
- [2. Elastic stack: анализ security логов. Logstash]( https://habr.com/ru/company/tssolution/blog/481960/)
- [3. Elastic stack: анализ security логов. Дашборды]( https://habr.com/ru/company/tssolution/blog/482054/)

### Лабораторная работа 6.3

1. Установить [Elastic Search]( https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html), загрузить данные и визуализировать результат.

