class Common::Wechat
  APPID = "wxfb21fe42fad45945"
  TOKEN_URL = "https://api.weixin.qq.com/cgi-bin/token"
  TICKET_URL = "https://api.weixin.qq.com/cgi-bin/ticket/getticket"
  SECRET = "6c405c91ded274312c3871a4c46ad8f7"
  attr_accessor :jsapi_ticket

  def initialize(args={})
    if File.exist?(Rails.root.to_s + '/config/wechat_jsapi_ticket.yml')
      tmp = YAML.load_file(RAILS_ROOT + '/config/wechat_jsapi_ticket.yml')
      if (tmp["expires_time"]+7200) < Time.now
        set_jsapi_ticket
      else
        self.jsapi_ticket = tmp["ticket"]
      end
    else
      set_jsapi_ticket
    end
  end

  def set_jsapi_ticket
    response = RestClient.get(TOKEN_URL,{params: {grant_type: "client_credential" ,appid: APPID, secret: SECRET}})
    access_token = JSON.load(response.body)["access_token"]
    response = RestClient.get(TICKET_URL,{params: {access_token: access_token ,type: "jsapi"}})
    tmp = JSON.load(response.body)
    tmp["expires_time"]=Time.now
    File.open(Rails.root.to_s + '/config/wechat_jsapi_ticket.yml','w'){|file| YAML.dump(tmp,file)}
    self.jsapi_ticket = tmp["ticket"]
  end
end