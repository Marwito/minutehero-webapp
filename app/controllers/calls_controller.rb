class CallsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  before_action :authorize_calls, only: [:index, :new, :create]
  attr_reader :call
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
      send_email_notification_to_admin(:create, @call)
    else
      render :new
    end
  end

  # PATCH/PUT /calls/1
  def update
    if @call.update(call_params)
      redirect_to calls_path, notice: 'Call was successfully updated.'
      send_email_notification_to_admin(:update, @call)
    else
      render :edit
    end
  end

  # DELETE /calls/1
  def destroy
    @call.destroy
    redirect_to calls_url, notice: 'Call was successfully deleted.'
    send_email_notification_to_admin(:destroy, @call)
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

def send_email_notification_to_admin(type_of_action, call)
  require 'aws-sdk'
  sender = ENV['send_call_notifications_to_email']
  recipient = ENV['send_call_notifications_to_email']
  awsregion = ENV['aws_region']
  subject, link_to_call_in_html_body = subject_and_link(type_of_action, call)
  # The HTML body of the email.
  htmlbody =
    "<table>
      <tr>
          <th>Id</th>
          <td> #{call.id} </td>
      </tr>
      <tr>
          <th>User</th>
          <td> #{call.user.first_name} #{call.user.last_name}</td>
      </tr>
      <tr>
          <th>Email Address</th>
          <td> #{call.user.email}</td>
      </tr>
      <tr>
          <th>Title</th>
          <td> #{call.title} </td>
      </tr>
      <tr>
          <th>Dial In</th>
          <td> #{call.dial_in} </td>
      </tr>
      <tr>
          <th>Participant Code</th>
          <td> #{call.participant_code} </td>
      </tr>
      <tr>
          <th>Schedule Date</th>
          <td> #{call.schedule_date} </td>
      </tr>
      <tr>
          <th>Schedule Time</th>
          <td> #{call.schedule_time.strftime '%H:%M'} </td>
      </tr>
      <tr>
          <th>Time Zone</th>
          <td> #{call.time_zone} </td>
      </tr>

    </table>

    #{link_to_call_in_html_body}"

  # The email body for recipients with non-HTML email clients.
  textbody = 'New call has been scheduled !'

  # Specify the text encoding scheme.
  encoding = 'UTF-8'

  # Create a new SES resource and specify a region
  ses = Aws::SES::Client.new(region: awsregion)

  # Try to send the email.
  begin

    # Provide the contents of the email.
    ses.send_email(
      destination: {
        to_addresses: [
          recipient
        ]
      },
      message: {
        body: {
          html: {
            charset: encoding,
            data: htmlbody
          },
        text: {
          charset: encoding,
          data: textbody
        }
        },
        subject: {
          charset: encoding,
          data: subject
        }
      },
      source: sender
    )

  # If something goes wrong, display an error message.
  rescue => e
    logger.error "Email not sent. Reason : #{e}"

  end
end

def subject_and_link(type_of_action, call)
  link_to_call = "<p>Click <a href='http://#{ENV['domain_name']}/calls/" \
                  "#{call.id}/edit'>here</a> to know the exact time zone of " \
                  "#{call.time_zone}.</p>"

  common_subj = "#{call.schedule_date} " \
                "#{call.schedule_time.strftime '%H:%M'} " \
                "#{call.time_zone}, #{call.user.first_name} " \
                "#{call.user.last_name}, #{call.title}"
  # The subject line for the email.
  if type_of_action == :create
    subject = 'Call Scheduled: ' + common_subj
    link_to_call_in_html_body = link_to_call
  elsif type_of_action == :update
    subject = 'Call Edited: ' + common_subj
    link_to_call_in_html_body = link_to_call
  elsif type_of_action == :destroy
    subject = 'Call Deleted: ' + common_subj
    link_to_call_in_html_body = ''
  else
    subject = 'Error in processing action of the scheduled call: ' + common_subj
    link_to_call_in_html_body = link_to_call
  end
  [subject, link_to_call_in_html_body]
end
