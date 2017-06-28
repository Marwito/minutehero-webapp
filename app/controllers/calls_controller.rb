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
      mn = MailNotifier.new @call, :create
      mn.send
    else
      render :new
    end
  end

  # PATCH/PUT /calls/1
  def update
    if @call.update(call_params)
      redirect_to calls_path, notice: 'Call was successfully updated.'
      mn = MailNotifier.new @call, :update
      mn.send
    else
      render :edit
    end
  end

  # DELETE /calls/1
  def destroy
    @call.destroy
    redirect_to calls_url, notice: 'Call was successfully deleted.'
    mn = MailNotifier.new @call, :destroy
    mn.send
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

class MailNotifier
  def initialize(call, type_of_action)
    @call = call
    @type_of_action = type_of_action
    @aws_region = ENV['aws_region']
    @sender = ENV['send_call_notifications_to_email']
    @recipient = ENV['send_call_notifications_to_email']
  end

  def send
    require 'aws-sdk'
    ses = Aws::SES::Client.new(region: @aws_region)
    begin
      ses.send_email ses_send_email_arg
    rescue => e
      Rails.logger.error "Email not sent. Reason : #{e}"
    end
  end

  private

  def ses_send_email_arg
    encoding = 'UTF-8'
    { destination: { to_addresses: [@recipient] },
      message: { subject: { charset: encoding, data: subject },
                 body: { html: { charset: encoding, data: htmlbody } } },
      source: @sender }
  end

  def subject
    call_action = case @type_of_action
                  when :create then 'Scheduled'
                  when :update then 'Edited'
                  when :destroy then 'Deleted'
                  end
    "Call #{call_action}: #{@call.schedule_date} " \
      "#{@call.schedule_time.strftime '%H:%M'} " \
      "#{@call.time_zone}, #{@call.user.first_name} " \
      "#{@call.user.last_name}, #{@call.title}"
  end

  def htmlbody
    body = '<table>'
    table_rows.each do |key, value|
      body += "<tr><th>#{key}</th><td>#{value}</td></tr>"
    end
    body += '</table>'
    [:create, :update].include?(@type_of_action) && body += link_to_call
    body
  end

  def table_rows
    [['Id', @call.id],
     ['User', "#{@call.user.first_name} #{@call.user.last_name}"],
     ['Email Address', @call.user.email],
     ['Title', @call.title],
     ['Dial In', @call.dial_in],
     ['Participant Code', @call.participant_code],
     ['Schedule Date', @call.schedule_date.to_s],
     ['Schedule Time', @call.schedule_time.strftime('%H:%M')],
     ['Time Zone', @call.time_zone]]
  end

  def link_to_call
    "<p>Click <a href='http://#{ENV['domain_name']}/calls/" \
      "#{@call.id}/edit'>here</a> to know the exact time zone of " \
      "#{@call.time_zone}.</p>"
  end
end
