# rails2:script/rails runner script/wx_test.rb
# rails3以上：rails runner bin/scripts/wx_test.rb
# 
# 操作通讯录
# wechat=Common::QyWechat.new
# options={:id => "1238"}
# puts wechat.op_contacts("department","list",options)
# 
# 微信验证
wechat=Common::QyWechat.new
wechat.apply_token = 'CYnThmqmahR'
wechat.encoding_aes_key = 'HGm36taLqNBvwLaJAMLGY8HNE2kQxyK4wQaPBzYEjdj'
puts wechat.verify_url("b9b1310b0e6f5ebd07e25be21669092dbebccd7a","1472189614","1808407466","Y95KLBXrN+LAqoEHdzfI+D+Y8tqqDXhOv5/nrlBJh3XXzBzMczfO1krOtd/S7Ah0WnYEbkgFvFjLk8o8RW2rQ/ILbngvWJNTe3gLjqzOq4DJ2DuI3iTNIZZenI8PQtEsz0D3AWuPKAR4f1/uyRMI1Zber4UHlvo37Oo2RAfcwKylyNvlbIdLZzlq3HOJ3YP0TxdzFihDldJHqRxrEqnQciK6RHlC2IHcir0eqCMi1Ewdw+KpTu2ZEZpBd2K9lIBYd5H7TglS8Htt9xtncETwXUJo4958kT1TjtipAE78HMzTUIeSS4xDXfgSovS/5ddx44/Ql45hzzmMAsFrnchoULqIrMhI/WHzmcAATbP4sfWVaNvSvv0L3eerPupWEYdMmp/W7Ecpd3HNzZeqzmYt/VFV7/HidXt612rgNjKyvOA6vllPRofwqhJQ8Xe5MGO9FdRXq7RC7AlQ9Us4SVZi3w==")

# 微信发送消息加密
# (Time.now.to_datetime.strftime '%Q')[0...10]获取10位数字
postxml=Nokogiri::XML("<xml>
   <ToUserName><![CDATA[tingting.fang]]></ToUserName>
   <FromUserName><![CDATA[#{Common::QyWechat::CORPID}]]></FromUserName> 
   <CreateTime>#{Time.now.to_i}</CreateTime>
   <MsgType><![CDATA[text]]></MsgType>
   <Content><![CDATA[this is a test]]></Content>
   <MsgId>#{Time.now.strftime('%Y%m%d%H%M%S')}</MsgId>
   <AgentID>20</AgentID>
</xml>")

# 生成企业签名
msg_encrypt=wechat.encrypt(postxml.to_xml)
timestamp=Time.now.to_i
nonce=rand(999999999)
sort_params = [postxml.to_xml, wechat.apply_token, timestamp,nonce].join
msg_signature=Digest::SHA1.hexdigest(sort_params)

# 生成标准回包
# <xml>
#    <Encrypt><![CDATA[msg_encrypt]]></Encrypt>
#    <MsgSignature><![CDATA[msg_signature]]></MsgSignature>
#    <TimeStamp>timestamp</TimeStamp>
#    <Nonce><![CDATA[nonce]]></Nonce>
# </xml>

postdoc=Nokogiri::XML("<xml>
   <Encrypt><![CDATA[#{msg_encrypt}]]></Encrypt>
   <MsgSignature><![CDATA[#{msg_signature}]]></MsgSignature>
   <TimeStamp>#{timestamp}</TimeStamp>
   <Nonce><![CDATA[#{nonce}]]></Nonce>
</xml>")

puts wechat.decrypt(msg_encrypt)

