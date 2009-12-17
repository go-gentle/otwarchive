class GiftsController < ApplicationController
  
  before_filter :load_collection
  
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @recipient_name = params[:recipient]
    unless @user || @recipient_name
      flash[:error] = t('gifts.whose', :default => "Whose gifts did you want to see?")
      redirect_to :back and return
    end
    if @user
      @gifts = @user.pseuds.collect {|pseud| Gift.find_by_recipient_name(pseud.name)}.flatten.uniq
    else      
      @gifts = Gift.find_all_by_recipient_name(@recipient_name)
    end
    
    @works = @gifts.collect(&:work).uniq
    @works = (@works & @collection.approved_works) if @collection
  end
  
end