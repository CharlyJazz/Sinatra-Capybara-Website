require 'sinatra/base'
require_relative './admin_helper'

module Sinatra
  module AdminView
    def self.registered(app)
      app.set :models_in_view, []
      app.enable :method_override
      app.helpers AdminHelpers
      
      def app.add_model_in_view(value:0, args:[])
        args.each do | model|
          settings.models_in_view << model
        end
      end
      
      app.before do
        @models = settings.models_in_view      
      end
      
      app.get '/' do
        render :erb, :'admin/home', :layout => :'admin/layout'
      end

      app.get '/:model' do
        verify_model_exist(params[:model])

        @query_all_modell = select_from_all_query(@model)
        create_array_result(@query_all_modell)
        render :erb, :'admin/table', :layout => :'admin/layout'
      end

      app.delete '/:model' do
        # params[:data] are the ids of the records (send for ajax)
        # params[:model] are the models class name
        content_type 'application/json', :charset => 'utf-8' if request.xhr?
        verify_model_exist(params[:model])

        delete_record(params[:data], params[:model])
        return { :success => params[:data] }.to_json
      end

    end
  end
  register AdminView
end
