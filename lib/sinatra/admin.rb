require 'sinatra/base'
require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'dm-validations'
require_relative './admin_helper'

module Sinatra
  module AdminView
    def self.registered(app)
      app.set :models_in_view, []         # Add model in the extension for create CRUD
      app.set :many_to_many_no_delete, [] # This model will not be deleted if it has many to many relation
                                          # with another record being deleted
      app.enable :method_override
      app.helpers AdminHelpers
      
      def app.add_model_in_view(value:0, args:[])
        args.each do | model|
          settings.models_in_view << model
        end
      end

      def app.add_many_to_many_no_delete_model(models={:model_delete=>nil, :model_life=>nil})
        if models[:model_delete].nil? || models[:model_life].nil?
          raise ArgumentError.new('Any model no exist or are nil.')
        end
        settings.many_to_many_no_delete << models
      end
      
      app.before do
        @models = settings.models_in_view
        @many_to_many_no_delete_model = settings.many_to_many_no_delete  
      end
      
      app.get '/' do
        render :erb, :'admin/home', :layout => :'admin/layout'
      end

      app.get '/:model' do
        verify_model_exist(params[:model]) # return @model

        @query_all_modell = select_from_all_query(@model)
        create_array_result(@query_all_modell)
        render :erb, :'admin/table', :layout => :'admin/layout'
      end

      app.get '/create/:model' do
        verify_model_exist(params[:model]) # return @model
        @form = bundle_form(@model)
        render :erb, :'admin/form', :layout => :'admin/layout'      
      end

      app.post '/create/:model' do
        verify_model_exist(params[:model]) # return @model
        create_record(@model, create=nil)
      end

      app.delete '/:model' do
        verify_model_exist(params[:model]) # return @model
        delete_record(params[:data], @model)
      end

    end
  end
  register AdminView
end