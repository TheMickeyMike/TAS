# require 'doorkeeper/grape/helpers'
module Statuses
	class StatusesController < Grape::API
		version 'v1', using: :path 
		format :json
		formatter :json, Grape::Formatter::ActiveModelSerializers
		use ::WineBouncer::OAuth2


		helpers do
			# Find the user that owns the access token
  			def current_resource_owner
    			User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  			end
		end

		resource :statuses do

			desc 'Return a stauses feed'
			# oauth2
			get :statuses do
				Status.all
				# User.all
			end

			desc 'Feed for user ID' 
			params do 
				requires :id, type: Integer, desc: 'User ID.'
			end
			get ':id' do
				Status.find(params[:id])
			end

			desc 'Return amount of statuses'
			#oauth2
			params do
				optional :count, type: Integer, default: 2, desc: 'How many statuses' # Max 200
				optional :min_id, type: Integer, desc: 'Status ID' #can be null
				optional :max_id, type: Integer, desc: 'Status ID' #can be null
			end
			get :feed do
				if params[:min_id] && params[:max_id]
					Status.where("id > ? AND id < ?", params[:min_id],params[:max_id]).last(params[:count])
				elsif params[:max_id]
					Status.where("id < ?", params[:max_id]).last(params[:count])
				elsif params[:min_id]
					Status.where("id > ?", params[:min_id]).last(params[:count])
				else
					Status.last(params[:count])
				end
			end

			desc 'Create a status'
			oauth2
			params do
				requires :content, type: String, desc: 'Status content'
			end
			post :new do
				Status.create!({
					user_id: resource_owner.id,
					content: params[:content]
				})
			end

			desc 'Update a status.'
			oauth2
			params do
				requires :id, type: Integer, desc: 'Status ID.'
				requires :content, type: String, desc: 'Updated status content'
			end
			put ':id' do
				resource_owner.statuses.find(params[:id]).update({
					user_id: resource_owner.id,
					content: params[:content]
					})
			end

			desc 'Delete a status'
			oauth2
			params do
				requires :id, type: Integer, desc: 'Status ID'
			end
			delete ':id' do
				current_resource_owner.statuses.find(params[:id]).destroy
			end

		end
	end
end