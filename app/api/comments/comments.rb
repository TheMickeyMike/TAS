module Comments
  class CommentsController < Grape::API
    version 'v1', using: :path
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    use ::WineBouncer::OAuth2

    default_error_status 400

    helpers do
      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end


    resource :comments do
      #curl -v -H "Content-Type: application/json" -H 'Authorization: Bearer <token>'
      #-d '{"post_id":"1","comment":"To jest moj nowy status"}'
      # -X POST http://localhost:3000/api/v1/comments/do_comment

      desc 'Dodawanie komentarzy'
      oauth2
      params do
        requires :post_id, type: Integer, desc: 'Id postu'
        requires :comment, type: String, desc: 'Komentarz'
      end
      post :do_comment do
        Comment.create!({
                            author_id: resource_owner.id,
                            post_id: params[:post_id],
                            comment: params[:comment]
                        })
      end

      #curl -X GET http://localhost:3000/api/v1/comments/get_comments_for_post/<id komentarza>
      desc 'Wyswietlanie kometarza po id'
      #oauth2
      params do
        requires :id, type: Integer, desc: 'Id komentarza'
      end
      get ':id' do
        Comment.find(params[:id])
      end

      #curl -X DELETE http://localhost:3000/api/v1/comments/delete_comment/<id komentarza>
      desc 'Usuwanie komentarza'
      resource :delete_comment do
        oauth2
        params do
          requires :id, type: Integer, desc: 'Id komentarza'
        end
        delete ':id' do
          Comment.find(params[:id]).destroy
        end
      end

      #curl -X GET http://localhost:3000/api/v1/comments/get_comments_for_post/<id posta>
      resource :get_comments_for_post do
        desc 'Wyswietlanie kometarza do posta'
        #oauth2
        params do
          requires :post_id, type: Integer, desc: 'Id posta'
        end
        get ':post_id' do
          Comment.where(params[:post_id])
        end
      end

      #curl -v -H "Content-Type: application/json" -H 'Authorization: Bearer <token>'
      #-d '{"comment":"zaktualizowany komenatrz"}'
      #-X PUT http://localhost:3000/api/v1/comments/update_comment/<id komentarza>
      resource :update_comment do
        desc 'Edytowanie komentarza'
        oauth2
        params do
          requires :id, type: Integer, desc: 'Id komentarza'
          requires :comment, type: String, desc: 'Komentarz'
        end
        put ':id' do
          Comment.find(params[:id]).update!({
                                                author_id: resource_owner.id,
                                                post_id: params[:id],
                                                comment: params[:comment]
                                            })

        end
      end

    end
  end
end
