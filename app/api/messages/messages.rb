module Messages
  class MessagesController < Grape::API
    version 'v1', using: :header, vendor: 'some_vendor'
    format :json
    use ::WineBouncer::OAuth2

    resource :do_message do
      oauth2
      params do
        requires :id_odbiorcy, type: Integer, desc: 'Id odbiorcy'
        requires :text, type: String, desc: 'treść wiadomości'
      end
      post do
        Message.create!({
                            id_odbiorcy: params[:id_odbiorcy],
                            id_nadawcy: resource_owner.id,
                            text: params[:text]
                        })
      end
    end


    resource :messages_sent do
      oauth2
      params do
        requires :id_nadawcy, type: Integer, desc: 'Id nadawcy'
      end
      get ':id_nadawcy' do
        Comment.find(params[:id_nadawcy])
      end
    end

    resource :messages_recived do
      oauth2
      params do
        requires :id_odbiorcy, type: Integer, desc: 'Id odbiorcy'
      end
      get ':id_odbiorcy' do
        Comment.find(params[:id_odbiorcy])
      end
    end
  end
end
