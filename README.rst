====================================================
Разворачивание odoo сервера с помощью docker-compose
====================================================

Перед тем как начать
--------------------

- Убеждаемся, что у клиента:

  - помимо основного домена также настроены поддомены
  - есть настройки smtp сервера

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

  - параметры раздела ``queue_job``.

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

Для основного домена сертификат тут-же должен быть доступен.
Для субдоменов надо настраивать через TXT-записи.

Разворачивание odoo
-------------------

В новой базе сразу устанавливаем ``saas_apps_signup``

.. code-block:: sh

   sudo docker-compose run --rm web odoo -d $ODOO_DATABASE -i saas_apps_signup --stop-after-init

Убеждаемся, что ошибок никаких не было.

Далее снова запускаем Odoo без привязки с консоли:

.. code-block:: sh

   sudo docker-compose up -d web

Смотрим последние строки из журнала:

.. code-block:: sh

   sudo docker-compose logs web

Среди них должно присутствовать следующее:

.. code-block::

   ...INFO...queue_job.jobrunner.runner: starting
   ...INFO...queue_job.jobrunner.runner: initializing database connections
   ...INFO...queue_job.jobrunner.runner: queue job runner ready for db <dbname>
   ...INFO...queue_job.jobrunner.runner: database connections ready

Открываем браузер, заходим в Odoo

- Логин: admin, пароль: admin
- Основное меню >> Settings >> Activate developer mode
- Основное меню >> Settings >> Users and Companies >> Companies >> My Company.
  Вводим страну и почту.
  Save
- Основное меню >> Settings >> Technical >> Outgoing email servers
  Записываем данные почтового сервера, которые есть у клиента.
  Save.
- Основное меню >> Settings >> General settings >> Customer Account >> Free sign up >> Save
- Основное меню >> Settings >> Invoicing >> Customer Payments >> Invoice online payments (on) >> Save
- Основное меню >> website >> configurations >> manage apps >> Refresh
- Основное меню >> SaaS >> Operators >> Same Instance
- - DB URLs. Probably http://{db_name}.mycompany.com
    Если не поддомены не подготовлены, то http://{db_name}.АЙПИ_АДРЕС.nip.io
- - Master URL. Probably https://mycompany.com
