module AdminHelpers

    def verify_model_exist(model) 
        @models.each do | model_registered |
            if model_registered.name == model.capitalize ||
                model_registered.name == model
                @model = model_registered
                break
            end
        end 
        if @model == nil then
            flash[:error] = "Model no exist"
            redirect to('/')
        end
    end # end verify_model_exist

    def select_from_all_query(model)
        model.all
    end # end select_from_all_query

    def create_array_result(query)
        @inspect_array = Array.new
        query.each do | register |
            normalize = register.inspect.gsub("#", "")
            normalize = normalize.gsub("nil", "empty")
            attributes = normalize.split(" @")
            attributes = attributes.drop(1)
            attributes.each { |attr| attr = attr.gsub!(/.*?(?==)/im, "")
                               attr.gsub!("=", "")
                               attr.gsub!(">", "")}
            @inspect_array.push(attributes)
        end
    end # end create_array_result
    
end # end helpers