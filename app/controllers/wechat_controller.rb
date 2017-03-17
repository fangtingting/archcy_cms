# 微信
class WechatController < ApplicationController

  # 回调url,接收消息，不同应用的回调url，apply_token跟encoding_aes_key是会变化的
  def qywx_emp
    wechat = QyWechat.new(apply_token: 'CYnThmqmahR',encoding_aes_key: 'HGm36taLqNBvwLaJAMLGY8HNE2kQxyK4wQaPBzYEjdj')

    if params[:echostr].present?
      # 第一次回调验证，返回明文给微信
      status,result = wechat.verify_url(params[:msg_signature],params[:timestamp],params[:nonce],params[:echostr])
      render :status => status, :text => result
    else
      # 解密接收的xml密文
      status,result = wechat.verify_url(params[:msg_signature],params[:timestamp],params[:nonce],params[:xml][:Encrypt])
      if status == 200
        # 生成xml密文发给微信
      end
      render :status => status, :text => result
      
    end
  end


end