# OTUS DevOps 08 2020 Crawler Project Work

# Описание

Репозиторий проектной работы курса OTUS DevOps 08 2020

Данный репозиторий содержит инфраструктурный код (Ansible, Terraform), а так же простое микросервисное приложение.
Репозиторий разбит на две части:
infra - код для деплоя базовой инфраструктуры (GitLab, Мониторинг инстансы)
app - код приложения и инфраструктурный код самого приложения

----

# Запуск проекта. I. Инфраструктура.

## Предварительная настройка

## Необходимое ПО

Ниже указан список необходимого ПО для запуска проекта и версии на которых проект точно работает.

* ansible (2.10.4)
* terraform (0.13.5)

## Развертывание инфраструктуры

### 1. Создайте пару ssh ключей с названием crawler-project

`ssh-keygen -C crawler-project -f ~/.ssh/crawler-project `

Скопируйте публичный ключ crawler-project.pub в директорию /keys/ *с заменой существующего*

Сделайте коммит `git add keys/crawler_project.pub && git commit -m "update pub key"`

### 2. Задайте свои переменные в infra/terraform/terraform.tfvars

| Переменная      | Комментарий                             | Пример                     |
| --------------- | --------------------------------------- | -------------------------- |
| cloud_id        | id облака                               | b1gaoe8gd60hmb5vcch0       |
| folder_id       | id каталога                             | b1g7rnu8v9blnov6283p       |
| subnet_id       | id подсети                              | e9b8jq70j2bafkcv156b       |
| zone            | Зона доступности                        | ru-central1-a              |
|                 |                                         |                            |

Переменная `image_id` выставлена в значение `fd8vmcue7aajpmeo39kk` (Ubuntu 20.04) и не предполагает замены.

### 3. Экспортируйте ключ сервисного аккаунта Yandex Cloud в файл `~/yandex-cloud/terraform-bot-key.json`

[Документация YC: Создание авторизованных ключей](https://cloud.yandex.ru/docs/iam/operations/authorized-key/create)

Сервисный аккаунт должен иметь следующие роли в каталоге:
* `vpc.admin`
* `storage.admin`
* `compute.admin`

### 4. Создайте S3 Bucket и настройте Terraform backend

[Документация YC: Создание бакета](https://cloud.yandex.ru/docs/storage/operations/buckets/create)

[Документация YC: Создание статитеческих ключей доступа](https://cloud.yandex.ru/docs/iam/operations/sa/create-access-key)

Создайте бакет.

Задайте свои переменные в infra/ansible/environments/prod/group_vars/all.yml

| Переменная           | Комментарий                       | Пример                                   |
| -------------------- | --------------------------------- | ---------------------------------------- |
| tf_bucket_name       | id подсети                        | e9b8jq70j2bafkcv156b                     |
| tf_bucket_access_key | access key S3 бакета              | 0WqXXX6D1xxxx_GmTKtG                     |
| tf_bucket_secret_key | secret key S3 бакета              | -WLwXXbvXmbi1Ex_FfUGeXxXxXxc6D64tf7B99it |
| gitlab_root_password | Пароль root для входа в Gitlab_CI | 123qwe123                                |
| gitlab_runner_token  | Токен для регистрации runner'ов   | Dfhju39dbklbnci33cju                     |
|                      |                                   |                                          |

### 5. Запустите ansible-playbook

Все действия производятся в директории *infra/ansible*

4.1 Установите необходимые зависимости

`ansible-galaxy install -r requirements.yml`

4.2 Запустите ansible-playbook

`ansible-playbook playbooks/site.yml`

----

Примерное время выполнения плейбука = 12 min.
После успешного выполнения плейбука будут развернуты 2 инстанса:

* GitLab CI
К GitLab CI уже подключен один runner (docker)

* Мониторинг (Prometheus + Grafana)
Prometheus уже собирает метрики с node_exporter с обоих инстансов.
В Grafana уже предустановлен dashboard - Prometheus Node Exporter Full.

----

# Запуск проекта. II. Приложение.

### 1. Задайте свои переменные в GitLab CI

Admin Area -> Settings -> CI/CD -> Variables

| Key                  | Value                                                     | Type     | Flags             |
| -------------------- | --------------------------------------------------------- | -------- | ----------------- |
| terraform_bot_key    | Содержимое файла ~/yandex-cloud/terraform-bot-key.json    | Variable | Protect           |
| crawler_project      | Содержимое файла ~/.ssh/crawler_project                   | File     | Protect           |
| tf_bucket_access_key | access key S3 bucket (задавали ранее в окружении Ansible) | Variable | Protected, Masked |
| tf_bucket_secret_key | secret key S3 bucket (задавали ранее в окружении Ansible) | Variable | Protected, Masked |
|                      |                                                           |          |                   |

### 2. Запуште проект в GitLab CI

`git push <YOUR_GITLAB_CI_URL>/root/$(git rev-parse --show-toplevel | xargs basename).git`

----

После пуша в GitLab CI появится проект с названием Otus-DevOps-08-2020-Project-Work
Запустится CI/CD Pipeline, состоящий из двух стейджей:
* На первом стейдже выполняется две джобы, в которых поднимается приложение и запускаются тесты.
* Если все тесты прошли успешно, становится доступна для ручного запуска джоба deploy_prod

При запуске джобы deploy_prod, GitLab Runner поднимает докер контейнер в котором запускается Ansible playbook, разворачивающий приложение.

Ссылка на Web UI приложения доступна в GitLab -> Проект -> Operations -> Environments -> View Deployment

В процессе деплоя приложения Terraform создает инстанс в YC, само приложение запускается через docker compose.
Prometheus начинает собирать метрики:
* Crawler
* UI
* node_exporter

В Grafana добавляется дашборд App Crawler, отображающий метрики приложения.
