# Модуль 3. Business Intelligence. Визуализация данных, дашборды и отчетность

[Обратно в содержание курса :leftwards_arrow_with_hook:](https://github.com/BosenkoTM/Data-Engineering-Platforms/tree/master?tab=readme-ov-file#%D0%BF%D0%BB%D0%B0%D1%82%D1%84%D0%BE%D1%80%D0%BC%D1%8B-data-engineering) 

В этом модуле мы погрузимся в мир **Business Intelligence (BI)** — ключевой дисциплины на стыке бизнеса, аналитики и Data Engineering. Мы разберем, как превращать сырые данные в значимые инсайты с помощью современных BI-платформ, научимся создавать интерактивные дашборды и освоим лучшие практики визуализации данных для принятия эффективных бизнес-решений.

## 3.1 Введение в Business Intelligence (BI)

**Видео лекция** - [Введение в модуль](https://youtu.be/sj2qRK7NRMQ) 

### 3.1.1 Что такое Business Intelligence?

**Видео лекция - теория** - [Что такое BI?](https://youtu.be/8dcISZnrlcw) 

**Business Intelligence (BI)** — это не просто создание отчетов. Это комплексный, итеративный процесс, который включает в себя технологии, архитектуру и практики для сбора, анализа и представления бизнес-информации. Главная цель BI — дать возможность бизнесу принимать решения не на основе интуиции, а на основе проверенных данных (*data-driven decision making*).

В современном мире BI-системы являются нервной системой компании, позволяя отслеживать ключевые показатели (KPI), выявлять тренды, находить "узкие места" и открывать новые возможности для роста.

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
1. [Короткое видео - что такое BI на примере Lamoda BI Academy и SAP Business Objects](https://youtu.be/xYExt37a9Qg) (Русский)
2. [Business Intelligence: принципы, технологии, обучение](https://habr.com/ru/post/134031/) (Русский)
3. [What is business intelligence? Transforming data into business insights](https://www.cio.com/article/2439504/business-intelligence-definition-and-solutions.html) (English)
4. [What is business intelligence? Your guide to BI and why it matters](https://www.tableau.com/learn/articles/business-intelligence) (English)
5. [Курс Data Warehousing for Business Intelligence Specialization](https://www.coursera.org/specializations/data-warehousing) (English)
</details>

### 3.1.2 Эволюция BI: от классики к современности

**Видео лекция - теория** - [2 типа решений BI?](https://youtu.be/VklEzWpFZIk) 

Подходы к BI кардинально изменились за последние десятилетия. Понимание этой эволюции критически важно для выбора правильных инструментов и построения эффективных процессов.

| Характеристика | Классический (Traditional) BI | Современный (Self-Service) BI |
| :--- | :--- | :--- |
| **Основной пользователь** | IT-специалисты, BI-разработчики | Бизнес-аналитики, менеджеры, руководители |
| **Процесс создания отчета**| Длинный цикл: ТЗ -> Разработка в IT -> Тестирование | Быстрый и гибкий: бизнес-пользователь сам создает отчет |
| **Инструменты** | Сложные, требующие программирования (SAP BO, Oracle BI) | Интуитивные, с drag-and-drop интерфейсом (Tableau, Power BI, Yandex DataLens)|
| **Источник данных** | Строго регламентированные хранилища данных (DWH) | DWH, озера данных (Data Lake), облачные сервисы, Excel/CSV |
| **Гибкость** | Низкая, отчеты статичны | Высокая, дашборды интерактивны, "drill-down" анализ |
| **Скорость получения инсайтов**| Дни, недели, месяцы | Минуты, часы |

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>
 
1. [Traditional vs. Self-Service BI: Analytics Alternatives Explained](https://www.softwareadvice.com/resources/traditional-bi-vs-self-service/) (English)
2. [Презентация Tool Comparison: Enterprise BI vs Self-Service Analytics](https://www.slideshare.net/senturus/tool-comparison-enterprise-bi-vs-selfservice-analytics-choosing-the-best-tool-for-the-job) (English)
3. [Семь раз отмерь, один раз внедри BI инструмент](https://habr.com/ru/company/ods/blog/460807/) (Русский)
</details>

## 3.2 Компоненты и рынок BI-решений

### 3.2.1 Из чего состоит любой BI-инструмент?

**Видео лекция - теория** - [Из чего состоит любой BI инструмент?](https://youtu.be/vtGjvKjZpmU) 

Несмотря на многообразие BI-платформ, их архитектура и основные компоненты схожи:
1.  **Коннекторы к данным (Data Connectors).** Модули для подключения к различным источникам: базам данных, файлам, API, облачным сервисам.
2.  **Слой подготовки данных (Data Preparation Layer).** Инструменты для объединения (JOIN), очистки, трансформации данных и создания вычисляемых полей. В современных системах это часто называется "созданием датасета" или "моделированием данных".
3.  **Движок обработки запросов (Query Engine).** Ядро системы, которое преобразует действия пользователя в визуальном интерфейсе в запросы к источнику данных (например, в SQL) и обрабатывает ответы.
4.  **Слой визуализации (Visualization Layer).** Набор диаграмм, графиков, карт и таблиц, которые используются для представления данных.
5.  **Интерактивный дашборд (Dashboard).** "Холст" для сборки визуализаций, фильтров (селекторов) и других элементов в единую аналитическую панель.
6.  **Слой управления и безопасности (Management & Security).** Инструменты для управления доступом, публикации отчетов и совместной работы.

### 3.2.2 Обзор рынка BI-решений

**Видео лекция - теория** - [Рынок BI?](https://youtu.be/CKDGGOzYg9w) 

Рынок BI-платформ очень динамичен. Ежегодно аналитические агентства, такие как Gartner и Forrester, публикуют отчеты, оценивающие лидеров рынка.
*   **Мировые лидеры:** Microsoft (Power BI), Tableau (Salesforce), Qlik.
*   **Отечественные решения:** Yandex DataLens, Visiology, Luxms BI, Polymatica.
*   **Open-source и "модные" инструменты:** Superset, Metabase, Redash, Looker (Google).

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>

1. [Технические отличия BI систем (Power BI, Qlik Sense, Tableau)](https://habr.com/ru/post/444758/) (Русский)
2. [Gartner BI отчет 2020 оригинал](https://www.tableau.com/reports/gartner) (English)
3. [Forrester 2019 Enterprise BI Platform Wave™ Evaluations](https://go.forrester.com/blogs/enterprise-bi-platform-waves/) (English)
</details>

## 3.3 Основы визуализации и проектирования дашбордов

Визуализация данных — это не искусство, а наука и навык. Правильная визуализация позволяет быстро и точно доносить информацию, в то время как плохая может ввести в заблуждение.

**Видео лекция - теория** - [Основы визуализации данных](https://youtu.be/zUpKIFFy-ok) 

**Запись вебинара c Экспертом** - [Алгоритм проектирования дашборда / Роман Бунин](https://youtu.be/xSp5ykKcQho)

**Ключевые принципы:**
*   **Цель превыше всего.** Каждая визуализация должна отвечать на конкретный бизнес-вопрос.
*   **Выбирайте правильный тип графика.** Линейный — для трендов, столбчатый — для сравнения, круговой — для долей (но с осторожностью!).
*   **Меньше — лучше.** Избегайте визуального "шума" — лишних линий, градиентов, 3D-эффектов.
*   **Используйте цвет осмысленно.** Цвет должен не украшать, а кодировать информацию или выделять главное.
*   **Обеспечьте контекст:** Всегда добавляйте заголовки, подписи осей и единицы измерения.

<details>
<summary> Дополнительные материалы для изучения (нажмите, чтобы развернуть)</summary>

1. [10 примеров визуализации из истории](https://www.tableau.com/learn/articles/best-beautiful-data-visualization-examples) (English)
2. [Как не врать с помощью статистики: основы визуализации данных](https://habr.com/ru/company/pixonic/blog/453828/) (Русский)
3. [Специализация на Coursera - Information Visualization Specialization](https://www.coursera.org/specializations/information-visualization) (English)
4. [Курс на Coursera - Data Visualization and Communication with Tableau](https://www.coursera.org/learn/analytics-tableau) (English)
</details>

---

## 3.4 Практика в BI-инструментах

### 3.4.1 Глубокое погружение в Yandex DataLens

**Yandex DataLens** — это облачный Self-Service BI инструмент от Яндекса, тесно интегрированный в экосистему Yandex Cloud. Он является отличным примером современной BI-платформы.

#### Ключевые объекты и процесс работы:
1.  **Подключение.** Настройка доступа к источнику (например, ClickHouse, PostgreSQL, CSV-файл).
2.  **Датасет.** Выбор таблиц, настройка связей между ними (JOIN), создание вычисляемых полей. Это главный этап подготовки данных для анализа.
3.  **Чарт.** Создание отдельной визуализации (графика, таблицы, индикатора) на основе датасета.
4.  **Дашборд.** Сборка нескольких чартов и селекторов (фильтров) на одной интерактивной странице.

#### Практическая работа 3.1
 - [Проектирование и настройка дашборда для бизнес-пользователей](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module03/pw_3_1_2025.md)

### 3.4.2 Знакомство с Tableau

**Видео лекция - теория** - [Знакомство с Tableau Desktop](https://youtu.be/QY1FYMnxElw) 

**Видео лекция - практика** - [Демонстрация Tableau Desktop](https://youtu.be/QY1FYMnxElw?t=2710) 

**Tableau** — один из мировых лидеров на рынке BI. Его сильные стороны — мощный движок визуализации, гибкость и огромное сообщество пользователей.

<details>
<summary> Дополнительные материалы по Tableau (нажмите, чтобы развернуть)</summary>

1. [Tableau Tutorial](https://help.tableau.com/current/guides/get-started-tutorial/en-us/get-started-tutorial-home.htm) (English)
2. [Примеры работ в Tableau - Tableau Zen Мастером](https://photos.google.com/share/AF1QipPtbvxIRuoBESlPztSPTsryjD0ehd8SmpLBHp4aKdpUu0vcVqLZZP81DH1uzoRzKA?key=THpkYTRRT2JKU1ZVQzJBdTh4UDF6T3FoWVB0MUVn) (English)
3. [Соревнования по Tableau - Iron Viz](https://www.tableau.com/iron-viz) (English)
</details>

### 3.4.3 Знакомство с Power BI

**Видео лекция - теория** - [Знакомство с Power BI](https://youtu.be/6no5xbpF3_o) 

**Видео лекция - практика** - [Демонстрация Power BI](https://youtu.be/6no5xbpF3_o?t=524)

**Power BI** от Microsoft — главный конкурент Tableau. Его преимущества — глубокая интеграция с продуктами Microsoft (Excel, Azure, SQL Server) и доступная модель лицензирования.

<details>
<summary> Дополнительные материалы по Power BI (нажмите, чтобы развернуть)</summary>
 
1. [Что такое Power BI от Microsoft](https://powerbi.microsoft.com/ru-ru/what-is-power-bi/) (Русский)
2. [Официальная документация про Power BI](https://docs.microsoft.com/ru-ru/power-bi/guidance/) (Русский)
3. [Самый крутой YouTube канал про Power BI - Guy in a Cube](https://www.youtube.com/channel/UCFp1vaKzpfvoGai0vE5VJ0w) (English)
</details>

## 3.5 Будущее BI. Искусственный интеллект и новые парадигмы

### 3.5.1 Использование ИИ в системах BI

Современные BI-платформы активно внедряют технологии искусственного интеллекта (AI) и машинного обучения (ML), что выводит аналитику на новый уровень. Этот тренд часто называют **Augmented Analytics** (Расширенная аналитика).

*   **Natural Language Query (NLQ).** Возможность задавать вопросы к данным на естественном языке. Пользователь пишет "Покажи продажи по категориям за прошлый месяц", а система сама строит нужный график. (Пример: "Ask Data" в Tableau, Q&A в Power BI).
*   **Automated Insights.** Автоматический поиск аномалий, трендов и корреляций в данных. Система сама подсвечивает пользователю "Продажи в регионе N резко упали на 20% на прошлой неделе".
*   **Predictive Analytics.** Встроенные функции для прогнозирования временных рядов (forecast) и кластеризации данных без необходимости писать код на Python/R.
*   **Data Storytelling.** Автоматическая генерация текстовых описаний и выводов на основе визуализаций, что помогает быстрее понять суть данных.

### 3.5.2 "Модные" BI-решения и новые подходы

**Видео лекция - теория** - [Fancy BI tools](https://youtu.be/GEl6NNpnZYQ)

Помимо "большой тройки", существует множество инновационных инструментов, которые продвигают новые подходы к BI:
*   **Looker (Google).** Продвигает парадигму **BI-as-Code** с использованием языка LookML для создания централизованной и переиспользуемой модели данных.
*   **ThoughtSpot.** Фокусируется на поиске по данным (*search-driven analytics*), развивая идеи NLQ.
*   **Sigma Computing.** Предоставляет интерфейс, похожий на Excel, для работы с миллиардами строк в облачных хранилищах данных, ориентируясь на бизнес-пользователей.
*   **Plotly/Dash, Streamlit.** Фреймворки для создания кастомных аналитических веб-приложений на Python, стирая грань между BI и Data Science.

<details>
<summary> Дополнительные материалы (нажмите, чтобы развернуть)</summary>
 
1. [Looker](https://looker.com/)
2. [Sigma BI](https://www.sigmacomputing.com/)
3. [ThoughtSpot](https://www.thoughtspot.com/)
4. [Plotly and Dash](https://plotly.com/)
5. [Redash](https://redash.io/)
</details>

## 3.6 Карьера в BI и сбор обратной связи

### 3.6.1 Требования к BI-разработчику/инженеру

**Видео лекция - теория** - [Требования к BI разработчику](https://youtu.be/DxRTAqpjowY) 

Современный BI-специалист — это не просто "человек, который рисует графики". Это аналитик с сильными техническими навыками.
*   **Hard Skills:**
    *   **SQL.** Беглое владение SQL — абсолютная необходимость.
    *   **BI-инструменты.** Глубокое знание одной или нескольких платформ (Tableau, Power BI, DataLens и т.д.).
    *   **Моделирование данных:** Понимание принципов построения хранилищ данных (звезды, снежинки).
    *   **Python (все чаще).** Для автоматизации, сложной обработки данных и интеграции с ML.
*   **Soft Skills:**
    *   **Понимание бизнеса.** Умение говорить на языке бизнеса и понимать его потребности.
    *   **Коммуникация и сторителлинг.** Способность не просто показать данные, а рассказать историю на их основе.
    *   **Критическое мышление.** Умение задавать правильные вопросы к данным и бизнесу.

<details>
<summary> Дополнительные материалы (нажмите, чтобы развернуть)</summary>
 
1. [Методика STAR для прохождения структурированных собеседований](https://hr-portal.ru/story/metodika-star-dlya-prohozhdeniya-strukturirovannyh-sobesedovaniy) (Русский)
2. [О собеседовании в Амазон](https://medium.com/@allo/%D0%BE-%D1%81%D0%BE%D0%B1%D0%B5%D1%81%D0%B5%D0%B4%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B8-%D0%B2-%D0%B0%D0%BC%D0%B0%D0%B7%D0%BE%D0%BD-27e649323c4b) (Русский)
</details>

### 3.6.2 Управление клиентским опытом BI-пользователей

**Видео лекция - теория** - [Voice of Customers (опросы пользователей аналитического решения)](https://youtu.be/kKI5PMVC6A4) 

Работа BI-разработчика не заканчивается после сдачи дашборда. Важно постоянно собирать обратную связь от пользователей, чтобы понимать, насколько решение полезно, удобно и какие проблемы оно решает. Проведение опросов среди пользователей — отличный инструмент для этого.

#### Лабораторная работа 3.1
- [Создание интерактивного аналитического дашборда на основе витрин данных](https://github.com/BosenkoTM/Data-Engineering-Platforms/blob/master/modules/Module03/lw_3_1_2025.md)
````
