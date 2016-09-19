module QyWechat
  module Base

    CORPID = "wxeb9c2ddbb4858794"
    CORPSECRET = "FynaaT3ybNYJygOL_Hr5n0qRBjnc05TPXlBC0bPmo_kbIaWSDEKi1SnqnmTIwDYL"
    TOKEN_URL = "https://qyapi.weixin.qq.com/cgi-bin/gettoken"
    def get_access_token
      args = {:corpid =>CORPID , :corpsecret => CORPSECRET}
      access_token=YAML.load_file(Rails.root.to_s + '/config/qywx_token.yml')
      if (access_token["expires_time"]+7200) < Time.now
        response= RestClient.get(TOKEN_URL,:params => args.to_json)
        tmp=response.body ? JSON.load(response.body) : {}
        tmp["expires_time"]=Time.now
        File.open(Rails.root.to_s + '/config/qywx_token.yml','w'){|file| YAML.dump(tmp,file)}
        access_token=YAML.load_file(Rails.root.to_s + '/config/qywx_token.yml')
      end
      return access_token["access_token"]
    end
  end
end