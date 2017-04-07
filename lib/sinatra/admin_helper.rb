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

    def delete_orphan(id, parent_model, child_model, cardinality_tipe)
    end

    def prevent_orphan_records(id, model_class)
        parent_model = model_class
        cardinality_tipe = "ManyToMany,ManyToOne,OneToMany,OneToOne".split(",")
        parent_model.relationships.each { | relationship |
            cardinality = relationship.class.name
            inverse_cardinality = relationship.inverse.class.name
            cardinality_tipe.each  do | tipe |
                if cardinality.include? tipe
                    puts "With this model: " + relationship.child_model.to_s
                    puts "Cardinality: " + tipe
                    # delete_orphan(id, parent_model, relationship.child_model, tipe)
                end
            end
        }
        
        #  -------codigo no escalable pero guia algoritmica--------
        if model_class == User
            # User basic data . . . ONE TO ONE
            UserMedia.first(:user_id => id).destroy
            UserInformation.first(:user_id => id).destroy
            if !UserSocial.all(:user_id => id).nil?
                UserSocial.all(:user_id => id).destroy
            end
            # # User albums . . .
            # user_albums = Album.all(:user_id => id)
            # user_albums.each { | album |
            #     AlbumTag.all(:album_id => album.id ).destroy
            #     CommentAlbum.all(:album_id => album.id ).destroy
            #     AlbumSong.all(:album_id => album.id).destroy
            # }
            # user_albums.destroy
            # # User Songs . . .
            # user_songs = Song.all(:user_id => id)
            # user_songs.each { | music |
            #     CommentSong.all(:song_id => music.id ).destroy
            #     AlbumSong.all(:song_id => music.id).destroy
            # }
            # user_songs.destroy
            # # User Comments . . .
            # CommentAlbum.all(:user_id).destroy            
            # CommentSong.all(:user_id).destroy
        end
    end

    def delete_record(record, model)
        array_id = record.split(",")
        model_class = Object.const_get(model) # convert string to class
        array_id.each do | id |
            prevent_orphan_records(id, model_class)
            model_class.get(id).destroy
        end
    end
    
end

# when Album
#     puts "Eliminar comentarios, Eliminar registros en \
#           AlbumSong que es many to many con varias canciones, \
#           Eliminar registros en AlbumTag "
# when Song
#     puts "Eliminar comentarios, Eliminar registros en \
#           AlbumSong que es many to many con varios albumes, \
#           Eliminar registros en AlbumTag "
# when AlbumSong
#     puts "Eliminar comentarios del album, Eliminar registros  \
#           en AlbumTag, Eliminar Album "