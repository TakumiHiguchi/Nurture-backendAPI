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
      
      token="eyJhbGciOiJSUzI1NiIsImtpZCI6ImUyMDI4MmY0NDE1NjdjNWVjYjYwNjQ4ODc2ODU3ZjdiOGM1MWM0M2EiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjUzOTkyMzEzMTcwLW9rdDJ0Zm11a3A1ZWc0czRnOGZpYWY2dTMyNjFhMG92LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjUzOTkyMzEzMTcwLW9rdDJ0Zm11a3A1ZWc0czRnOGZpYWY2dTMyNjFhMG92LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTExMzkyMTczNjE5MTMxOTc0MjkxIiwiZW1haWwiOiJ1aWxqcGZzNGZnNWhzeHpybmhrbnBkcWZ4QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiMDRyQjA4UmswWWk1NnhDcFIxNVdUZyIsIm5hbWUiOiLmqIvlj6Pmi5Plrp8iLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDQuZ29vZ2xldXNlcmNvbnRlbnQuY29tLy1JczhReFlnSVRGdy9BQUFBQUFBQUFBSS9BQUFBQUFBQUFBQS9BTVp1dWNscURWczNZWDRTYU1FaUdGelAwMEpBYXBxbWhnL3M5Ni1jL3Bob3RvLmpwZyIsImdpdmVuX25hbWUiOiLmi5Plrp8iLCJmYW1pbHlfbmFtZSI6Iuaoi-WPoyIsImxvY2FsZSI6ImphIiwiaWF0IjoxNTkyNzU0ODEyLCJleHAiOjE1OTI3NTg0MTIsImp0aSI6IjcxYzE1YTgyYTk3MThhZGQwNGZjOWRjYzg1NWJkMzM0NGNlNGI3MjAifQ.EitsCR4bEbZD1bn7BXsLZOXUQ2h1acyE_fh_LaJYwn0w8VRHNMtsnOoml-1LN-K7AeYTxs3iL9MyffXdG8jMGAt7-td4QcaYcfWCuao_OUzn7so71aiDdJVNz66acediijHIrFdNj7uF58GDOY9lJYp8_IrkxSEdseQ1KeNMIunwTsK3-R4kd0fp4_-x7fUzVtO1-t-JSG3PLVPJaNX8YzYK7SnqpbbOCNaPhebHG3J0856s40zAyeUrSF7tj1-08tU8GDH4xm4rGJx7i0Pl7ehXeegwDn6XP0WQaEbWBzS-nwximeSgEeo6_uOzYXGXRsoFI7UWis3gB3NlUiTsZg"
      
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
