class Api::V1::ScheduleController < ApplicationController
  def index
      
      render json: JSON.pretty_generate({
                                        status:'SUCESS',
                                        api_version: 'v1',
                                        
                                        
                                        })
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
