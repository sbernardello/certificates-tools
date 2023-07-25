# SSL tools

## Info

Here are some scripts to test and dump information from ssl certificates.

The test_ssl.sh script will connect to the domain you choos to pull information using openssl

## Requirements

openssl need to be installed

## Usage

```bash
./test_ssl www.example.com
```

In the certificate folder will be saved ssl certificate bundle.

## OCSP SSL

Info on OCSP and AWS : [Docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/RequestAndResponseBehaviorCustomOrigin.html#request-custom-ocsp-stapling)

## HSTS

To enable add these http headers:

```nginx
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

Before deploying this test with lower max-age values, eg:

```nginx

# 5 minutes:
    max-age=300; includeSubDomains
# 1 week:
    max-age=604800; includeSubDomains
# 1 month:
    max-age=2592000; includeSubDomains

```

To disable

```nginx
# Disabling HSTS
# If you completely want to disable HSTS, you can send the following knockout entry:


Strict-Transport-Security: max-age=0

```