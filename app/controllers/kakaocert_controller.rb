################################################################################
#
# Barocert KAKAO API Ruby SDK Example
#
# 업데이트 일자 : 2024-04-17
# 연동기술지원 연락처 : 1600-9854
# 연동기술지원 이메일 : code@linkhubcorp.com
#         
# <테스트 연동개발 준비사항>
#   1) API Key 변경 (연동신청 시 메일로 전달된 정보)
#       - LinkID : 링크허브에서 발급한 링크아이디
#       - SecretKey : 링크허브에서 발급한 비밀키
#   2) ClientCode 변경 (연동신청 시 메일로 전달된 정보)
#       - ClientCode : 이용기관코드 (파트너 사이트에서 확인가능)
#   3) SDK 환경설정 필수 옵션 설정
#       - IPRestrictOnOff : 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
#       - UseStaticIP : 통신 IP 고정, true-사용, false-미사용, (기본값:false)
#
################################################################################

require 'barocert/kakaocert'

class KakaocertController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 이용기관코드 (파트너 사이트에서 확인가능)
  ClientCode = "023040000001";

  # KakaocertService Instance 초기화
  KCService = KakaocertService.instance(
      KakaocertController::LinkID,
      KakaocertController::SecretKey
  )

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  KCService.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  KCService.setUseStaticIP(false)

  # 카카오톡 이용자에게 본인인증을 요청합니다.
  # https://developers.barocert.com/reference/kakao/ruby/identity/api#RequestIdentity
  def requestIdentity

    # 본인인증 요청정보 객체
    identity = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => KCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => KCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => KCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '본인인증 요청 메시지 제목',
      # 커스텀 메시지 - 최대 500자
      "extraMessage" => KCService._encrypt('본인인증 커스텀 메시지'),
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 최대 40자 까지 입력가능
      "token" => KCService._encrypt('본인인증 요청 원문'),
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      'appUseYN' => false,
      # App to App 방식 이용시, 호출할 URL
      # "returnURL" => 'https://kakao.barocert.com'
    } 

    begin
      @Response = KCService.requestIdentity(ClientCode, identity)
      render "kakaocert/requestIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 본인인증 요청 후 반환받은 접수아이디로 본인인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/kakao/ruby/identity/api#GetIdentityStatus
  def getIdentityStatus

    # 본인인증 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000015"

    begin
      @Response = KCService.getIdentityStatus(ClientCode, receiptID)
      render "kakaocert/getIdentityStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 반환받은 전자서명값(signedData)과 [1. RequestIdentity] 함수 호출에 입력한 Token의 동일 여부를 확인하여 이용자의 본인인증 검증을 완료합니다.
  # 카카오 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 완료일시로부터 10분 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/kakao/ruby/identity/api#VerifyIdentity
  def verifyIdentity

    # 본인인증 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000015"

    begin
      @Response = KCService.verifyIdentity(ClientCode, receiptID)
      render "kakaocert/verifyIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 카카오톡 이용자에게 단건(1건) 문서의 전자서명을 요청합니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-single#RequestSign
  def requestSign

    sign = {
      
      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => KCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => KCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => KCService._encrypt('19700101'),
      
      # 서명 요청 제목 - 최대 40자
      "signTitle" => '전자서명(단건) 서명 요청 제목',
      # 커스텀 메시지 - 최대 500자
      "extraMessage" => KCService._encrypt('전자서명(단건) 커스텀 메시지'),
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "token" => KCService._encrypt('전자서명(단건) 요청 원문'),
      # 서명 원문 유형
      # TEXT - 일반 텍스트, HASH - HASH 데이터
      "tokenType" => 'TEXT',
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      "appUseYN" => false,
      # App to App 방식 이용시, 호출할 URL
      # "returnURL" => 'https://kakao.barocert.com'
    }
      

    begin
      @Response = KCService.requestSign(ClientCode,sign)
      render "kakaocert/requestSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명(단건) 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-single#GetSignStatus
  def getSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000011"

    begin
      @Response = KCService.getSignStatus(ClientCode, receiptID)
      render "kakaocert/getSignStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 카카오 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 완료일시로부터 10분 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-single#VerifySign
  def verifySign

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000011"

    begin
      @Response = KCService.verifySign(ClientCode, receiptID)
      render "kakaocert/verifySign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 카카오톡 이용자에게 복수(최대 20건) 문서의 전자서명을 요청합니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-multi#RequestMultiSign
  def requestMultiSign

    multiSign = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => KCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => KCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => KCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '전자서명(복수) 요청 메시지 제목',
      # 커스텀 메시지 - 최대 500자
      "extraMessage" => KCService._encrypt('전자서명(복수) 커스텀 메시지'),
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "tokens" => [
        {
          # 서명 요청 제목 - 최대 40자
          "signTitle" => "전자서명(복수) 서명 요청 제목 1",
          # 서명 원문 - 원문 2,800자 까지 입력가능  
          "token" => KCService._encrypt('전자서명(복수) 요청 원문 1'),
        },
        {
          # 서명 요청 제목 - 최대 40자
          "signTitle" => "전자서명(복수) 서명 요청 제목 2",
          # 서명 원문 - 원문 2,800자 까지 입력가능
          "token" => KCService._encrypt('전자서명(복수) 요청 원문 2'),
        },
      ],
      # 서명 원문 유형
      # TEXT - 일반 텍스트, HASH - HASH 데이터
      "tokenType" => 'TEXT',
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      "appUseYN" => false,
      # App to App 방식 이용시, 호출할 URL
      # "returnURL" => 'https://kakao.barocert.com'
    }

    begin
      @Response = KCService.requestMultiSign(ClientCode,multiSign)
      render "kakaocert/requestMultiSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명(복수) 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-multi#GetMultiSignStatus
  def getMultiSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000013"

    begin
      @Response = KCService.getMultiSignStatus(ClientCode, receiptID)
      render "kakaocert/getMultiSignStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 카카오 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 완료일시로부터 10분 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/kakao/ruby/sign/api-multi#VerifyMultiSign
  def verifyMultiSign

    # 전자서명 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000013"

    begin
      @Response = KCService.verifyMultiSign(ClientCode, receiptID)
      render "kakaocert/verifyMultiSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 카카오톡 이용자에게 자동이체 출금동의를 요청합니다.
  # https://developers.barocert.com/reference/kakao/ruby/cms/api#RequestCMS
  def requestCMS

    # 자동이체 출금동의 요청정보 객체
    cms = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => KCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => KCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => KCService._encrypt('19700101'),

      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '출금동의 요청 메시지 제목',
      # 커스텀 메시지 - 최대 500자
      "extraMessage" => KCService._encrypt('출금동의 커스텀 메시지'),
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 청구기관명 - 최대 100자
      "requestCorp" => KCService._encrypt("링크허브"),
      # 출금은행명 - 최대 100자
      "bankName" => KCService._encrypt("국민은행"),
      # 출금계좌번호 - 최대 32자
      "bankAccountNum" => KCService._encrypt("19-321442-1231"),
      # 출금계좌 예금주명 - 최대 100자
      "bankAccountName" => KCService._encrypt("홍길동"),
      # 출금계좌 예금주 생년월일 - 8자
      "bankAccountBirthday" => KCService._encrypt("19700101"),
      # 출금유형
      # CMS - 출금동의용, FIRM - 펌뱅킹, GIRO - 지로용
      "bankServiceType" => KCService._encrypt("CMS"),
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      "appUseYN" => false,
      # App to App 방식 이용시, 에러시 호출할 URL
      # "returnURL" => 'https://kakao.barocert.com'
		}

    begin
      @Response = KCService.requestCMS(ClientCode,cms)
      render "kakaocert/requestCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 자동이체 출금동의 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # https://developers.barocert.com/reference/kakao/ruby/cms/api#GetCMSStatus
  def getCMSStatus

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000014"

    begin
      @Response = KCService.getCMSStatus(ClientCode, receiptID)
      render "kakaocert/getCMSStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 카카오 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 완료일시로부터 10분 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/kakao/ruby/cms/api#VerifyCMS
  def verifyCMS

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptID = "02305090230400000010000000000014"

    begin
      @Response = KCService.verifyCMS(ClientCode, receiptID)
      render "kakaocert/verifyCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명 데이터 전문(signedData)을 반환 받습니다.
  # 카카오 보안정책에 따라 검증 API는 1회만 호출할 수 있습니다. 재시도시 오류가 반환됩니다.
  # 전자서명 완료일시로부터 10분 이후에 검증 API를 호출하면 오류가 반환됩니다.
  # https://developers.barocert.com/reference/kakao/ruby/login/api#VerifyLogin
  def verifyLogin

    # 간편로그인 요청시 반환받은 트랜잭션 아이디
    txId = "01432a68fd-d92c-4c70-9888-ee42b7ce4d25"

    begin
      @Response = KCService.verifyLogin(ClientCode, txId)
      render "kakaocert/verifyLogin"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
