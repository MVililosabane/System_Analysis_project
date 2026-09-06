# 2. Моделирование бизнес-процессов (BPMN)

В этом разделе представлены диаграммы бизнес-процессов в нотации BPMN для текущего (AS-IS) и целевого (TO-BE) процессов выдачи кредита.


## 2.1 AS-IS (Текущий процесс)

На диаграмме показан существующий процесс, который полностью проходит в офлайн-формате.

![AS-IS BPMN](https://raw.githubusercontent.com/MVililosabane/System_Analysis_project/main/diagrams/bpmn/AS-IS.png)



## 2.2 TO-BE (Целевой процесс)

Целевой процесс включает онлайн-взаимодействие с клиентом и автоматизацию ключевых этапов.

![TO-BE BPMN](https://raw.githubusercontent.com/MVililosabane/System_Analysis_project/main/diagrams/bpmn/TO-BE.png)

## 2.3 Подпроцессы TO-BE

### Подача онлайн-заявки

![Подача заявки](https://raw.githubusercontent.com/MVililosabane/System_Analysis_project/main/diagrams/bpmn/TO-BE_submit.png)

### Выполнение скоринга и подбор условий кредита

![Скоринг](https://raw.githubusercontent.com/MVililosabane/System_Analysis_project/main/diagrams/bpmn/TO-BE_scoring.png)


## Исходные файлы

Диаграммы построены в Camunda Modeler. Исходные файлы (.bpmn) находятся в папке:

- [Исходники BPMN](../diagrams/bpmn/)
