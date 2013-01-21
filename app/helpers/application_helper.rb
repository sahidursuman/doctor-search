module ApplicationHelper
	def active_link(controller, action = '')
    	params[:controller] == controller && (action == '' || params[:action] == action) ? 'active' : ''
  	end

  	def link_to_add_fields( name, f, association, options={} )
  		new_object = f.object.send(association).klass.new
  		id = new_object.object_id
  		fields = f.simple_fields_for(association, new_object, :child_index => id) do |builder|
  			render(association.to_s + "_fields", :f => builder)
  		end
  		link_to(name, '#', class: "add_fields btn right", data: {id: id, fields: fields.gsub("\n", "")})
  	end
end
