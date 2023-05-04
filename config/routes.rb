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

end
