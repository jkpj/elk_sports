class Official::ClubsController < Official::OfficialController
  before_filter :assign_race_by_race_id, :check_assigned_race, :set_clubs

  def index
  end

  def create
    @club = @race.clubs.build(params[:club])
    if @club.save
      respond_to do |format|
        format.html { redirect_to(official_race_clubs_path(@race) )}
        format.js { render :created }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js { render :created }
      end
    end
  end

  def update
    @club = Club.find(params[:id])
    @club.update_attributes(params[:club])
    if @club.save
      respond_to do |format|
        format.html { redirect_to(official_race_clubs_path(@race) )}
        format.js { render :updated }
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.js { render :updated }
      end
    end
  end

  def destroy
    @club = Club.find(params[:id])
    @club.destroy
    respond_to do |format|
      format.html { redirect_to(official_race_clubs_path(@race) )}
      format.js { render :destroyed }
    end
  end

  private
  def set_clubs
    @is_clubs = true
  end
end
