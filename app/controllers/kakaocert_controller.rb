################################################################################
#
# Kakaocert API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2023-05-04
# 연동기술지원 연락처 : 1600-9854 
# 연동기술지원 이메일 : dev@linkhubcorp.com
#
################################################################################

require 'barocert/kakaocert'

class KakaocertController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # Kakaocert 이용기관코드, Kakaocert 파트너 사이트에서 확인
  ClientCode = "023040000001";

  # KakaocertService Instance 초기화
  KCService = KakaocertService.instance(
      KakaocertController::LinkID,
      KakaocertController::SecretKey
  )

  # 인증토큰 IP제한기능 사용여부, true-권장
  KCService.setIpRestrictOnOff(true)

  # 카카오써트 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  KCService.setUseStaticIP(false)

  # 로컬시스템 시간 사요영부, true-사용, false-미사용, 기본값(true)
  KCService.setUseLocalTimeYN(true)

  # 카카오톡 사용자에게 본인인증 전자서명을 요청합니다.
  def requestIdentity

    # 본인인증 요청정보 객체
    identity = {
      
      # 수신자 정보
      # 휴대폰번호,성명,생년월일 또는 Ci(연계정보)값 중 택 일
      "receiverHP" => KakaocertController::KCService._encrypt('01054437896'),
      "receiverName" => KakaocertController::KCService._encrypt('최상혁'),
      "receiverBirthday" => KakaocertController::KCService._encrypt('19880301'),
      "ci" => '',
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '인증요청 메시지 제목란',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 최대 40자 까지 입력가능
      "token" => KakaocertController::KCService._encrypt('본인인증요청토큰'),
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      'appUseYN' => false,
      # App to App 방식 이용시, 호출할 URL
      "returnURL" => 'https://kakao.barocert.com'
    } 

    begin
      @Response = KCService.requestIdentity(KakaocertController::ClientCode, identity)
      render "kakaocert/requestIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 본인인증 요청시 반환된 접수아이디를 통해 서명 상태를 확인합니다.
  def getIdentityStatus

    # 본인인증 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    begin
      @Response = KCService.getIdentityStatus(KakaocertController::ClientCode, receiptId)
      render "kakaocert/getIdentityStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 본인인증 요청시 반환된 접수아이디를 통해 본인인증 서명을 검증합니다. 
  # 검증하기 API는 완료된 전자서명 요청당 1회만 요청 가능하며, 사용자가 서명을 완료후 유효시간(10분)이내에만 요청가능 합니다.
  def verifyIdentity

    # 본인인증 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000015"

    begin
      @Response = KCService.verifyIdentity(KakaocertController::ClientCode, receiptId)
      render "kakaocert/verifyIdentity"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 인증을 요청합니다.
  def requestSign

    sign = {
      
      # 수신자 정보
      # 휴대폰번호,성명,생년월일 또는 Ci(연계정보)값 중 택 일
      "receiverHP" => KakaocertController::KCService._encrypt('01054437896'),
      "receiverName" => KakaocertController::KCService._encrypt('최상혁'),
      "receiverBirthday" => KakaocertController::KCService._encrypt('19880301'),
      "ci" => '',
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '인증요청 메시지 제목란',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "token" => KakaocertController::KCService._encrypt('전자서명단건테스트데이터'),
      # 서명 원문 유형
      # TEXT - 일반 텍스트, HASH - HASH 데이터
      "tokenType" => 'TEXT',
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      "appUseYN" => false,
      # App to App 방식 이용시, 호출할 URL
      "returnURL" => 'https://kakao.barocert.com'
    }
      

    begin
      @Response = KCService.requestSign(KakaocertController::ClientCode,sign)
      render "kakaocert/requestSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 요청시 반환된 접수아이디를 통해 서명 상태를 확인합니다. (단건)
  def getSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000011"

    begin
      @Response = KCService.getSignStatus(KakaocertController::ClientCode, receiptId)
      render "kakaocert/getSignStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 요청시 반환된 접수아이디를 통해 서명을 검증합니다. (단건)
  # 검증하기 API는 완료된 전자서명 요청당 1회만 요청 가능하며, 사용자가 서명을 완료후 유효시간(10분)이내에만 요청가능 합니다.
  def verifySign

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000011"

    begin
      @Response = KCService.verifySign(KakaocertController::ClientCode, receiptId)
      render "kakaocert/verifySign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 카카오톡 사용자에게 전자서명을 요청합니다.(복수)
  def requestMultiSign

    multiSign = {
      
      # 수신자 정보
      # 휴대폰번호,성명,생년월일 또는 Ci(연계정보)값 중 택 일
      "receiverHP" => KakaocertController::KCService._encrypt('01054437896'),
      "receiverName" => KakaocertController::KCService._encrypt('최상혁'),
      "receiverBirthday" => KakaocertController::KCService._encrypt('19880301'),
      "ci" => '',
      
      # 인증요청 메시지 제목 - 최대 40자
      "reqTitle" => '인증요청 메시지 제목란',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
      "expireIn" => 1000,
      # 서명 원문 - 원문 2,800자 까지 입력가능
      "tokens" => [
        {
          # 인증요청 메시지 제목 - 최대 40자
          "reqTitle" => "전자서명복수테스트1",
          # 서명 원문 - 원문 2,800자 까지 입력가능  
          "token" => KakaocertController::KCService._encrypt('전자서명복수테스트데이터1'),
        },
        {
          # 인증요청 메시지 제목 - 최대 40자
          "reqTitle" => "전자서명복수테스트2",
          # 서명 원문 - 원문 2,800자 까지 입력가능
          "token" => KakaocertController::KCService._encrypt('전자서명복수테스트데이터2'),
        },
      ],
      # 서명 원문 유형
      # TEXT - 일반 텍스트, HASH - HASH 데이터
      "tokenType" => 'TEXT',
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
      "appUseYN" => false,
      # App to App 방식 이용시, 호출할 URL
      "returnURL" => 'https://kakao.barocert.com'
    }
      

    begin
      @Response = KCService.requestMultiSign(KakaocertController::ClientCode,multiSign)
      render "kakaocert/requestMultiSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 요청시 반환된 접수아이디를 통해 서명 상태를 확인합니다. (복수)
  def getMultiSignStatus

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000013"

    begin
      @Response = KCService.getMultiSignStatus(KakaocertController::ClientCode, receiptId)
      render "kakaocert/getSignStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 전자서명 요청시 반환된 접수아이디를 통해 서명을 검증합니다. (복수)
  # 검증하기 API는 완료된 전자서명 요청당 1회만 요청 가능하며, 사용자가 서명을 완료후 유효시간(10분)이내에만 요청가능 합니다.
  def verifyMultiSign

    # 전자서명 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000013"

    begin
      @Response = KCService.verifyMultiSign(KakaocertController::ClientCode, receiptId)
      render "kakaocert/verifyMultiSign"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 카카오톡 사용자에게 자동이체 출금동의 전자서명을 요청합니다.
  def requestCMS

    # 자동이체 출금동의 요청정보 객체
    cms = {
      # 수신자 정보
      # 휴대폰번호,성명,생년월일 또는 Ci(연계정보)값 중 택 일
			"receiverHP" => KakaocertController::KCService._encrypt('01054437896'),
			"receiverName" => KakaocertController::KCService._encrypt('최상혁'),
			"receiverBirthday" => KakaocertController::KCService._encrypt('19880301'),
			"ci" => '',
      # 인증요청 메시지 제목 - 최대 40자
			"reqTitle" => '인증요청 메시지 제목란',
      # 인증요청 만료시간 - 최대 1,000(초)까지 입력 가능
			"expireIn" => 1000,
      # 청구기관명 - 최대 100자
			"requestCorp" => KakaocertController::KCService._encrypt("링크허브"),
      # 출금은행명 - 최대 100자
			"bankName" => KakaocertController::KCService._encrypt("국민은행"),
      # 출금계좌번호 - 최대 32자
			"bankAccountNum" => KakaocertController::KCService._encrypt("19-321442-1231"),
      # 출금계좌 예금주명 - 최대 100자
			"bankAccountName" => KakaocertController::KCService._encrypt("최상혁"),
      # 출금계좌 예금주 생년월일 - 8자
			"bankAccountBirthday" => KakaocertController::KCService._encrypt("19880301"),
      # 출금유형
      # CMS - 출금동의용, FIRM - 펌뱅킹, GIRO - 지로용
			"bankServiceType" => KakaocertController::KCService._encrypt("CMS"),
      # AppToApp 인증요청 여부
      # true - AppToApp 인증방식, false - Talk Message 인증방식
			"appUseYN" => false,
      # App to App 방식 이용시, 에러시 호출할 URL
			"returnURL" => 'https://kakao.barocert.com'
		}


    begin
      @Response = KCService.requestCMS(KakaocertController::ClientCode,cms)
      render "kakaocert/requestCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 자동이체 출금동의 요청시 반환된 접수아이디를 통해 서명 상태를 확인합니다.
  def getCMSStatus

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000014"

    begin
      @Response = KCService.getCMSStatus(KakaocertController::ClientCode, receiptId)
      render "kakaocert/getCMSStatus"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end

  # 자동이체 출금동의 요청시 반환된 접수아이디를 통해 서명을 검증합니다.
  # 검증하기 API는 완료된 전자서명 요청당 1회만 요청 가능하며, 사용자가 서명을 완료후 유효시간(10분)이내에만 요청가능 합니다.
  def verifyCMS

    # 자동이체 출금동의 요청시 반환받은 접수아이디
    receiptId = "02305090230400000010000000000014"

    begin
      @Response = KCService.verifyCMS(KakaocertController::ClientCode, receiptId)
      render "kakaocert/verifyCMS"
    rescue BarocertException => pe
      @Response = pe
      render "home/exception"
    end
  end


end
