module AdminHelpers
    def verify_model_exist(model) 
        @models.each do | model_registered |
            if model_registered.name == model.capitalize ||
                model_registered.name == model
                @model = model_registered
                break
            end
        end 
        if @model.nil?
            flash[:error] = "Model no exist"
            redirect to('/')
        end
    end

    def select_from_all_query(model)
        model.all
    end

    def create_array_result(query)
        @inspect_array = Array.new
        query.each do | register |
            attributes = register.inspect.gsub("#", "").gsub("nil", "empty").split(" @").drop(1)
            attributes.each { |attr| attr = attr.gsub!(/.*?(?==)/im, "").gsub!("=", "").gsub!(">", "") }
            @inspect_array.push(attributes)
        end
    end

    def delete_orphan(id, main_model, parent_model, child_model, child_key, cardinality_tipe)
        if cardinality_tipe == "OneToOne"
            records = child_model.all(child_key.to_sym => id)
            if !records.nil? then records.destroy! end
        elsif cardinality_tipe == "OneToMany"
            if main_model == parent_model
                begin
                records = child_model.all(child_key.to_sym => id)
                if !records.nil? then records.destroy! end
                rescue ArgumentError
                    convert_to_symbol = parent_model.to_s.downcase!
                    convert_to_symbol += "_id"
                    records = child_model.all(convert_to_symbol => id)
                    if !records.nil? then records.destroy! end
                end
            end
        elsif cardinality_tipe == "ManyToOne"
            records = child_model.all(child_key.to_sym => id)          
            if !records.nil? then records.destroy! end
        end
    end

    def prevent_orphan_records(id, model_class)
        cardinality_tipe = "ManyToMany,ManyToOne,OneToMany,OneToOne".split(",")

        model_class.relationships.each { | relationship |
            parent_model = relationship.parent_model
            child_model = relationship.child_model 
            cardinality = relationship.class.name
            inverse_cardinality = relationship.inverse.class.name
            if model_class == child_model then cardinality = inverse_cardinality end
            cardinality_tipe.each  { | tipe |
                if cardinality.include? tipe
                    if tipe != "ManyToMany"
                        child_key = relationship.child_key.indexes.values[0]
                    else
                        settings.many_to_many_no_delete.each  { | _hash |
                            if _hash[:model_delete] == parent_model && _hash[:model_life] == child_model
                                tipe = "ManyToManyNoDeleteChild"
                            end
                        }
                        child_key = 0
                    end
                    if !child_key.nil?
                        child_key = child_key[0]
                    else
                        child_key = relationship.instance_variable_name.to_s.gsub("@", "") # Passing string of symbol
                    end
                    delete_orphan(id, model_class, parent_model, child_model, child_key, tipe)
                end
            }
        }
    end

    def delete_record(record, model)
        record.split(",").each do | id |
            prevent_orphan_records(id, model)
            model.get(id).destroy!
        end
        halt 200,  { :success => params[:data] }.to_json
    end

    def bundle_form(model)
        # I should use the DateTime type of datemapper
        # but this orm sucks and does not serve any type of timestamp.
        timestamps = ["created_at", "updated_at", "created_on", "updated_on"]
        @form = Hash.new
        model.properties.field_map.each { | k, v | #  k => class of the typeof property, v => name of the property.
            if v.kind_of? DataMapper::Property::String and !v.kind_of? DataMapper::Property::FilePath and !timestamps.include? k and k != "password"
                @form[k] = 'text'
            elsif timestamps.include? k or v.kind_of? DataMapper::Property::DateTime or v.kind_of? DataMapper::Property::Time
                @form[k] = 'date'
            elsif v.kind_of? DataMapper::Property::Serial
                @form[k] = 'number'
            elsif v.kind_of? DataMapper::Property::Integer and !v.kind_of? DataMapper::Property::Enum
                @form[k] = 'integer'
            elsif v.kind_of? DataMapper::Property::BCryptHash
                @form[k] = 'password'
            elsif v.kind_of? DataMapper::Property::Enum
                @form[k] = 'enum'
                @form[k+"-options"] = v.options[:flags].join(",")
            elsif v.kind_of? DataMapper::Property::FilePath
                @form[k] = 'file'
            end   
        }
        @form
    end    

    def create_record(model, create=nil)
        params.delete_if { |key, value| ["action", "splat", "model", "captures"].include? key } # Filter
        symbol_params = params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} # Convert all keys in symbol
        length_old = model.all.length # Verify if really created other record 
        if !create == true then
            model.relationships.each { | relationship |
                if model == relationship.child_model then
                    child_key = relationship.child_key.indexes.values[0][0]
                    if relationship.inverse.kind_of? DataMapper::Associations::OneToOne::Relationship
                        # Buscare en el modelo hijo o sea User_Information si ya existe un registro con
                        # el id_user que se mando en el formulario sí es así entonces debo mostrar un modal
                        # diciendo que ya existe este registro y que si desea actualizarlo o no.
                        if !relationship.child_model.first(child_key.to_sym => params[child_key.to_sym]).nil?
                            model.update(symbol_params)
                            halt 200, {:update => "Record update!"}.to_json
                        else
                            create_record(model, create=true)
                        end
                    end
                end
            }
        end
        begin
            model.create(symbol_params)
        rescue DataObjects::IntegrityError
            model.new(symbol_params)
        end
        if length_old < model.all.length
            halt 200, {:create => "Record create!"}.to_json
        else
            halt 200, {:no_create => "Could not create log, some field is failing."}.to_json
        end
    end

end