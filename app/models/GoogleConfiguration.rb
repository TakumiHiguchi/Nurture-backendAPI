require 'json'
require 'jwt' #jwt認証のライブラリ
require 'openssl'
require 'net/https'
require "base64" #base64ライブラリ

#グーグルOpenIdのベースURL（ここからJWK形式の公開鍵を取得するURLを取得する）
GOOGLE_OPENID_CONFIGURATION_HOST = "https://accounts.google.com/.well-known/openid-configuration".freeze
#タイムアウト秒数
TIMEOUT = 5
class GoogleConfiguration
    def userData(token)
        aud = ['653992313170-7iqt3ahq46pg322edi3l117kife5e6d8.apps.googleusercontent.com']
        iss = ['accounts.google.com']
        
        #トークンのヘッダーを取得
        token_header = decodeTokenHeader(token)
        
        #トークンがRS256で、JWTで書かれているか判定
        if token_header["alg"] == "RS256" && token_header["typ"] == "JWT"
            #jwkを取得して、RSA形式のPublicKeyに変換
            publicKey = rsaPubkey(token_header["kid"])
            
            if !publicKey.nil?
                decoded_token = JWT.decode token, publicKey, true, { :verify_iat => true, :iss => iss, :verify_iss => true, :aud => aud, :verify_aud => true, :algorithm => 'RS256' }
            end
            return decoded_token[0]
        else
            return nil
        end
        
    end
    
    def rsaPubkey(kid)
        #JWK形式のPublicKeyの取得
        jwkPubkeys = jwkPublicKey_load
        jwkPubkeys["keys"].each do |keyData|
            #ヘッダーのkidが公開鍵のkidと一致したらJWKの公開鍵をRSAの公開鍵にする
            @rsaPublicKey = jwkPubkey_to_rsaPubkey(keyData) if keyData["kid"] == kid
        end
        
        if @rsaPublicKey.nil?
            return nil
        else
            return @rsaPublicKey
        end
        
    end
    
    #ここから
    def jwkPubkey_to_rsaPubkey(keyData)
        modulus = openssl_bn(keyData['n'])
        exponent = openssl_bn(keyData['e'])
        sequence = OpenSSL::ASN1::Sequence.new(
          [OpenSSL::ASN1::Integer.new(modulus),
            OpenSSL::ASN1::Integer.new(exponent)])
        return OpenSSL::PKey::RSA.new(sequence.to_der)
            
    end
    
    def openssl_bn(n)
        n = n + '=' * (4 - n.size % 4) if n.size % 4 != 0
        decoded = Base64.urlsafe_decode64 n
        unpacked = decoded.unpack('H*').first
        OpenSSL::BN.new unpacked, 16
    end
    
    #ここまで
    
    def decodeTokenHeader(token)
        #トークンヘッダーをbase64でデコードして、加工する
        hash = {}
        tokenHeader = Base64.decode64(token.split(".")[0]).split(',').map { |m| m.delete('"{}')}
        
        #加工したヘッダーを連想配列にする
        tokenHeader.each do |element|
            el = element.split(':')
            hash[el[0]] = el[1]
        end
        return hash
    end
    
    def jwkPublicKey_load
        #googleのjwk形式の公開鍵があるURLの取得
        jwkPubkeyURL = jwkPublicKeyUrl_load
        
        #jwk形式の公開鍵の取得
        uri = URI.parse(jwkPubkeyURL)
        https = Net::HTTP.new(uri.host, uri.port)
        https.open_timeout = TIMEOUT
        https.read_timeout = TIMEOUT
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5

        begin
          response = nil
          https.start do
            response = https.get(uri.path)
          end
            return JSON.parse(response.body)
        rescue => e
            logger.error([e.class, e.message].join(' : '))
        end
    end
    
    def jwkPublicKeyUrl_load
        #JWK形式の公開鍵を取得するURLを取得する
        uri = URI.parse(GOOGLE_OPENID_CONFIGURATION_HOST)
        https = Net::HTTP.new(uri.host, uri.port)
        https.open_timeout = TIMEOUT
        https.read_timeout = TIMEOUT
        https.use_ssl = true
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5

        begin
          response = nil
          https.start do
            response = https.get(uri.path)
          end
            return JSON.parse(response.body)["jwks_uri"]
        rescue => e
            logger.error([e.class, e.message].join(' : '))
        end
    end
end
