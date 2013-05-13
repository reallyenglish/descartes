require 'sinatra/base'
require 'sinatra_auth_github'

module Descartes
  class GithubAuth < Sinatra::Base

    set :github_options, {
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
      :org_id    => ENV['GITHUB_ORG_ID'],
    }

    register Sinatra::Auth::Github

    before do
      github_organization_authenticate!(settings.github_options[:org_id])
      set_user_session
    end

    def set_user_session
      unless session['user']
        p github_user.__id__
        session['user'] = {
          'uid'    => github_user.__id__,
          'email' => github_user.email
        }
      end
      redirect '/'
    end

  end
end
