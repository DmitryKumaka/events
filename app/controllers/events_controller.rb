class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :users, :update_users]

  # GET /events
  # GET /events.json
  def index
    @events = current_user.events
    gon.all_events = @events
    gon.visited_events = @events.where(visited_flag: true)
    gon.not_visited_events = @events.where(visited_flag: false)
    gon.past_events = @events.past
    gon.feature_events = @events.feature
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    @event.users << current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def users
    @users = @event.users
    @all_users_except_current = User.where.not(id: current_user.id)
  end

  def update_users
    user_ids = params[:users].present? ? params[:users] : []
    user_ids << current_user.id
    respond_to do |format|
      if @event.update_attributes(user_ids: user_ids)
        format.html { redirect_to users_path(@event), notice: 'Users were successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :index }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :date, :visited_flag)
    end
end
