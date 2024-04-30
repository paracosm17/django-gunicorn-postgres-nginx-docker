# Django + gunicorn + postgres + nginx + docker deploy
Это небольшая шпаргалка по деплою django приложения с помощью docker. <br>
Вместо чистого Django используется CMS [Wagtail](https://wagtail.org/) (надстройка над Django), 
но в целом, разницы особой нет. Структура проекта та же. <br>
Проект полностью чистый, от сюда можно брать только часть, связанную непосредственно с деплоем

# Запуск

### Без докера
Запуск без докера больше подойдет для этапа разработки, чтобы быстренько запускать проект из консоли с 
помощью встроенного в джанго тестового сервера
```bash
git clone https://github.com/paracosm17/django-gunicorn-postgres-nginx-docker djangodeploy && cd djangodeploy
```

```bash
python manage.py makemigrations &&
python manage.py migrate &&
python manage.py createsuperuser &&
python manage.py runserver
```

### Через докер
```bash
git clone https://github.com/paracosm17/django-gunicorn-postgres-nginx-docker djangodeploy && cd djangodeploy
```
```bash
mv .env.dist .env
```
Также предварительно можете отредактировать файл .env
```bash
sudo docker compose up --build
```

## Как всё работает

В docker compose собираются 3 контейнера из 3 образов: nginx, postgresql, и третий это само наше приложение, оно билдится из папки с проектом. <br>

### Postgres
По части postgres Вам ничего трогать не нужно. Имя БД, имя пользователя для бд и пароль указываете в файле .env <br>
Во внешнюю систему соединение с бд будет пробрасываться по порту 5439, это можно изменить в docker-compose.yml если вдруг 5439 занят <br>
В остальном, всё уже настроено и ничего трогать не нужно. Также написан небольшой скрипт в docker-entrypoint.sh который ждёт запуска бд, 
только потом стартует джанго приложение.

### Nginx
Если вы хотите более тонкую настройку nginx, можно изменить конфигурационный файл nginx/templates/default.conf.template <br>
Использование темплейта объясняется тем, что используются переменные среды, а конфигурационные файлы nginx их не видят, поэтому нужен шаблон. <br>
Подробнее тут - https://hub.docker.com/_/nginx (Using environment variables in nginx configuration (new in 1.19)) <br>
Порт, по которому будет доступно само приложение в вашей внешней системе (за пределами контейнера) настраивается через переменную PORT в .env. 
По дефолту там порт 666, поэтому заходите по адресу http://localhost:666


### Django
Для джанги используются 2 файла настроек dev или production. Каждый из них ипортирует в себя всё что есть в базовых настройках, 
они отличаются между собой переменными DEBUG, EMAIL_BACKEND, DATABASES <br>
Проект настроен так, что его можно запустить и без переменных окружения, поэтому в некоторые переменные в настройках 
подставятся дефолтные значения, на случай, если переменные среды не указаны. Например, будет использоваться файл настроек 
dev, а там используется бд sqlite3, где логины, пароли, порты и т д не нужны <br>
Также настроено автосоздание суперпользователя в docker-entrypoint.sh. Данные для создания берутся из .env


### Заключение
Проект показывает базовую настройку для деплоя джанго проекта с помощью докера. Nginx нормально проксирует все запросы, вся статика работает. Постгрес нормально запускается и сохраняет в себя данные. Джанго приложение нормально запускается и работает.