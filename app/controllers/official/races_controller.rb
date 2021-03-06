class Official::RacesController < Official::OfficialController
  before_filter :assign_race_by_id, :check_assigned_race, :except => [:new, :create]

  def show
    @is_race = true
  end

  def new
    @race = Race.new
    @race.start_interval_seconds = Race::DEFAULT_START_INTERVAL
    @race.batch_size = 0
    @race.batch_interval_seconds = Race::DEFAULT_BATCH_INTERVAL
    @race.sport = Sport.default_sport
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      current_user.races << @race
      flash[:success] = "Kilpailu lisätty. "
      if params[:add_default_series]
        @race.add_default_series
        flash[:success] << "Pääset lisäämään kilpailijoita klikkaamalla sarjan " +
          "nimen vieressä olevaa linkkiä."
        redirect_to official_race_path(@race)
      else
        flash[:success] << "Voit nyt lisätä sarjoja kilpailulle alla olevasta linkistä."
        redirect_to edit_official_race_path(@race)
      end
    else
      render :new
    end
  end

  def edit
    @is_race_edit = true
  end

  def update
    if @race.update_attributes(params[:race])
      redirect_to official_race_path(@race)
    else
      render :edit
    end
  end

  def destroy
    if @race.destroy
      flash[:success] = "Kilpailu poistettu"
    else
      flash[:error] = "Kilpailua ei voi poistaa: #{@race.errors[:base]}"
    end
    redirect_to official_root_path
  end
end
