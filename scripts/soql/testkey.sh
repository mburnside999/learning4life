#!/bin/sh
        
usage ()
{
echo 'Generates a random 256-bit value, hashes it, and encrypts it using a given certificate.'
echo 'Outputs a bunch of files into pwd.  encrypted_secret.b64 is the one to upload to sfdc'
echo ''
echo 'Usage : secretgen <downloaded.crt>'
    exit
    }
    
    if [ -z "$1" ]
    then
    usage
    fi
    
    PLAINTEXT_SECRET="plaintext_secret.bin"
    PLAINTEXT_SECRET_B64="plaintext_secret.b64"
    PLAINTEXT_SECRET_HASH_B64="plaintext_secret_hash.b64"
    ENCRYPTED_SECRET_B64="encrypted_secret.b64"
    PUBLIC_KEY_PEM="public_key.pem"
    
    head -c 32 /dev/urandom > $PLAINTEXT_SECRET
    
    openssl dgst -sha256 -binary $PLAINTEXT_SECRET | openssl base64 -out $PLAINTEXT_SECRET_HASH_B64
    
    openssl x509 -pubkey -noout -in $1 > $PUBLIC_KEY_PEM
    
    openssl pkeyutl -pkeyopt rsa_oaep:sha256 -oaep -encrypt -pubin -inkey $PUBLIC_KEY_PEM -in $PLAINTEXT_SECRET | openssl base64 -out $ENCRYPTED_SECRET_B64
    
    #openssl enc -aes-256-cbc -e -in $PLAINTEXT_SECRET -a -salt -out $PLAINTEXT_SECRET_B64