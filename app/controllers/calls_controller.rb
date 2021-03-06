class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :authorize_calls, only: [:index, :new, :create]

  # GET /calls
  def index
    @calls = CallPolicy::Scope.new(current_user, Call).resolve
    @calls = @calls.joins(:user)
                   .table_filters params,
                                  'schedule_date desc, schedule_time desc'
    @past_calls = CallPolicy::Scope.new(current_user, Call).resolve_past
    @upcoming_calls = CallPolicy::Scope.new(current_user, Call).resolve_upcoming
  end

  # GET /calls/1
  def show; end

  # GET /calls/new
  def new
    @call = Call.new
  end

  # GET /calls/1/edit
  def edit; end

  # POST /calls
  def create
    @call = Call.new call_params
    @call.user = current_user unless @call.user

    if @call.save
      redirect_to calls_path, notice: 'Call was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /calls/1
  def update
    if @call.update(call_params)
      redirect_to calls_path, notice: 'Call was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /calls/1
  def destroy
    @call.destroy
    redirect_to calls_url, notice: 'Call was successfully deleted.'
  end

  private

  def set_call
    @call = Call.find(params[:id])
    authorize @call
  end

  def call_params
    params.require(:call).permit(:title, :dial_in, :participant_code,
                                 :schedule_date, :schedule_time, :time_zone,
                                 :user_id)
  end

  def authorize_calls
    authorize Call
  end

  def apply_order
    if params[:column] && params[:sort]
      @calls.order("#{params[:column]} #{params[:sort]}")
    else
      @calls.order(date_time: :desc)
    end
  end
end
