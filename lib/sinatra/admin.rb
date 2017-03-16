require 'sinatra/base'

module Sinatra
  module AdminView
    module AdminHelpers
      def verify_model_exist(model) 
        @models.each do | model_registered |
           if model_registered.to_s == model.capitalize
              @model = model_registered
              break
           end
           if @model == nil then redirect to('/') end
         end
      end # end verify_model_exist
      def select_from_all_query(model)
        model.all
      end # end select_from_all_query
      def create_array_result(query)
        @inspect_array = Array.new
        query.each do | register |
          @inspect_array.push(register.inspect)
        end
      end # end create_array_result
    end # end helpers
    def self.registered(app)
      app.set :models_in_view, []
      app.helpers AdminView::AdminHelpers

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
    end
  end
  register AdminView
end
