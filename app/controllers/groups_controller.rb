class GroupsController < ApplicationController

 def index
   @book = Book.new
   @groups = Group.all
 end
 
  def new
    @group = Group.new
    @group.users << current_user
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to groups_path, notice: 'グループを作成しました'
    else
      render :new
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :introduction, user_ids: [])
  end

end
