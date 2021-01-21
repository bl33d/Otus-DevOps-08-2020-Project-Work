1. Terraform

1.1 Задайте свои переменные в infra/terraform/terraform.tfvars

| Переменная      | Комментарий                             | Пример               |
| --------------- | --------------------------------------- | -------------------- |
| cloud_id        | id облака                               | b1gaoe8gd60hmb5vcch0 |
| folder_id       | id каталога                             | b1g7rnu8v9blnov6283p |
| subnet_id       | id подсети                              | e9b8jq70j2bafkcv156b |
| zone            | Зона доступности                        | ru-central1-a        |
| public_key_path | Публичный ssh ключ для подключения к ВМ | ~/.ssh/appuser.pub   |
| --------------- | --------------------------------------- | -------------------- |

Переменная `image_id` выставлена в значение fd8fjtn3mj2kfe7h6f0r (Ubuntu 18.04) и не предполагает замены.

1.2 Экспортируйте ключ сервисного аккаунта Yandex Cloud в файл `~/yandex-cloud/terraform-bot-key.json"`

Сервисный аккаунт должен иметь следующие роли в каталоге: `vpc.admin` `storage.admin` `compute.admin`

Команда для экспорта ключа сервисного аккаунта через утилиту yc `yc iam key create --service-account-name <YOUR-SERIVCE-ACCOUNT-NAME> --output ~/yandex-cloud/terraform-bot-key.json`

