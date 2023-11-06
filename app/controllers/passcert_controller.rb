################################################################################
#
# Passcert API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2023-11-06
# 연동기술지원 연락처 : 1600-9854 
# 연동기술지원 이메일 : code@linkhubcorp.com
#
################################################################################

require 'barocert/passcert'

class PasscertController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # Passcert 이용기관코드, Passcert 파트너 사이트에서 확인
  ClientCode = "023070000014";

  # PasscertService Instance 초기화
  PCService = PasscertService.instance(
      PasscertController::LinkID,
      PasscertController::SecretKey
  )

  # 인증토큰 IP제한기능 사용여부, true-사용, false-미사용, 기본값(true)
  PCService.setIpRestrictOnOff(true)

  # 패스써트 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  PCService.setUseStaticIP(false)

  # 패스 이용자에게 본인인증을 요청합니다.
  # https://developers.barocert.com/reference/pass/ruby/identity/api#RequestIdentity
  def requestIdentity

    # 본인인증 요청정보 객체
    identity = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => PCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => PCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => PCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '본인인증 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => PCService._encrypt('본인인증 요청 메시지'),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 최대 2,800자
      "token" => PCService._encrypt('본인인증 요청 원문'),
      
      # 사용자 동의 필요 여부
      "userAgreementYN" => true,
      # 사용자 정보 포함 여부
      "receiverInfoYN" => true,

      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Push 인증방식
      'appUseYN' => false,
      # ApptoApp 인증방식에서 사용
      # 통신사 유형('SKT', 'KT', 'LGU'), 대문자 입력(대소문자 구분)
      # 'telcoType' => "SKT",
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # 'deviceOSType' => "IOS"
    } 

    begin
      @Response = PCService.requestIdentity(ClientCode, identity)
      render "passcert/requestIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 본인인증 요청 후 반환받은 접수아이디로 본인인증 진행 상태를 확인합니다.
  # 상태확인 함수는 본인인증 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 본인인증 요청 함수를 호출한 당일 23시 59분 59초 이후 상태확인 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/identity/api#GetIdentityStatus
  def getIdentityStatus

    # 본인인증 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    begin
      @Response = PCService.getIdentityStatus(ClientCode, receiptId)
      render "passcert/getIdentityStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 반환받은 전자서명값(signedData)과 [1. RequestIdentity] 함수 호출에 입력한 Token의 동일 여부를 확인하여 이용자의 본인인증 검증을 완료합니다.
  # 검증 함수는 본인인증 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 본인인증 요청 함수를 호출한 당일 23시 59분 59초 이후 검증 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/identity/api#VerifyIdentity
  def verifyIdentity

    # 본인인증 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    identityVerify = {
			"receiverHP" => PCService._encrypt('01012341234'),
			"receiverName" => PCService._encrypt('홍길동')
		}

    begin
      @Response = PCService.verifyIdentity(ClientCode, receiptId, identityVerify)
      render "passcert/verifyIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 패스 이용자에게 문서의 전자서명을 요청합니다.
  # https://developers.barocert.com/reference/pass/ruby/sign/api#RequestSign
  def requestSign

    sign = {
      
      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => PCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => PCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => PCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '전자서명 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => PCService._encrypt('전자서명 요청 메시지'),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "token" => PCService._encrypt('전자서명 요청 원문'),
      # 서명 원문 유형
      # 'TEXT' - 일반 텍스트, 'HASH' - HASH 데이터, 'URL' - URL 데이터
      # 원본데이터(originalTypeCode, originalURL, originalFormatCode) 입력시 'TEXT'사용 불가
      "tokenType" => 'HASH',

      # 사용자 동의 필요 여부
      "userAgreementYN" => true,
      # 사용자 정보 포함 여부
      "receiverInfoYN" => true,

      # 원본유형코드
      # 'AG' - 동의서, 'AP' - 신청서, 'CT' - 계약서, 'GD' - 안내서, 'NT' - 통지서, 'TR' - 약관
      "originalTypeCode" => "TR",
      # 원본조회URL
      "originalURL" => "https://www.passcert.co.kr",
      # 원본형태코드
      "originalFormatCode" => "HTML",
            
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Push 인증방식
      'appUseYN' => false,
      # ApptoApp 인증방식에서 사용
      # 통신사 유형('SKT', 'KT', 'LGU'), 대문자 입력(대소문자 구분)
      # 'telcoType' => "SKT",
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # 'deviceOSType' => "IOS"
    }

    begin
      @Response = PCService.requestSign(ClientCode,sign)
      render "passcert/requestSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # 상태확인 함수는 전자서명 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 전자서명 요청 함수를 호출한 당일 23시 59분 59초 이후 상태확인 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/sign/api#GetSignStatus
  def getSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000011"

    begin
      @Response = PCService.getSignStatus(ClientCode, receiptId)
      render "passcert/getSignStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 검증 함수는 전자서명 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 전자서명 요청 함수를 호출한 당일 23시 59분 59초 이후 검증 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/sign/api#VerifySign
  def verifySign

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000011"

    signVerify = {
			"receiverHP" => PCService._encrypt('01012341234'),
			"receiverName" => PCService._encrypt('홍길동')
		}

    begin
      @Response = PCService.verifySign(ClientCode, receiptId, signVerify)
      render "passcert/verifySign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 패스 이용자에게 자동이체 출금동의를 요청합니다.
  # https://developers.barocert.com/reference/pass/ruby/cms/api#RequestCMS
  def requestCMS

    # 자동이체 출금동의 요청정보 객체
    cms = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
			"receiverHP" => PCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
			"receiverName" => PCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
			"receiverBirthday" => PCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
			"reqTitle" => '출금동의 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => PCService._encrypt('출금동의 요청 메시지'),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
			"expireIn" => 1000,
      
      # 사용자 동의 필요 여부
      "userAgreementYN" => true,
      # 사용자 정보 포함 여부
      "receiverInfoYN" => true,
      # 출금은행명 - 최대 100자
			"bankName" => PCService._encrypt("국민은행"),
      # 출금계좌번호 - 최대 31자
			"bankAccountNum" => PCService._encrypt("9-****-5117-58"),
      # 출금계좌 예금주명 - 최대 100자
			"bankAccountName" => PCService._encrypt("홍길동"),
      # 출금계좌 예금주 생년월일 - 8자
			"bankAccountBirthday" => PCService._encrypt("19700101"),
      # 출금유형
      # CMS - 출금동의, OPEN_BANK - 오픈뱅킹
			"bankServiceType" => PCService._encrypt("CMS"),
      # 출금액
			"bankWithdraw" => PCService._encrypt("1,000,000원"),
      
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Push 인증방식
      'appUseYN' => false,
      # ApptoApp 인증방식에서 사용
      # 통신사 유형('SKT', 'KT', 'LGU'), 대문자 입력(대소문자 구분)
      # 'telcoType' => "SKT",
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # 'deviceOSType' => "IOS"
		}

    begin
      @Response = PCService.requestCMS(ClientCode,cms)
      render "passcert/requestCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 자동이체 출금동의 요청 후 반환받은 접수아이디로 인증 진행 상태를 확인합니다.
  # 상태확인 함수는 자동이체 출금동의 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 자동이체 출금동의 요청 함수를 호출한 당일 23시 59분 59초 이후 상태확인 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/cms/api#GetCMSStatus
  def getCMSStatus

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000014"

    begin
      @Response = PCService.getCMSStatus(ClientCode, receiptId)
      render "passcert/getCMSStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 검증 함수는 자동이체 출금동의 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 자동이체 출금동의 요청 함수를 호출한 당일 23시 59분 59초 이후 검증 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/cms/api#VerifyCMS
  def verifyCMS

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000014"

    cmsVerify = {
			"receiverHP" => PCService._encrypt('01012341234'),
			"receiverName" => PCService._encrypt('홍길동')
		}

    begin
      @Response = PCService.verifyCMS(ClientCode, receiptId, cmsVerify)
      render "passcert/verifyCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 패스 이용자에게 간편로그인을 요청합니다.
  # https://developers.barocert.com/reference/pass/ruby/login/api#RequestLogin
  def requestLogin

    # 간편로그인 요청정보 객체
    login = {

      # 수신자 휴대폰번호 - 11자 (하이픈 제외)
      "receiverHP" => PCService._encrypt('01012341234'),
      # 수신자 성명 - 80자
      "receiverName" => PCService._encrypt('홍길동'),
      # 수신자 생년월일 - 8자 (yyyyMMdd)
      "receiverBirthday" => PCService._encrypt('19700101'),
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '간편로그인 요청 메시지 제목',
      # 인증요청 메시지 - 최대 500자
      "reqMessage" => PCService._encrypt('간편로그인 요청 메시지'),
      # 고객센터 연락처 - 최대 12자
      "callCenterNum" => '1600-9854',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 최대 2,800자
      "token" => PCService._encrypt('간편로그인 요청 원문'),
      
      # 사용자 동의 필요 여부
      "userAgreementYN" => true,
      # 사용자 정보 포함 여부
      "receiverInfoYN" => true,

      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Push 인증방식
      'appUseYN' => false,
      # ApptoApp 인증방식에서 사용
      # 통신사 유형('SKT', 'KT', 'LGU'), 대문자 입력(대소문자 구분)
      # 'telcoType' => "SKT",
      # ApptoApp 인증방식에서 사용
      # 모바일장비 유형('ANDROID', 'IOS'), 대문자 입력(대소문자 구분)
      # 'deviceOSType' => "IOS"
    } 

    begin
      @Response = PCService.requestLogin(ClientCode, login)
      render "passcert/requestLogin"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 간편로그인 요청 후 반환받은 접수아이디로 진행 상태를 확인합니다.
  # 상태확인 함수는 간편로그인 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 간편로그인 요청 함수를 호출한 당일 23시 59분 59초 이후 상태확인 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/login/api#GetLoginStatus
  def getLoginStatus

    # 간편로그인 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    begin
      @Response = PCService.getLoginStatus(ClientCode, receiptId)
      render "passcert/getLoginStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 완료된 전자서명을 검증하고 전자서명값(signedData)을 반환 받습니다.
  # 검증 함수는 간편로그인 요청 함수를 호출한 당일 23시 59분 59초까지만 호출 가능합니다.
  # 간편로그인 요청 함수를 호출한 당일 23시 59분 59초 이후 검증 함수를 호출할 경우 오류가 반환됩니다.
  # https://developers.barocert.com/reference/pass/ruby/login/api#VerifyLogin
  def verifyLogin

    # 간편로그인 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    loginVerify = {
			"receiverHP" => PCService._encrypt('01012341234'),
			"receiverName" => PCService._encrypt('홍길동')
		}

    begin
      @Response = PCService.verifyLogin(ClientCode, receiptId, loginVerify)
      render "passcert/verifyLogin"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
