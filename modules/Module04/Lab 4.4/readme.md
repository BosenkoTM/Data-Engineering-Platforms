В этой папке находятся jobs для Pentaho DI, которые необходимы для Лабораторной работы 4:
- `staging orders.ktr` - трансформация, которая загружает данные из файлы Superstore в Postgres
- `dim_tables.ktr` - трансформация, которая трансформирует данные (T в ETL) внутри нашей базы данных
- `Pentaho Job.kjb` - главный job, который выполняет последовательность трансформаций (оркестрирует нашим data pipeline)

## Перед первым запуском
- *[Документацию (English)](https://wiki.pentaho.com/display/EAI/Pentaho+Data+Integration+Steps) по всем шагам/трансформациям можно найти на официальной вики*
- *Также, в качестве шпаргалки, я начал собирать руководство по всем затронутым в обучении шагам Pentaho [тут](https://medium.com/@romangailit/pentaho-di-steps-guide-faada864b3e) (пока черновик)*

Для того, чтобы Pentaho Data Integration стартовала (под win10), необходимо проделать ряд не очевидных шагов:
1. Установить [Java 8 выпуска 261](https://downzen.com/en/windows/java-runtime-environment/download/8-update-261/) (ссылка ведет не на официальный сайт, но файл подписан сертификатом Oracle, что позволяет думать, что все в порядке). Экспериментально установлено, что Spoon.bat не стартует с наиболее актуальным на текущий момент 281-м выпуском;
2. [Задать путь до папки с Java в качестве переменной окружения](https://java-lessons.ru/first-steps/java-home) с названием JAVA_HOME;
3. Запустить **Spoon.bat**.
## Типичные ошибки
Ниже перечислю типичные ошибки, которые возникали у меня во время запуска первых трансформаций в рамках прохождения 4-го модуля курса Data Engineering:
### 1. Отсутствует необходимая для загрузки данных структура таблицы.
- Например: *"Relation order_id doesn’t exist"*.

В данном случае вы пытаетесь загрузить в таблицу данные, не соответствующие ей реальной структуре.
1. Для начала убедитесь, что вы подвели к вашему output-шагу (**Table output**) подготовленные и трансформированные данные. Это позволит системе автоматически определить необходимую структуру конечной таблицы и сгенерировать SQL код, который проведет все необходимые трансформации, включая создание таблицы и определение ее полей;
2. Прямо через интерфейс Pentaho (по кнопке) выполните данный SQL скрипт (при необходимости, отредактируйте перед выполнением);
3. Попробуйте прогнать трансформацию заново.

### 2. Ошибка взаимодействия с БД
Для работы с PostgreSQL (и любыми другими) базами данных необходимо поместить [соответствующий JDBC драйвер](https://jdbc.postgresql.org/download.html) в папку data-integration/lib
### 3. Не работает Unique Rows
Необходимо предварительно отсортировать (**Sort rows**, ASC=Y) входящий поток по тому полю, по которому вы планируете отсеивать неуникальные значения.
## Советы
1. На шаге вставки данных в БД (**Table output**) проверяйте, что признак **Truncate table** активен, иначе система будет пытаться вставить данные поверх существующих, что приведет к ошибкам.
2. Обратите внимание, что SQL скрипты выполняются раньше большинства трансформаций, но позже input-шагов
3. Сортируйте потоки по целевому полю как минимум перед шагами: **Unique Rows** и **Join**
4. Переименовать, удалить лишние, изменить тип атрибутов можно с помощью **Select values**
