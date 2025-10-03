# Модуль 3. Визуализация данных, дашборды и отчетность - Business Intelligence.

[Обратно в содержание курса :leftwards_arrow_with_hook:](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master?tab=readme-ov-file#%D0%BF%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D1%8B-data-engineering) 

В 3-ем модуле вы узнаете про системы Business Intelligence. Рассмотрим примеры из реальной жизни, популярные инструменты BI - Tableau, Power BI и другие. Научимся создавать отчетность и поговорим про лучшие практики визуализации данных и ее применении для пользы бизнеса.


## 3.1 Введение 

**Видео лекция** - [Введение](https://youtu.be/sj2qRK7NRMQ) 

## 3.2 Что такое Business Intelligence (BI)

**Видео лекция - теория** - [Что такое BI?](https://youtu.be/8dcISZnrlcw) 

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения

1. [Короткое видео - что такое BI на примере Lamoda BI Academy и SAP Business Objects](https://youtu.be/xYExt37a9Qg) (Русский)
2. [Business Intelligence: принципы, технологии, обучение](https://habr.com/ru/post/134031/) (Русский)
3. [Что такое BI?](https://habr.com/ru/company/navicon/blog/250875/) (Русский)
4. [What is business intelligence? Transforming data into business insights](https://www.cio.com/article/2439504/business-intelligence-definition-and-solutions.html) (English)
5. [What is business intelligence? Your guide to BI and why it matters](https://www.tableau.com/learn/articles/business-intelligence) (English)
6. [Курс Data Warehousing for Business Intelligence Specialization](https://www.coursera.org/specializations/data-warehousing) (English)
7. [Книга Hyper: Changing the way you think about, plan, and execute business intelligence for real results, real fast!](https://www.amazon.ca/Hyper-Changing-execute-business-intelligence-ebook/dp/B011MXBW96/ref=sr_1_17?crid=LHAXKU4X0H3Y&dchild=1&keywords=business+intelligence&qid=1594192470&sprefix=business+intel%2Caps%2C208&sr=8-17) (English)
</details>

## 3.3 Обзор рынка решений BI

**Видео лекция - теория** - [Рынок BI?](https://youtu.be/CKDGGOzYg9w) 

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>

### Дополнительные материалы для изучения

1. [Куда движется рынок BI-аналитики в 2019 году](https://habr.com/ru/post/475470/) (Русский)
2. [Топ-10 технологических трендов в обработке данных и аналитике в 2019 году по мнению Gartner](https://habr.com/ru/company/otus/blog/457450/) (Русский)
3. [Технические отличия BI систем (Power BI, Qlik Sense, Tableau)](https://habr.com/ru/post/444758/) (Русский)
4. [Gartner BI отчет 2020 оригинал](https://www.tableau.com/reports/gartner) (English)
5. [Forrester 2019 Enterprise BI Platform Wave™ Evaluations — Research Update](https://go.forrester.com/blogs/enterprise-bi-platform-waves/) (English)
</details>

## 3.4 2 Типа решений BI

**Видео лекция - теория** - [2 типа решений BI?](https://youtu.be/VklEzWpFZIk) 

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения

1. [Traditional vs. Self-Service BI: Analytics Alternatives Explained](https://www.softwareadvice.com/resources/traditional-bi-vs-self-service/) (English)
2. [Презентация Tool Comparison: Enterprise BI vs Self-Service Analytics: Choosing the Best Tool for the Job](https://www.slideshare.net/senturus/tool-comparison-enterprise-bi-vs-selfservice-analytics-choosing-the-best-tool-for-the-job) (English)
3. [Семь раз отмерь, один раз внедри BI инструмент](https://habr.com/ru/company/ods/blog/460807/) (Русский)
</details>

## 3.5 Ох уж эти кубы (Molap vs Rolap)

Когда мы работаем с аналитикой мы часто слышим про кубы. Если честно, кубами и OLAP называют все в подряд без разбора, включая BI и хранилище данных. Давайте решим, что для нас OLAP куб это MOLAP, закэшированные данные в файле или in-memory, где мы используем язык MDX для работы с ними по средством Excel или BI инструмента. А все остальное пусть будет ROLAP или просто классический BI. Чем я и пользуюсь, например в Tableau. MDX я тоже не знаю и не собираюсь его использовать.


**Видео лекция - теория** - [Ох уж эти кубы (Molap vs Rolap)](https://youtu.be/FWEQYomEbqw) 

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения

1. [Введение в многомерный анализ](https://habr.com/ru/post/126810/) (Русский)
2. [Многомерные кубы, OLAP и MDX](https://habr.com/ru/post/66356/) (Русский)
3. [Запуск OLAP-сервера на базе Pentaho по шагам](https://habr.com/ru/post/187782/) (Русский)
</details>

## 3.6 Из чего состоит любой BI инструмент?

Мы рассматриваем Business Intelligence как класс инструментов для создания аналитического решения и коммуникации с бизнес пользователями. Существует огромное кол-во инструментов BI, но если посмотреть поближе, они все похожи и имею много общего.


**Видео лекция - теория** - [Из чего состоит любой BI инструмент?](https://youtu.be/vtGjvKjZpmU) 

## 3.7 Основы визуализации данных
Визуализация данных это неотъемлемая часть любого BI решения. Эксперты пишут книги, университеты готовят специалистов и все для того, чтобы научить нас эффективно коммуницировать данные с конечным пользователем. Каждый раз когда вы будет создавать дашборд или строить отчет, вы должны задуматься о том, как лучше рассказать историю на основе данных и какой метод визуализации использовать.

**Видео лекция - теория** - [Основы визуализации данных](https://youtu.be/zUpKIFFy-ok) 

**Запись вебинара c Экспертом** 
[Алгоритм проектирования дашборда / Роман Бунин](https://youtu.be/xSp5ykKcQho)

<details>
<summary>  Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>

1. [Вебинар DataLearn: Алгоритм Проектирования Дашборда с Романом Буниным](https://youtu.be/xSp5ykKcQho) (Русский)
2. [10 примеров визуализации из истории](https://www.tableau.com/learn/articles/best-beautiful-data-visualization-examples) (English)
3. [Влияние цвета на качество визуализации](https://hbr.org/2014/04/the-right-colors-make-data-easier-to-read) (English)
4. [Хорошая визуализация должна быть скучной](https://everydayanalytics.ca/2015/10/good-data-visualization-should-be-boring.html) (English)
5. [Курс ВШЭ - Основы анализа и визуализация данных для медиа 2019/2020](http://wiki.cs.hse.ru/%D0%9E%D1%81%D0%BD%D0%BE%D0%B2%D1%8B_%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0_%D0%B8_%D0%B2%D0%B8%D0%B7%D1%83%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D1%8F_%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85_%D0%B4%D0%BB%D1%8F_%D0%BC%D0%B5%D0%B4%D0%B8%D0%B0_2019/2020#.D0.9C.D0.B0.D1.82.D0.B5.D1.80.D0.B8.D0.B0.D0.BB.D1.8B_.D0.BA.D1.83.D1.80.D1.81.D0.B0) (Русский)
6. [Специализация на Coursera - Information Visualization Specialization](https://www.coursera.org/specializations/information-visualization) (English)
7. [Курс на Coursera - Data Analysis and Presentation Skills: the PwC Approach Specialization](https://www.coursera.org/specializations/pwc-analytics) (English)
8. [Курс на Coursera - Data Visualization with Advanced Excel](https://www.coursera.org/learn/advanced-excel) (English)
9. [Курс на Coursera - Data Visualization and Communication with Tableau](https://www.coursera.org/learn/analytics-tableau) (English)
10. [Как не врать с помощью статистики: основы визуализации данных](https://habr.com/ru/company/pixonic/blog/453828/) (Русский)
</details>


## 3.8 Знакомство с BI Tableau Desktop

**Видео лекция - теория** - [Знакомство с Tableau Desktop](https://youtu.be/QY1FYMnxElw) 

**Видео лекция - практика** - [Демонстрация Tableau Desktop](https://youtu.be/QY1FYMnxElw?t=2710) 

**Запись вебинара c Экспертом** 
[АДАПТИВНАЯ ВЕРСТКА ДАШБОРДОВ В ТАБЛО / РОМАН БУНИН](https://youtu.be/GE1czOiI-8o)

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>

1. [Tableau Tutorial](https://help.tableau.com/current/guides/get-started-tutorial/en-us/get-started-tutorial-home.htm) (English)
2. [Как создать Sparkline в Tableau](https://www.vizwiz.com/2015/09/kpisandsparklines.html) (English)
3. [Обзор 43 графика за 50 минут](https://www.vizwiz.com/2017/10/43-charts-in-50-minutes.html) (English)
4. [Шаблон 5 дашбордов](http://duelingdata.blogspot.com/2019/01/5-types-of-dashboards.html) (English)
5. [Курс на Coursera - Data Visualization and Communication with Tableau](https://www.coursera.org/learn/analytics-tableau) (English)
6. [Примеры работ в Tableau - Tableau Zen Мастером](https://photos.google.com/share/AF1QipPtbvxIRuoBESlPztSPTsryjD0ehd8SmpLBHp4aKdpUu0vcVqLZZP81DH1uzoRzKA?key=THpkYTRRT2JKU1ZVQzJBdTh4UDF6T3FoWVB0MUVn) (English)
7. [Соревнования по Tableau - Iron Viz](https://www.tableau.com/iron-viz) (English)
8. [Как создать Sankey график](https://www.flerlagetwins.com/2018/04/sankey-template.html) (English)
</details>

### Практическая работа 3.1 Проектирование и настройка дашборда для бизнес-пользователей.

 - [Практическая работа 3.1 Проектирование и настройка дашборда для бизнес-пользователей](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module03/pw_3_1_2025.md)

## 3.9 Знакомство с Power BI

[Эдгар Лакшин](https://www.linkedin.com/in/edgar-lakshin-b9386b22/) записал для вас интересную лекцию по Power BI, где вы можете познакомиться с этим BI инструментом.

**Видео лекция - теория** - [Знакомство с Power BI](https://youtu.be/6no5xbpF3_o) 

**Видео лекция - практика** - [Демонстрация Power BI](https://youtu.be/6no5xbpF3_o?t=524)

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения

1. [Что такое Power BI от Microsoft](https://powerbi.microsoft.com/ru-ru/what-is-power-bi/) (Русский)
2. [Официальная документация про Power BI](https://docs.microsoft.com/ru-ru/power-bi/guidance/) (Русский)
3. [Самый крутой YouTube канал про Power BI - Guy in a Cube](https://www.youtube.com/channel/UCFp1vaKzpfvoGai0vE5VJ0w) (English)
</details>

## 3.10 BI опросы или как управлять клиентским опытом BI пользователей

Один из главных принцип лидерства ([Leadership Principles](https://www.amazon.jobs/en/principles)) в Амазон - Любовь к Клиентам (Customer Obsession). Да и не только у Амазона, многие компании являются клиентоориентированными. 

Когда мы внедряем или сопровождаем аналитическое решение, мы тоже должны быть customer obsession. Только для нас клиенты - это пользователи BI решения. Лучший способ узнать у коллег - провести опрос и визуализировать результат. Таким образом вы сможете собрать обратную связь, быть проактивным и приоритизировать или выявить ключевые проблемы у ваших пользователей, которые вы сможете решить. Таким образом, вы повысите клиентский опыт и у вас будет, что рассказать вашему руководителю или другой компании на собеседовании. ;)

**Видео лекция - теория** - [ Voice of Customers (опросы  пользователей аналитического решения)](https://youtu.be/kKI5PMVC6A4) 

### Дополнительные материалы для изучения

1. [Визуализацию опросов в Tableau](https://www.datarevelations.com/visualizing-survey-data/) (English)
2. [How to measure Customer Satisfaction](https://blog.hubspot.com/service/how-to-measure-customer-satisfaction) (English)
</details>

### Лабораторная работа 3.1 Создание интерактивного аналитического дашборда на основе витрин данных

Разработать, провести и проанализировать опрос по актуальным темам `Data Engineering`, применяя полученные знания на практике.

#### Содержание задания
1. **Подготовка опроса:**
   - Создайте опрос, используя Google Forms (https://forms.google.com/) или Survey Monkey (https://www.surveymonkey.com/).
   - Тематика опроса должна быть связана с одной из предложенных тем (см. таблицу ниже).

2. **Материалы для подготовки вопросов:**
   - [The Rise of the Data Engineer](https://www.freecodecamp.org/news/the-rise-of-the-data-engineer-91be18f1e603/) от Maxime Beauchemin
   - [Gartner Data Management Blog](https://blogs.gartner.com/andrew_white/category/data-management/)
   - [Fundamentals of Data Engineering (O'Reilly)](https://www.oreilly.com/library/view/fundamentals-of-data/9781098108298/)
   - [Data Engineering Podcast](https://www.dataengineeringpodcast.com/)

4. **Требования к опросу:**
   - 10-15 вопросов различных типов (множественный выбор, шкала, открытые вопросы).
   - Минимум 5 респондентов (коллеги по работе, сокурсники или профессиональное сообщество).
   - Вопросы должны быть сформулированы четко и профессионально.

5. **Анализ результатов:**
   - Соберите ответы и проведите базовый анализ данных.
   - Создайте минимум 3 визуализации полученных результатов (графики, диаграммы).
   - Сформулируйте 3-5 основных выводов на основе полученных данных.

6. **Документация и сохранение:**
   - Загрузите в Git-репозиторий:
     1. PDF-версию созданного опроса или скриншоты всех страниц.
     2. Экспортированные данные результатов (CSV/Excel).
     3. Jupyter Notebook или R Markdown с анализом и визуализацией результатов.
     4. README.md с описанием проекта, процесса и основных выводов.

#### Варианты тем для опроса

| № | Тема для опроса |
|---|----------------|
| 1 | Современные ETL/ELT инструменты и их эффективность |
| 2 | Проблемы качества данных в корпоративной среде |
| 3 | Хранилища данных: современные подходы и архитектуры |
| 4 | Технологии Big Data в бизнес-процессах |
| 5 | Data Governance: практики и вызовы |
| 6 | Роль Data Engineer в современной организации |
| 7 | Облачные решения для работы с данными |
| 8 | Реализация Data Lake в компаниях |
| 9 | Проблемы безопасности данных в Data Engineering |
| 10 | Автоматизация процессов работы с данными |
| 11 | Data Mesh: принципы и применение |
| 12 | Технический долг в системах работы с данными |\n| 13 | Batch vs Real-time processing: выбор подхода |
| 14 | Интеграция данных из разнородных источников |
| 15 | Метаданные и их управление |
| 16 | Версионирование данных и кода в Data Engineering |
| 17 | MLOps и его связь с Data Engineering |
| 18 | Мониторинг пайплайнов данных |
| 19 | Масштабирование систем хранения и обработки данных |
| 20 | Организация командной работы в Data Engineering проектах |
| 21 | Data Catalog: внедрение и использование |
| 22 | Оптимизация производительности запросов и пайплайнов |
| 23 | Оркестрация рабочих процессов с данными |
| 24 | Микросервисная архитектура для работы с данными |
| 25 | Serverless архитектура в Data Engineering |
| 26 | Стратегии обработки ошибок в пайплайнах данных |
| 27 | DataOps: практики и инструменты |
| 28 | Тестирование в Data Engineering |
| 29 | Обработка потоковых данных: инструменты и подходы |
| 30 | Управление затратами в системах работы с данными |
| 31 | Этические аспекты работы с данными |
| 32 | Компетенции современного Data Engineer |
| 33 | Изменение данных (CDC): методы и инструменты |
| 34 | Интеграция AI/ML в процессы Data Engineering |
| 35 | Внедрение Data Mesh в организации |

#### Критерии оценки
- Качество и релевантность вопросов (30%).
- Глубина анализа полученных данных (30%).
- Качество визуализаций (20%).
- Оформление документации и Git-репозитория (20%).

#### Дополнительные рекомендации
- При недостатке респондентов можно использовать профессиональные сообщества в LinkedIn или специализированные форумы.
- Для визуализации можно использовать Python (matplotlib, seaborn, plotly), R (ggplot2) или Power BI/Tableau.
- При отсутствии возможности провести опрос на работе, создайте гипотетический набор данных с обоснованием предполагаемых результатов.

#### В ответ предоставить ссылку на  Git-репозиторий:
     1. PDF-версию созданного опроса или скриншоты всех страниц.
     2. Экспортированные данные результатов (CSV/Excel).
     3. Jupyter Notebook или R Markdown с анализом и визуализацией результатов.
     4. README.md с описанием проекта, процесса и основных выводов.

### 3.10 Требования к BI разработчику/инженеру

Мы уже изучили достаточно, чтобы перейти к более серьезным шагам. То есть 3х модулей, который вы могли пройти будет достаточно, чтобы найти работу BI разработчика. Мы говорили про много вещей - BI, SQL, базы данных, задачи аналитики и BI разработчика, посмотрели примеры решений. Так же я вам давал много вспомогательных материалов, чтобы у вас нарисовалась картинка - кто такой BI разработчик и какие у него обязанности. Инструмент BI это уже 2ой приоритет. В этом видео я поделюсь с вами очень ценной и полезной информацией, на базе своего 10ти летнего опыта в индустрии. Сам я проходил много собеседований по всему миру и так же собеседовал много людей для Амазона.

**Видео лекция - теория** - [Требования к BI разработчику](https://youtu.be/DxRTAqpjowY) 


<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения

1. [Indeed Worldwide](https://youtu.be/DxRTAqpjowY) (English)
2. [Методика STAR для прохождения структурированных собеседований](https://hr-portal.ru/story/metodika-star-dlya-prohozhdeniya-strukturirovannyh-sobesedovaniy) (Русский)
3. [О собеседовании в Амазон](https://medium.com/@allo/%D0%BE-%D1%81%D0%BE%D0%B1%D0%B5%D1%81%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B8-%D0%B2-%D0%B0%D0%BC%D0%B0%D0%B7%D0%BE%D0%BD-27e649323c4b) (Русский)
</details>

## 3.13 Обзор "модных" решений для визуализации и отчетности (Fancy BI tools)

На рынке существует огромное количество BI инструментов. В модуле 3 мы уже познакомились с лидерами индустрии и попробовали их в деле. Так же мы попробовали разные сервисы для визуализации. А теперь, чтобы полностью закрыть тему Business Intelligence, я хочу вас познакомить еще с рядом интересных BI решений, которые активно используются на западе. 

**Видео лекция - теория** - [Fancy BI tools](https://youtu.be/GEl6NNpnZYQ)

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
### Дополнительные материалы для изучения
Вы может посмотреть примеры решений и даже попробовать скачать и подключиться к существующей базе данных Postgres или файлику с данными.

1. [Looker](https://looker.com/)
2. [Sigma BI](https://www.sigmacomputing.com/)
3. [Mode](https://mode.com/)
4. [Plotly and Dash](https://plotly.com/)
5. [Redash](https://redash.io/)
6. [Chartio](https://chartio.com/)
7. [ThoughtSpot](https://www.thoughtspot.com/)
</details>

