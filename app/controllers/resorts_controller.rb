class ResortsController < ApplicationController
  # GET /resorts
  # GET /resorts.xml
  def index
    @resorts = Resort.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resorts }
    end
  end

  # GET /resorts/1
  # GET /resorts/1.xml
  def show
    @resort = Resort.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resort }
    end
  end

  # GET /resorts/new
  # GET /resorts/new.xml
  def new
    @resort = Resort.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resort }
    end
  end

  # GET /resorts/1/edit
  def edit
    @resort = Resort.find(params[:id])
  end

  # POST /resorts
  # POST /resorts.xml
  def create
    @resort = Resort.new(params[:resort])

    respond_to do |format|
      if @resort.save
        format.html { redirect_to(@resort, :notice => 'Resort was successfully created.') }
        format.xml  { render :xml => @resort, :status => :created, :location => @resort }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resort.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resorts/1
  # PUT /resorts/1.xml
  def update
    @resort = Resort.find(params[:id])

    respond_to do |format|
      if @resort.update_attributes(params[:resort])
        format.html { redirect_to(@resort, :notice => 'Resort was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resort.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resorts/1
  # DELETE /resorts/1.xml
  def destroy
    @resort = Resort.find(params[:id])
    @resort.destroy

    respond_to do |format|
      format.html { redirect_to(resorts_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /resorts/1/map
  def map
     @resorts = Resort.all
     
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resorts }  
     end   
  end
  
end
