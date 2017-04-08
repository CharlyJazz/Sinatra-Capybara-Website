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

    def delete_orphan(id, parent_model, child_model, child_key, cardinality_tipe)
        # Delete orphan records of parent_model before delete this
        # Parameters:
        # id : id of parent_model
        # parent_model: Main model to be deleted
        # child_model: Model that has relation with parent_model
        # child_key: Foreign key of the child model_class
        # cardinality_tipe: Tipe of relations e.g: "Many To Many"
        puts "ENTRAMOS EN DELETE ORPHAN"
        child_key = child_key[0]
        puts "child_key " + child_key.to_s
        puts "parent_model " + parent_model.to_s
        puts "child_model " + child_model.to_s
        puts "cadinality " + cardinality_tipe
        if cardinality_tipe == "OneToOne" # Ready for: User
            records = child_model.all(child_key.to_sym => id)
            if !records.nil? then records.destroy end

        elsif cardinality_tipe == "OneToMany" # Ready for: User
            records = child_model.all(child_key.to_sym => id)
            if !records.nil? then records.destroy end

        elsif cardinality_tipe == "ManyToOne"
            records = child_model.all(child_key.to_sym => id)          
            if !records.nil? then records.destroy end 

        elsif cardinality_tipe == "ManyToMany"
           records = child_model.all(child_key.to_sym => id)          
           if !records.nil? then records.destroy end            
        end    
    end

    def prevent_orphan_records(id, model_class)
        # indexes no sirve para many to many
        # parent_key = relationship.parent_key.indexes.values[0]
        # puts "PARENT KEY " + parent_key.to_s
        cardinality_tipe = "ManyToMany,ManyToOne,OneToMany,OneToOne".split(",")

        model_class.relationships.each { | relationship |
            # TENGO QUE CREAR LA OPCION DE EVITAR A SONG Y MATAR A ALBUMSONG
            puts "exp : " + relationship.instance_variable_name.to_s # DE TODAS FORMAS ESTO ME AYUDA A MATAR A SONG PERO DA BUGS
            parent_model = relationship.parent_model
            # puts parent_model
            child_model = relationship.child_model 
            # puts child_model
            cardinality = relationship.class.name
            # puts cardinality
            inverse_cardinality = relationship.inverse.class.name
            # puts inverse_cardinality

            if model_class == child_model then cardinality = inverse_cardinality end
            cardinality_tipe.each  { | tipe |
                if cardinality.include? tipe then
                    if tipe != "ManyToMany"
                        child_key = relationship.child_key.indexes.values[0]
                    else
                        child_key = 0
                    end
                    delete_orphan(id, parent_model, child_model, child_key, tipe)
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
    
end