class DashboardController < ApplicationController

    def index
        respond_to do |format|
            format.all do
                render json: User.all.as_json
            end
        end
    end
end
