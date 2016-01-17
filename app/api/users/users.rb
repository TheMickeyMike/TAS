module Users
	class UsersController < Grape::API
		version 'v1', using: :path
		format :json
		formatter :json, Grape::Formatter::ActiveModelSerializers
		use ::WineBouncer::OAuth2

		default_error_status 400

		rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
			error!({ error: e.message }, 401)
		end

		 rescue_from ActiveRecord::RecordNotFound do |e|
		 	error!({ error: e.message }, 404)
		 end
		
		resource :users do
			desc 'Get infromation about resource owner'
			oauth2
			get :me, root: false, serializer: UserShortSerializer do
				resource_owner
			end

			desc 'Createing new user'
			params do
				requires :first_name, type: String, desc: 'First name'
				requires :last_name, type: String, desc: 'Last name'
				requires :profile_name, type: String, desc: 'Profile name'
				requires :email , type: String, desc: 'Email adress'
				requires :password, type: String, desc: 'Password'
				requires :password_confirmation , type: String, desc: 'Password confirmation'
			end
			post :sign_up do
				User.create!(params)
			end


			desc 'Get user by username'
			params do
				requires :username, type: String, desc: 'Username'
			end
			get ':username', proot: false, serializer: UserShortSerializer do
				User.find_by(profile_name: params[:username])
			end

			resource :id do
				desc 'Get user by id'
				params do
					requires :id, type: Integer, desc: 'user id'
				end
				get ':id', root: false, serializer: UserShortSerializer do
					User.find(params[:id])
				end
			end



			resource :recent do
				desc 'Get user private feed'
				# oauth2
				params do
					requires :id, type: Integer, desc: 'User ID.'
					optional :count, type: Integer, default: 2, desc: 'How many statuses' # Max 200
					optional :min_id, type: Integer, desc: 'Status ID' #can be null
					optional :max_id, type: Integer, desc: 'Status ID' #can be null
					optional :min_timestamp, type: DateTime, desc: 'Min timestamp ID' #can be null
					optional :max_timestamp, type: DateTime, desc: 'Max timestamp ID' #can be null

				end
				get ':id', root: false do
					if params[:min_id] && params[:max_id]
						Status.where("user_id = ? AND id > ? AND id < ?",params[:id], params[:min_id],params[:max_id]).last(params[:count]).reverse
					elsif params[:max_id]
						Status.where("user_id = ? AND id < ?",params[:id], params[:max_id]).last(params[:count]).reverse
					elsif params[:min_id]
						Status.where("user_id = ? AND id > ?",params[:id], params[:min_id]).last(params[:count]).reverse
					else
						Status.where("user_id = ?", params[:id]).last(params[:count]).reverse
					end
				end
			end

		end
	end
end
