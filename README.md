# terraform-v3

## Overview

このプロジェクトはTerraformを使用してAWS上に静的サイトホスティング環境を構築します。CloudFront、S3、Route53、ACMなどのAWSサービスを活用し、セキュアで高速な配信基盤を提供します。

主な機能:
- S3による静的コンテンツのホスティング
- CloudFrontによるグローバルコンテンツ配信
- Basic認証による簡易アクセス制御
- Route53とACMによる独自ドメイン対応（SSL/TLS対応）
- GitHub Actions OIDC連携によるCI/CDパイプライン

## Tech Stack

- **IaC**: Terraform
- **Cloud Provider**: AWS
  - S3 (静的コンテンツホスティング)
  - CloudFront (CDN)
  - Route53 (DNS)
  - ACM (SSL/TLS証明書)
  - IAM (アクセス管理)
  - GitHub OIDC Provider
- **CI/CD**: GitHub Actions (OIDC認証)

## Setup

### 前提条件

- Terraform >= 1.0
- AWS CLI設定済み
- 有効なAWSアカウント
- Route53で管理されているドメイン

### 1. Bootstrap（初回のみ）

Terraform stateファイルを保存するS3バケットを作成:

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを編集してバケット名を設定
terraform init
terraform apply
```

### 2. 開発環境のセットアップ

```bash
cd environments/dev
terraform init
```

### 3. 変数の設定

必要な変数を設定（環境変数またはterraform.tfvarsで設定）:

```hcl
project             = "your-project-name"
region              = "ap-northeast-1"
repo                = "owner/repository"
root_domain         = "example.com"
subdomain           = "docs"
basic_auth_username = "username"
basic_auth_password = "password"
```

### 4. デプロイ

```bash
terraform plan
terraform apply
```

## Usage

### リソースのデプロイ

```bash
cd environments/dev
terraform apply
```

### GitHub Actionsからのデプロイ

GitHub OIDC連携により、AWS認証情報をシークレットに保存せずにデプロイ可能:

1. Terraformで作成されたIAM Role ARNを確認
2. GitHub ActionsワークフローでOIDC認証を使用
3. S3へのファイルアップロードとCloudFrontキャッシュ無効化を実行

### リソースの削除

```bash
cd environments/dev
terraform destroy
```

## Directory Structure

```
.
├── bootstrap/              # Terraform state管理用S3バケット
│   ├── main.tf
│   ├── variables.tf
│   └── provider.tf
├── environments/
│   └── dev/               # 開発環境の設定
│       ├── main.tf        # メインリソース定義
│       ├── variables.tf   # 変数定義
│       ├── locals.tf      # ローカル変数
│       ├── outputs.tf     # 出力値
│       └── backend.tf     # Backend設定
└── modules/               # 再利用可能なモジュール
    ├── cloudfront/        # CloudFront配信設定
    ├── common/            # 共通設定
    ├── github-oidc/       # GitHub OIDC Provider
    ├── iam/              # IAMロールとポリシー
    ├── route53/          # DNS設定
    └── s3/               # S3バケット設定
```

## License

This repository is for personal/private use only.
