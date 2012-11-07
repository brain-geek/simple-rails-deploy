module Deploy
  class StageGenerator < Rails::Generators::NamedBase
    argument :address, :banner => "ip address"

    source_root File.expand_path('../templates', __FILE__)

    def append_stage_to_deploy_rb
      sentinel = /set :stages,?+\n/

      append_to_file 'config/deploy.rb', "\nset :stages, self.stages.push('#{name}') \n"
    end

    def create_stagefile
      @app_name = Rails.application.class.to_s.split("::").first.underscore
      
      template "stage.rb.erb", "config/deploy/#{name}.rb"    
    end
  end
end