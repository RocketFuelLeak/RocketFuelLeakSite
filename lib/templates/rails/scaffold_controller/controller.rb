<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
    before_action :load_<%= singular_table_name %>, only: :create
    load_and_authorize_resource

    # GET <%= route_url %>
    # GET <%= route_url %>.json
    def index
    end

    # GET <%= route_url %>/1
    # GET <%= route_url %>/1.json
    def show
    end

    # GET <%= route_url %>/new
    def new
    end

    # GET <%= route_url %>/1/edit
    def edit
    end

    # POST <%= route_url %>
    # POST <%= route_url %>.json
    def create
        respond_to do |format|
            if @<%= orm_instance.save %>
                format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %> }
                format.json { render action: 'show', status: :created, location: @<%= singular_table_name %> }
            else
                format.html { render action: 'new' }
                format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT <%= route_url %>/1
    # PATCH/PUT <%= route_url %>/1.json
    def update
        respond_to do |format|
            if @<%= orm_instance.update("#{singular_table_name}_params") %>
                format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %> }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE <%= route_url %>/1
    # DELETE <%= route_url %>/1.json
    def destroy
        @<%= orm_instance.destroy %>
        respond_to do |format|
            format.html { redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %> }
            format.json { head :no_content }
        end
    end

    private
        # Only allow a trusted parameter "white list" through.
        def <%= "#{singular_table_name}_params" %>
            <%- if attributes_names.empty? -%>
            params[<%= ":#{singular_table_name}" %>]
            <%- else -%>
            params.require(<%= ":#{singular_table_name}" %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
            <%- end -%>
        end

        def load_<%= singular_table_name %>
            @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
        end
end
<% end -%>
