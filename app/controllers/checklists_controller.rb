require 'yaml'
class ChecklistsController < ApplicationController
	# GET /checklists
	# GET /checklists.xml
	def index
		@checklists = Checklist.all(:select=>'id,list,title,updated_at',:order=>'updated_at DESC')
		
		@checklists = Checklist.prepare_lists @checklists
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml { render :xml => @checklists }
		end
	end
  
	# what happens when a user checks off a checklist item
	def checkoff
		render :layout => false
		
		if (request.xhr?)
			puts 'ajax!'
		end
	end

	# GET /checklists/1
	# GET /checklists/1.xml
	def show
		@checklist = Checklist.prepare_list Checklist.find(params[:id])
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @checklist }
		end
	end

	# GET /checklists/new
	# GET /checklists/new.xml
	def new
		@checklist = Checklist.new
		
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @checklist }
		end
	end

	# GET /checklists/1/edit
	def edit
		@checklist = Checklist.find(params[:id])
	end

	# POST /checklists
	# POST /checklists.xml
	def create
		@checklist = Checklist.new(params[:checklist])
		
		respond_to do |format|
			if @checklist.save
				format.html { redirect_to(@checklist, :notice => 'Checklist was successfully created.') }
				format.xml  { render :xml => @checklist, :status => :created, :location => @checklist }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @checklist.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /checklists/1
	# PUT /checklists/1.xml
	def update
		@checklist = Checklist.find(params[:id])
		
		# we take the first line and make that the title
		params[:checklist][:title] = Checklist.get_title_from_list params[:checklist][:list]
		
		# we take thelast line to get the email recipients
		params[:checklist][:emails] = Checklist.get_emails_from_list params[:checklist][:list]
		
		respond_to do |format|
			if @checklist.update_attributes(params[:checklist])
				format.html { redirect_to(@checklist, :notice => 'Checklist was successfully updated.') }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @checklist.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /checklists/1
	# DELETE /checklists/1.xml
	def destroy
		@checklist = Checklist.find(params[:id])
		@checklist.destroy
		
		respond_to do |format|
			format.html { redirect_to(checklists_url) }
			format.xml  { head :ok }
		end
	end
end