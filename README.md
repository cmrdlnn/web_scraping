# Приложение для wep-парсинга интернет ресурсов bnkomi.ru и komiinform.ru

## Запуск тестов

Для запуска тестов рекомендуется использовать виртуальную машину, которую можно
запустить с помощью следующей команды в терминале в корневой директории
Git-репозитория библиотеки:

```
vagrant up
```

После создания, запуска и настройки виртуальной машины необходимо зайти в неё с
помощью команды

```
vagrant ssh
```

Если виртуальная машина была только создана, необходимо установить требуемые
библиотеки с помощью следующей команды в терминале виртуальной машины:

```
bundle install
```

Запустить тесты можно с помощью следующей команды в терминале виртуальной
машины:

```
make test
```
