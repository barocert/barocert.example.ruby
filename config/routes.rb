Rails.application.routes.draw do
  root :to => 'home#index'

  get "/KakaocertExample/requestIdentity" => 'kakaocert#requestIdentity', via: [:get]
  get "/KakaocertExample/getIdentityStatus" => 'kakaocert#getIdentityStatus', via: [:get]
  get "/KakaocertExample/verifyIdentity" => 'kakaocert#verifyIdentity', via: [:get]

  get "/KakaocertExample/requestSign" => 'kakaocert#requestSign', via: [:get]
  get "/KakaocertExample/getSignStatus" => 'kakaocert#getSignStatus', via: [:get]
  get "/KakaocertExample/verifySign" => 'kakaocert#verifySign', via: [:get]
  
  get "/KakaocertExample/requestMultiSign" => 'kakaocert#requestMultiSign', via: [:get]
  get "/KakaocertExample/getMultiSignStatus" => 'kakaocert#getMultiSignStatus', via: [:get]
  get "/KakaocertExample/verifyMultiSign" => 'kakaocert#verifyMultiSign', via: [:get]

  get "/KakaocertExample/requestCMS" => 'kakaocert#requestCMS', via: [:get]
  get "/KakaocertExample/getCMSStatus" => 'kakaocert#getCMSStatus', via: [:get]
  get "/KakaocertExample/verifyCMS" => 'kakaocert#verifyCMS', via: [:get]

  get "/KakaocertExample/verifyLogin" => 'kakaocert#verifyLogin', via: [:get]

  get "/PasscertExample/requestIdentity" => 'passcert#requestIdentity', via: [:get]
  get "/PasscertExample/getIdentityStatus" => 'passcert#getIdentityStatus', via: [:get]
  get "/PasscertExample/verifyIdentity" => 'passcert#verifyIdentity', via: [:get]

  get "/PasscertExample/requestSign" => 'passcert#requestSign', via: [:get]
  get "/PasscertExample/getSignStatus" => 'passcert#getSignStatus', via: [:get]
  get "/PasscertExample/verifySign" => 'passcert#verifySign', via: [:get]

  get "/PasscertExample/requestCMS" => 'passcert#requestCMS', via: [:get]
  get "/PasscertExample/getCMSStatus" => 'passcert#getCMSStatus', via: [:get]
  get "/PasscertExample/verifyCMS" => 'passcert#verifyCMS', via: [:get]

  get "/PasscertExample/requestLogin" => 'passcert#requestLogin', via: [:get]
  get "/PasscertExample/getLoginStatus" => 'passcert#getLoginStatus', via: [:get]
  get "/PasscertExample/verifyLogin" => 'passcert#verifyLogin', via: [:get]

end
