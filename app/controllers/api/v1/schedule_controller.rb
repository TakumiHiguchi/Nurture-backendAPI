class Api::V1::ScheduleController < ApplicationController
  def index
      schedules = Schedule.all.order('id DESC').searchAPI("position",params[:p]).searchAPI("fr",params[:q]).first(50)
      result = [];
      schedules.each do |pas|
          result.push(
                      id:pas.id,
                      title:pas.title,
                      CoNum:pas.CoNum,
                      teacher:pas.teacher,
                      semester:pas.semester,
                      position:pas.position,
                      grade:pas.grade,
                      status:pas.status
                      )
      end
      
      token="eyJhbGciOiJSUzI1NiIsImtpZCI6ImUyMDI4MmY0NDE1NjdjNWVjYjYwNjQ4ODc2ODU3ZjdiOGM1MWM0M2EiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjUzOTkyMzEzMTcwLW9rdDJ0Zm11a3A1ZWc0czRnOGZpYWY2dTMyNjFhMG92LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjUzOTkyMzEzMTcwLW9rdDJ0Zm11a3A1ZWc0czRnOGZpYWY2dTMyNjFhMG92LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTExMzkyMTczNjE5MTMxOTc0MjkxIiwiZW1haWwiOiJ1aWxqcGZzNGZnNWhzeHpybmhrbnBkcWZ4QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiRjBQT0xIRFJwdHlHbS1RQ00zTFdUdyIsIm5hbWUiOiLmqIvlj6Pmi5Plrp8iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDQuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1JczhReFlnSVRGdy9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BTVp1dWNscURWczNZWDRTYU1FaUdGelAwMEpBYXBxbWhnL3M5Ni1jL3Bob3RvLmpwZyIsImdpdmVuX25hbWUiOiLmi5Plrp8iLCJmYW1pbHlfbmFtZSI6Iuaoi-WPoyIsImxvY2FsZSI6ImphIiwiaWF0IjoxNTkyNzU4MTExLCJleHAiOjE1OTI3NjE3MTEsImp0aSI6ImUyMDM2ODRhMjE0ZDY3ZWQzZDE5NzMzOTVhMjM2OWU4NGMwZGZmOWIifQ.Hxa6uvQH3TQdPT0Mt0OC5trDcL1A1B45jaUnPER2fafx1ErKKLkT_zgBocxJCkBZ23Hw0M3r28ehUo0Gzs8KSRAlvDL7ABeTYwzZjgvyjtxp0YTe3OZsSn2e7faUP4M5URJoLQrXf9N6kYz4FVG-qgI4kxtrP1aNnLDRWfd5-0ZbRaLt5RxAfjqKYIofJcWd6X-J9W4qjXSdQ-NeIpkdG5QUvIv4Dhh9usccuZq3jOp9s-JNQnZ0OBpYGAB2ncKz6kiauh8PdNutwyAWMYEwnO7nRrXNvOM2lH00xLLfMhcMlB3jQmRcCQtrLTJUae6JAgTk30lo-ADq_odKRjffTQ"
      
      user = GoogleConfiguration.new
      d= user.userData(token)
      
      
      render json: JSON.pretty_generate({
                                        status:'SUCESS',
                                        api_version: 'v1',
                                        data_count:result.length,
                                        user:d,
                                        data:result
                                        
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
