
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.project}-${var.env}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# resource "aws_cloudfront_function" "security_headers" {
#   name    = "${var.project}-${var.env}-sec-headers"
#   runtime = "cloudfront-js-1.0"
#   publish = true

#   code = templatefile(
#     "${path.module}/templates/security_headers.js.tftpl",
#     {} # 置換パラメータなし
#   )
# }

resource "aws_cloudfront_function" "basic_auth" {
  name    = "${var.project}-${var.env}-basic-auth"
  runtime = "cloudfront-js-1.0"
  publish = true

  code = templatefile(
    "${path.module}/templates/basic_auth.js.tftpl",
    { token = local.basic_auth_token }
  )
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "C2 learn S3+CF"
  default_root_object = "index.html"

  origin {
    domain_name              = var.origin_domain_name
    origin_id                = local.cf_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  logging_config {
    bucket          = var.cf_logs_bucket_domain_name
    prefix          = "yyyy/MM/dd/"
    include_cookies = false
  }



  default_cache_behavior {
    target_origin_id       = local.cf_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }

    # function_association {
    #   event_type   = "viewer-response"
    #   function_arn = aws_cloudfront_function.security_headers.arn
    # }

    # マネージドポリシー
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

    # 旧式スタイル
    # クエリもCookieも転送しない (静的コンテンツ向け)
    # forwarded_values {
    #   query_string = false
    #   cookies {
    #     forward = "none"
    #   }
    # }
  }

  # 最も安価（北米・ヨーロッパのみ）
  # price_class = "PriceClass_100"
  # 中間価格（北米・ヨーロッパ・アジア・オセアニア）
  # price_class = "PriceClass_200"
  # 最も高価（全世界のエッジロケーション）
  # price_class = "PriceClass_All"
  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
    }
  }

  # カスタムドメイン名（独自ドメイン）では使用できない
  # カスタムドメインを使用したい場合は、代わりにACM証明書やIAM証明書を設定する必要がある
  # viewer_certificate {
  #   cloudfront_default_certificate = true
  # }

  aliases = var.aliases

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # 403 → error.html (200) を 60 秒キャッシュ
  custom_error_response {
    error_code            = 403
    response_page_path    = "/error.html"
    response_code         = 200
    error_caching_min_ttl = 60
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/error.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }

  # 404 → SPA フォールバック (200) を 30 秒キャッシュ
  # custom_error_response {
  #   error_code            = 404
  #   response_page_path    = "/index.html"
  #   response_code         = 200
  #   error_caching_min_ttl = 30
  # }

  # 500 → error.html (500) を 120 秒キャッシュ
  custom_error_response {
    error_code            = 500
    response_page_path    = "/error.html"
    response_code         = 500
    error_caching_min_ttl = 120
  }

  tags = var.tags
}
