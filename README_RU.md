# Предварительная настройка

## Terraform

### 1. Задайте свои переменные в infra/terraform/terraform.tfvars

| Переменная      | Комментарий                             | Пример                     |
| --------------- | --------------------------------------- | -------------------------- |
| cloud_id        | id облака                               | b1gaoe8gd60hmb5vcch0       |
| folder_id       | id каталога                             | b1g7rnu8v9blnov6283p       |
| subnet_id       | id подсети                              | e9b8jq70j2bafkcv156b       |
| zone            | Зона доступности                        | ru-central1-a              |
| public_key_path | Публичный ssh ключ для подключения к ВМ | ~/.ssh/crawler-project.pub |
|                 |                                         |                            |

Переменная `image_id` выставлена в значение `fd8fjtn3mj2kfe7h6f0r` (Ubuntu 18.04) и не предполагает замены.

### 2. Экспортируйте ключ сервисного аккаунта Yandex Cloud в файл `~/yandex-cloud/terraform-bot-key.json"`

[Документация YC: Создание авторизованных ключей](https://cloud.yandex.ru/docs/iam/operations/authorized-key/create)

Сервисный аккаунт должен иметь следующие роли в каталоге:
* `vpc.admin`
* `storage.admin`
* `compute.admin`

### 3. Создайте S3 Bucket и настройте Terraform backend

[Документация YC: Создание бакета](https://cloud.yandex.ru/docs/storage/operations/buckets/create)

[Документация YC: Создание статитеческих ключей доступа](https://cloud.yandex.ru/docs/iam/operations/sa/create-access-key)

Создайте бакет.

Создайте файл `infra/terraform/backend.tf` следующего содержания:
```JSON
terraform {
    backend "s3" {
        endpoint    = "storage.yandexcloud.net"
        bucket      = "<BUCKET_NAME>"
        region      = "us-east-1"
        key         = "terraform-crawler.tfstate"
        access_key  = "<ACCESS_KEY>"
        secret_key  = "<SECRET_KEY>"

        skip_region_validation      = true
        skip_credentials_validation = true
    }
}
```

## Ansible

Все действия производятся в директории *infra/ansible*

### 1. Установите необходимые зависимости

`ansible-galaxy install -r requirements.yml`

### 2. Задайте свои значения в переменный в vars.yml

| Переменная | Комментарий | Пример |
|---|---|---|
| gitlab_root_password | Пароль root для входа в Gitlab_CI | 123qwe123 |
| gitlab_runner_token | Токен для регистрации runner'ов | Dfhju39dbklbnci33cju |
| | | |