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
    end

    def select_from_all_query(model)
        model.all
    end

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
    end

    def delete_orphan(id, main_model, parent_model, child_model, child_key, cardinality_tipe)
        if cardinality_tipe == "OneToOne"
            records = child_model.all(child_key.to_sym => id)
            if !records.nil? then records.destroy end
        elsif cardinality_tipe == "OneToMany"
            if main_model != parent_model
                ;
            else
                begin
                records = child_model.all(child_key.to_sym => id)
                if !records.nil? then records.destroy end
                rescue ArgumentError
                    table_reference = parent_model.get(id)
                    convert_to_symbol = parent_model.to_s.downcase!
                    convert_to_symbol += "_id"
                    records = child_model.all(convert_to_symbol => id)
                    if !records.nil? then records.destroy end
                end
            end
        elsif cardinality_tipe == "ManyToOne"
            records = child_model.all(child_key.to_sym => id)          
            if !records.nil? then records.destroy end 
        elsif cardinality_tipe == "ManyToMany"
            ;
        elsif cardinality_tipe == "ManyToManyNoDeleteChild"
            ;
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
                if cardinality.include? tipe then
                    if tipe != "ManyToMany"
                        child_key = relationship.child_key.indexes.values[0]
                    else
                        settings.many_to_many_no_delete.each  { | _hash |
                            if _hash[:model_delete] == parent_model && _hash[:model_life] == child_model then
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
        array_id = record.split(",")
        model_class = Object.const_get(model)
        array_id.each do | id |
            prevent_orphan_records(id, model_class)
            model_class.get(id).destroy
        end
    end

    def bundle_form(model)
        @form = Hash.new
        model.properties.field_map.each { | k, v |
            if v.kind_of? DataMapper::Property::String and !v.kind_of? DataMapper::Property::FilePath
                @form[k] = 'text' # text fields
            elsif v.kind_of? DataMapper::Property::Serial
                @form[k] = 'number' #id fields
            elsif v.kind_of? DataMapper::Property::Integer and !v.kind_of? DataMapper::Property::Enum
                @form[k] = 'integer' # sometimes foreign id field                
            elsif v.kind_of? DataMapper::Property::BCryptHash
                @form[k] = 'password' #id fields
            elsif v.kind_of? DataMapper::Property::Enum
                @form[k] = 'enum' # enum
                @form[k+"-options"] = v.options[:flags].join(",")
            elsif v.kind_of? DataMapper::Property::FilePath
                @form[k] = 'file' # file
            end   
        }
        puts @form
        @form
    end
    
end