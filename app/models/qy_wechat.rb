class QyWechat

  CORPID = "wxeb9c2ddbb4858794"
  CORPSECRET = "FynaaT3ybNYJygOL_Hr5n0qRBjnc05TPXlBC0bPmo_kbIaWSDEKi1SnqnmTIwDYL"
  TOKEN_URL = "https://qyapi.weixin.qq.com/cgi-bin/gettoken"
  BLOCK_SIZE = 32

  attr_accessor :access_token
  attr_accessor :apply_token, :encoding_aes_key

  def initialize(*args)
    args = {:corpid => CORPID , :corpsecret => CORPSECRET}
    qy_token=YAML.load_file(Rails.root.to_s + '/config/qywx_token.yml')
    if (qy_token["expires_time"]+7200) < Time.now
      response= RestClient.get(TOKEN_URL,:params => args)
      tmp=response.body ? JSON.load(response.body) : {}
      tmp["expires_time"]=Time.now
      File.open(Rails.root.to_s + '/config/qywx_token.yml','w'){|file| YAML.dump(tmp,file)}
      qy_token=YAML.load_file(Rails.root.to_s + '/config/qywx_token.yml')
    end
    self.access_token = qy_token["access_token"]
  end

  # 应用回调验证,返回明文的echostr跟status
  # 第一次验证echostr是params[:echostr],以后验证echostr是params[:xml][:Encrypt]
  def verify_url(msg_signature,timestamp,nonce,echostr)
    signature=Digest::SHA1.hexdigest([self.apply_token,timestamp, nonce, echostr].sort.join)
    Rails.logger.debug "signature:#{signature}"
    if signature == msg_signature
      status,result = 200, decrypt(echostr)
    else
      status, result = 401, "<xml></xml>"
    end
    return status,result
  end

  # 解密
  def decrypt(encrypt)
    # 使用BASE64对密文进行解码
    text = Base64.decode64(encrypt)
    aes_key=Base64.decode64(self.encoding_aes_key + '=')
    text = handle_cipher(:decrypt, aes_key, text)
    result = decode_padding(text)
    xml_len = result[16, 4].reverse.unpack('V')[0]
    xml_content = result[20,xml_len]
    from_corpid = result[(20+xml_len)..-1]
    # if from_corpid != CORPID
    #   Rails.logger.debug("#{__FILE__}:#{__LINE__} Failure because #{CORPID} != #{from_corpid}")
    #   status = 401
    # end
    return xml_content
  end

  # 去除补位字符
  def decode_padding(text)
    pad = text[text.length-1].to_i
    pad = 0 if (pad < 1 || pad > BLOCK_SIZE)
    size = text.length - pad
    text[0...size]
  end

  # 加密解密模式为AES的CBC模式
  def handle_cipher(action, aes_key, text)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.send(action)
    cipher.padding = 0
    cipher.key = aes_key
    cipher.iv = aes_key[0...16]
    cipher.update(text) + cipher.final
  end

  # 加密？？(还需测试)
  def encrypt(postxml)
    convertor = Iconv.new('UTF-8//IGNORE', 'US-ASCII')
    aes_key=Base64.decode64(self.encoding_aes_key + '=')
    text = convertor.iconv(postxml)
    random  = SecureRandom.hex(8)
    msg_len = [text.length].pack("N")
    text = "#{random}#{msg_len}#{text}#{CORPID}"
    text = encode_padding(text)
    text = handle_cipher(:encrypt, aes_key, text)
    Base64.encode64(text)
  end 

  def encode_padding(text)
    # 计算需要填充的位数
    amount_to_pad = BLOCK_SIZE - (text.length % BLOCK_SIZE)
    amount_to_pad = BLOCK_SIZE if amount_to_pad == 0
    # 获得补位所用的字符
    pad_chr = amount_to_pad.chr
    "#{text}#{pad_chr * amount_to_pad}"
  end

  # 主动方式调用
  # 管理通讯录:op_obj(department、user、tag), action(create、update、delete、get、list)
  def op_contacts(op_obj,action,options={})
    url = "https://qyapi.weixin.qq.com/cgi-bin/#{op_obj}/#{action}?access_token=#{self.access_token}"
    if %w(create update).include?(action)
      response = RestClient.post(url,:params => options)
    else
      options.each{|key,value| url += "&#{key}=#{value}"}
      response = RestClient.get(url)
    end
    result = JSON.load(response.body)
  end

  # 素材管理
  # action(add_mpnews、add_material、get、del、update_mpnews、batchget)
  def op_media(action,option={})
    url = "https://qyapi.weixin.qq.com/cgi-bin/material/#{action}?access_token=#{self.access_token}"
    if %w(add_mpnews add_material).include?(action)
      response = RestClient.post(url,options)
    else
      options.each{|key,value| url += "&#{key}=#{value}"}
      response = RestClient.get(url)
    end
    result = JSON.load(response.body)
  end

  # 临时素材管理(包含缩略图)
  # action(get,upload),如果是上传文件,options={:media => File.new(file_path,'rb'),:multiple => true}
  def op_thumb_media(action,type,options={})
    url = "https://qyapi.weixin.qq.com/cgi-bin/media/#{action}?access_token=#{self.access_token}&type=#{type}"
    if action == "get"
      options.each{|key,value| url += "&#{key}=#{value}"}
      response = RestClient.get(url)
    else
      response = RestClient.post(url,options)
    end
    result = JSON.load(response.body)
  end

  # 发送消息
  def send_messages(options={})
    url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=#{self.access_token}"
    response = RestClient.post(url,options)
    result = JSON.load(response.body)
  end


end