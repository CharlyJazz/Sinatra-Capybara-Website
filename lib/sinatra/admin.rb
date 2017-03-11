require 'sinatra/base'

module Sinatra
  module AdminView
    def self.registered(app)
      app.set :models_in_view, []

      def app.add_model_in_view(value:0, args:[])
        args.each do | model|
          settings.models_in_view << model
        end
      end

      app.get '/' do
        @models = settings.models_in_view
        render :erb, :'admin/home', :layout => :'admin/layout'
      end
    end
  end
  register AdminView
end
