################################################################################
#
# Navercert API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2023-12-10
# 연동기술지원 연락처 : 1600-9854 
# 연동기술지원 이메일 : code@linkhubcorp.com
#
################################################################################

require 'barocert/navercert'

class NavercertController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # Navercert 이용기관코드, Navercert 파트너 사이트에서 확인
  ClientCode = "023090000021";

  # NavercertService Instance 초기화
  NCService = NavercertService.instance(
      NavercertController::LinkID,
      NavercertController::SecretKey
  )

  # 인증토큰 IP제한기능 사용여부, true-사용, false-미사용, 기본값(true)
  NCService.setIpRestrictOnOff(true)

  # 네이버써트 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  NCService.setUseStaticIP(false)

  # 네이버 이용자에게 본인인증을 요청합니다.
  # https://developers.barocert.com/reference/naver/ruby/identity/api#RequestIdentity
  def requestIdentity

    # 본인인증 요청정보 객체
    identity = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => NCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => NCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => NCService._encrypt('19700101'),
      
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,

      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - 푸시(Push) 인증방식
      "appUseYN" => false,
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # "deviceOSType" => 'ANDROID',
      # AppToApp 방식 이용시, 호출할 URL
      # "http", "https"등의 웹프로토콜 사용 불가
      # "returnURL" => 'navercert://Identity'
    } 

    begin
      @Response = NCService.requestIdentity(ClientCode, identity)
      render "navercert/requestIdentity"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 본인인증 요청 후 반환받은 접수아이디로 본인인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/naver/ruby/identity/api#GetIdentityStatus
  def getIdentityStatus

    # 본인인증 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000009"

    begin
      @Response = NCService.getIdentityStatus(ClientCode, receiptID)
      render "navercert/getIdentityStatus"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 반환받은 전자서명값(signedData)과 [1. RequestIdentity] 함수 호출에 입력한 Token의 동일 여부를 확인하여 이용자의 본인인증 검증을 완료합니다.
  # 네이버 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # https://developers.barocert.com/reference/naver/ruby/identity/api#VerifyIdentity
  def verifyIdentity

    # 본인인증 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000009"

    begin
      @Response = NCService.verifyIdentity(ClientCode, receiptID)
      render "navercert/verifyIdentity"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 네이버 이용자에게 단건(1건) 문서의 전자서명을 요청합니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-single#RequestSign
  def requestSign

    sign = {
      
      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => NCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => NCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => NCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '전자서명(단건) 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => NCService._encrypt("전자서명(단건) 요청 메시지"),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 유형
      # TEXT - 일반 텍스트, HASH - HASH 데이터
      "tokenType" => 'TEXT',
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "token" => NCService._encrypt('전자서명(단건) 요청 원문'),
      # 서명 원문 유형
      # "tokenType" => 'HASH',
      # 서명 원문 유형이 HASH인 경우, 원문은 SHA-256, Base64 URL Safe No Padding을 사용
      # "token" => NCService._encrypt(NCService._sha256_base64url('전자서명(단건) 요청 원문')),
    
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - 푸시(Push) 인증방식
      "appUseYN" => false,
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # "deviceOSType" => 'ANDROID',
      # AppToApp 방식 이용시, 호출할 URL
      # "http", "https"등의 웹프로토콜 사용 불가
      # "returnURL" => 'navercert://sign'
    }

    begin
      @Response = NCService.requestSign(ClientCode,sign)
      render "navercert/requestSign"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 전자서명(단건) 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-single#GetSignStatus
  def getSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000010"

    begin
      @Response = NCService.getSignStatus(ClientCode, receiptID)
      render "navercert/getSignStatus"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 네이버 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-single#VerifySign
  def verifySign

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000010"

    begin
      @Response = NCService.verifySign(ClientCode, receiptID)
      render "navercert/verifySign"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 네이버 이용자에게 복수(최대 50건) 문서의 전자서명을 요청합니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-multi#RequestMultiSign
  def requestMultiSign

    multiSign = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => NCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => NCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => NCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '전자서명(복수) 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => NCService._encrypt("전자서명(복수) 요청 메시지"),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,

      # 개별문서 등록 - 최대 50 건
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "tokens" => [
        {
          # 서명 원문 유형
          # 'TEXT' - 일반 텍스트, 'HASH' - HASH 데이터
          "tokenType" => 'TEXT',  
          # 서명 원문 - 원문 2,800자 까지 입력가능  
          "token" => NCService._encrypt('전자서명(복수) 요청 원문 1'),
          # 서명 원문 유형
          # "tokenType" => 'HASH',
          # 서명 원문 유형이 HASH인 경우, 원문은 SHA-256, Base64 URL Safe No Padding을 사용
          # "token" => NCService._encrypt(NCService._sha256_base64url('전자서명(단건) 요청 원문 1')),
        },
        {
          # 서명 원문 유형
          # 'TEXT' - 일반 텍스트, 'HASH' - HASH 데이터
          "tokenType" => 'TEXT',
          # 서명 원문 - 원문 2,800자 까지 입력가능
          "token" => NCService._encrypt('전자서명(복수) 요청 원문 2'),
          # 서명 원문 유형
          # "tokenType" => 'HASH',
          # 서명 원문 유형이 HASH인 경우, 원문은 SHA-256, Base64 URL Safe No Padding을 사용
          # "token" => NCService._encrypt(NCService._sha256_base64url('전자서명(단건) 요청 원문 2')),
        },
      ],
      
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - 푸시(Push) 인증방식
      "appUseYN" => false,
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # "deviceOSType" => 'ANDROID',
      # AppToApp 방식 이용시, 호출할 URL
      # "http", "https"등의 웹프로토콜 사용 불가
      # "returnURL" => 'navercert://sign'
    }

    begin
      @Response = NCService.requestMultiSign(ClientCode,multiSign)
      render "navercert/requestMultiSign"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 전자서명(복수) 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-multi#GetMultiSignStatus
  def getMultiSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000012"

    begin
      @Response = NCService.getMultiSignStatus(ClientCode, receiptID)
      render "navercert/getMultiSignStatus"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 네이버 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # https://developers.barocert.com/reference/naver/ruby/sign/api-multi#VerifyMultiSign
  def verifyMultiSign

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000012"

    begin
      @Response = NCService.verifyMultiSign(ClientCode, receiptID)
      render "navercert/verifyMultiSign"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 네이버 이용자에게 자동이체 출금동의를 요청합니다.
  # https://developers.barocert.com/reference/naver/ruby/cms/api#RequestCMS
  def requestCMS

    # 출금동의 요청정보 객체
    cms = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => NCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => NCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => NCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '출금동의 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => NCService._encrypt('출금동의 요청 메시지'),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,

      # 청구기관명
      "requestCorp" = NCService._encrypt('청구기관'),    
      # 출금은행명
      "bankName" = NCService._encrypt('출금은행'),    
      # 출금계좌번호
      "bankAccountNum" = NCService._encrypt('123-456-7890'),    
      # 출금계좌 예금주명
      "bankAccountName" = NCService._encrypt('홍길동'),    
      # 출금계좌 예금주 생년월일
      "bankAccountBirthday" = NCService._encrypt('19700101'),    

      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - 푸시(Push) 인증방식
      "appUseYN" => false,
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # "deviceOSType" => 'ANDROID',
      # AppToApp 방식 이용시, 호출할 URL
      # "http", "https"등의 웹프로토콜 사용 불가
      # "returnURL" => 'navercert://cms'
    } 

    begin
      @Response = NCService.requestCMS(ClientCode, cms)
      render "navercert/requestCMS"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 자동이체 출금동의 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/naver/ruby/cms/api#GetCMSStatus
  def getCMSStatus

    # 출금동의 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000009"

    begin
      @Response = NCService.getCMSStatus(ClientCode, receiptID)
      render "navercert/getCMSStatus"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 네이버 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 만료일시 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/naver/ruby/cms/api#VerifyCMS
  def verifyCMS

    # 출금동의 요청시 반환받은 접수아이디
    receiptID = "02310300230900000210000000000009"

    begin
      @Response = NCService.verifyCMS(ClientCode, receiptID)
      render "navercert/verifyCMS"
    rescue BarocertException => ne
      @Response = ne
      render "home/exception"
    end
  end
end
