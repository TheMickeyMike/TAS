# in /app/main/api.rb
module Files
    class FilesController < Grape::API
        version 'v1', using: :header, vendor: 'some_vendor'
        format :json
        use ::WineBouncer::OAuth2

        resource :upload_image do
          oauth2
            post do
                # takes the :avatar value and assigns it to a variable
                avatar = params[:avatar]


                # the avatar parameter needs to be converted to a
                # hash that paperclip understands as:
                attachment = {
                    :filename => avatar[:filename],
                    :type => avatar[:type],
                    :headers => avatar[:head],
                    :tempfile => avatar[:tempfile],
                    #:user_id => integer(2)
                }

                # creates a new User object
                image = Image.new
                image.user_id = resource_owner.id

                # This is the kind of File object Grape understands so let's
                # pass the hash to it
                image.img = ActionDispatch::Http::UploadedFile.new(attachment)

                # easy
                image.image_path = attachment[:filename]

                # even easier
                #user.name = "dummy name"

                # and...
                image.save
            end
        end

        resource :delete_image do
          oauth2
          params do
            requires :id, type: Integer, desc: 'image_id.'
          end

          delete ':id' do
              Image.find(params[:id]).destroy
          end


        end

    end
end