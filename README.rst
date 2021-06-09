====================================================
Разворачивание odoo сервера с помощью docker-compose
====================================================

Перед тем как начать
--------------------

- Устанавливаем git.
  Обычно через команду ``sudo apt-get install git``.

- Редактируем ``nginx.conf``.
  Напротив server_name перечисляем через домены, которые будут использоваться

- Редактируем ``Dockerfile.master``.
  Поправляем версию Odoo, если требуется.

- Выставляем переменные окружения

.. code-block:: sh

   export ODOO_VERSION=14.0  # Используем его для выполнения каких-либо команд данной инструкции.
   export ODOO_DATABASE=saas  # название базы, в котором все будем устанавливать

- В каталоге ``vendor`` клонируем репозитории с модулями.

.. code-block:: sh

   ./clone_master_modules.sh
   ./clone_build_modules.sh

- Редактируем ``odoo.conf``.
  Выставляем нужные параметры.
  Среди них:

  - ``admin_password``.
    Оставлять стандартным не рекомендую.

Установка docker и docker-compose
---------------------------------

Для Debian подготовлен скрипт ``install_docker_debian.sh``.

Для других операционных систем надо смотреть тут https://docs.docker.com/engine/install/ и тут https://docs.docker.com/compose/install/

Установка nginx
---------------

Для Debian и Ubuntu подобных

.. code-block:: sh

   sudo apt-get install nginx


Установка certbot
-----------------

Не требуется, если у клиента есть свой сертификат и сам будет его обновлять.

.. code-block:: sh

   sudo apt-get install certbot

Настройка nginx
---------------

Есть готовый шаблон.

.. code-block:: sh

   sudo cp ./nginx.conf /etc/nginx/sites-available/odoo.conf
   sudo ln -s /etc/nginx/sites-available/odoo.conf /etc/nginx/sites-enabled/odoo.conf

Убеждаемся, что все правильно настроили:

.. code-block:: sh

   sudo nginx -t

Если на выводе будет что-то вроде "все ок", то продолжаем.
Если нет, то исправляем ошибки и после чего продолжаем.

.. code-block:: sh

   sudo service nginx restart

Привязка сертификата от Let's Encrypt
-------------------------------------

Выполняем команду ниже и отвечаем на вопросы

.. code-block:: sh

   sudo certbot

Разворачивание odoo
-------------------

В новой базе сразу устанавливаем ``saas_apps_signup``

.. code-block:: sh

   sudo docker-compose run --rm web odoo -d $ODOO_DATABASE -i saas_apps_signup --stop-after-init

Убеждаемся, что ошибок никаких не было.

Далее снова запускаем Odoo без привязки с консоли:

.. code-block:: sh

   sudo docker-compose up -d web

Открываем браузер, заходим в Odoo

- Логин: admin, пароль: admin
- Основное меню >> Settings >> Activate developer mode
- Основное меню >> Settings >> Technical >> Configure back-ups
- Create
- Параметры по-умолчанию заданы корректно. Save
- Technical >> Scheduled Actions
- Открываем Backup scheduler
- Нажимаем на "Run manually"
- При успехе в каталоге backups будет создан дамп
- Переключаем значение поле Active. Должно иметь состояние "Включено"

Готово. Дальше уже устанавливаем нужные модули, настраиваем пользователей и прочее
