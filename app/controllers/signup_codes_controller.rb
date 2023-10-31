# frozen_string_literal: true

class SignupCodesController < InternalController
  before_action :set_signup_code, only: [:show, :edit, :update, :destroy]

  def index
    authorize!
    @signup_codes = SignupCode.includes(:user_group).order(created_at: :desc)
  end

  def show
    authorize! @signup_code
  end

  def new
    authorize!
    @signup_code = SignupCode.new(active: false)
    set_user_group_options
  end

  def create
    authorize!
    @signup_code = SignupCode.new(signup_code_params)

    if @signup_code.save
      redirect_to signup_codes_url, notice: "Successfully created signup code."
    else
      set_user_group_options
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! @signup_code
    set_user_group_options
  end

  def update
    authorize! @signup_code
    if @signup_code.update(signup_code_params)
      redirect_to signup_codes_url, notice: "Successfully updated signup code."
    else
      set_user_group_options
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @signup_code
    respond_to do |format|
      if @signup_code.destroy
        format.html { redirect_to signup_codes_url, status: :see_other, notice: "Successfully deleted signup code." }
        format.turbo_stream
      else
        format.html { redirect_to signup_codes_url, error: "#{@signup_code.errors.full_messages.to_sentence}." }
        format.turbo_stream
      end
    end
  end

  private

  def set_signup_code
    @signup_code = SignupCode.find(params[:id])
  end

  def signup_code_params
    params.require(:signup_code).permit(
      :active,
      :code,
      :user_group_id,
    )
  end

  def set_user_group_options
    @user_group_options = UserGroup.by_name.pluck(:name, :id)
  end
end
